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
;*                      CLEAR SCREEN ROUTINE FOR VDC (text mode)               *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

CLST:
    ; Set the start location
    ; Set address to clear
    LD HL, (TEXTADDRESS)
    PUSH HL
    POP IY
    CALL VDCZSETADDR

    ; Clear the copy bit && Reverse Bit
    LD IXH, 24
    LD IXL, 0
    CALL VDCZWRITE

    ; Set data byte
    LD IXH, 31
    LD A, (EMPTYTILE)
    LD IXL, A
    CALL VDCZWRITE

    LD B, 8

CLSTL1:
    ; Word count register
    ; Set data byte
    LD IXH, 30
    LD IXL, 0
    CALL VDCZWRITE

    DEC B
    JR NZ, CLSTL1

    ; Set the start location
    ; Set address to clear
    LD HL, (COLORMAPADDRESS)
    PUSH HL
    POP IY
    CALL VDCZSETADDR

    ; Clear the copy bit && Reverse Bit
    LD IXH, 24
    LD IXL, 0
    CALL VDCZWRITE

    ; Set data byte
    LD IXH, 31
    LD A, (_PEN)
    LD IXL, A
    CALL VDCZWRITE

    LD B, 8

CLSTL2:
    ; Word count register
    ; Set data byte
    LD IXH, 30
    LD IXL, 0
    CALL VDCZWRITE

    DEC B
    JR NZ, CLSTL2

    RET
