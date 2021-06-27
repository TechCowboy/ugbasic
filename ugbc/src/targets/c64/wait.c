/*****************************************************************************
 * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
 *****************************************************************************
 * Copyright 2021 Marco Spedaletti (asimov@mclink.it)
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
 * @brief Emit ASM code for <b>WAIT # [integer] CYCLES</b>
 * 
 * This function outputs a code that engages the CPU in a busy wait.
 * 
 * @param _environment Current calling environment
 * @param _timing Number of cycles to wait
 */
/* <usermanual>
@keyword WAIT

@english
Engages the CPU in a wait. The timing can be given as
number of CPU cycles (''CYCLES''), number of 50th/seconds (''TICKS'')
or milliseconds (''MILLISECONDS'' or ''MS'').

@italian
Impiega la CPU in una attesa. Il tempo può essere espresso
come numero di cicli CPU (''CYCLES''), numero di 50th/seconds (''TICKS''),
o millisecondi (''MILLISECONDS'' oppure ''MS'').

@syntax WAIT [delay] [CYCLES|TICKS|MILLISECONDS]

@example WAIT #42 CYCLES
@usedInExample control_uncond_jumps_01.bas
@usedInExample control_uncond_jumps_02.bas
@usedInExample control_returning_01.bas
@usedInExample control_returning_02.bas

@target c64
</usermanual> */
void wait_cycles( Environment * _environment, int _timing ) {

    outline1("; WAIT %d", _timing);

    char timingString[MAX_TEMPORARY_STORAGE]; sprintf(timingString, "#$%2.2x", _timing );

    cpu6502_busy_wait( _environment, timingString );

}

/**
 * @brief Emit ASM code for <b>WAIT [expression] CYCLES</b>
 * 
 * This function outputs a code that engages the CPU in a busy wait.
 * 
 * @param _environment Current calling environment
 * @param _timing Number of cycles to wait
 */
/* <usermanual>
@keyword WAIT

@example WAIT delay CYCLES
</usermanual> */
void wait_cycles_var( Environment * _environment, char * _timing ) {

    outline1("; WAIT %s", _timing);

    MAKE_LABEL

    Variable * timing = variable_retrieve( _environment, _timing );
    
    cpu6502_busy_wait( _environment, timing->realName );

}

/**
 * @brief Emit ASM code for <b>WAIT # [integer] TICKS</b>
 * 
 * This function outputs a code that engages the CPU in a busy wait.
 * 
 * @param _environment Current calling environment
 * @param _timing Number of cycles to wait
 */
/* <usermanual>
@keyword WAIT

@example WAIT #2 TICKS

@target c64
</usermanual> */
void wait_ticks( Environment * _environment, int _timing ) {

    outline1("; WAIT %d TICKS", _timing);

    char timingString[MAX_TEMPORARY_STORAGE]; sprintf(timingString, "#$%2.2x", _timing );

    vic2_busy_wait( _environment, timingString );

}

/**
 * @brief Emit ASM code for <b>WAIT [expression] TICKS</b>
 * 
 * This function outputs a code that engages the CPU in a busy wait.
 * 
 * @param _environment Current calling environment
 * @param _timing Number of cycles to wait
 */
/* <usermanual>
@keyword WAIT

@example WAIT timing TICKS
</usermanual> */
void wait_ticks_var( Environment * _environment, char * _timing ) {

    outline1("; WAIT %s", _timing);

    MAKE_LABEL

    Variable * timing = variable_retrieve( _environment, _timing );
    
    vic2_busy_wait( _environment, timing->realName );

}

/**
 * @brief Emit ASM code for <b>WAIT # [integer] MS</b>
 * 
 * This function outputs a code that engages the CPU in a busy wait.
 * 
 * @param _environment Current calling environment
 * @param _timing Number of cycles to wait
 */
/* <usermanual>
@keyword WAIT

@example WAIT #10 MILLISECONDS

@target c64
</usermanual> */
void wait_milliseconds( Environment * _environment, int _timing ) {

    outline1("; WAIT %d MILLISECONDS", _timing);

    char timingString[MAX_TEMPORARY_STORAGE]; sprintf(timingString, "#$%2.2x", _timing >> 2 );

    vic2_busy_wait( _environment, timingString );

}

/**
 * @brief Emit ASM code for <b>WAIT [expression] MILLISECONDS</b>
 * 
 * This function outputs a code that engages the CPU in a busy wait.
 * 
 * @param _environment Current calling environment
 * @param _timing Number of cycles to wait
 */
/* <usermanual>
@keyword WAIT

@example WAIT timing MILLISECONDS
</usermanual> */
void wait_milliseconds_var( Environment * _environment, char * _timing ) {

    outline1("; WAIT %s MILLISECONDS", _timing);

    MAKE_LABEL

    Variable * timing = variable_retrieve( _environment, _timing );
    Variable * zero = variable_temporary( _environment, VT_BYTE, "(0)" );
    variable_store( _environment, zero->name, 0 );

    Variable * temp = variable_cast( _environment, timing->name, VT_BYTE );

    variable_div2_const( _environment, temp->name, 2 );

    if_then( _environment, variable_compare_not( _environment, temp->name, zero->name )->name );
        vic2_busy_wait( _environment, temp->realName );
    end_if_then( _environment );

    
}

