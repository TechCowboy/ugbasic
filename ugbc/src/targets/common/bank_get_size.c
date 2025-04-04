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

/**
 * @brief Emit ASM code for instruction <b>= BANK SIZE( )</b>
 * 
 * This function outputs the ASM code to get the size
 * of the shared memory for the given bank.
 * 
 * @param _environment Current calling environment
 * @param _bank Bank to get size of
 * @return Current size of the bank selected
 */
/*
@keyword BANK SIZE

@english

The ''BANK SIZE'' function allows you to know the size of the given bank.

@italian

La funzione ''BANK SIZE'' consente di conoscere la dimensione del banco 
di memoria indicato.

@syntax = BANK SIZE(id)

@example x = BANK SIZE(1)

@seeAlso BANK ADDRESS
@seeAlso BANK (function)
@target all
</usermanual> */

Variable * bank_get_size( Environment * _environment, int _bank ) {

    Variable * result = variable_temporary( _environment, VT_ADDRESS, "(bank size)" );

    Bank * bank = _environment->expansionBanks;

    if ( bank ) {
        cpu_store_16bit(_environment, result->realName, bank->space );
    }

    return result;
    
}

/**
 * @brief Emit ASM code for instruction <b>= BANK SIZE( )</b>
 * 
 * This function outputs the ASM code to get the resident
 * memory address for the given bank.
 * 
 * @param _environment Current calling environment
 * @param _bank Bank to get address of
 * @return Current size of the bank selected
 */
Variable * bank_get_size_var( Environment * _environment, char * _bank ) {

    Variable * result = variable_temporary( _environment, VT_ADDRESS, "(bank size)" );

    Bank * bank = _environment->expansionBanks;

    if ( bank ) {
        cpu_store_16bit(_environment, result->realName, bank->space );
    }

    return result;
    
}
