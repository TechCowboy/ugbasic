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

void pause_seconds( Environment * _environment, char * _string, char * _duration ) {

    MAKE_LABEL

    char loopLabel[MAX_TEMPORARY_STORAGE]; sprintf( loopLabel, "%sloop", label );

    if ( _string ) {
        print( _environment, _string, 0 );
    }

    Variable * duration = variable_retrieve_or_define( _environment, _duration, VT_BYTE, 0 );
    Variable * count = variable_temporary( _environment, VT_BYTE, "(count)" );

    variable_move( _environment, duration->name, count->name );

    cpu_label( _environment, loopLabel );
    cpu_compare_and_branch_8bit_const( _environment, count->realName, 0, label, 1 );
    wait_milliseconds( _environment, 1000 );
    cpu_dec( _environment, count->realName );
    cpu_jump( _environment, loopLabel );

    cpu_label( _environment, label );

}