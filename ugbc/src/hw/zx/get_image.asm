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
;*                          IMAGES ROUTINE FOR ZX SPECTRUM                     *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; ----------------------------------------------------------------------------
; - Get image on bitmap
; ----------------------------------------------------------------------------

GETIMAGE:
    
;     LD A, (CURRENTMODE)
;     ; BITMAP_MODE_STANDARD
;     CP 0
;     JR NZ, GETIMAGE0X
;     JMP GETIMAGE0
; GETIMAGE0X:
;     ; TILEMAP_MODE_STANDARD
;     CP 1
;     JR NZ, GETIMAGE1X
;     JMP GETIMAGE1
; GETIMAGE1X:
;     RET

; GETIMAGE1:
;     RET

GETIMAGE0:
GETIMAGE1:
    LD A, (HL)
    LD (IMAGEW), A
    ADD HL, 1
    LD A, (HL)
    LD (IMAGEW+1), A
    ADD HL, 1
    LD A, (HL)
    ; SRL A
    ; SRL A
    ; SRL A
    LD (IMAGEH), A
    LD (IMAGEH2), A
    ADD HL, 1

    PUSH HL

;     LD A, (IMAGEX)
;     AND $7
;     LD B, A
;     LD A, $8
;     SUB B
;     LD B, A
;     LD E, 1
; GETIMAGE0A:
;     DEC B
;     JR Z,GETIMAGE0B
;     SLA E
;     JMP GETIMAGE0A
GETIMAGE0B:
    LD A, (IMAGEY)
    AND $F8
    LD B, A
    LD A, (IMAGEX)
    AND $F8
    LD C, A

    LD A,B
    AND %00000111
    OR %01000000
    LD H,A
    LD A,B
    RRA
    RRA
    RRA
    AND %00011000
    OR H
    LD H,A
    LD A,B
    RLA
    RLA
    AND %11100000
    LD L,A
    LD A,C
    RRA
    RRA
    RRA
    AND %00011111
    OR L
    LD L,A

    PUSH HL
    POP DE
    POP HL

    LD A, (IMAGEY)
    AND $F8
    LD IXL, A

    LD A, (IMAGEH)
    LD C, A
    ; SLA C
    ; SLA C
    ; SLA C
    LD A, (IMAGEW+1)
    LD B, A
    LD A, (IMAGEW)
    SRL B
    RR A
    SRL B
    RR A
    SRL B
    RR A
    LD B, A
GETIMAGE0CP:
    LD A, (DE)
    LD (HL), A
    INC HL
    INC DE
    DEC B
    JR NZ, GETIMAGE0CP
    LD A, (IMAGEW+1)
    LD B, A
    LD A, (IMAGEW)
    SRL B
    RR A
    SRL B
    RR A
    SRL B
    RR A
    LD B, A

    PUSH BC
    PUSH HL
    
    INC IXL

    LD A, (CURRENTHEIGHT)
    CP IXL
    JR Z, GETDONEY

    LD A, IXL
    LD B, A
    LD A, (IMAGEX)
    AND $F8
    LD C, A

    LD A,B
    AND %00000111
    OR %01000000
    LD H,A
    LD A,B
    RRA
    RRA
    RRA
    AND %00011000
    OR H
    LD H,A
    LD A,B
    RLA
    RLA
    AND %11100000
    LD L,A
    LD A,C
    RRA
    RRA
    RRA
    AND %00011111
    OR L
    LD L,A

    PUSH HL
    POP DE
    POP HL

    POP BC

    DEC C
    JR NZ, GETIMAGE0CP

    JP GETDONEYY
    ;;;;

GETDONEY:

    PUSH HL
    POP DE
    POP HL

    POP BC

GETDONEYY:

    LD A, (IMAGEY)
    AND $F8
    LD IXL, A

    LD A, (IMAGET)
    AND $1
    CMP $0
    JP Z, GETDONE

    PUSH HL

    LD A, (IMAGEX)
    AND $F8
    LD L,A
    LD A,0
    LD H,A
    AND A
    SRA H
    RR L
    SRA H
    RR L
    SRA H
    RR L
    LD DE,HL

    LD A, (IMAGEY)
    AND $f8
    LD L,A
    LD A,0
    LD H,A
    AND A
    SLA L
    RL H
    SLA L
    RL H
    ADD HL,DE
    LD DE,(COLORMAPADDRESS)
    ADD HL,DE

    PUSH HL

    POP DE
    POP HL

    LD A, (IMAGEH)
    SRL A
    SRL A
    SRL A
    LD C, A
    ; INC C
    LD A, (IMAGEW+1)
    LD B, A
    LD A, (IMAGEW)
    SRL B
    RR A
    SRL B
    RR A
    SRL B
    RR A
    LD B, A
GETIMAGE00CP:
    LD A, (DE)
    LD (HL), A
    INC HL
    INC DE
    DEC B
    JR NZ, GETIMAGE00CP

    PUSH BC

    LD A, (IMAGEW+1)
    LD B, A
    LD A, (IMAGEW)
    SRL B
    RR A
    SRL B
    RR A
    SRL B
    RR A
    LD C, A
    LD A, 0
    LD B, A

    PUSH HL
    LD HL, DE
    ADD HL, 32
    AND A
    SBC HL, BC
    LD DE, HL
    POP HL

    POP BC

    LD A, (IMAGEW+1)
    LD B, A
    LD A, (IMAGEW)
    SRL B
    RR A
    SRL B
    RR A
    SRL B
    RR A
    LD B, A

    INC IXL
    LD A, (CURRENTHEIGHT)
    CP IXL
    JR Z, GETDONE

    DEC C
    JR NZ, GETIMAGE00CP

GETDONE:

    RET

