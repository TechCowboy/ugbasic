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
 * @brief Emit code for <strong>MOVE ...</strong>
 * 
 * @param _environment Current calling environment
 * @param _name Name of the procedure
 */
/* <usermanual>
@keyword MOVE

@english

The ''MOVE'' command allows you to activate a specific movement from the current 
position. If a movement is already active, it will be abruptly interrupted and 
the indicated one will be started.

It is also possible to indicate an animation to be run in a "synchronized" way 
with respect to the movement, using the keyword ''SYNC''. In particular, 
the synchronization will occur by executing the ease in of the animation and, 
at the end of the same, by starting the movement and the loop of the animation 
(which must therefore have one). At the end of the movement, the animation 
will be eased out.

@italian

Il comando ''MOVE'' consente di attivare un movimento specifico dalla posizione 
corrente. Se un movimento è già attivo, verrà interrotto bruscamente e verrà 
avviato quello indicato.

E' possibile indicare anche una animazione da far viaggiare in modo "sincronizzato" 
rispetto al movimento, usando la parola chiave ''SYNC''. In particolare, il 
sincronismo avverrà facendo eseguire l'ease in dell'animazione e, al termine 
della stessa, facendo partire lo spostamento e il loop dell'animazione (che deve 
quindi averne uno). Al termine del movimento, si avrà l'ease out dell'animazione.

@syntax MOVE id WITH movement [SYNC animation]
@syntax MOVE id TO x,y WITH movement [SYNC animation]

@example MOVE player TO 10, 10 WITH moveTo SYNC animWalking

</usermanual> */
void move( Environment * _environment, char * _prefix, char * _movement, char * _x, char * _y, char * _animation ) {

    char prefixMovement[MAX_TEMPORARY_STORAGE]; sprintf( prefixMovement, "%sMovement", _prefix );

    if ( ! variable_exists( _environment, prefixMovement ) ) {
        CRITICAL_CANNOT_USE_MOVE_WITHOUT_MOVEMENT(_prefix);
    }

    Variable * prefixMovementVar = variable_retrieve( _environment, prefixMovement );

    if ( prefixMovementVar->type != VT_THREAD ) {
        CRITICAL_CANNOT_USE_MOVE_WITHOUT_MOVEMENT(_prefix);
    }

    char prefixAnimation[MAX_TEMPORARY_STORAGE]; sprintf( prefixAnimation, "%sAnimation", _prefix );
    if ( _animation ) {

        if ( ! procedure_exists( _environment, _animation ) ) {
            CRITICAL_CANNOT_USE_MOVE_SYNC_WITHOUT_ANIMATIOn( _prefix, _animation );
        }

        animate_semivars( _environment, _prefix, _animation, NULL, NULL );

        char prefixSync[MAX_TEMPORARY_STORAGE]; sprintf( prefixSync, "%sSync", _prefix );
        Variable * prefixSyncVar = variable_retrieve( _environment, prefixSync );
        variable_store( _environment, prefixSyncVar->name, 0x01 );

    }

    // DIM [prefix]TX AS POSITION
    char prefixTX[MAX_TEMPORARY_STORAGE]; sprintf( prefixTX, "%sTX", _prefix );
    Variable * prefixTXVar;
    if ( _x ) {
        if ( ! variable_exists( _environment, prefixTX ) ) {
            CRITICAL_CANNOT_USE_ABSOLUTE_MOVE_WITHOUT_ABSOLUTE_MOVEMENT(_prefix);
        }
        Variable * x = variable_retrieve_or_define( _environment, _x, VT_POSITION, 0 );
        prefixTXVar = variable_retrieve( _environment, prefixTX );
        variable_move( _environment, x->name, prefixTXVar->name );
    }

    // DIM [prefix]TY AS POSITION
    char prefixTY[MAX_TEMPORARY_STORAGE]; sprintf( prefixTY, "%sTY", _prefix );
    Variable * prefixTYVar;
    if ( _y ) {
        if ( ! variable_exists( _environment, prefixTY ) ) {
            CRITICAL_CANNOT_USE_ABSOLUTE_MOVE_WITHOUT_ABSOLUTE_MOVEMENT(_prefix);
        }
        Variable * y = variable_retrieve_or_define( _environment, _y, VT_POSITION, 0 );
        prefixTYVar = variable_retrieve( _environment, prefixTY );
        variable_move( _environment, y->name, prefixTYVar->name );
    }

    MAKE_LABEL

    char skipKillLabel[MAX_TEMPORARY_STORAGE]; sprintf( skipKillLabel, "%sskip", label );
    cpu_compare_and_branch_8bit_const( _environment, prefixMovementVar->realName, 0xff, skipKillLabel, 1 );

    // KILL playerAnimation
    kill_procedure( _environment, prefixMovementVar->name );

    cpu_label( _environment, skipKillLabel );

    // playerAnimation = SPAWN animPlayerPunch
    variable_move( _environment, spawn_procedure( _environment, _movement, 0 )->name, prefixMovementVar->name );
   
    run_parallel( _environment );

}
