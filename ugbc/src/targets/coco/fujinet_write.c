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
@keyword FUJINET WRITE

@english

The ''FUJINET WRITE'' function allows you to write data to the connection.

@italian

La funzione ''FUJINET WRITE'' consente di scrivere dati su una connessione.

@syntax FUJINET WRITE value

@example FUJINET WRITE "hello!"

@target coco
</usermanual> */
void fujinet_write( Environment * _environment, char * _value ) {

    Variable * value = variable_retrieve( _environment, _value );
    Variable * address = variable_temporary( _environment, VT_ADDRESS, "(address of DSTRING)");
    Variable * size = variable_temporary( _environment, VT_BYTE, "(size of DSTRING)");

    switch( value->type ) {
        case VT_STRING:
            cpu_move_8bit( _environment, value->realName, size->realName );
            cpu_addressof_16bit( _environment, value->realName, address->realName );
            cpu_inc_16bit( _environment, address->realName );
            break;
        case VT_DSTRING:
            cpu_dsdescriptor( _environment, value->realName, address->realName, size->realName );
            break;
        case VT_CHAR:
            cpu_addressof_16bit( _environment, value->realName, address->realName );
            cpu_store_8bit( _environment, size->realName, 1 );
            break;
    }

    coco_fujinet_write( _environment, address->realName, size->realName );

}
