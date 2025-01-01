; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
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
;*                               PROTOTHREADING                                *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

PTP0    = $F9

PROTOTHREADVOID:
    RTS

; PROTOTHREADREGAT(Y,TMPPTR)
PROTOTHREADREGAT:
    TYA
    ASL A
    ASL A
    ASL A
    TAY
    INY
    INY
    INY
    INY
    INY
    INY
    LDA #<PROTOTHREADLOOP
    STA PTP0
    LDA #>PROTOTHREADLOOP
    STA PTP0+1
    LDA TMPPTR
    STA (PTP0),Y
    INY
    LDA TMPPTR+1
    STA (PTP0),Y
    RTS

; PROTOTHREADADDRESS(Y)->TMPPTR
PROTOTHREADGETADDRESS:
    TYA
    ASL A
    ASL A
    ASL A
    TAY
    INY
    INY
    INY
    INY
    INY
    INY
    LDA #<PROTOTHREADLOOP
    STA PTP0
    LDA #>PROTOTHREADLOOP
    STA PTP0+1
    LDA (PTP0),Y
    STA TMPPTR
    INY
    LDA (PTP0),Y
    STA TMPPTR+1
    RTS

; PROTOTHREADREG(TMPPTR)->Y
PROTOTHREADREG:
    LDX #0
    LDY #6
    LDA #<PROTOTHREADLOOP
    STA PTP0
    LDA #>PROTOTHREADLOOP
    STA PTP0+1
PROTOTHREADREGL1:
    LDA (PTP0),Y
    CMP #<PROTOTHREADVOID
    BNE PROTOTHREADREGNEXT
    INY
    LDA (PTP0),Y
    CMP #>PROTOTHREADVOID
    BNE PROTOTHREADREGNEXT
    DEY
    LDA TMPPTR
    STA (PTP0),Y
    INY
    LDA TMPPTR+1
    STA (PTP0),Y
    TXA
    TAY
    RTS
PROTOTHREADREGNEXT2:
    DEY
PROTOTHREADREGNEXT:
    INX
    INY
    INY
    INY
    INY
    INY
    INY
    INY
    INY
    JMP PROTOTHREADREGL1

; PROTOTHREADUNREG(Y)
PROTOTHREADUNREG:
    TYA
    ASL A
    ASL A
    ASL A
    CLC
    ADC #6
    TAY
    LDA #<PROTOTHREADLOOP
    STA PTP0
    LDA #>PROTOTHREADLOOP
    STA PTP0+1
    LDA #<PROTOTHREADVOID
    STA (PTP0),Y
    INY
    LDA #>PROTOTHREADVOID
    STA (PTP0),Y
    RTS

; PROTOTHREADSAVE(Y,X)
PROTOTHREADSAVE:
    LDA #<PROTOTHREADLC
    STA PTP0
    LDA #>PROTOTHREADLC
    STA PTP0+1
    TXA
    STA (PTP0),Y
    RTS

; PROTOTHREADRESTORE(Y)->X
PROTOTHREADRESTORE:
    LDA #<PROTOTHREADLC
    STA PTP0
    LDA #>PROTOTHREADLC
    STA PTP0+1
    LDA (PTP0),Y
    TAX
    RTS

; PROTOTHREADSETSTATE(Y,X)
PROTOTHREADSETSTATE:
    LDA #<PROTOTHREADST
    STA PTP0
    LDA #>PROTOTHREADST
    STA PTP0+1
    TXA
    STA (PTP0),Y
    RTS

; PROTOTHREADGETSTATE(Y)->X
PROTOTHREADGETSTATE:
    LDA #<PROTOTHREADST
    STA PTP0
    LDA #>PROTOTHREADST
    STA PTP0+1
    LDA (PTP0),Y
    TAX
    RTS
