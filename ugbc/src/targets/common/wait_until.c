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
 * @brief Emit code for <strong>WAIT UNTIL ...</strong>
 * 
 * @param _environment Current calling environment
 */
/* <usermanual>
@keyword WAIT UNTIL

@english

The ''WAIT UNTIL'' command allows you to suspend the execution of a thread until 
the indicated condition becomes ''TRUE''. In other words, the expression is 
evaluated and, if ''FALSE'', the execution will be suspended to send another 
scheduled thread to execute. If it becomes ''TRUE'', the execution of this thread
will continue.

@italian

Il comando ''WAIT UNTIL'' permette di sospendere l'esecuzione di un thread fino a
che la condizione indicata non diventa vera. In altri termini, l'espressione 
viene valutata e, se ''FALSE'', l'esecuzione sarà sospesa per mandare in esecuzione
un altro thread di quelli schedulati.  Se invece diventa TRUE, l'esecuzione di
questo thread proseguirà.

@syntax WAIT UNTIL expression

@example WAIT UNTIL x < 0

@target all
</usermanual> */
void wait_until( Environment * _environment ) {

    yield( _environment );

}

void wait_until_condition( Environment * _environment, char * _condition ) {

    _environment->anyProtothread = 1;

    if ( _environment->protothreadForbid ) {
        CRITICAL_MULTITASKING_FORBIDDEN();
    }

    if ( ! _environment->procedureName ) {
        CRITICAL_WAIT_UNTIL_CANNOT_BE_CALLED_OUTSIDE_PROCEDURE();
    }

    MAKE_LABEL

    char protothreadLabel[MAX_TEMPORARY_STORAGE]; sprintf(protothreadLabel, "%spt%d", _environment->procedureName, _environment->protothreadStep );

    Variable * expression = variable_retrieve_or_define( _environment, _condition, VT_BYTE, 0 );

    cpu_bvneq( _environment, expression->realName, protothreadLabel );

    cpu_protothread_save( _environment, "PROTOTHREADCT", ( _environment->protothreadStep - 1 ) );
    cpu_protothread_set_state( _environment, "PROTOTHREADCT", PROTOTHREAD_STATUS_WAITING );
    cpu_return( _environment );
    cpu_label( _environment, protothreadLabel );
    cpu_protothread_set_state( _environment, "PROTOTHREADCT", PROTOTHREAD_STATUS_RUNNING );

    ++_environment->protothreadStep;
    
}
