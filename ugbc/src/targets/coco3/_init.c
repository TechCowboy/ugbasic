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

extern char OUTPUT_FILE_TYPE_AS_STRING[][16];

void target_initialization( Environment * _environment ) {

    _environment->program.startingAddress = 0x2a00;

    cpu6809_init( _environment );

    // MEMORY_AREA_DEFINE( MAT_RAM, 0xe000, 0xff00 );

    banks_init( _environment );

    _environment->dstring.count = 32;
    _environment->dstring.space = 512;

    variable_import( _environment, "BITMAPADDRESS", VT_ADDRESS, 0x0c00 );
    variable_global( _environment, "BITMAPADDRESS" );
    variable_import( _environment, "COLORMAPADDRESS", VT_ADDRESS, 0xa000 );
    variable_global( _environment, "COLORMAPADDRESS" );
    variable_import( _environment, "TEXTADDRESS", VT_ADDRESS, 0x0400 );
    variable_global( _environment, "TEXTADDRESS" );    
    variable_import( _environment, "EMPTYTILE", VT_TILE, 32 );
    variable_global( _environment, "EMPTYTILE" );    
    variable_import( _environment, "DATAPTR", VT_ADDRESS, 0 );
    variable_global( _environment, "DATAPTR" );
    variable_import( _environment, "BANKSHADOW", VT_BYTE, 0 );
    variable_global( _environment, "BANKSHADOW" );

    bank_define( _environment, "VARIABLES", BT_VARIABLES, 0x5000, NULL );
    bank_define( _environment, "TEMPORARY", BT_TEMPORARY, 0x5100, NULL );
    variable_import( _environment, "FREE_STRING", VT_WORD, DSTRING_DEFAULT_SPACE );
    variable_global( _environment, "FREE_STRING" );    

    // outline0("ORG $2A00");
    // outline0("JMP CODESTART");
    // outhead0("IRQSTACK rzb 512");
    outhead0("CODESTART");
    outline0("LDS #IRQSTACK");
    outline0("STA $FFDF");

    deploy( vars, src_hw_coco3_vars_asm);
    deploy_deferred( startup, src_hw_coco3_startup_asm);
    bank_define( _environment, "STRINGS", BT_STRINGS, 0x4200, NULL );

    outline0( "JSR COCO3STARTUP2");
    outline0( "JSR COCO3STARTUP" );

    setup_text_variables( _environment );

    gime_initialization( _environment );
    cpu_call( _environment, "COCO3AUDIO1STARTUP" );
    sn76489m_initialization( _environment );

    if ( _environment->tenLinerRulesEnforced ) {
        cpu_call( _environment, "VARINIT" );
        shell_injection( _environment );
    }

    cpu_call( _environment, "VARINIT" );

}

void interleaved_instructions( Environment * _environment ) {

}