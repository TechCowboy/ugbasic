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

static void variable_cleanup_entry( Environment * _environment, Variable * _first ) {

    Variable * variable = _first;

    while( variable ) {

        if ( ( !variable->assigned || ( variable->assigned && !variable->temporary ) ) && !variable->imported && !variable->memoryArea ) {

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
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        vars_emit_byte( _environment, variable->realName, variable->initialValue);
                    }        
                    break;
                case VT_DOJOKA:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 4,0", variable->realName);
                    }        
                    break;
                case VT_IMAGEREF:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 12,0", variable->realName);
                    }        
                    break;
                case VT_PATH:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 16,0", variable->realName);
                    }        
                    break;
                case VT_VECTOR2:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 4,0", variable->realName);
                    }        
                    break;
                case VT_WORD:
                case VT_SWORD:
                case VT_POSITION:
                case VT_ADDRESS:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        vars_emit_word( _environment, variable->realName, variable->initialValue);
                    }
                    break;
                case VT_DWORD:
                case VT_SDWORD:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        vars_emit_dword( _environment, variable->realName, variable->initialValue);
                    }
                    break;
                case VT_FLOAT:
                    if ( variable->memoryArea && !variable->bankAssigned ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 4,0", variable->realName);
                    }
                    break;
                case VT_STRING:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead2("%s = cstring%d", variable->realName, variable->valueString->id );
                    }
                    break;
                case VT_DSTRING:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 1,0", variable->realName);
                    }
                    break;
                case VT_TILE:
                case VT_TILESET:
                case VT_MSPRITE:
                case VT_SPRITE:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 1,0", variable->realName);
                    }
                    break;
                case VT_TILES:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s: .res 4,0", variable->realName);
                    }
                    break;                
                case VT_BLIT:
                    break;
                case VT_IMAGE:
                case VT_IMAGES:
                case VT_SEQUENCE:
                case VT_MUSIC:
                case VT_BUFFER:
                case VT_TYPE:
                    if ( variable->bankAssigned != -1 ) {
                        outhead2("; relocated on bank %d (at %4.4x)", variable->bankAssigned, variable->absoluteAddress );
                        outhead1("%s: .byte $0", variable->realName );
                    } else {
                        if ( ! variable->absoluteAddress ) {
                            if ( variable->valueBuffer ) {
                                if ( variable->printable ) {
                                    char * string = malloc( variable->size + 1 );
                                    memset( string, 0, variable->size + 1 );
                                    memcpy( string, variable->valueBuffer, variable->size );
                                    outhead2("%s: .byte %s", variable->realName, escape_newlines( string ) );
                                } else {
                                    out1("%s: .byte ", variable->realName);
                                    int i=0;
                                    for (i=0; i<(variable->size-1); ++i ) {
                                        if ( ( ( i + 1 ) % 16 ) == 0 ) {
                                            outline1("$%2.2x", variable->valueBuffer[i]);
                                            out0("  .byte ");
                                        } else {
                                            out1("$%2.2x,", variable->valueBuffer[i]);
                                        }
                                    }
                                    outline1("$%2.2x", variable->valueBuffer[(variable->size-1)]);
                                }
                            } else {
                                outhead2("%s: .res %d,0", variable->realName, variable->size);
                            }
                        } else {
                            if ( ! variable->memoryArea && variable->valueBuffer ) {
                                outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                                if ( variable->printable ) {
                                    char * string = malloc( variable->size + 1 );
                                    memset( string, 0, variable->size + 1 );
                                    memcpy( string, variable->valueBuffer, variable->size );
                                    outhead2("%scopy: .byte %s", variable->realName, escape_newlines( string ) );
                                } else {
                                    out1("%scopy: .byte ", variable->realName);
                                    int i=0;
                                    for (i=0; i<(variable->size-1); ++i ) {
                                        out1("%d,", variable->valueBuffer[i]);
                                    }
                                    outline1("%d", variable->valueBuffer[(variable->size-1)]);
                                }
                            }
                        }
                    }
                    break;
                case VT_TILEMAP:
                case VT_TARRAY: {
                    if ( variable->bankAssigned != -1 ) {
                        outhead4("; relocated on bank %d (at %4.4x) for %d bytes (uncompressed: %d)", variable->bankAssigned, variable->absoluteAddress, variable->size, variable->uncompressedSize );
                        if ( variable->type == VT_TARRAY ) {
                            if (VT_BITWIDTH( variable->arrayType ) == 0 ) {
                                CRITICAL_DATATYPE_UNSUPPORTED( "BANKED", DATATYPE_AS_STRING[ variable->arrayType ] );
                            }
                            // force +1 byte if size is odd
                            outhead2("%s: .res %d, $00", variable->realName, (VT_BITWIDTH( variable->arrayType )>>3) );
                        } else {
                            if (VT_BITWIDTH( variable->type ) == 0 ) {
                                CRITICAL_DATATYPE_UNSUPPORTED( "BANKED", DATATYPE_AS_STRING[ variable->type ] );
                            }
                            // force +1 byte if size is odd
                            outhead2("%s: .res %d, $00", variable->realName, (VT_BITWIDTH( variable->type )>>3) );
                        }
                    } else {

                        if ( ! variable->memoryArea && variable->valueBuffer ) {
                            out1("%s: .byte ", variable->realName);
                            int i=0;
                            for (i=0; i<(variable->size-1); ++i ) {
                                out1("%d,", variable->valueBuffer[i]);
                            }
                            outline1("%d", variable->valueBuffer[(variable->size-1)]);
                        } else if ( variable->memoryArea && ! variable->value ) {
                            // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                        } else {
                            if ( variable->value ) {

                                switch( VT_BITWIDTH( variable->arrayType ) ) {
                                    case 32: {
                                        out1("%s: .byte ", variable->realName );
                                        for( int i=0; i<(variable->size/4)-1; ++i ) {
                                            out4("$%2.2x, $%2.2x, $%2.2x, $%2.2x, ", (unsigned int)( variable->value & 0xff ), (unsigned int)( ( variable->value >> 8 ) & 0xff ), (unsigned int)( ( variable->value >> 16 ) & 0xff ), (unsigned int)( ( variable->value >> 24 ) & 0xff ) );
                                        }
                                        out4("$%2.2x, $%2.2x, $%2.2x, $%2.2x", (unsigned int)( variable->value & 0xff ), (unsigned int)( ( variable->value >> 8 ) & 0xff ), (unsigned int)( ( variable->value >> 16 ) & 0xff ), (unsigned int)( ( variable->value >> 24 ) & 0xff ) );
                                        outline0("");
                                        break;
                                    }
                                    case 16: {
                                        out1("%s: .byte ", variable->realName );
                                        for( int i=0; i<(variable->size/2)-1; ++i ) {
                                            out2("$%2.2x, $%2.2x,", (unsigned int)( variable->value & 0xff ), (unsigned int)( ( variable->value >> 8 ) & 0xff ) );
                                        }
                                        out2("$%2.2x, $%2.2x", (unsigned int)( variable->value & 0xff ), (unsigned int)( ( variable->value >> 8 ) & 0xff ) );
                                        outline0("");
                                        break;
                                    }
                                    case 8:
                                        outhead3("%s: .res %d, $%2.2x", variable->realName, variable->size, (unsigned char)(variable->value&0xff) );
                                        break;
                                    case 1:
                                        outhead3("%s: .res %d, $%2.2x", variable->realName, variable->size, (unsigned char)(variable->value?0xff:0x00));
                                        break;
                                }                    
                                
                            } else {
                                outhead2("%s: .res %d,0", variable->realName, variable->size);
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

static void variable_cleanup_memory_mapped( Environment * _environment, Variable * _variable ) {

    outhead2("; %s (%4.4x)", _variable->realName, _variable->absoluteAddress );
    outhead1("%s:", _variable->realName );

    switch( _variable->type ) {
        case VT_CHAR:
        case VT_BYTE:
        case VT_SBYTE:
        case VT_COLOR:
        case VT_THREAD:
            vars_emit_byte( _environment, NULL, _variable->initialValue);
            break;
        case VT_DOJOKA:
            outline0(" .res 4" );
            break;
        case VT_IMAGEREF:
            outline0(" .res 12" );
            break;
        case VT_PATH:
            outline0(" .res 16" );
            break;
        case VT_VECTOR2:
            outline0(" .res 4" );
            break;
        case VT_WORD:
        case VT_SWORD:
        case VT_POSITION:
        case VT_ADDRESS:
            vars_emit_word( _environment, NULL, _variable->initialValue);
            break;
        case VT_DWORD:
        case VT_SDWORD:
            vars_emit_dword( _environment, NULL, _variable->initialValue);
            break;
        case VT_FLOAT: {
            int bytes = VT_FLOAT_BITWIDTH( _variable->precision ) >> 3;
            int * data = malloc( bytes * sizeof( int ) );
            switch( _variable->precision ) {
                case FT_FAST:
                    cpu_float_fast_from_double_to_int_array( _environment, _variable->valueFloating, data );
                    break;
                case FT_SINGLE:
                    cpu_float_single_from_double_to_int_array( _environment, _variable->valueFloating, data );
                    break;
            }
            for( int i=0; i<bytes; ++i ) {
                outline1(" .byte $%2.2x", (unsigned char)( ( data[i] ) & 0xff ) );
            }
            break;
        }
        case VT_STRING:
            outhead2("%s = cstring%d", _variable->realName, _variable->valueString->id );
            break;
        case VT_DSTRING:
        case VT_MSPRITE:
        case VT_SPRITE:
        case VT_TILE:
        case VT_TILESET:
            outline0("   .byte 0" );
            break;
        case VT_TILES:
            outline0("   .byte 0, 0, 0, 0" );
            break;
        case VT_BLIT:
            break;
        case VT_IMAGE:
        case VT_IMAGES:
        case VT_SEQUENCE:
        case VT_MUSIC:
        case VT_BUFFER:
        case VT_TYPE:
            if ( _variable->bankAssigned != -1 ) {
                outhead2("; relocated on bank %d (at %4.4x)", _variable->bankAssigned, _variable->absoluteAddress );
                outhead1("%s: .byte $0", _variable->realName );
            } else {
                if ( _variable->valueBuffer ) {
                    if ( _variable->printable ) {
                        char * string = malloc( _variable->size + 1 );
                        memset( string, 0, _variable->size + 1 );
                        memcpy( string, _variable->valueBuffer, _variable->size );
                        outline1("    .byte %s", escape_newlines( string ) );
                    } else {
                        out0("    .byte ");
                        int i=0;
                        for (i=0; i<(_variable->size-1); ++i ) {
                            out1("%d,", _variable->valueBuffer[i]);
                        }
                        outline1("%d", _variable->valueBuffer[(_variable->size-1)]);
                    }
                } else {
                    outline1(" .res %d,0", _variable->size);
                }
            }
            break;
        case VT_TILEMAP:
        case VT_TARRAY: {
            if ( _variable->bankAssigned != -1 ) {
                outhead4("; relocated on bank %d (at %4.4x) for %d bytes (uncompressed: %d)", _variable->bankAssigned, _variable->absoluteAddress, _variable->size, _variable->uncompressedSize );
                if ( _variable->type == VT_TARRAY ) {
                    if (VT_BITWIDTH( _variable->arrayType ) == 0 ) {
                        CRITICAL_DATATYPE_UNSUPPORTED( "BANKED", DATATYPE_AS_STRING[ _variable->arrayType ] );
                    }
                    // force +1 byte if size is odd
                    outhead2("%s: .res %d, $00", _variable->realName, (VT_BITWIDTH( _variable->arrayType )>>3) );
                } else {
                    if (VT_BITWIDTH( _variable->type ) == 0 ) {
                        CRITICAL_DATATYPE_UNSUPPORTED( "BANKED", DATATYPE_AS_STRING[ _variable->type ] );
                    }
                    // force +1 byte if size is odd
                    outhead2("%s: .res %d, $00", _variable->realName, (VT_BITWIDTH( _variable->type )>>3) );
                }
            } else {

                if ( _variable->valueBuffer ) {
                    out0("    .byte ");
                    int i=0;
                    for (i=0; i<(_variable->size-1); ++i ) {
                        out1("%d,", _variable->valueBuffer[i]);
                    }
                    outline1("%d", _variable->valueBuffer[(_variable->size-1)]);
                } else {
                    if ( _variable->value ) {
                        outhead2("    .res %d, $%2.2x", _variable->size, (unsigned char)(_variable->value&0xff));
                    } else {
                        outline1("    .res %d,0", _variable->size);
                    }
                }
            }

            break;
        }
    }

}

static void variable_cleanup_entry_bit( Environment * _environment, Variable * _first ) {

    Variable * variable = _first;

    int bitCount = 0;

    while( variable ) {

        if ( ( !variable->assigned || ( variable->assigned && !variable->temporary ) ) && !variable->imported && !variable->memoryArea ) {

            if ( variable->memoryArea && _environment->debuggerLabelsFile ) {
                fprintf( _environment->debuggerLabelsFile, "%4.4x %s\r\n", variable->absoluteAddress, variable->realName );
            }

            switch( variable->type ) {
                case VT_BIT:
                    if ( variable->memoryArea ) {
                        // outhead2("%s = $%4.4x", variable->realName, variable->absoluteAddress);
                    } else {
                        outhead1("%s:", variable->realName);
                    }
                    ++bitCount;
                    if ( bitCount == 8 ) {
                        outline0("   .res 1,0");
                    }        
                    break;
            }

        }

        variable = variable->next;

    }

    if ( bitCount > 0 ) {
        outline0("   .res 1,0");
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
        outhead1("DATAFIRSTSEGMENT = %s", _environment->dataSegment->realName );
        if ( _environment->readDataUsed && _environment->restoreDynamic ) {
            outhead0("DATASEGMENTNUMERIC:" );
            DataSegment * actual = _environment->dataSegment;
            while( actual ) {
                if ( actual->isNumeric ) {
                    outline2( ".word $%4.4x, %s", actual->lineNumber, actual->realName );
                }
                actual = actual->next;
            }
            outline0( ".word $ffff, DATAPTRE" );
        }
    }

    if ( _environment->offsetting ) {
        Offsetting * actual = _environment->offsetting;
        while( actual ) {
            out1("OFFSETS%4.4x: .word ", actual->size );
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
                        outhead1("%soffsetsequence:", actualVariable->variable->realName );
                    } else {
                        outhead1("%soffsetframe:", actualVariable->variable->realName );
                    }
                    actualVariable = actualVariable->next;
                }
                outhead1("fs%4.4xoffsetsequence:", actual->size );
                outhead1("fs%4.4xsoffsetframe:", actual->size );                
                outline1("LDA #<OFFSETS%4.4x", actual->size );
                outline0("STA MATHPTR1" );
                outline1("LDA #>OFFSETS%4.4x", actual->size );
                outline0("STA MATHPTR1+1" );
                outline0("CLC" );
                outline0("LDA MATHPTR0" );
                outline0("ASL" );
                outline0("TAY" );
                outline0("LDA TMPPTR" );
                outline0("ADC (MATHPTR1), Y" );
                outline0("STA TMPPTR" );
                outline0("INY" );
                outline0("LDA TMPPTR+1" );
                outline0("ADC (MATHPTR1), Y" );
                outline0("STA TMPPTR+1" );
                outline0("RTS" );
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
            sprintf( address[count], "fs%4.4xsoffsetframe", actual->size );
            actual = actual->next;
            ++count;
        }

        cpu_address_table_build( _environment, "EXECOFFSETS", values, address, count );

        cpu_address_table_lookup( _environment, "EXECOFFSETS", count );

    }

    generate_cgoto_address_table( _environment );

    banks_generate( _environment );

    for(i=0; i<BANK_TYPE_COUNT; ++i) {
        Bank * actual = _environment->banks[i];
        while( actual ) {
            if ( actual->type == BT_VARIABLES ) {
                // cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
                // cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
                // outhead1(".segment \"%s\"", actual->name);
                Variable * variable = _environment->variables;
                
                variable_cleanup_entry( _environment, variable );
                variable_cleanup_entry_bit( _environment, variable );

            } else if ( actual->type == BT_TEMPORARY ) {
                // cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
                // cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
                // outhead1(".segment \"%s\"", actual->name);
                if ( _environment->bitmaskNeeded ) {
                    outhead0("BITMASK: .byte $01,$02,$04,$08,$10,$20,$40,$80");
                    outhead0("BITMASKN: .byte $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f");
                }
                if ( _environment->deployed.dstring ) {
                    outhead1("max_free_string = $%4.4x", _environment->dstring.space == 0 ? DSTRING_DEFAULT_SPACE : _environment->dstring.space );
                }

                for( int j=0; j< (_environment->currentProcedure+1); ++j ) {
                    Variable * variable = _environment->tempVariables[j];
                    variable_cleanup_entry( _environment, variable );
                    variable_cleanup_entry_bit( _environment, variable );
                }
                
                Variable * variable = _environment->tempResidentVariables;

                variable_cleanup_entry( _environment, variable );
                variable_cleanup_entry_bit( _environment, variable );

            // } else if ( actual->type == BT_STRINGS ) {
            //     cfgline3("# BANK %s %s AT $%4.4x", BANK_TYPE_AS_STRING[actual->type], actual->name, actual->address);
            //     cfgline2("%s:   load = MAIN,     type = ro,  optional = yes, start = $%4.4x;", actual->name, actual->address);
            } else {

            }
           actual = actual->next;
        }
    }    

    if ( _environment->descriptors ) {
        outhead0("UDCCHAR:" );
        int i=0,j=0;
        for(i=_environment->descriptors->first;i<(_environment->descriptors->first+_environment->descriptors->count);++i) {
            out0(".byte " );
            for(j=0;j<7;++j) {
                out1("$%2.2x,", ((unsigned char)_environment->descriptors->data[i].data[j]) );
            }
            outline1("$%2.2x", ((unsigned char)_environment->descriptors->data[i].data[j]) );
        }
        outhead0("TEDUDCCHAR:" );
        char startAddress[MAX_TEMPORARY_STORAGE]; sprintf( startAddress, "$E800+$%4.4x", ( _environment->descriptors->first * 8) );
        cpu_mem_move_direct_size( _environment, "UDCCHAR", startAddress, _environment->descriptors->count*8 );
        // outline0("LDA $FF12" );
        // outline0("AND #$FB" );
        // outline0("STA $FF12" );
        // outline0("LDA $FF13" );
        // outline0("AND #$03" );
        // outline0("ORA #$18" );
        outline0("LDA #$F8" );
        outline0("STA $FF13" );
        // outline0("LDA $FF07" );
        // outline0("ORA #$80" );
        // outline0("STA $FF07" );
        outline0("RTS" );
    } else {
        outhead0("TEDUDCCHAR:" );
        outline0("RTS" );
    }

    if ( _environment->memoryAreas ) {
        MemoryArea * memoryArea = _environment->memoryAreas;
        while( memoryArea ) {
            // if ( memoryArea->type == MAT_RAM ) {
            //     cfgline3("MA%3.3x:  load = RAM%3.3x, type = overwrite,  optional = yes, start = $%4.4x;", memoryArea->id, memoryArea->id, memoryArea->start);
            // } else {
            //     cfgline2("MA%3.3x:  load = MAIN, type = overwrite,  optional = yes, start = $%4.4x;", memoryArea->id, memoryArea->start);
            // }
            outhead1(".segment \"MA%3.3x\"", memoryArea->id );
            for( i=memoryArea->start; i<memoryArea->end; ++i ) {
                Variable * variable = _environment->variables;
                while( variable ) {
                    if ( !variable->assigned && variable->memoryArea == memoryArea && variable->absoluteAddress == i ) {
                        variable_cleanup_memory_mapped( _environment, variable );
                        variable->staticalInit = ( memoryArea->type == MAT_RAM ? 0 : 1 );
                        break;
                    }
                    variable = variable->next;
                }
                for( int j=0; j< (_environment->currentProcedure+1); ++j ) {
                    Variable * variable = _environment->tempVariables[j];
                    while( variable ) {
                        if ( !variable->assigned && variable->memoryArea == memoryArea && variable->absoluteAddress == i ) {
                            variable_cleanup_memory_mapped( _environment, variable );
                            variable->staticalInit = ( memoryArea->type == MAT_RAM ? 0 : 1 );
                            break;
                        }
                        variable = variable->next;
                    }
                }
                variable = _environment->tempResidentVariables;
                while( variable ) {
                    if ( !variable->assigned && variable->memoryArea == memoryArea && variable->absoluteAddress == i ) {
                        variable_cleanup_memory_mapped( _environment, variable );
                        variable->staticalInit = ( memoryArea->type == MAT_RAM ? 0 : 1 );
                        break;
                    }
                    variable = variable->next;
                }
            }
            memoryArea = memoryArea->next;
        }

    }    

    for( i=0; i<MAX_RESIDENT_SHAREDS; ++i ) {
        if ( _environment->maxExpansionBankSize[i] ) {
            outhead1("BANKWINDOWID%2.2x: .byte $FF, $FF", i );
            outhead2("BANKWINDOW%2.2x: .res %d,0", i, _environment->maxExpansionBankSize[i]);
        }
    }

    deploy_inplace_preferred( tedstartup, src_hw_ted_startup_asm );

    outhead0(".segment \"CODE\"" );

    variable_on_memory_init( _environment, 0 );

    DataSegment * dataSegment = _environment->dataSegment;
    while( dataSegment ) {
        int i=0;
        if ( dataSegment->data ) {
            out1("%s: .BYTE ", dataSegment->realName );
        } else {
            outhead1("%s: ", dataSegment->realName );
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
        outhead0("DATAPTRE:");
    }
    
    StaticString * staticStrings = _environment->strings;
    while( staticStrings ) {
        outhead3("cstring%d: .byte %d, %s", staticStrings->id, (int)strlen(staticStrings->value), escape_newlines( staticStrings->value ) );
        staticStrings = staticStrings->next;
    }


}
