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
 * @brief Emit code for <strong>MOVEMENT ...</strong>
 * 
 * @param _environment Current calling environment
 * @param _name Name of the procedure
 */
/* <usermanual>
@keyword MOVEMENT

@english

The ''MOVEMENT'' command allows you to define a movement of an object,
starting from a given ''ATLAS'' and giving a destination, that can be
relative to the current position or absolute. Once defined, the 
movement, IT can then be used at any time.

In order for this to work, you need to indicate a variable prefix that will be 
associated with the trajectorty of the object that will have this movement. 
This can be indicated with the ''USING'' keyword. 

The relative movement lasts as the number of the frames contained in the
''ATLAS'' given with the ''WITH'' keyword. The absolute movement, instead,
depends on the original and destination position.

This statement will generate a series of variables: on relative movements,
'prefixSteps'' which will be decremented to zero when movement is ended; 
''prefixX'' and ''prefixY'', which will contain the position where 
the object is located actually. If a movement to a position is required, 
the ''prefixTX'' and ''prefixTY'' variables will contain the destination 
position, white ''prefixPath'' will be defined, to take track of the 
movement itself.

@italian

Il comando ''MOVEMENT'' consente di definire uno spostamento di un oggetto, 
partendo da un dato ''ATLAS'' e dando una destinazione, che può essere 
relativa alla posizione corrente o assoluta. Una volta definito, lo spostamento, 
può essere utilizzato in qualsiasi momento.

Affinché ciò funzioni, è necessario indicare un prefisso di variabile che sarà 
associato alla traiettoria dell'oggetto che avrà questo spostamento. Questo può 
essere indicato con la parola chiave ''USING''.

Lo spostamento relativo dura come il numero di frame contenuti nell''ATLAS'' dato 
con la parola chiave ''WITH''. Lo spostamento assoluto, invece, dipende dalla 
posizione di origine e di destinazione.

Questa istruzione genererà una serie di variabili: sugli spostamenti relativi, 
''prefixSteps'' che verrà decrementato a zero quando lo spostamento sarà terminato; 
''prefixX'' e ''prefixY'', che conterranno la posizione in cui si trova effettivamente
l'oggetto. Se è richiesto uno spostamento verso una posizione, le variabili 
''prefixTX'' e ''prefixTY'' conterranno la posizione di destinazione, mentre 
verrà definito ''prefixPath'' per tenere traccia dello spostamento stesso.

@syntax MOVEMENT id TO LEFT|RIGHT|UP|DOWN WITH atlas [DELAY delay] USING player
@syntax MOVEMENT id TO POSITION [DELAY delay] USING player

@example MOVEMENT moveLeft TO LEFT WITH playerForward USING player

</usermanual> */
void movement( Environment * _environment, char * _identifier, char * _atlas, char * _prefix ) {

    if ( _environment->procedureName ) {
        CRITICAL_CANNOT_DEFINE_MOVEMENT_INSIDE_A_PROCEDURE( _identifier );
    }

    Variable * atlas;
    
    if ( (_environment->movementDeltaX == 0) && (_environment->movementDeltaY == 0) ) {

    } else {
        atlas = variable_retrieve( _environment, _atlas );
        if ( atlas->type != VT_IMAGES ) {
            CRITICAL_CANNOT_DEFINE_MOVEMENT_WITHOUT_ATLAS( _identifier );
        }
    }

	// DIM [prefix]Movement AS THREAD
    char prefixMovement[MAX_TEMPORARY_STORAGE]; sprintf( prefixMovement, "%sMovement", _prefix );
    Variable * prefixMovementVar = variable_define( _environment, prefixMovement, VT_THREAD, 0 );

	// DIM [prefix]X AS POSITION
    char prefixX[MAX_TEMPORARY_STORAGE]; sprintf( prefixX, "%sX", _prefix );
    Variable * prefixXVar = variable_define( _environment, prefixX, VT_POSITION, 0 );

	// DIM [prefix]Y AS POSITION
    char prefixY[MAX_TEMPORARY_STORAGE]; sprintf( prefixY, "%sY", _prefix );
    Variable * prefixYVar = variable_define( _environment, prefixY, VT_POSITION, 0 );

	// DIM [prefix]TX AS POSITION
    char prefixTX[MAX_TEMPORARY_STORAGE]; sprintf( prefixTX, "%sTX", _prefix );
    Variable * prefixTXVar;

	// DIM [prefix]TY AS POSITION
    char prefixTY[MAX_TEMPORARY_STORAGE]; sprintf( prefixTY, "%sTY", _prefix );
    Variable * prefixTYVar;

	// DIM [prefix]Steps AS BYTE
    char prefixSteps[MAX_TEMPORARY_STORAGE]; sprintf( prefixSteps, "%sSteps", _prefix );
    Variable * prefixStepsVar = NULL;
    // DIM [prefix]Path AS PATH
    char prefixPath[MAX_TEMPORARY_STORAGE]; sprintf( prefixPath, "%sPath", _prefix );
    Variable * prefixPathVar = NULL;
    if ( (_environment->movementDeltaX == 0) && (_environment->movementDeltaY == 0) ) {
        prefixPathVar = variable_define( _environment, prefixPath, VT_PATH, 0 );
        prefixTXVar = variable_define( _environment, prefixTX, VT_POSITION, 0 );
        prefixTYVar = variable_define( _environment, prefixTY, VT_POSITION, 0 );
    } else {
        prefixStepsVar = variable_define( _environment, prefixSteps, VT_BYTE, 0 );
    }

	// PARALLEL PROCEDURE moveLeft
    ((struct _Environment *)_environment)->parameters = 0;
    ((struct _Environment *)_environment)->protothread = 1;
    ((struct _Environment *)_environment)->emptyProcedure = 0;
    begin_procedure( _environment, _identifier );

	// 	SHARED  [prefix]Movement
    ((struct _Environment *)_environment)->parametersEach[((struct _Environment *)_environment)->parameters] = strdup( prefixMovement );
    ((struct _Environment *)_environment)->parametersTypeEach[((struct _Environment *)_environment)->parameters] = VT_THREAD;
    ++((struct _Environment *)_environment)->parameters;

	// 	SHARED  [prefix]X
    ((struct _Environment *)_environment)->parametersEach[((struct _Environment *)_environment)->parameters] = strdup( prefixX );
    ((struct _Environment *)_environment)->parametersTypeEach[((struct _Environment *)_environment)->parameters] = VT_POSITION;
    ++((struct _Environment *)_environment)->parameters;

	// 	SHARED  [prefix]Y
    ((struct _Environment *)_environment)->parametersEach[((struct _Environment *)_environment)->parameters] = strdup( prefixY );
    ((struct _Environment *)_environment)->parametersTypeEach[((struct _Environment *)_environment)->parameters] = VT_POSITION;
    ++((struct _Environment *)_environment)->parameters;

    if ( (_environment->movementDeltaX == 0) && (_environment->movementDeltaY == 0) ) {
        // 	SHARED  [prefix]TX
        ((struct _Environment *)_environment)->parametersEach[((struct _Environment *)_environment)->parameters] = strdup( prefixTX );
        ((struct _Environment *)_environment)->parametersTypeEach[((struct _Environment *)_environment)->parameters] = VT_POSITION;
        ++((struct _Environment *)_environment)->parameters;

        // 	SHARED  [prefix]TY
        ((struct _Environment *)_environment)->parametersEach[((struct _Environment *)_environment)->parameters] = strdup( prefixTY );
        ((struct _Environment *)_environment)->parametersTypeEach[((struct _Environment *)_environment)->parameters] = VT_POSITION;
        ++((struct _Environment *)_environment)->parameters;

        // 	SHARED  [prefix]Path
        ((struct _Environment *)_environment)->parametersEach[((struct _Environment *)_environment)->parameters] = strdup( prefixPath );
        ((struct _Environment *)_environment)->parametersTypeEach[((struct _Environment *)_environment)->parameters] = VT_PATH;
        ++((struct _Environment *)_environment)->parameters;

    }

	// 	SHARED  [prefix]Steps
    ((struct _Environment *)_environment)->parametersEach[((struct _Environment *)_environment)->parameters] = strdup( prefixSteps );
    ((struct _Environment *)_environment)->parametersTypeEach[((struct _Environment *)_environment)->parameters] = VT_BYTE;
    ++((struct _Environment *)_environment)->parameters;

    shared( _environment );

    MAKE_LABEL

    outline0("; -----!!!!----");
    if ( (_environment->movementDeltaX == 0) && (_environment->movementDeltaY == 0) ) {
        // t = CREATE PATH OP optional_x OP_COMMA optional_y TO expr OP_COMMA expr CP
        variable_move( _environment, create_path( _environment, prefixXVar->name, prefixYVar->name, prefixTXVar->name, prefixTYVar->name )->name, prefixPathVar->name );
    } else {
        // 	[prefix]Steps = FRAMES( [atlas] )
        variable_store( _environment, prefixStepsVar->name, atlas->frameCount );		
    }

    char loopLabel[MAX_TEMPORARY_STORAGE]; sprintf( loopLabel, "%sloop", label );
    char loopDoneLabel[MAX_TEMPORARY_STORAGE]; sprintf( loopDoneLabel, "%sdone", label );

	// 	DO
    cpu_label( _environment, loopLabel );

        if ( (_environment->movementDeltaX == 0) && (_environment->movementDeltaY == 0) ) {
            //      TRAVEL t TO x, y
            travel_path( _environment, prefixPathVar->name, prefixXVar->name, prefixYVar->name );
        } else {
            if ( _environment->movementDeltaX == 1) {
                // 		INC prefixXVar
                variable_increment( _environment, prefixXVar->name );
            } else if ( _environment->movementDeltaX == -1) {
                // 		DEC playerX
                variable_decrement( _environment, prefixXVar->name );
            }

            if ( _environment->movementDeltaY == 1) {
                // 		INC playerX
                variable_increment( _environment, prefixYVar->name );
            } else if ( _environment->movementDeltaY == -1) {
                // 		DEC playerX
                variable_decrement( _environment, prefixYVar->name );
            }
        }
	// 		WAIT 50 MS
        wait_milliseconds( _environment, _environment->movementDelay );

        if ( (_environment->movementDeltaX == 0) && (_environment->movementDeltaY == 0) ) {
            //      EXIT IF x = x1 AND y = y1
            cpu_compare_and_branch_16bit_const( _environment, 
                variable_or( 
                    _environment,
                    variable_xor( _environment, prefixXVar->name, prefixTXVar->name )->name, 
                    variable_xor( _environment, prefixYVar->name, prefixTYVar->name )->name
                )->realName,
                0, loopDoneLabel, 1 );
        } else {
        // 		DEC playerSteps
            variable_decrement( _environment, prefixStepsVar->name );

        // 		EXIT IF playerSteps = 0
            cpu_compare_and_branch_8bit_const( _environment, prefixStepsVar->realName, 0, loopDoneLabel, 1 );

        }

	// 	LOOP
    cpu_jump( _environment, loopLabel );
		
    cpu_label( _environment, loopDoneLabel );

	// END PROC
    end_procedure( _environment, NULL );

}
