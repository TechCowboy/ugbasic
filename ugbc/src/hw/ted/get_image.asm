; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2022 Marco Spedaletti (asimov@mclink.it)
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
;*                          IMAGES ROUTINE FOR TED                             *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; ----------------------------------------------------------------------------
; - Put image on bitmap
; ----------------------------------------------------------------------------

GETIMAGE:
    LDA CURRENTMODE
    ; BITMAP_MODE_STANDARD
    CMP #2
    BNE GETIMAGE2X
    JMP GETIMAGE2
GETIMAGE2X:
    ; BITMAP_MODE_MULTICOLOR
    CMP #3
    BNE GETIMAGE3X
    JMP GETIMAGE3
GETIMAGE3X:
    ; TILEMAP_MODE_STANDARD
    CMP #0
    BNE GETIMAGE0X
    JMP GETIMAGE0
GETIMAGE0X:
    ; TILEMAP_MODE_MULTICOLOR
    CMP #1
    BNE GETIMAGE1X
    JMP GETIMAGE1
GETIMAGE1X:
    ; TILEMAP_MODE_EXTENDED
    CMP #4
    BNE GETIMAGE4X
    JMP GETIMAGE4
GETIMAGE4X:
    RTS

GETIMAGE0:
GETIMAGE1:
GETIMAGE4:
    RTS

GETIMAGE2:
    LDY #0
    LDA (TMPPTR),Y
    STA IMAGEW
    LDY #1
    LDA (TMPPTR),Y
    LSR
    LSR
    LSR
    STA IMAGEH
    STA IMAGEH2

    CLC
    LDA TMPPTR
    ADC #2
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    ;-------------------------
    ;calc Y-cell, divide by 8
    ;y/8 is y-cell table index
    ;-------------------------
    LDA IMAGEY
    LSR                         ;/ 2
    LSR                         ;/ 4
    LSR                         ;/ 8
    TAY                         ;tbl_8,y index

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;divide 2-byte PLOTX / 8
    ;------------------------
    LDA IMAGEX
    ROR IMAGEX+1                ;rotate the high byte into carry flag
    ROR                        ;lo byte / 2 (rotate C into low byte)
    LSR                        ;lo byte / 4
    LSR                        ;lo byte / 8
    TAX                        ;tbl_8,x index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    LDA PLOTVBASELO,Y          ;table of $A000 row base addresses
    ADC PLOT8LO,X              ;+ (8 * Xcell)
    STA PLOTDEST               ;= cell address

    LDA PLOTVBASEHI,Y          ;do the high byte
    ADC PLOT8HI,X
    STA PLOTDEST+1

    TXA
    ADC PLOTCVBASELO,Y          ;table of $8400 row base addresses
    STA PLOTCDEST               ;= cell address

    LDA #0
    ADC PLOTCVBASEHI,Y          ;do the high byte
    STA PLOTCDEST+1

    TYA

    LDA IMAGEW
    TAY
    DEY
GETIMAGE2L1:
GETIMAGE3L1DEF:
    LDA (PLOTDEST),Y
GETIMAGE3L1FINAL:
    STA (TMPPTR),Y
    DEY
    CPY #255
    BNE GETIMAGE2L1

    CLC
    LDA TMPPTR
    ADC IMAGEW
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    CLC
    LDA PLOTDEST
    ADC #$40
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #$1
    STA PLOTDEST+1

    DEC IMAGEH
    BEQ GETIMAGE2C

    LDA IMAGEW
    TAY
    DEY
    JMP GETIMAGE2L1

GETIMAGE2C:

    LDA IMAGEH2
    STA IMAGEH
    LDA IMAGEW
    LSR A
    LSR A
    LSR A
    STA IMAGEW
    TAY
    DEY
GETIMAGE2L2:
    LDA (PLOTCDEST),Y
    STA (TMPPTR),Y
    DEY
    CPY #255
    BNE GETIMAGE2L2

    DEC IMAGEH
    BEQ GETIMAGE2E

    CLC
    LDA TMPPTR
    ADC IMAGEW
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    CLC
    LDA PLOTCDEST
    ADC #40
    STA PLOTCDEST
    LDA PLOTCDEST+1
    ADC #0
    STA PLOTCDEST+1

    LDA IMAGEW
    TAY
    DEY
    JMP GETIMAGE2L2

GETIMAGE2E:
    RTS

;;;;;;;;;;;;;;;;;

GETIMAGE3:
    LDY #0
    LDA (TMPPTR),Y
    STA IMAGEW
    LDY #1
    LDA (TMPPTR),Y
    LSR
    LSR
    LSR
    STA IMAGEH
    STA IMAGEH2

    CLC
    LDA TMPPTR
    ADC #2
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    ;-------------------------
    ;calc Y-cell, divide by 8
    ;y/8 is y-cell table index
    ;-------------------------
    LDA IMAGEY
    LSR                         ;/ 2
    LSR                         ;/ 4
    LSR                         ;/ 8
    TAY                         ;tbl_8,y index

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;divide 2-byte PLOTX / 8
    ;------------------------
    LDA IMAGEX
    ROR IMAGEX+1                ;rotate the high byte into carry flag
    ROR                        ;lo byte / 2 (rotate C into low byte)
    LSR                        ;lo byte / 4
    TAX                        ;tbl_8,x index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    LDA PLOTVBASELO,Y          ;table of $A000 row base addresses
    ADC PLOT8LO,X              ;+ (8 * Xcell)
    STA PLOTDEST               ;= cell address

    LDA PLOTVBASEHI,Y          ;do the high byte
    ADC PLOT8HI,X
    STA PLOTDEST+1

    CLC

    TXA
    ADC PLOTCVBASELO,Y          ;table of $8400 row base addresses
    STA PLOTCDEST               ;= cell address

    LDA #0
    ADC PLOTCVBASEHI,Y          ;do the high byte
    STA PLOTCDEST+1

    CLC

    TXA
    ADC PLOTC2VBASELO,Y          ;table of $8400 row base addresses
    STA PLOTC2DEST               ;= cell address

    LDA #0
    ADC PLOTC2VBASEHI,Y          ;do the high byte
    STA PLOTC2DEST+1

    LDA IMAGEW
    ASL
    TAY
    DEY
GETIMAGE3L1:
    LDA (PLOTDEST),Y
    STA (TMPPTR),Y
    DEY
    CPY #255
    BNE GETIMAGE3L1

    CLC
    LDA TMPPTR
    ADC IMAGEW
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    CLC
    LDA TMPPTR
    ADC IMAGEW
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    CLC
    LDA PLOTDEST
    ADC #$40
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #$1
    STA PLOTDEST+1

    DEC IMAGEH
    BEQ GETIMAGE3C

    LDA IMAGEW
    ASL
    TAY
    DEY
    JMP GETIMAGE3L1

GETIMAGE3C:

    LDA IMAGEH2
    STA IMAGEH
    LDA IMAGEW
    LSR A
    LSR A
    STA IMAGEW
    TAY
    DEY
GETIMAGE3L2:
    LDA (PLOTCDEST),Y
    STA (TMPPTR),Y
    DEY
    CPY #255
    BNE GETIMAGE3L2

    CLC
    LDA TMPPTR
    ADC IMAGEW
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    CLC
    LDA PLOTCDEST
    ADC #40
    STA PLOTCDEST
    LDA PLOTCDEST+1
    ADC #0
    STA PLOTCDEST+1

    DEC IMAGEH
    BEQ GETIMAGE3C2
    
    LDA IMAGEW
    TAY
    DEY
    JMP GETIMAGE3L2

GETIMAGE3C2:

    LDA IMAGEH2
    STA IMAGEH
    LDA IMAGEW
    TAY
    DEY
GETIMAGE3C2L2:
    LDA (PLOTC2DEST),Y
    STA (TMPPTR),Y
    DEY
    CPY #255
    BNE GETIMAGE3C2L2

    DEC IMAGEH
    BEQ GETIMAGE3E

    CLC
    LDA TMPPTR
    ADC IMAGEW
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    CLC
    LDA PLOTC2DEST
    ADC #40
    STA PLOTC2DEST
    LDA PLOTC2DEST+1
    ADC #0
    STA PLOTC2DEST+1

    LDA IMAGEW
    TAY
    DEY
    JMP GETIMAGE3C2L2

GETIMAGE3E:
    LDY #0
    LDA $FF15
    STA (TMPPTR),Y
    LDA $FF16
    LDY #1
    STA (TMPPTR),Y

    RTS
