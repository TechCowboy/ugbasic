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
 * @brief Emit ASM code for <b>HALT</b>
 * 
 * This function outputs the indefinite stop code. Note that even if the 
 * main program is suspended indefinitely, the raster and other functions 
 * will continue without problems.
 * 
 * @param _environment Current calling environment
 */
/* <usermanual>
@keyword HALT

@english

This instruction stops the program execution, in "busy" mode. The implementation is
by means of an infinite loop, which is executed when the instruction is executed. 
With this expedient, the execution of interrupts will continue without being 
interrupted while all other operations will be interrupted, including multithreading.

@italian

Questa istruzione ferma l'esecuzione del programma, in modo "busy". L'implementazione 
è per mezzo di un loop infinito, che viene eseguito in corrispondenza dell'esecuzione 
dell'istruzione. Con tale espediente, l'esecuzione degli interrupt continuerà senza 
essere interrotta mentre saranno interrotte tutte le altre operazioni, compreso 
quindi il multithreading.

@syntax HALT

@example HALT

@target all
</usermanual> */
void halt( Environment * _environment ) {

    MAKE_LABEL

    cpu_label( _environment, label );
    interleaved_instructions( _environment );
    cpu_jump( _environment, label );
    
}
