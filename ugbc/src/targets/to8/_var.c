/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *----------------------------------------------------------------------------
 * Concesso in licenza secondo i termini della Licenza Apache, versione 2.0
 * (la "Licenza"); è proibito usare questo file se non in conformità alla
 * Licenza. Una copia della Licenza è disponibile all'indirizzo:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Se non richiesto dalla legislazione vigente o concordato per iscritto,
 * il software distribuito nei termini della Licenza è distribuito
 * "COSÌ COM'È", SENZA GARANZIE O CONDIZIONI DI ALCUN TIPO, esplicite o
 * implicite. Consultare la Licenza per il testo specifico che regola le
 * autorizzazioni e le limitazioni previste dalla medesima.
 ****************************************************************************/

/****************************************************************************
 * INCLUDE SECTION 
 ****************************************************************************/

#include "../../ugbc.h"

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

extern char BANK_TYPE_AS_STRING[][16];
extern char DATATYPE_AS_STRING[][16];

static void variable_cleanup_entry_multibyte( Environment * _environment, Variable * _first, int _bank_read_write ) {

    Variable * variable = _first;

    outline0("ALIGN 2");

    while( variable ) {

        if ( 
                variable->bankReadOrWrite == _bank_read_write &&
             ( !variable->assigned || ( variable->assigned && !variable->temporary ) ) && !variable->imported ) {

            if ( variable->memoryArea && _environment->debuggerLabelsFile ) {
                fprintf( _environment->debuggerLabelsFile, "%4.4x %s\r\n", variable->absoluteAddress, variable->realName );
            }

            switch( variable->type ) {
                case VT_WORD:
                case VT_SWORD:
                case VT_POSITION:
                case VT_ADDRESS:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        vars_emit_word( _environment, variable->realName, variable->initialValue );
                    }   
                    break;
                case VT_DWORD:
                case VT_SDWORD:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        vars_emit_dword( _environment, variable->realName, variable->initialValue );
                    }   
                    break;
                case VT_FLOAT:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        // force 6 bytes to help even alignment (5->6 bytes)
                        outhead1("%s rzb 6", variable->realName);
                    }   
                    break;   
                case VT_TILES:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 4", variable->realName);
                    }   
                    break;                    
                case VT_BLIT:
                    break;
                case VT_MUSIC:
                case VT_BUFFER:
                case VT_TYPE:
                    if ( variable->bankAssigned != -1 ) {
                        outhead4("; relocated on bank %d (at %4.4x) for %d bytes (uncompressed: %d)", variable->bankAssigned, variable->absoluteAddress, variable->size, variable->uncompressedSize );
                        // force 2 bytes to help even alignment (1->2 bytes)
                        outhead1("%s    fcb 0,0", variable->realName );
                    } else {
                        if ( ! variable->absoluteAddress ) {
                            if ( variable->valueBuffer ) {
                                if ( variable->printable ) {
                                    char * string = malloc( variable->size + 1 );
                                    memset( string, 0, variable->size + 1 );
                                    memcpy( string, variable->valueBuffer, variable->size );
                                    // force +1 byte if size is odd
                                    if ( variable->size & 0x01 ) {
                                        outhead2("%s    fcc %s,0", variable->realName, escape_newlines( string ) );
                                    } else {
                                        outhead2("%s    fcc %s", variable->realName, escape_newlines( string ) );
                                    }
                                } else {
                                    out1("%s fcb ", variable->realName);
                                    int i=0;
                                    for (i=0; i<(variable->size-1); ++i ) {
                                        if ( ( ( i + 1 ) % 16 ) == 0 ) {
                                            outline1("$%2.2x", (unsigned char)variable->valueBuffer[i]);
                                            out0("   fcb ");
                                        } else {
                                            out1("$%2.2x,", (unsigned char)variable->valueBuffer[i]);
                                        }
                                    }
                                    // force +1 byte if size is odd
                                    if ( variable->size & 0x01 ) {
                                        outhead1("$%2.2x, $0", variable->valueBuffer[(variable->size-1)]);
                                    } else {
                                        outhead1("$%2.2x", variable->valueBuffer[(variable->size-1)]);
                                    }
                                }
                            } else {
                                // force +1 byte if size is odd
                                if ( variable->size & 0x01 ) {
                                    outhead2("%s rzb %d", variable->realName, variable->size+1);
                                } else {
                                    outhead2("%s rzb %d", variable->realName, variable->size);
                                }
                            }
                        } else {
                            outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                            if ( variable->valueBuffer ) {
                                if ( variable->printable ) {
                                    char * string = malloc( variable->size + 1 );
                                    memset( string, 0, variable->size + 1 );
                                    memcpy( string, variable->valueBuffer, variable->size );
                                    // force +1 byte if size is odd
                                    if ( variable->size & 0x01 ) {
                                        outhead2("%s    fcc %s,0", variable->realName, escape_newlines( string ) );
                                    } else {
                                        outhead2("%s    fcc %s", variable->realName, escape_newlines( string ) );
                                    }
                                } else {
                                    out1("%scopy fcb ", variable->realName);
                                    int i=0;
                                    for (i=0; i<(variable->size-1); ++i ) {
                                        out1("$%2.2x,", variable->valueBuffer[i]);
                                    }
                                    // force +1 byte if size is odd
                                    if ( variable->size & 0x01 ) {
                                        outhead1("$%2.2x,$0", variable->valueBuffer[(variable->size-1)]);
                                    } else {
                                        outhead1("$%2.2x", variable->valueBuffer[(variable->size-1)]);
                                    }
                                }
                            }
                        }
                    }
                    break;
                case VT_IMAGEREF:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 12", variable->realName);
                    }   
                    break;
                case VT_PATH:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 16", variable->realName);
                    }   
                    break;
                case VT_VECTOR2:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 4", variable->realName);
                    }   
                    break;
                case VT_TILEMAP:
                case VT_TARRAY: {
                    if ( variable->bankAssigned == -1 ) {

                        if ( variable->valueBuffer ) {
                            out1("%s fcb ", variable->realName);
                            int i=0;
                            for (i=0; i<(variable->size-1); ++i ) {
                                out1("$%2.2x,", variable->valueBuffer[i]);
                            }
                            // force +1 byte if size is odd
                            if ( variable->size & 0x01 ) {
                                outhead1("$%2.2x,$0", variable->valueBuffer[(variable->size-1)]);
                            } else {
                                outhead1("$%2.2x", variable->valueBuffer[(variable->size-1)]);
                            }
                        } else if ( variable->value ) {

                            switch( VT_BITWIDTH( variable->arrayType ) ) {
                                case 32: {
                                    out1("%s fcb ", variable->realName );
                                    for( int i=0; i<(variable->size/4)-1; ++i ) {
                                        out4("$%2.2x, $%2.2x, $%2.2x, $%2.2x, ", (unsigned int)( ( variable->value >> 24 ) & 0xff ), (unsigned int)( ( variable->value >> 16 ) & 0xff ), (unsigned int)( ( variable->value >> 8 ) & 0xff ), (unsigned int)( variable->value & 0xff ) );
                                    }
                                    out4("$%2.2x, $%2.2x, $%2.2x, $%2.2x", (unsigned int)( ( variable->value >> 24 ) & 0xff ), (unsigned int)( ( variable->value >> 16 ) & 0xff ), (unsigned int)( ( variable->value >> 8 ) & 0xff ), (unsigned int)( variable->value & 0xff ) );
                                    outline0("");
                                    break;
                                }
                                case 16: {
                                    out1("%s fcb ", variable->realName );
                                    for( int i=0; i<(variable->size/2)-1; ++i ) {
                                        out2("$%2.2x, $%2.2x,", (unsigned int)( ( variable->value >> 8 ) & 0xff ), (unsigned int)( variable->value & 0xff ) );
                                    }
                                    out2("$%2.2x, $%2.2x", (unsigned int)( ( variable->value >> 8 ) & 0xff ), (unsigned int)( variable->value & 0xff ) );
                                    outline0("");
                                    break;
                                }
                                case 8:
                                    outhead3("%s rzb %d, $%2.2x", variable->realName, variable->size, (unsigned char)(variable->value&0xff) );
                                    break;
                                case 1:
                                    outhead3("%s rzb %d, $%2.2x", variable->realName, variable->size, (unsigned char)(variable->value?0xff:0x00));
                                    break;
                            }                             
                            
                        } else {
                            outhead4("; relocated on bank %d (at %4.4x) for %d bytes (uncompressed: %d)", variable->bankAssigned, variable->absoluteAddress, variable->size, variable->uncompressedSize );
                            // force +1 byte if size is odd
                            if ( variable->size & 0x01 ) {
                                outhead2("%s rzb %d", variable->realName, variable->size+1);
                            } else {
                                outhead2("%s rzb %d", variable->realName, variable->size);
                            }
                        }

                    } else {
                        outhead4("; relocated on bank %d (at %4.4x) for %d bytes (uncompressed: %d)", variable->bankAssigned, variable->absoluteAddress, variable->size, variable->uncompressedSize );
                        if ( variable->type == VT_TARRAY ) {
                            // if (VT_BITWIDTH( variable->arrayType ) == 0 && variable->arrayType != VT_TYPE ) {
                            //     CRITICAL_DATATYPE_UNSUPPORTED( "BANKED", DATATYPE_AS_STRING[ variable->arrayType ] );
                            // }
                            // force +1 byte if size is odd
                            if ( variable->arrayType == VT_TYPE ) {
                                int size = 1;
                                Field * field = variable->typeType->first;
                                while( field ) {
                                    if ( size < ( VT_BITWIDTH( field->type ) >> 3 ) ) {
                                        size = VT_BITWIDTH( field->type ) >> 3;
                                    }
                                    field = field->next;
                                }
                                if ( size & 0x01 ) {
                                    outhead2("%s rzb %d, $00", variable->realName, size+1 );
                                } else {
                                    outhead2("%s rzb %d, $00", variable->realName, size );
                                }
                            } else if ( variable->arrayType == VT_PATH ) {
                                outhead1("%s rzb 16, $00", variable->realName );
                            } else {
                                if ( variable->size & 0x01 ) {
                                    outhead2("%s rzb %d, $00", variable->realName, (VT_BITWIDTH( variable->arrayType )>>3)+1 );
                                } else {
                                    outhead2("%s rzb %d, $00", variable->realName, (VT_BITWIDTH( variable->arrayType )>>3) );
                                }
                            }
                        } else {
                            if (VT_BITWIDTH( variable->type ) == 0 ) {
                                CRITICAL_DATATYPE_UNSUPPORTED( "BANKED", DATATYPE_AS_STRING[ variable->type ] );
                            }
                            // force +1 byte if size is odd
                            if ( variable->size & 0x01 ) {
                                outhead2("%s rzb %d, $00", variable->realName, (VT_BITWIDTH( variable->type )>>3)+1 );
                            } else {
                                outhead2("%s rzb %d, $00", variable->realName, (VT_BITWIDTH( variable->type )>>3) );
                            }
                        }
                    }

                    break;
                }
            }
        }
        
        variable = variable->next;

    }


}

static void variable_cleanup_entry_byte( Environment * _environment, Variable * _first, int _bank_read_write ) {

    Variable * variable = _first;

    while( variable ) {

        if ( variable->bankReadOrWrite == _bank_read_write &&
            ( !variable->assigned || ( variable->assigned && !variable->temporary ) ) && !variable->imported ) {

            if ( variable->memoryArea && _environment->debuggerLabelsFile ) {
                fprintf( _environment->debuggerLabelsFile, "%4.4x %s\r\n", variable->absoluteAddress, variable->realName );
            }

            switch( variable->type ) {
                case VT_CHAR:
                case VT_BYTE:
                case VT_SBYTE:
                case VT_COLOR:
                case VT_THREAD:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        vars_emit_byte( _environment, variable->realName, variable->initialValue );
                    }   
                    break;
                case VT_DOJOKA:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 4", variable->realName);
                    }   
                    break;
                case VT_STRING:
                    if ( ! variable->valueString ) {
                        printf("%s", variable->realName);
                        exit(EXIT_FAILURE);
                    }
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead2("%s equ cstring%d", variable->realName, variable->valueString->id );
                    }   
                    break;
                case VT_DSTRING:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 1", variable->realName);
                    }   
                    break;
                case VT_SPRITE:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 1", variable->realName);
                    }   
                    break;
                case VT_MSPRITE:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 2", variable->realName);
                    }   
                    break;
                case VT_TILE:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 1", variable->realName);
                    }   
                    break;
                case VT_TILESET:
                    if ( variable->memoryArea ) {
                        outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s rzb 1", variable->realName);
                    }   
                    break;
            }

        }
        
        variable = variable->next;

    }

}

static void variable_cleanup_entry( Environment * _environment, Variable * _first, int _bank_read_write ) {

    variable_cleanup_entry_multibyte( _environment, _first, _bank_read_write );
    variable_cleanup_entry_byte( _environment, _first, _bank_read_write );

}

static void variable_cleanup_entry_image( Environment * _environment, Variable * _first ) {

    Variable * variable = _first;

    outline0("ALIGN 2");
    while( variable ) {

        if ( ( !variable->assigned || ( variable->assigned && !variable->temporary ) ) && !variable->imported ) {

            if ( variable->memoryArea && _environment->debuggerLabelsFile ) {
                fprintf( _environment->debuggerLabelsFile, "%4.4x %s\r\n", variable->absoluteAddress, variable->realName );
            }

            switch( variable->type ) {
                case VT_IMAGE:
                case VT_IMAGES:
                case VT_SEQUENCE:
                    if ( variable->bankAssigned != -1 ) {
                        outhead4("; relocated on bank %d (at %4.4x) for %d bytes (uncompressed: %d)", variable->bankAssigned, variable->absoluteAddress, variable->size, variable->uncompressedSize );
                        // forced 2 bytes to even alignment
                        outhead1("%s    fcb 2", variable->realName );
                    } else {
                        if ( ! variable->absoluteAddress ) {
                            if ( variable->valueBuffer ) {
                                if ( variable->printable ) {
                                    char * string = malloc( variable->size + 1 );
                                    memset( string, 0, variable->size + 1 );
                                    memcpy( string, variable->valueBuffer, variable->size );
                                    // forced +1 byte to even alignment
                                    if ( variable->size & 0x01 ) {
                                        outhead2("%s    fcc %s,0", variable->realName, escape_newlines( string ) );
                                    } else {
                                        outhead2("%s    fcc %s", variable->realName, escape_newlines( string ) );
                                    }
                                } else {
                                    out1("%s fcb ", variable->realName);
                                    int i=0;
                                    for (i=0; i<(variable->size-1); ++i ) {
                                        if ( ( ( i + 1 ) % 16 ) == 0 ) {
                                            outline1("$%2.2x", (unsigned char)variable->valueBuffer[i]);
                                            out0("   fcb ");
                                        } else {
                                            out1("$%2.2x,", (unsigned char)variable->valueBuffer[i]);
                                        }
                                    }
                                    // forced +1 byte to even alignment
                                    if ( variable->size & 0x01 ) {
                                        outhead1("$%2.2x, $0", variable->valueBuffer[(variable->size-1)]);
                                    } else {
                                        outhead1("$%2.2x", variable->valueBuffer[(variable->size-1)]);
                                    }
                                }
                            } else {
                                // forced +1 byte to even alignment
                                if ( variable->size & 0x01 ) {
                                    outhead2("%s rzb %d", variable->realName, variable->size+1);
                                } else {
                                    outhead2("%s rzb %d", variable->realName, variable->size);
                                }
                            }
                        } else {
                            outhead2("%s equ $%4.4x", variable->realName, variable->absoluteAddress);
                            if ( variable->valueBuffer ) {
                                if ( variable->printable ) {
                                    char * string = malloc( variable->size + 1 );
                                    memset( string, 0, variable->size + 1 );
                                    memcpy( string, variable->valueBuffer, variable->size );
                                    // forced +1 byte to even alignment
                                    if ( variable->size & 0x01 ) {
                                        outhead2("%s    fcc %s, 0", variable->realName, escape_newlines( string ) );
                                    } else {
                                        outhead2("%s    fcc %s", variable->realName, escape_newlines( string ) );
                                    }
                                } else {
                                    out1("%scopy fcb ", variable->realName);
                                    int i=0;
                                    for (i=0; i<(variable->size-1); ++i ) {
                                        out1("$%2.2x,", variable->valueBuffer[i]);
                                    }
                                    // forced +1 byte to even alignment
                                    if ( variable->size & 0x01 ) {
                                        outhead1("$%2.2x, $0", variable->valueBuffer[(variable->size-1)]);
                                    } else {
                                        outhead1("$%2.2x", variable->valueBuffer[(variable->size-1)]);
                                    }
                                }
                            }
                        }
                    }
                    break;
            }
        }
        
        variable = variable->next;

    }

}

static void variable_cleanup_entry_bit( Environment * _environment, Variable * _first, int _bank_read_write ) {

    Variable * variable = _first;

    int bitCount = 0;

    while( variable ) {

        if ( variable->bankReadOrWrite == _bank_read_write &&
            ( !variable->assigned || ( variable->assigned && !variable->temporary ) ) && !variable->imported && !variable->memoryArea ) {

            if ( variable->memoryArea && _environment->debuggerLabelsFile ) {
                fprintf( _environment->debuggerLabelsFile, "%4.4x %s\r\n", variable->absoluteAddress, variable->realName );
            }

            switch( variable->type ) {
                case VT_BIT:
                    if ( variable->memoryArea ) {
                        // outline2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s", variable->realName);
                    }
                    ++bitCount;
                    if ( bitCount == 8 ) {
                        outline0("   fcb 0");
                    }        
                    break;
            }

        }

        variable = variable->next;

    }

    if ( bitCount > 0 ) {
        outline0("   fcb 0");
    }

}

/**
 * @brief Emit source and configuration lines for variables
 * 
 * This function can be called to generate all the definitions (on the source
 * file, on the configuration file and on any support file) necessary to 
 * implement the variables.
 * 
 * @param _environment Current calling environment
 */
void variable_cleanup( Environment * _environment ) {
    int i=0;

    vars_emit_constants( _environment );

    if ( _environment->dataSegment ) {
        outhead1("DATAFIRSTSEGMENT EQU %s", _environment->dataSegment->realName );
        if ( _environment->readDataUsed && _environment->restoreDynamic ) {
            outhead0("DATASEGMENTNUMERIC" );
            DataSegment * actual = _environment->dataSegment;
            while( actual ) {
                if ( actual->isNumeric ) {
                    outline2( "fdb $%4.4x, %s", actual->lineNumber, actual->realName );
                }
                actual = actual->next;
            }
            outline0( "fdb $ffff, DATAPTRE" );
        }
    }

    if ( _environment->offsetting ) {
        Offsetting * actual = _environment->offsetting;
        while( actual ) {
            outline0("ALIGN 2");
            outhead1("OFFSETS%4.4x", actual->size );
            out0("        fdb " );
            for( i=0; i<actual->count; ++i ) {
                out1("$%4.4x", i * actual->size );
                if ( i < ( actual->count - 1 ) ) {
                    out0(",");
                } else {
                    outline0("");
                }
            }
            if ( actual->variables ) {
                OffsettingVariable * actualVariable = actual->variables;
                while( actualVariable ) {
                    if ( actualVariable->sequence ) {
                        outhead1("%soffsetsequence", actualVariable->variable->realName );
                    } else {
                        outhead1("%soffsetframe", actualVariable->variable->realName );
                    }
                    actualVariable = actualVariable->next;
                }
                outhead1("fs%4.4xoffsetsequence", actual->size );
                outhead1("fs%4.4xoffsetframe", actual->size );                      
                outline1("LDX #OFFSETS%4.4x", actual->size );
                outline0("LDA #0" );
                outline0("ABX" );
                outline0("ABX" );
                outline0("LDD ,X" );
                outline0("LEAY D, Y" );
                outline0("RTS");
            }
            actual = actual->next;
        }

        int values[MAX_TEMPORARY_STORAGE];
        char * address[MAX_TEMPORARY_STORAGE];

        actual = _environment->offsetting;
        int count = 0;
        while( actual ) {
            values[count] = actual->size;
            address[count] = malloc( MAX_TEMPORARY_STORAGE );
            sprintf( address[count], "fs%4.4xoffsetframe", actual->size );
            actual = actual->next;
            ++count;
        }

        cpu_address_table_build( _environment, "EXECOFFSETS", values, address, count );

        cpu_address_table_lookup( _environment, "EXECOFFSETS", count );

    }

    for(i=0; i<BANK_TYPE_COUNT; ++i) {
        Bank * actual = _environment->banks[i];
        while( actual ) {
            if ( actual->type == BT_VARIABLES ) {
                // cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
                // cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
                // outhead1(".segment \"%s\"", actual->name);
                Variable * variable = _environment->variables;

                variable_cleanup_entry( _environment, variable, 0 );
                variable_cleanup_entry_bit( _environment, variable, 0 );

            } else if ( actual->type == BT_TEMPORARY ) {
                // cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
                // cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
                // outhead1(".segment \"%s\"", actual->name);

                for( int j=0; j< (_environment->currentProcedure+1); ++j ) {
                    Variable * variable = _environment->tempVariables[j];
                    variable_cleanup_entry( _environment, variable, 0 );
                    variable_cleanup_entry_bit( _environment, variable, 0 );
                } 
                
                Variable * variable = _environment->tempResidentVariables;

                variable_cleanup_entry( _environment, variable, 0 );
                variable_cleanup_entry_bit( _environment, variable, 0 );

            } else if ( actual->type == BT_STRINGS ) {
                // cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
                // cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
            } else {

            }
           actual = actual->next;
        }
        
    }    

    if ( _environment->descriptors ) {
        outline0("ALIGN 2");
        outhead0("UDCCHAR" );
        int i=0,j=0;
        for(i=0;i<_environment->descriptors->count;++i) {
            outline1("; $%2.2x ", i);
            out0("  fcb " );
            for(j=0;j<7;++j) {
                out1("$%2.2x,", ((unsigned char)_environment->descriptors->data[_environment->descriptors->first+i].data[j]) );
            }
            outline1("$%2.2x", ((unsigned char)_environment->descriptors->data[_environment->descriptors->first+i].data[j]) );
        }
    }

    generate_cgoto_address_table( _environment );

    variable_on_memory_init( _environment, 0 );

    DataSegment * dataSegment = _environment->dataSegment;
    while( dataSegment ) {
        int i=0;
        if ( dataSegment->data ) {
            out1("%s fcb ", dataSegment->realName );
        } else {
            outhead1("%s ", dataSegment->realName );
        }
        DataDataSegment * dataDataSegment = dataSegment->data;
        while( dataDataSegment ) {
            if ( dataSegment->type ) {
                if ( dataDataSegment->type == VT_STRING || dataDataSegment->type == VT_DSTRING ) {
                    out1("$%2.2x,", (unsigned char)(dataDataSegment->size) );
                    out1("\"%s\"", dataDataSegment->data );
                } else {
                    for( i=0; i<(dataDataSegment->size-1); ++i ) {
                        out1("$%2.2x,", (unsigned char)(dataDataSegment->data[i]&0xff) );
                    }
                    out1("$%2.2x", (unsigned char)(dataDataSegment->data[i]&0xff) );
                }
            } else {
                if ( dataDataSegment->type == VT_STRING || dataDataSegment->type == VT_DSTRING ) {
                    out1("$%2.2x,", (unsigned char)(dataDataSegment->type) );
                    out1("$%2.2x,", (unsigned char)(dataDataSegment->size) );
                    out1("\"%s\"", dataDataSegment->data );
                } else {
                    out1("$%2.2x,", (unsigned char)(dataDataSegment->type) );
                    for( i=0; i<(dataDataSegment->size-1); ++i ) {
                        out1("$%2.2x,", (unsigned char)(dataDataSegment->data[i]&0xff) );
                    }
                    out1("$%2.2x", (unsigned char)(dataDataSegment->data[i]&0xff) );
                }
            }
            dataDataSegment = dataDataSegment->next;
            if ( dataDataSegment ) {
                out0(",");
            }
        }
        outline0("");
        dataSegment = dataSegment->next;
    }

    if ( _environment->dataNeeded || _environment->dataSegment || _environment->deployed.read_data_unsafe ) {
        outhead0("DATAPTRE");
    }
        
    StaticString * staticStrings = _environment->strings;
    while( staticStrings ) {
        outhead2("cstring%d fcb %d", staticStrings->id, (int)strlen(staticStrings->value) );
        if ( strlen( staticStrings->value ) > 0 ) {
            outhead1("   fcc %s", escape_newlines( staticStrings->value ) );
        } 
        staticStrings = staticStrings->next;
    }

    if ( _environment->bitmaskNeeded ) {
        outhead0("BITMASK fcb $01,$02,$04,$08,$10,$20,$40,$80");
        outhead0("BITMASKN fcb $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f");
    }
    if ( _environment->deployed.dstring ) {
        outhead1("max_free_string equ $%4.4x", _environment->dstring.space == 0 ? DSTRING_DEFAULT_SPACE : _environment->dstring.space );
    }

    buffered_push_output( _environment );

    outline1("ORG $%4.4x", _environment->program.startingAddress );
    outhead0("CODESTART");
    outline0("LDS #STACK");
    outline0("JMP CODESTART2");
    outhead0("STACK");
    outline0("rzb 256");
    outhead0("STACKEND");

    Bank * bank = _environment->expansionBanks;
    while( bank ) {
        if ( bank->address ) {

            deploy_preferred( duff, src_hw_6809_duff_asm );
            deploy_preferred( msc1, src_hw_6809_msc1_asm );
            deploy_preferred( bank, src_hw_pc128op_bank_asm );

            outhead1("BANKREADBANK%2.2xXSDR", bank->id );
            outline1("LDX #BANKWINDOW%2.2x", bank->defaultResident );
            outhead1("BANKREADBANK%2.2xXS", bank->id );
            outline1("LDB #$%2.2x", bank->id );
            outline0("JMP BANKREAD" );

            outhead1("BANKUNCOMPRESS%2.2xXSDR", bank->id );
            outline1("LDY #BANKWINDOW%2.2x", bank->defaultResident );
            outhead1("BANKUNCOMPRESS%2.2xXS", bank->id );
            outline1("LDB #$%2.2x", bank->id );
            // outline0("LEAX $6000,X" );
            outline0("JMP BANKUNCOMPRESS" );
        }
        bank = bank->next;
    }

    deploy_inplace_preferred( duff, src_hw_6809_duff_asm );
    deploy_inplace_preferred( msc1, src_hw_6809_msc1_asm );
    deploy_inplace_preferred( bank, src_hw_to8_bank_asm );
    for( i=0; i<MAX_RESIDENT_SHAREDS; ++i ) {
        if ( _environment->maxExpansionBankSize[i] ) {
            outline0("ALIGN 2");            
            outhead1("BANKWINDOWID%2.2x fcb $FF, $FF", i );
            outhead2("BANKWINDOW%2.2x rzb %d", i, _environment->maxExpansionBankSize[i]);
        }
    }

    outline0("ALIGN 2");

    for(i=0; i<BANK_TYPE_COUNT; ++i) {
        Bank * actual = _environment->banks[i];
        while( actual ) {
            if ( actual->type == BT_VARIABLES ) {
                // cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
                // cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
                // outhead1(".segment \"%s\"", actual->name);
                Variable * variable = _environment->variables;

                variable_cleanup_entry_image( _environment, variable );
                variable_cleanup_entry( _environment, variable, 1 );

            } else if ( actual->type == BT_TEMPORARY ) {
                for( int j=0; j< (_environment->currentProcedure+1); ++j ) {
                    Variable * variable = _environment->tempVariables[j];
                    variable_cleanup_entry_image( _environment, variable );
                    variable_cleanup_entry( _environment, variable, 1 );
                    variable_cleanup_entry_bit( _environment, variable, 1 );
                } 
                
                Variable * variable = _environment->tempResidentVariables;
                variable_cleanup_entry_image( _environment, variable );
                variable_cleanup_entry( _environment, variable, 1 );

            } else if ( actual->type == BT_STRINGS ) {
                // cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
                // cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
            } else {

            }
           actual = actual->next;
        }
    }    

    outhead0("BANKLOAD");

    bank = _environment->expansionBanks;

    while( bank ) {

        if ( bank->address ) {
            outline1("fcb $%2.2x", bank->id);
        } else {
            outline0("fcb $ff");
        }

        bank = bank->next;

    }

    outline0("fcb $ff");

    deploy_inplace_preferred( vars, src_hw_to8_vars_asm);
    deploy_inplace_preferred( startup, src_hw_to8_startup_asm);
    deploy_inplace_preferred( ef936xvars, src_hw_ef936x_vars_asm);
    deploy_inplace_preferred( ef936xstartup, src_hw_ef936x_startup_asm);
    deploy_inplace_preferred( putimage, src_hw_ef936x_put_image_asm );
    deploy_inplace_preferred( getimage, src_hw_ef936x_get_image_asm );
    deploy_inplace_preferred( clsBox, src_hw_ef936x_cls_box_asm )
    deploy_inplace_preferred( scancode, src_hw_to8_scancode_asm );
    deploy_inplace_preferred( textEncodedAt, src_hw_ef936x_text_at_asm );
    deploy_inplace_preferred( textEncodedAtGraphicRaw, src_hw_ef936x_text_at_raw_asm );
    deploy_inplace_preferred( textEncodedAtGraphic, src_hw_ef936x_text_at_asm );
        
    outhead0("CODESTART2");
    outline0("LDS #STACKEND");

    buffered_prepend_output( _environment );

}
