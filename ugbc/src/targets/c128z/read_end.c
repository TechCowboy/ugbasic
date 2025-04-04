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

Variable * read_end( Environment * _environment ) {

    _environment->dataNeeded = 1;
    
    MAKE_LABEL

    Variable * readEnd = variable_temporary( _environment, VT_BYTE, "(flag)" );
    
    outline0("LD HL, (DATAPTR)");
    outline0("LD DE, DATAPTRE");
    outline0("SCF");
    outline0("SBC HL, DE");
    outline0("LD A, H");
    outline0("OR L");
    outline1("JR Z, %send", label);
    outline0("LD A, 0");
    outline1("LD (%s), A", readEnd->realName);
    outline1("JMP %sdone", label);
    outhead1("%send:", label);
    outline0("LD A, $ff");
    outline1("LD (%s), A", readEnd->realName);
    outhead1("%sdone:", label);

    return readEnd;

}

