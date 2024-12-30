; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file except in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless required by applicable law or agreed to in writing, software
;  * distributed under the License is distributed on an "AS IS" BASIS,
;  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;  * See the License for the specific language governing permissions and
;  * limitations under the License.
;  *----------------------------------------------------------------------------
;  * Concesso in licenza secondo i termini della Licenza Apache, versione 2.0
;  * (la "Licenza"); è proibito usare questo file se non in conformità alla
;  * Licenza. Una copia della Licenza è disponibile all'indirizzo:
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Se non richiesto dalla legislazione vigente o concordato per iscritto,
;  * il software distribuito nei termini della Licenza è distribuito
;  * "COSì COM'è", SENZA GARANZIE O CONDIZIONI DI ALCUN TIPO, esplicite o
;  * implicite. Consultare la Licenza per il testo specifico che regola le
;  * autorizzazioni e le limitazioni previste dalla medesima.
;  ****************************************************************************/
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                                                                             *
;*                          VERTICAL SCROLL ON 6847                            *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

VSCROLLT
    LDA CURRENTMODE
    CMPA #6
    BHI VSCROLLTX
    JMP VSCROLLTT
VSCROLLTX
    RTS

VSCROLLTT
    PSHS A,B,X,Y,U
    LDA <DIRECTION
    CMPA #0
    BGT VSCROLLTDOWN

VSCROLLTUP
    LDX TEXTADDRESS
    LDA CURRENTTILESWIDTH
    LDB CONSOLEY1
VSCROLLTUPYL1
    BEQ VSCROLLTUP2
    LEAX A, X
    DECB
    BRA VSCROLLTUPYL1
VSCROLLTUP2
    TFR X, Y
    LEAY A, Y

    CLRA
    LDB CONSOLEH
    DECB
    BEQ VSCROLLTUPYSCRNO
    TFR D, U
VSCROLLTUPYSCR
    LDB CONSOLEX1
VSCROLLTUPYSCR1
    LDA B,Y
    STA B,X
    INCB
    CMPB CONSOLEX2
    BLE VSCROLLTUPYSCR1
    LDA CURRENTTILESWIDTH
    LEAX A, X
    LEAY A, Y
    LEAU -1, U
    CMPU #0
    BNE VSCROLLTUPYSCR

VSCROLLTUPYSCRNO
    LDA EMPTYTILE
    LDB CONSOLEX1
VSCROLLTUPREFILL
    STA B,X
    INCB
    CMPB CONSOLEX2
    BLE VSCROLLTUPREFILL

    JMP VSCROLLTE

VSCROLLTDOWN
    LDA CURRENTTILESWIDTH
    LDX TEXTADDRESS
    LDB CONSOLEY2
VSCROLLTDOWNYL1
    BEQ VSCROLLTDOWN2
    LEAX A, X
    DECB
    BRA VSCROLLTDOWNYL1
VSCROLLTDOWN2
    TFR X, Y
    LDA CURRENTTILESWIDTH
    NEGA
    LEAY A, Y

    CLRA
    LDB CONSOLEH
    TFR D, U
    CMPB #0
    BEQ VSCROLLTDOWNYS31L1NO
VSCROLLTDOWNYS31L1
    LDB CONSOLEX2
VSCROLLTDOWNYS31
    LDA B,Y
    STA B,X
    DECB
    CMPB CONSOLEX1
    BNE VSCROLLTDOWNYS31
VSCROLLTDOWNYS31L1NO    
    LDA CURRENTTILESWIDTH
    NEGA
    LEAX A, X
    LEAY A, Y
    LEAU -1, U
    CMPU #0
    BNE VSCROLLTDOWNYS31L1

    LDA EMPTYTILE
    LDB CONSOLEX1
VSCROLLTDOWNREFILL
    STA B,Y
    INCB
    CMPB CONSOLEX2
    BLE VSCROLLTDOWNREFILL

    JMP VSCROLLTE

VSCROLLTE
    PULS A,B,X,Y,U
    RTS