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

/* <usermanual>
@keyword MEMDEF

@english

The ''MEMDEF'' is a collective command for all expansion memory settings 
required for a transfer. First you specify the number of ''bytes'' to be transferred 
(see ''MEMLEN''), then the ''address'' in the target computer (see ''MEMOR''). This is
followed by the expansion memory address (''eaddress'), including the ''bank'' (''MEMPOS''). 

@italian

Il comando ''MEMDEF'' è un comando collettivo per tutte le impostazioni di memoria di 
espansione richieste per un trasferimento. Per prima cosa si specifica il numero di ''byte'' 
da trasferire (vedere ''MEMLEN''), quindi l''address'' nel computer di destinazione (vedere 
''MEMOR''). Questo è seguito dall'indirizzo di memoria di espansione (''eaddress'), incluso il
''bank'' (''MEMPOS'').

@syntax MEMDEF bytes[, address[, eaddress, bank]]

@example MEMDEF 128, &HC000

@usedInExample tsb_memload.bas

@seeAlso MEMLEN
@seeAlso MEMPOS
@seeAlso MEMCONT
@seeAlso MEMRESTORE
@seeAlso MEMLOAD
@seeAlso MEMSAVE

</usermanual> */

void memdef( Environment * _environment, char * _size, char * _address, char * _eaddress, char * _bank ) {

    Variable * membank = variable_retrieve_or_define( _environment, "MEMBANK", VT_BYTE, 0 );
    Variable * mempos = variable_retrieve_or_define( _environment, "MEMPOS", VT_ADDRESS, 0 );
    Variable * memor = variable_retrieve_or_define( _environment, "MEMOR", VT_ADDRESS, 0 );
    Variable * memlen = variable_retrieve_or_define( _environment, "MEMLEN", VT_WORD, 0 );

    Variable * size = variable_retrieve_or_define( _environment, _size, VT_ADDRESS, 0 );

    variable_move( _environment, size->name, memlen->name );

    if ( _address ) {
        Variable * address = variable_retrieve_or_define( _environment, _address, VT_ADDRESS, 0 );
        variable_move( _environment, address->name, memor->name );
    }

    if ( _eaddress ) {
        Variable * eaddress = variable_retrieve_or_define( _environment, _eaddress, VT_ADDRESS, 0 );
        variable_move( _environment, eaddress->name, mempos->name );
    }

    if ( _bank ) {
        Variable * bank = variable_retrieve_or_define( _environment, _bank, VT_ADDRESS, 0 );
        variable_move( _environment, bank->name, membank->name );
    }

}
