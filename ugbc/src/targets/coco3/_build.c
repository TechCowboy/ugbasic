/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
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

extern char OUTPUT_FILE_TYPE_AS_STRING[][16];

void generate_bin( Environment * _environment ) {

    char commandLine[8*MAX_TEMPORARY_STORAGE];
    char executableName[MAX_TEMPORARY_STORAGE];
    char listingFileName[MAX_TEMPORARY_STORAGE];
    char binaryName[MAX_TEMPORARY_STORAGE];

    BUILD_SAFE_REMOVE( _environment, _environment->exeFileName );

    strcpy( binaryName, _environment->exeFileName );
    char * p = strstr( binaryName, ".dsk" );
    if ( p ) {
        strcpy( p, ".bin" );
    }
    strcpy( _environment->exeFileName, binaryName );

    BUILD_TOOLCHAIN_ASM6809_GET_EXECUTABLE( _environment, executableName );

    BUILD_TOOLCHAIN_ASM6809_GET_LISTING_FILE( _environment, listingFileName );

    BUILD_TOOLCHAIN_ASM6809EXEC( _environment, "-C", 0x2A00, executableName, listingFileName );

    if ( _environment->listingFileName ) {

        if ( _environment->profileFileName && _environment->profileCycles ) {
            if ( _environment->executerFileName ) {
                sprintf(executableName, "%s", _environment->executerFileName );
            } else if( access( "run6809.exe", F_OK ) == 0 ) {
                sprintf(executableName, "%s", "run6809.exe" );
            } else {
                sprintf(executableName, "%s", "run6809" );
            }

            sprintf( commandLine, "\"%s\" -i \"%s\" -R 2800 -C -l 0 \"%s\" -p \"%s\" %d",
                executableName,
                _environment->listingFileName,
                _environment->exeFileName,
                _environment->profileFileName,
                _environment->profileCycles ? _environment->profileCycles : 1000000
                );

            if ( system_call( _environment,  commandLine ) ) {
                printf("The profiling of assembly program failed.\n\n");
                return;
            }; 

        }
    
    }

}

void generate_dsk( Environment * _environment ) {

    Storage * storage = _environment->storage;

    char temporaryPath[MAX_TEMPORARY_STORAGE];
    strcpy( temporaryPath, _environment->temporaryPath );
    strcat( temporaryPath, " " );
    temporaryPath[strlen(temporaryPath)-1] = PATH_SEPARATOR;

    char commandLine[8*MAX_TEMPORARY_STORAGE];
    char executableName[MAX_TEMPORARY_STORAGE];
    char listingFileName[MAX_TEMPORARY_STORAGE];
    char binaryName[MAX_TEMPORARY_STORAGE];
    char originalFileName[MAX_TEMPORARY_STORAGE];

    int fileSize = 0;
    int standardSize = 0;
    int ondemandSize = 0;
    int blockSize = 0;
    int blocks = 0;
    int block = 0;
    int remainSize = 0;

    strcpy( binaryName, _environment->exeFileName );

    BUILD_TOOLCHAIN_DECB_GET_EXECUTABLE( _environment, executableName );

    FILE * fh = fopen( binaryName, "rb" );
    if ( fh ) {
        fseek( fh, 0, SEEK_END );
        fileSize = ftell( fh );
        fclose( fh );
    } else {
        CRITICAL( "cannot create dsk file");
    }

    if ( fileSize < 22016 ) {
        
        standardSize = fileSize - 10;
        ondemandSize = 0;
        blockSize = 4096;
        blocks = 0;
        remainSize = 0;

    } else {

        standardSize = 22016;
        ondemandSize = fileSize - standardSize - 10;
        blockSize = 4096;
        blocks = ( ondemandSize / blockSize ) + 1;
        remainSize = ondemandSize - ( ( blocks - 1 ) * blockSize ) - 5;

    }

    int programExeSize = 5 + standardSize + data_coco3_footer_bin_len;

    char * programExe = malloc( programExeSize );
    memset( programExe, 0, programExeSize );
    fh = fopen( binaryName, "rb" );
    if ( !fh ) {
        CRITICAL( "cannot create dsk file");
    }        
    (void)!fread( &programExe[0], 1, standardSize + 5, fh );
    programExe[1] = standardSize >> 8;
    programExe[2] = standardSize & 0xff;
    memcpy( &programExe[standardSize + 5], &data_coco3_footer_bin[0], data_coco3_footer_bin_len );

    char * programBlocks = NULL;
    int programBlockSize = 0;

    if ( blocks ) {

        programBlockSize = 5 + blockSize + data_coco3_footer_bin_len;
        programBlocks = malloc( programBlockSize * blocks );
        memset( &programBlocks[0], 0, programBlockSize * blocks );

        for( int block; block < blocks; ++block ) {

            memcpy( &programBlocks[block * programBlockSize], &data_coco3_header_bin[0], data_coco3_header_bin_len );

            if ( block < ( blocks - 1 ) ) {
                (void)!fread( &programBlocks[block * programBlockSize + data_coco3_header_bin_len], 1, blockSize, fh );
                memcpy( &programBlocks[block * programBlockSize + data_coco3_header_bin_len + blockSize], &data_coco3_footer_bin[0], data_coco3_footer_bin_len );
            } else {
                (void)!fread( &programBlocks[block * programBlockSize + data_coco3_header_bin_len], 1, remainSize + 5, fh );
                programBlocks[block * programBlockSize + 1] = ( remainSize + 5 ) >> 8;
                programBlocks[block * programBlockSize + 2] = ( remainSize + 5 ) & 0xff;
                memcpy( &programBlocks[block * programBlockSize + data_coco3_header_bin_len + remainSize + 5], &data_coco3_footer_bin[0], data_coco3_footer_bin_len );
            }

        }

    }

    fclose( fh );

    char buffer[MAX_TEMPORARY_STORAGE];
    if ( storage ) {
        char filemask[MAX_TEMPORARY_STORAGE];
        strcpy( filemask, _environment->exeFileName );
        char * basePath = find_last_path_separator( filemask );
        if ( basePath ) {
            ++basePath;
            *basePath = 0;
            if ( storage->fileName ) {
                strcat( basePath, storage->fileName );
            } else {
                strcat( basePath, "disk%d.dsk" );
            }
        } else {
            if ( storage->fileName ) {
                strcpy( filemask, storage->fileName );
            } else {
                strcpy( filemask, "disk%d.dsk" );
            }
        }
        sprintf( buffer, filemask, 0 );
        if ( !strstr( buffer, ".dsk" ) ) {
            strcat( buffer, ".dsk" );
        }
        _environment->exeFileName = strdup( buffer );
    } else {
        strcpy( binaryName, _environment->exeFileName );
        char * p = strstr( binaryName, ".bin" );
        if ( p ) {
            strcpy( p, ".dsk" );
        }
        _environment->exeFileName = strdup( binaryName );
    }

    remove( _environment->exeFileName );
    sprintf( commandLine, "\"%s\" dskini \"%s\"", executableName, _environment->exeFileName );
    if ( system_call( _environment,  commandLine ) ) {
        printf("The compilation of assembly program failed.\n\n");
        printf("Please use option '-I' to install chain tool.\n\n");
    };

    char * loaderBas = malloc( MAX_TEMPORARY_STORAGE * 100 );

    strcpy( loaderBas, "1 REM ugBASIC loader\n" );
    strcat( loaderBas, "2 REM --[ PROLOGUE ]--\n" );
    strcat( loaderBas, "3 DATA  26, 80, 52, 16, 52,  6,142, 14\n");
    strcat( loaderBas, "4 DATA   0,191,  0, 31, 31, 65, 16,206\n");
    strcat( loaderBas, "5 DATA  15,  0, 16,255,  0, 33,198,255\n");
    strcat( loaderBas, "6 DATA 166,133,167,229, 90, 38,249, 53\n");
    strcat( loaderBas, "7 DATA   6, 53, 16, 28,159, 57, 26, 80\n");
    strcat( loaderBas, "8 DATA 206, 16,  0,142, 42,  0, 16,142\n");
    strcat( loaderBas, "9 DATA  42,  0,183,255,223,166,128,167\n");
    strcat( loaderBas, "10DATA 160, 51, 95, 17,131,  0,  0, 38\n");
    strcat( loaderBas, "11DATA 244,183,255,222, 28,159, 57, 26\n");
    strcat( loaderBas, "12DATA  80,206, 16,  0,142, 42,  0, 16\n");
    strcat( loaderBas, "13DATA 142,192,  0,183,255,223,134,  0\n");
    strcat( loaderBas, "14DATA 183,255,166,166,128,167,160, 51\n");
    strcat( loaderBas, "15DATA  95, 17,131,  0,  0, 38,244,134\n");
    strcat( loaderBas, "16DATA  62,183,255,166,183,255,222, 28\n");
    strcat( loaderBas, "17DATA 159, 57,  0\n" );
    strcat( loaderBas, "18FORA=&HE00 TO &HE71:READX:POKEA,X:NEXTA\n" );
    strcat( loaderBas, "19REM --[ MAIN ]--\n" );
    strcat( loaderBas, "20CLEAR 999: PRINT \"LOADING, PLEASE WAIT\";\n" );

    int lineNr = 21;

    Bank * bank = _environment->expansionBanks;
    while( bank ) {
        int bankSize = bank->space - bank->remains;
        if ( bankSize ) {
            char line[MAX_TEMPORARY_STORAGE];

            if ( bankSize > blockSize ) {
                sprintf( line, "%dLOADM\"BANK0.%03d\":PRINT\".\";\n", lineNr, bank->id);
                strcat( loaderBas, line );
                ++lineNr;

                sprintf( line, "%dPOKE &HE51, &HC0: POKE &HE57, %d: EXEC &HE47\n", lineNr, bank->id);
                strcat( loaderBas, line );
                ++lineNr;

                sprintf( line, "%dLOADM\"BANK1.%03d\":PRINT\".\";\n", lineNr, bank->id);
                strcat( loaderBas, line );
                ++lineNr;

                sprintf( line, "%dPOKE &HE51, &HD0: EXEC &HE47\n", lineNr);
                strcat( loaderBas, line );
                ++lineNr;

            } else {
                sprintf( line, "%dEXEC &HE46: LOADM\"BANK0.%03d\":PRINT\".\";\n", lineNr, bank->id);
                strcat( loaderBas, line );
                ++lineNr;

                sprintf( line, "%dPOKE &HE51, &HC0: POKE &HE57, %d: EXEC &HE47\n", lineNr, bank->id);
                strcat( loaderBas, line );
                ++lineNr;

            }

        }
        bank = bank->next;
    }

    char line[MAX_TEMPORARY_STORAGE];
    for( block = 0; block < blocks; ++block ) {

        sprintf( line, "%dLOADM\"PROGRAM.%03d\":PRINT\".\";\n", lineNr, block);
        strcat( loaderBas, line );
        ++lineNr;

        int address = 128 + block*16;
        sprintf( line, "%dPOKE &HE30, %d: EXEC &HE26\n", lineNr, address);
        strcat( loaderBas, line );
        ++lineNr;

    }

    sprintf( line, "%dEXEC &HE00: PRINT \"...\";: LOADM\"PROGRAM.EXE\": PRINT \"...\": EXEC\n", lineNr);
    strcat( loaderBas, line );
    ++lineNr;

    char basFileName[MAX_TEMPORARY_STORAGE];
    sprintf( basFileName, "%sloader.bas", temporaryPath );
    
    fh = fopen( basFileName, "wb" );
    fwrite( loaderBas, 1, strlen(loaderBas), fh );
    fclose( fh );
    
    sprintf( commandLine, "\"%s\" copy -0 -t \"%s\" \"%s,LOADER.BAS\"",
        executableName, 
        basFileName, 
        _environment->exeFileName );
    if ( system_call( _environment,  commandLine ) ) {
        printf("The compilation of assembly program failed.\n\n"); 
        printf("Please use option '-I' to install chain tool.\n\n");
    };

    remove( basFileName );

    char tempFileName[MAX_TEMPORARY_STORAGE];
    sprintf( tempFileName, "%sprogram.exe", temporaryPath );

    fh = fopen( tempFileName, "wb" );
    fwrite( programExe, 1, programExeSize, fh );
    fclose( fh );
    
    sprintf( commandLine, "\"%s\" copy -2 \"%s\" \"%s,PROGRAM.EXE\"",
        executableName, 
        tempFileName, 
        _environment->exeFileName );
    if ( system_call( _environment,  commandLine ) ) {
        printf("The compilation of assembly program failed.\n\n"); 
        printf("Please use option '-I' to install chain tool.\n\n");
    };

    // remove( tempFileName );

    for( block = 0; block < blocks; ++block ) {

        sprintf( tempFileName, "%sprogram.%03d", temporaryPath, block );

        fh = fopen( tempFileName, "wb" );
        fwrite( &programBlocks[block * programBlockSize], 1, ( block < ( blocks - 1 ) ) ? programBlockSize : ( remainSize + 15 ), fh );
        fclose( fh );
        
        sprintf( commandLine, "\"%s\" copy -2 \"%s\" \"%s,PROGRAM.%03d\"",
            executableName, 
            tempFileName, 
            _environment->exeFileName,
            block );
        if ( system_call( _environment,  commandLine ) ) {
            printf("The compilation of assembly program failed.\n\n"); 
            printf("Please use option '-I' to install chain tool.\n\n");
        };

        // remove( tempFileName );

    }

    bank = _environment->expansionBanks;
    while( bank ) {
        int bankSize = bank->space - bank->remains;
        if ( bankSize > 0 ) {
            int effectiveSize = blockSize > bankSize ? bankSize : blockSize;
            char bankFileName[MAX_TEMPORARY_STORAGE];
            sprintf( bankFileName, "%sbank0.%03d", temporaryPath, bank->id );
            fh = fopen( bankFileName, "wb" );
            fputc( 0, fh );
            fputc( (unsigned char) ( ( effectiveSize >> 8 ) & 0xff ), fh );
            fputc( (unsigned char) ( ( effectiveSize ) & 0xff ), fh );
            fputc( 0x2a, fh );
            fputc( 0x00, fh );
            fwrite( &bank->data[0], 1, effectiveSize, fh );
            fputc( 0xff, fh );
            fputc( 0x00, fh );
            fputc( 0x00, fh );
            fputc( 0x2a, fh );
            fputc( 0x00, fh );
            fputc( 0x00, fh );

            fclose( fh );
            sprintf( commandLine, "\"%s\" copy -2 -b \"%s\" \"%s,BANK0.%03d\"",
                executableName, 
                bankFileName, 
                _environment->exeFileName,
                bank->id );
            if ( system_call( _environment,  commandLine ) ) {
                printf("The compilation of assembly program failed.\n\n"); 
                printf("Please use option '-I' to install chain tool.\n\n");
                exit(0);
            };
            // remove( bankFileName );

            if ( bankSize > blockSize ) {
                effectiveSize = bankSize - blockSize;
                sprintf( bankFileName, "%sbank1.%03d", temporaryPath, bank->id );
                fh = fopen( bankFileName, "wb" );
                fputc( 0, fh );
                fputc( (unsigned char) ( ( effectiveSize >> 8 ) & 0xff ), fh );
                fputc( (unsigned char) ( ( effectiveSize ) & 0xff ), fh );
                fputc( 0x2a, fh );
                fputc( 0x00, fh );
                fwrite( &bank->data[blockSize], 1, bankSize - blockSize, fh );
                fputc( 0xff, fh );
                fputc( 0x00, fh );
                fputc( 0x00, fh );
                fputc( 0x2a, fh );
                fputc( 0x00, fh );
                fputc( 0x00, fh );
                fclose( fh );
                sprintf( commandLine, "\"%s\" copy -2 -b \"%s\" \"%s,BANK1.%03d\"",
                    executableName, 
                    bankFileName, 
                    _environment->exeFileName,
                    bank->id );
                if ( system_call( _environment,  commandLine ) ) {
                    printf("The compilation of assembly program failed.\n\n"); 
                    printf("Please use option '-I' to install chain tool.\n\n");
                    exit(0);
                };
                // remove( bankFileName );
            }
        }
        bank = bank->next;
    }

    if ( !storage ) {

    } else {
        strcpy( buffer, _environment->exeFileName );
        int i=0;
        while( storage ) {
            FileStorage * fileStorage = storage->files;
            while( fileStorage ) {
                int size;
                char * buffer;

                if ( fileStorage->content && fileStorage->size ) {
                    size = fileStorage->size + 2;
                    buffer = malloc( size );
                    memset( buffer, 0, size );
                    memcpy( buffer, fileStorage->content, fileStorage->size );
                } else {
                    FILE * file = fopen( fileStorage->sourceName, "rb" );
                    if ( !file ) {
                        CRITICAL_DLOAD_MISSING_FILE( fileStorage->sourceName );
                    }
                    fseek( file, 0, SEEK_END );
                    size = ftell( file );
                    fseek( file, 0, SEEK_SET );
                    buffer = malloc( size );
                    memset( buffer, 0, size );
                    (void)!fread( buffer, size, 1, file );
                    fclose( file );
                }
                char dataFilename[MAX_TEMPORARY_STORAGE];
                sprintf( dataFilename, "%s%s", temporaryPath, fileStorage->targetName );
                FILE * fileOut = fopen( dataFilename, "wb" );
                if ( fileOut ) {
                    fwrite( buffer, 1, size, fileOut );
                    fclose(fileOut );
                }
                sprintf( commandLine, "\"%s\" copy -1 -b \"%s\" \"%s,%s\"",
                    executableName, 
                    dataFilename, 
                    _environment->exeFileName,
                    fileStorage->targetName );
                if ( system_call( _environment,  commandLine ) ) {
                    printf("The compilation of assembly program failed.\n\n"); 
                    printf("Please use option '-I' to install chain tool.\n\n");
                };
                fileStorage = fileStorage->next;
            }

            storage = storage->next;
            ++i;

            if ( storage ) {

                char filemask[MAX_TEMPORARY_STORAGE];
                strcpy( filemask, _environment->exeFileName );
                char * basePath = find_last_path_separator( filemask );
                if ( basePath ) {
                    ++basePath;
                    *basePath = 0;
                    if ( storage->fileName ) {
                        strcat( basePath, storage->fileName );
                    } else {
                        strcat( basePath, "disk%d.dsk" );
                    }
                } else {
                    if ( storage->fileName ) {
                        strcpy( filemask, storage->fileName );
                    } else {
                        strcpy( filemask, "disk%d.dsk" );
                    }
                }
                sprintf( buffer, filemask, i );
                if ( !strstr( buffer, ".dsk" ) ) {
                    strcat( buffer, ".dsk" );
                }
                remove( buffer );
                sprintf( commandLine, "\"%s\" dskini \"%s\"", executableName, buffer );
                if ( system_call( _environment,  commandLine ) ) {
                    printf("The compilation of assembly program failed.\n\n");
                    printf("Please use option '-I' to install chain tool.\n\n");
                };

            }

        }

    }

}

void target_linkage( Environment * _environment ) {

    switch( _environment->outputFileType ) {
        case OUTPUT_FILE_TYPE_BIN:
            generate_bin( _environment );
            break;
        case OUTPUT_FILE_TYPE_DSK:
            generate_bin( _environment );
            generate_dsk( _environment );
            break;
        default:
            CRITICAL_UNSUPPORTED_OUTPUT_FILE_TYPE( OUTPUT_FILE_TYPE_AS_STRING[_environment->outputFileType] );
    }

}

void target_cleanup( Environment * _environment ) {

    remove( _environment->asmFileName );

    if ( _environment->analysis && _environment->listingFileName ) {
        target_analysis( _environment );
    }

}
