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

/**
 * @brief Emit ASM code for <b>BELL ...</b>
 * 
 * This function emits a code capable of play a bell sound
 * 
 * @param _environment Current calling environment
 * @param _pitch frequency to play
 * @param _channels channels to play on
 */
/* <usermanual>
@keyword BELL
@target gb
</usermanual> */
void bell( Environment * _environment, int _note, int _duration, int _channels ) {

    gb_start( _environment, ( _channels & 0x03 ) );
    gb_set_program( _environment, ( _channels & 0x03 ), IMF_INSTRUMENT_GLOCKENSPIEL );
    gb_set_note( _environment, ( _channels & 0x03 ), _note );

    long durationInCycles = ( _duration / 20 ) & 0xffff;

    gb_set_duration( _environment,  ( _channels & 0x03 ), durationInCycles );

    if ( ! _environment->audioConfig.async ) {
        gb_wait_duration( _environment, _channels );
    }

}

/**
 * @brief Emit ASM code for <b>BELL ...</b>
 * 
 * This function emits a code capable of play a bell-like sound.
 * 
 * @param _environment Current calling environment
 * @param _pitch frequency to play
 * @param _channels channels to play on
 */
/* <usermanual>
@keyword BELL
@target gb
</usermanual> */
void bell_vars( Environment * _environment, char * _note, char * _duration, char * _channels, int _sync ) {

    Variable * note = variable_retrieve_or_define( _environment, _note, VT_WORD, 42 );
    if ( _channels ) {
        Variable * channels = variable_retrieve_or_define( _environment, _channels, VT_WORD, 0x03 );
        gb_start_var( _environment, channels->realName );
        gb_set_program_semi_var( _environment, channels->realName, IMF_INSTRUMENT_GLOCKENSPIEL );
        gb_set_note_vars( _environment, channels->realName, note->realName );
        if ( _duration ) {
            Variable * duration = variable_retrieve_or_define( _environment, _duration, VT_WORD, 1500 );
            Variable * durationInTicks = variable_div_const( _environment, duration->name, 20, NULL );
            gb_set_duration_vars( _environment, channels->realName, durationInTicks->realName );
        } else {
            gb_set_duration_vars( _environment, channels->realName, NULL );
        } 
    } else {
        gb_start_var( _environment, NULL );
        gb_set_program_semi_var( _environment, NULL, IMF_INSTRUMENT_GLOCKENSPIEL );
        gb_set_note_vars( _environment, NULL, note->realName );
        if ( _duration ) {
            Variable * duration = variable_retrieve_or_define( _environment, _duration, VT_WORD, 1500 );
            Variable * durationInTicks = variable_div_const( _environment, duration->name, 20, NULL );
            gb_set_duration_vars( _environment, NULL, durationInTicks->realName );
        } else {
            gb_set_duration_vars( _environment, NULL, NULL );
        } 
    }

    if ( ! _environment->audioConfig.async || _sync ) {
        gb_wait_duration_vars( _environment, _channels );
    }
}