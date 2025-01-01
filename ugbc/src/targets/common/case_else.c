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
 * @brief Emit ASM code for <b>CASE ELSE</b>
 * 
 * This function outputs the code when other comparisons fails
 * 
 * @param _environment Current calling environment
 * @param _expression Expression with the true / false condition
 */
/* <usermanual>
@keyword CASE ELSE

@english

The ''CASE ELSE'' command is part of ''SELECT...ENDSELECT'' construct.
It is optional and is executed if none of the previous cases are true.
The code will be executed up to the ''ENDSELECT'' instruction.

@italian

Il comando ''CASE ELSE'' fa parte della costruzione ''SELECT...ENDSELECT''.
È facoltativo e viene eseguito se nessuno dei casi precedenti è vero.
Il codice verrà eseguito fino all'istruzione ''ENDSELECT''.

@syntax CASE ELSE

@example SELECT CASE answer
@example    CASE 42
@example       PRINT "The answer!"
@example    CASE ELSE
@example       PRINT "I am still thinking..."
@example ENDSELECT

@seeAlso SELECT CASE
@seeAlso CASE
@seeAlso ENDSELECT

</usermanual> */
void case_else( Environment * _environment ) {

    Conditional * conditional = _environment->conditionals;

    if ( ! conditional ) {
        CRITICAL_CASE_ELSE_WITHOUT_SELECT_CASE();
    }

    if ( conditional->type != CT_SELECT_CASE ) {
        CRITICAL_CASE_ELSE_WITHOUT_SELECT_CASE();
    }

    if ( conditional->caseElse ) {
        CRITICAL_CASE_ELSE_ALREADY_EMITTED();
    }
    conditional->caseElse = 1;

}
