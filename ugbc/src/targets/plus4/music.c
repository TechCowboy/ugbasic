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

/**
 * @brief Emit ASM code for <b>MUSIC ...</b>
 * 
 * This function emits a code capable of play a music.
 * 
 * @param _environment Current calling environment
 * @param _music music to play
 */
/* <usermanual>
@keyword MUSIC
@target plus4
</usermanual> */
void music_var( Environment * _environment, char * _music, int _loop, int _music_type ) {

    if ( _environment->emptyProcedure ) {
        return;
    }
    
    Variable * music = variable_retrieve( _environment, _music );

    if ( _music_type == MUSIC_TYPE_AUTO ) {
        if ( music->type != VT_MUSIC ) {
            CRITICAL_CANNOT_MUSIC( _music );
        }

        if ( ! music->sidFile ) {
            ted_start( _environment, 0xff );
            ted_music( _environment, music->realName, music->size, _loop );
        }
    }
    
}

/* <usermanual>
@keyword MUSIC PAUSE

@target plus4
</usermanual> */
void music_pause( Environment * _environment ) {
    
    cpu_store_8bit( _environment, "TEDMUSICPAUSE", 0xff );
    volume( _environment, 0, 0x7 );

}

/* <usermanual>
@keyword MUSIC RESUME

@target plus4
</usermanual> */
void music_resume( Environment * _environment ) {

    cpu_store_8bit( _environment, "TEDMUSICPAUSE", 0x0 );
    volume( _environment, 255, 0x7 );

}

/* <usermanual>
@keyword MUSIC STOP

@target plus4
</usermanual> */
void music_stop( Environment * _environment ) {

    cpu_store_8bit( _environment, "TEDMUSICLOOP", 0x0 );
    cpu_store_8bit( _environment, "TEDMUSICREADY", 0x0 );
    volume( _environment, 0, 0x7 );

}

/* <usermanual>
@keyword MUSIC SEEK

@target plus4
</usermanual> */
void music_seek_var( Environment * _environment, char * _position ) {

    Variable * position = variable_retrieve_or_define( _environment, _position, VT_WORD, 0 );

    cpu_move_8bit( _environment, address_displacement( _environment, position->realName, "1" ), "TEDBLOCKS" );
    cpu_move_8bit( _environment, position->realName, "TEDLASTBLOCK" );

}
