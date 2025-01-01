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
 * @brief Emit code for <strong>END PROC</strong>
 * 
 * @param _environment Current calling environment
 * @param _value Value to the return
 */
/* <usermanual>
@keyword PROCEDURE...END PROC

@english
As an option, you can specify a value for the function to return. 
The value must be indicated in square brackets (''[...]''). 
The value will then be copied into the ''PARAM'' variable and 
returned by the call, if the call was made in the context of an expression.

Important: if the ''OPTION CALL AS GOTO'' pragma is in effect, the instruction
will be considered as a ''NOP''.

@italian
Come opzione è possibile indicare un valore da restituire da parte 
della procedura. Il valore va indicato tra parentesi quadre. 
Il valore sarà, quindi, copiato nella variable ''PARAM'' e restituito 
dalla chiamata, se la chiamata è stata fatta nel contesto di una espressione.

Importante: se il pragma ''OPTION CALL AS GOTO'' è attivo, l'istruzione
sarà considerata un ''NOP''.

@example PROCEDURE hundred
@example END PROC[100]

</usermanual> */
void end_procedure( Environment * _environment, char * _value ) {

    if ( _environment->emptyProcedure ) {
        return;
    }

    if ( ! _environment->procedureName ) {
        CRITICAL_PROCEDURE_NOT_OPENED();
    }

    if ( _value ) {
        char paramName[MAX_TEMPORARY_STORAGE]; sprintf(paramName,"%s__PARAM", _environment->procedureName );
        Variable * value;
        if ( variable_exists( _environment, _value ) ) {
            value = variable_retrieve( _environment, _value );
        } else {
            value = variable_retrieve_or_define( _environment, _value, _environment->defaultVariableType, 0 );
        }
        Variable * param = variable_define( _environment, paramName, value->type, 0 );
        variable_move( _environment, value->name, param->name );
    }

    char procedureAfterLabel[MAX_TEMPORARY_STORAGE]; sprintf(procedureAfterLabel, "%safter", _environment->procedureName );

    if ( _environment->protothread ) {
        cpu_protothread_set_state( _environment, "PROTOTHREADCT", PROTOTHREAD_STATUS_ENDED );
    }

    if ( ! _environment->optionCallAsGoto ) {
        cpu_return( _environment );
    }

    if ( _environment->protothread ) {

        char procedureParallelDispatch[MAX_TEMPORARY_STORAGE]; sprintf(procedureParallelDispatch, "%sdispatch", _environment->procedureName );
        char procedureEndedLabel[MAX_TEMPORARY_STORAGE]; sprintf(procedureEndedLabel, "%sended", _environment->procedureName );
        char procedureSuspendedLabel[MAX_TEMPORARY_STORAGE]; sprintf(procedureSuspendedLabel, "%ssusp", _environment->procedureName );
        char protothreadLabelWaiting[MAX_TEMPORARY_STORAGE]; sprintf(protothreadLabelWaiting, "%spt%d", _environment->procedureName, 0 );

        cpu_label( _environment, procedureParallelDispatch  );

        Variable * status = variable_temporary( _environment, VT_BYTE, "(status)" );

        cpu_protothread_get_state( _environment, "PROTOTHREADCT", status->realName );

        cpu_compare_and_branch_8bit_const( _environment, status->realName, PROTOTHREAD_STATUS_ENDED, procedureEndedLabel, 1 );

        cpu_compare_and_branch_8bit_const( _environment, status->realName, PROTOTHREAD_STATUS_PAUSED, procedureSuspendedLabel, 1 );
        // cpu_compare_and_branch_8bit_const( _environment, status->realName, PROTOTHREAD_STATUS_WAITING, protothreadLabelWaiting, 1 );

        if ( _environment->protothreadStep > 1 ) {
            outline0("; start end proc with parallel");
            Variable * step = variable_temporary( _environment, VT_BYTE, "(dispatch)");
            cpu_protothread_restore( _environment, "PROTOTHREADCT", step->realName );

            int i = 0;

            cpu_prepare_for_compare_and_branch_8bit( _environment, step->realName );
            for(i=0;i<_environment->protothreadStep; ++i) {
                outline1("; step %d", i );
                char protothreadLabel[MAX_TEMPORARY_STORAGE]; sprintf(protothreadLabel, "%spt%d", _environment->procedureName, i );
                cpu_execute_compare_and_branch_8bit_const( _environment, i, protothreadLabel, 1 );
            }
            cpu_protothread_save( _environment, "PROTOTHREADCT", 1 );
            char protothreadLabel[MAX_TEMPORARY_STORAGE]; sprintf(protothreadLabel, "%spt%d", _environment->procedureName, 0 );
            cpu_jump( _environment, protothreadLabel );
        }

        cpu_label( _environment, procedureEndedLabel );
        cpu_label( _environment, procedureSuspendedLabel );
        cpu_return( _environment );

    }


    cpu_label( _environment, procedureAfterLabel );

    Variable * current = _environment->procedureVariables;

    if ( current ) {
        while( current->next ) {
            current->name = current->realName;
            current = current->next;
        }
        current->name = current->realName;
    }

    current = _environment->procedureVariables;

    Variable * varLast = _environment->variables;
    if ( varLast ) {
        while( varLast->next ) {
            varLast = varLast->next;
        }
        varLast->next = current;
    } else {
        _environment->variables = current;
    }

    _environment->procedureName = NULL;

    _environment->procedureVariables = NULL;

};

