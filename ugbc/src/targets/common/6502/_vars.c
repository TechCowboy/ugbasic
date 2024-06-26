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

#include "../../../ugbc.h"

#if defined(__atari__) || defined(__atarixl__) || defined(__c64__) || defined(__c64reu__) || defined(__c128__) || defined(__plus4__) || defined(__vic20__)

/****************************************************************************
 * CODE SECTION 
 ****************************************************************************/

extern char DATATYPE_AS_STRING[][16];

void vars_emit_constant_integer( Environment * _environment, char * _name, int _value ) {

    outhead2("%s = $%4.4x", _name, _value );

}

void vars_emit_constants( Environment * _environment ) {

    int i=0;

    if ( _environment->constants ) {
        Constant * actual = _environment->constants;
        while( actual ) {
            if ( ! actual->emitted ) {
                switch( actual->type ) {
                    case CT_INTEGER:
                        vars_emit_constant_integer( _environment, actual->realName, actual->value );
                        break;
                    case CT_STRING:
                    break;
                }
            }
            actual = actual->next;
        }
    }

}

#endif