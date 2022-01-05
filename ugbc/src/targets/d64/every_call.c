/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021-2022 Marco Spedaletti (asimov@mclink.it)
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

void every_ticks_call( Environment * _environment, char * _timing, char * _label ) {

    Variable * timing = variable_retrieve( _environment, _timing );

    _environment->everyStatus = variable_retrieve( _environment, "EVERYSTATUS");
    _environment->everyStatus->locked = 1;

    _environment->everyCounter = variable_temporary( _environment, VT_WORD, "(every counter)");
    _environment->everyCounter->locked = 1;
    _environment->everyTiming = variable_cast( _environment, timing->name, VT_WORD );
    _environment->everyTiming->locked = 1;

    char skipEveryRoutineLabel[MAX_TEMPORARY_STORAGE]; sprintf(skipEveryRoutineLabel, "setg%d", UNIQUE_ID );
    char everyRoutineLabel[MAX_TEMPORARY_STORAGE]; sprintf(everyRoutineLabel, "etg%d", UNIQUE_ID );
    char endOfEveryRoutineLabel[MAX_TEMPORARY_STORAGE]; sprintf(endOfEveryRoutineLabel, "eetg%d", UNIQUE_ID );
    
    cpu_jump( _environment, skipEveryRoutineLabel );
    
    cpu_label( _environment, everyRoutineLabel );
    
    cpu_di( _environment );

    cpu_bveq( _environment, _environment->everyStatus->realName, endOfEveryRoutineLabel );

    cpu_dec( _environment, _environment->everyCounter->realName );

    cpu_bvneq( _environment, _environment->everyCounter->realName, endOfEveryRoutineLabel );

    call_procedure( _environment, _label );

    variable_move_naked( _environment, _environment->everyTiming->name, _environment->everyCounter->name );

    cpu_label( _environment, endOfEveryRoutineLabel );

    cpu_ei( _environment );

    d64_follow_irq( _environment );

    cpu_label( _environment, skipEveryRoutineLabel );

    d64_irq_at( _environment, everyRoutineLabel );

}
