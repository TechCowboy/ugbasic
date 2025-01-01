; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file eXcept in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless required by applicable law or agreed to in writing, software
;  * distributed under the License is distributed on an "AS IS" BASIS,
;  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either eXpress or implied.
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
;*                  MOVABLE OBJECTS UNDER TED (specific algorithms)            *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

MOBDRAW_TMP: .byte 0
MOBDRAW_PD: .byte 0
MOBDRAW_DY: .byte 0
MOBDRAW_DY2: .byte 0
MOBDRAW_DX: .byte 0
MOBDRAW_I: .byte 0
MOBDRAW_J: .byte 0
MOBDRAW_K: .byte 0
MOBDRAW_C: .byte 0
MOBDRAW_R: .byte 0

; ---------------------------------------------------------------------------
; Chipset specific initialization
; MOBINITCS(X:index,draw)
; ---------------------------------------------------------------------------
MOBINITCS:
    LDA CURRENTMODE
    ; BITMAP_MODE_STANDARD
    CMP #2
    BNE MOBINITCS2X
    JMP MOBINITCS2
MOBINITCS2X:
    ; BITMAP_MODE_MULTICOLOR
    CMP #3
    BNE MOBINITCS3X
    JMP MOBINITCS3
MOBINITCS3X:
    ; TILEMAP_MODE_STANDARD
    CMP #0
    BNE MOBINITCS0X
    JMP MOBINITCS0
MOBINITCS0X:
    ; TILEMAP_MODE_MULTICOLOR
    CMP #1
    BNE MOBINITCS1X
    JMP MOBINITCS1
MOBINITCS1X:
    ; TILEMAP_MODE_EXTENDED
    CMP #4
    BNE MOBINITCS4X
    JMP MOBINITCS4
MOBINITCS4X:
    RTS

; ---------------------------------------------------------------------------
; MODE 2 (BITMAP STANDARD)
; Shift the *current* draw area image of MOBI mob of MOBDRAW_DX pixel 
; to the right. Additional left pixel are put to zero.
; ---------------------------------------------------------------------------
MOBDRAW2_SHIFTRIGHT:

    LDX MOBI

    ; Load first location of draw data
    LDA MOBDESCRIPTORS_DL, X
    STA MOBADDR
    LDA MOBDESCRIPTORS_DH, X
    STA MOBADDR+1

    ; Load height (in pixels) = height (in rows) + 8
    CLC
    LDA MOBDESCRIPTORS_H, X
    STA MOBH
    ADC #8
    STA MOBDRAW_R
    STA MOBDRAW_I

    ; Load width (in pixels) = width (in cols) + 1
    LDA MOBDESCRIPTORS_W, X
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_C
    ASL
    ASL
    ASL
    STA MOBW

    ; Load displacement = iteraction for each  line
    LDA MOBDRAW_DX
    AND #$07
    STA MOBDRAW_K

    ; Rows loop
MOBDRAW2_SHIFTRIGHTL1:

    ; j = cols
    LDA MOBDRAW_C
    STA MOBDRAW_J

    LDY #0
    CLC

    ; Cols loop
MOBDRAW2_SHIFTRIGHTL2:

    ; Rotate the content of the cell by 1 pixel to the right
    ; and save the last pixel on carry. The carry will be put
    ; on the leftmost pixel.
    LDA (MOBADDR),Y
    ROR
    STA (MOBADDR),Y

    ; Move to the next cell on the same line.
    ; This is placed after 8 bytes from the current position.
    INY
    INY
    INY
    INY
    INY
    INY
    INY
    INY

    ; Repeat for each cell of the same row.
    DEC MOBDRAW_J
    BNE MOBDRAW2_SHIFTRIGHTL2

    ; Repeat for the entire size of the displacement.
    LDY #0
    DEC MOBDRAW_K
    BNE MOBDRAW2_SHIFTRIGHTL1

    ; Move to the next line
    ; If we are at the last line of the cell,
    ; we must advace of an entire row.
    LDA MOBDRAW_I
    AND #$07
    CMP #$01
    BEQ MOBDRAW2_SHIFTRIGHTR8

MOBDRAW2_SHIFTRIGHTR1:
    CLC
    LDA MOBADDR
    ADC #1
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1
    JMP MOBDRAW2_SHIFTRIGHTRD

MOBDRAW2_SHIFTRIGHTR8:
    CLC
    LDA MOBADDR
    ADC MOBW
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    SEC
    LDA MOBADDR
    SBC #7
    STA MOBADDR
    LDA MOBADDR+1
    SBC #0
    STA MOBADDR+1

    JMP MOBDRAW2_SHIFTRIGHTRD

MOBDRAW2_SHIFTRIGHTRD:
    LDA MOBDRAW_DX
    AND #$07
    STA MOBDRAW_K
    ; Repeat for each row of the entire draw.
    DEC MOBDRAW_I
    BNE MOBDRAW2_SHIFTRIGHTL1
    RTS

; ---------------------------------------------------------------------------
; MODE 2 (BITMAP STANDARD)
; Shift the *current* draw area image of MOBI mob of MOBDRAW_DX pixel 
; to the left. Pixels on the right are put to zero.
; ---------------------------------------------------------------------------

MOBDRAW2_SHIFTLEFT:

    LDX MOBI

    ; Load first location of draw data
    LDA MOBDESCRIPTORS_DL, X
    STA MOBADDR
    LDA MOBDESCRIPTORS_DH, X
    STA MOBADDR+1

    LDA MOBDESCRIPTORS_SIZEL, X
    STA MOBSIZE
    LDA MOBDESCRIPTORS_SIZEH, X
    STA MOBSIZE+1

    ; Load height (in pixels) = height (in rows) + 8
    LDA MOBDESCRIPTORS_H, X
    STA MOBH
    CLC
    ADC #8
    STA MOBDRAW_R
    STA MOBDRAW_I

    ; Load width (in pixels) = width (in cols) + 1
    LDA MOBDESCRIPTORS_W, X
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_C
    SEC
    SBC #1
    ASL
    ASL
    ASL
    STA MOBW

    ; Load displacement = iteraction for each  line
    LDA MOBDRAW_DX
    AND #$07
    STA MOBDRAW_K

    ; Rows loop
MOBDRAW2_SHIFTLEFTL1:

    ; j = cols
    LDA MOBDRAW_C
    STA MOBDRAW_J

    LDA MOBW
    TAY

    CLC

    ; Cols loop
MOBDRAW2_SHIFTLEFTL2:

    ; Rotate the content of the cell by 1 pixel to the left
    ; and save the first pixel on carry. The carry will be put
    ; on the rightmost pixel.
    LDA (MOBADDR),Y
    ROL A
    STA (MOBADDR),Y

    ; Move to the previous cell on the same line.
    ; This is placed after 8 bytes from the current position.
    DEY
    DEY
    DEY
    DEY
    DEY
    DEY
    DEY
    DEY

    ; Repeat for each cell of the same row.
    DEC MOBDRAW_J
    BNE MOBDRAW2_SHIFTLEFTL2

    ; Repeat for the entire size of the displacement.
    LDA MOBW
    TAY
    DEC MOBDRAW_K
    BNE MOBDRAW2_SHIFTLEFTL1

    ; Move to the next line
    ; If we are at the last line of the cell,
    ; we must advace of an entire row.
    LDA MOBDRAW_I
    AND #$07
    CMP #$01
    BEQ MOBDRAW2_SHIFTLEFTR8

MOBDRAW2_SHIFTLEFTR1:
    CLC
    LDA MOBADDR
    ADC #1
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1
    JMP MOBDRAW2_SHIFTLEFTRD

MOBDRAW2_SHIFTLEFTR8:
    CLC
    LDA MOBADDR
    ADC MOBW
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    CLC
    LDA MOBADDR
    ADC #1
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1
    JMP MOBDRAW2_SHIFTLEFTRD

MOBDRAW2_SHIFTLEFTRD:
    LDA MOBDRAW_DX
    AND #$07
    STA MOBDRAW_K
    ; Repeat for each row of the entire draw.
    DEC MOBDRAW_I
    BNE MOBDRAW2_SHIFTLEFTL1
    RTS

; ---------------------------------------------------------------------------
; MODE 2 (BITMAP STANDARD)
; Shift the *current* draw area image of MOBI mob of MOBDRAW_DY pixel 
; to the top. Pixels on the bottom are put to zero.
; ---------------------------------------------------------------------------

MOBDRAW2_SHIFTUP:

    LDX MOBI

    LDA MOBDRAW_DY
    AND #$07
    STA MOBDRAW_K

    LDA MOBDESCRIPTORS_W, x
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_C
    ASL
    ASL
    ASL
    STA MOBW
    LDA #0
    STA MOBDRAW_J

    ; Load height (in pixels) = height (in rows) + 8
    LDA MOBDESCRIPTORS_H, X
    STA MOBH
    CLC
    ADC #8
    LSR
    LSR
    LSR
    STA MOBDRAW_R
    STA MOBDRAW_I

MOBDRAW2_SHIFTUPL0:

    ; MOBSIZE = WC x WR
    LDA MOBDESCRIPTORS_SIZEL, X
    STA MOBSIZE
    LDA MOBDESCRIPTORS_SIZEH, X
    STA MOBSIZE+1

    LDA MOBSIZE
    ; MOBSIZE => C = 8 x WC X WR = MOBSIZE

    ; WC1 = WC-1
    LDA MOBDESCRIPTORS_W, X
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_C

    SEC
    SBC #1

    ; WC12 = WC1*8
    ASL A
    ASL A
    ASL A
    ; MOBDRAW_TMP <= WC121 = WC12+1
    CLC
    ADC #1

    STA MOBDRAW_TMP

MOBDRAW2_SHIFTUPLCC:

    LDA MOBDESCRIPTORS_DL, X
    STA MOBADDR
    LDA MOBDESCRIPTORS_DH, X
    STA MOBADDR+1

    LDA MOBADDR
    STA TMPPTR
    LDA MOBADDR+1
    STA TMPPTR+1

    CLC
    LDA MOBADDR
    ADC #1
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    LDA #0
    STA MOBDRAW_J

MOBDRAW2_SHIFTUPL1:

    LDX MOBI

    LDY #0

MOBDRAW2_SHIFTUPLA:
    LDA (MOBADDR),Y
    STA (TMPPTR),Y
    INY
    CPY #$7
    BNE MOBDRAW2_SHIFTUPLA

    CLC
    LDA MOBADDR
    ADC #7
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    LDA MOBADDR
    STA TMPPTR
    LDA MOBADDR+1
    STA TMPPTR+1

    SEC
    LDA TMPPTR
    SBC MOBDRAW_TMP
    STA TMPPTR
    LDA TMPPTR+1
    SBC #0
    STA TMPPTR+1

    LDA MOBDRAW_I
    CMP #$ff
    BEQ MOBDRAW2_SHIFTUPSKIP

    ;      sposta da [C-[((WC-1)*8)+1]] a [C] 

    LDY #0
    LDA (MOBADDR),Y
    STA (TMPPTR),Y

    JMP MOBDRAW2_SHIFTUPSKIPD

MOBDRAW2_SHIFTUPSKIP:

    LDY #0
    LDA #0
    STA (MOBADDR),Y

MOBDRAW2_SHIFTUPSKIPD:

    CLC
    LDA TMPPTR
    ADC MOBDRAW_TMP
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    SEC
    LDA MOBADDR
    SBC #7
    STA MOBADDR
    LDA MOBADDR+1
    SBC #0
    STA MOBADDR+1

    ; C = C - 8

    CLC
    LDA MOBADDR
    ADC #8
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    SEC
    LDA MOBADDR
    SBC #1
    STA TMPPTR
    LDA MOBADDR+1
    SBC #0
    STA TMPPTR+1

    ; se C < 0 FINE

    LDY #0
    INC MOBDRAW_J
    LDA MOBDRAW_J
    CMP MOBDRAW_C
    BEQ MOBDRAW2_SHIFTUPL1X
    JMP MOBDRAW2_SHIFTUPL1

MOBDRAW2_SHIFTUPL1X:
    LDA #0
    STA MOBDRAW_J
    LDY #0
    DEC MOBDRAW_I

    LDA MOBDRAW_I
    CMP #$0
    BEQ MOBDRAW2_SHIFTUPL1X2
    JMP MOBDRAW2_SHIFTUPL1

MOBDRAW2_SHIFTUPL1X2:
    
    LDA #0
    STA MOBDRAW_J
    LDA MOBDRAW_R
    STA MOBDRAW_I
    DEC MOBDRAW_K
    BEQ MOBDRAW2_SHIFTUPL1X3
    JMP MOBDRAW2_SHIFTUPLCC

MOBDRAW2_SHIFTUPL1X3:

MOBDRAW2_SHIFTUPL0X:

    RTS

; ---------------------------------------------------------------------------
; MODE 2 (BITMAP STANDARD)
; Shift the *current* draw area image of MOBI mob of MOBDRAW_DY pixel 
; to the bottom. Pixels on the top are put to zero.
; ---------------------------------------------------------------------------

MOBDRAW2_SHIFTDOWN:

    LDX MOBI

    LDA MOBDRAW_DY
    AND #$07
    STA MOBDRAW_K

    LDA MOBDESCRIPTORS_W, x
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_C
    LDA #0
    STA MOBDRAW_J
    ASL
    ASL
    ASL
    STA MOBW

    ; Load height (in pixels) = height (in rows) + 8
    LDA MOBDESCRIPTORS_H, X
    STA MOBH
    CLC
    ADC #8
    LSR
    LSR
    LSR
    STA MOBDRAW_R
    STA MOBDRAW_I

MOBDRAW2_SHIFTDOWNL0:

    ; MOBSIZE = WC x WR
    LDA MOBDESCRIPTORS_SIZEL, X
    STA MOBSIZE
    LDA MOBDESCRIPTORS_SIZEH, X
    STA MOBSIZE+1

    LDA MOBSIZE
    ; MOBSIZE => C = 8 x WC X WR = MOBSIZE

    ; WC1 = WC-1
    LDA MOBDESCRIPTORS_W, X
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_C

    SEC
    SBC #1

    ; WC12 = WC1*8
    ASL A
    ASL A
    ASL A
    ; MOBDRAW_TMP <= WC121 = WC12+1
    CLC
    ADC #1

    STA MOBDRAW_TMP

MOBDRAW2_SHIFTDOWNLCC:

    LDA MOBDESCRIPTORS_DL, X
    STA MOBADDR
    LDA MOBDESCRIPTORS_DH, X
    STA MOBADDR+1

    CLC
    LDA MOBADDR
    ADC MOBSIZE
    STA MOBADDR
    LDA MOBADDR+1
    ADC MOBSIZE+1
    STA MOBADDR+1

    SEC
    LDA MOBADDR
    SBC #8
    STA MOBADDR
    LDA MOBADDR+1
    SBC #0
    STA MOBADDR+1

    CLC
    LDA MOBADDR
    ADC #1
    STA TMPPTR
    LDA MOBADDR+1
    ADC #0
    STA TMPPTR+1

    LDA #0
    STA MOBDRAW_J

MOBDRAW2_SHIFTDOWNL1:

    LDX MOBI
    ; se C > WC121 allora

    LDY #6

MOBDRAW2_SHIFTDOWNLA:
    ; sposta da [C+6] a [C+7]
    ; ...
    ; sposta da [C+1] a [C+2]
    ; sposta da [C] a [C+1]
    LDA (MOBADDR),Y
    STA (TMPPTR),Y
    DEY
    CPY #$FF
    BNE MOBDRAW2_SHIFTDOWNLA

    LDA MOBDRAW_I
    CMP #$1
    BEQ MOBDRAW2_SHIFTDOWNSKIP

    ;      sposta da [C-[((WC-1)*8)+1]] a [C] 

    CLC
    LDA MOBADDR
    ADC #0
    STA TMPPTR
    LDA MOBADDR+1
    ADC #0
    STA TMPPTR+1

    SEC
    LDA MOBADDR
    SBC MOBDRAW_TMP
    STA MOBADDR
    LDA MOBADDR+1
    SBC #0
    STA MOBADDR+1

    LDY #0
    LDA (MOBADDR),Y
    LDY #0
    STA (TMPPTR),Y

    CLC
    LDA MOBADDR
    ADC MOBDRAW_TMP
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    CLC
    LDA MOBADDR
    ADC #1
    STA TMPPTR
    LDA MOBADDR+1
    ADC #0
    STA TMPPTR+1

    JMP MOBDRAW2_SHIFTDOWNSKIPD

MOBDRAW2_SHIFTDOWNSKIP:

    LDY #0
    LDA #0
    STA (MOBADDR),Y

MOBDRAW2_SHIFTDOWNSKIPD:

    ; C = C - 8

    SEC
    LDA MOBADDR
    SBC #8
    STA MOBADDR
    LDA MOBADDR+1
    SBC #0
    STA MOBADDR+1

    CLC
    LDA MOBADDR
    ADC #1
    STA TMPPTR
    LDA MOBADDR+1
    ADC #0
    STA TMPPTR+1

    ; se C < 0 FINE

    LDY #6
    INC MOBDRAW_J
    LDA MOBDRAW_J
    CMP MOBDRAW_C
    BEQ MOBDRAW2_SHIFTDOWNL1X
    JMP MOBDRAW2_SHIFTDOWNL1

MOBDRAW2_SHIFTDOWNL1X:
    LDA #0
    STA MOBDRAW_J
    LDY #6
    DEC MOBDRAW_I

    LDA MOBDRAW_I
    CMP #$0
    BEQ MOBDRAW2_SHIFTDOWNL1X2
    JMP MOBDRAW2_SHIFTDOWNL1

MOBDRAW2_SHIFTDOWNL1X2:
    
    LDA MOBDRAW_R
    STA MOBDRAW_I
    DEC MOBDRAW_K
    BEQ MOBDRAW2_SHIFTDOWNL1X3
    JMP MOBDRAW2_SHIFTDOWNLCC

MOBDRAW2_SHIFTDOWNL1X3:

MOBDRAW2_SHIFTDOWNL0X:

    RTS

; Chipset specific initialization
; (we use the data that generic initialization put on descriptor)
MOBINITCS2:
    
    SEI
    STA $FF3F

    LDX MOBI

    ; Save the actual data into save attribute of descriptor,
    ; in order to avoid to lose it during allocation.
    LDA MOBDESCRIPTORS_DL,X
    STA MOBDESCRIPTORS_SL,X
    LDA MOBDESCRIPTORS_DH,X
    STA MOBDESCRIPTORS_SH,X

    ; Now load the actual size of the image
    ; (in pixel)
    LDA MOBDESCRIPTORS_W, X
    STA MOBW
    LDA MOBDESCRIPTORS_H, X
    STA MOBH

    ; Calculate the needed memory space for the drawing area
    ; that will contain the drawing. It must be 8 pixels (+ 1 cell) wider
    ; and 8 pixel (+ 1 cell) higher.
    LDA MOBW
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_C

    LDA MOBH
    LSR
    LSR
    LSR
    CLC
    ADC #1
    STA MOBDRAW_R
    ASL
    ASL
    ASL
    STA MOBH

    ; Now calculate the product MOBW x MOBH
    ; in MOBSIZE (bytes needed)
    LDA #0
    LDX #8
MOBINITCS21:
    LSR MOBH
    BCC MOBINITCS22
    CLC
    ADC MOBDRAW_C
MOBINITCS22:
    ROR A
    ROR MOBSIZE
    DEX
    BNE MOBINITCS21
    STA MOBSIZE+1

    LDX MOBI

    LDA MOBSIZE
    STA MOBDESCRIPTORS_SIZEL,X
    LDA MOBSIZE+1
    STA MOBDESCRIPTORS_SIZEH,X

MOBINITCS22X:
    ; Now we can allocate the space on the MOBSEGMENT
    JSR MOBALLOC

    LDX MOBI

    ; We now can save the address of freshly allocated
    ; space into the specific descriptor.
    LDA MOBADDR
    STA MOBDESCRIPTORS_DL,X
    LDA MOBADDR+1
    STA MOBDESCRIPTORS_DH,X

    ; Now we can copy the original data to the new space,
    ; at position 0,0 and assuring that is aligned to the
    ; new space.

XXXXXX:
    ; Recalculate limits (w,h)
    LDA MOBDRAW_C
    SEC
    SBC #1
    STA MOBDRAW_J
    ASL
    ASL
    ASL
    STA MOBW
    LDA MOBDRAW_R
    SEC
    SBC #1
    STA MOBDRAW_I
    ASL
    ASL
    ASL
    STA MOBH

    ; Move the source data to a temporary pointer,
    ; (the destination area is already on MOBADDR)
    LDA MOBDESCRIPTORS_SL,X
    STA TMPPTR
    LDA MOBDESCRIPTORS_SH,X
    STA TMPPTR+1

    ; Copy one line at a time.
MOBINITCSL1A:
    LDY #0
MOBINITCSL1:
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    LDA (TMPPTR),Y
    STA (MOBADDR),Y
    INY
    DEC MOBDRAW_J
    BNE MOBINITCSL1

    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY

MOBINITCSL1R8:
    CLC
    LDA TMPPTR
    ADC MOBW
    STA TMPPTR
    LDA TMPPTR+1
    ADC #0
    STA TMPPTR+1

    CLC
    LDA MOBADDR
    ADC MOBW
    ADC #8
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    ; Repeat for each row of the entire draw.
    LDA MOBDRAW_C
    SEC
    SBC #1
    STA MOBDRAW_J
    DEC MOBDRAW_I
    BEQ MOBINITCSL1AX
    JMP MOBINITCSL1A

MOBINITCSL1AX:

    LDA MOBDRAW_C
    STA MOBDRAW_J
MOBINITCSL1HG:
    LDY #0
MOBINITCSL1H:
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    LDA #0
    STA (MOBADDR),Y
    INY
    DEC MOBDRAW_J
    BNE MOBINITCSL1H

    ; Now we must adjust the image inside the larger
    ; clip, by right and bottom shifting it, accordingly
    ; to the (relative) position (x,y)
    LDA MOBDESCRIPTORS_XL, X
    STA MOBX
    LDA MOBDESCRIPTORS_YL, X
    STA MOBY

    ; Calculate dx as x & 7: if the result is not zero,
    ; it means that the drawing is not aligned with the
    ; left border of the image.
    LDA MOBX
    AND #$07
    STA MOBDRAW_DX
    BEQ MOBINITCS2A

    ; If not aligned, we must shift it right by dx
    JSR MOBDRAW2_SHIFTRIGHT

MOBINITCS2A:

    ; Calculate dy as y & 7: if the result is not zero,
    ; it means that the drawing is not aligned with the
    ; top border of the image.

    LDA MOBY
    AND #$07
    STA MOBDRAW_DY
    BEQ MOBINITCS2B

    ; If not aligned, we must shift it down by dy
    JSR MOBDRAW2_SHIFTDOWN

MOBINITCS2B:

    STA $FF3E
    CLI

    RTS

MOBINITCS0:
MOBINITCS1:
MOBINITCS3:
MOBINITCS4:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; MOBSAVE(X:indeX) -> chipset
MOBSAVE:
    LDA CURRENTMODE
    ; BITMAP_MODE_STANDARD
    CMP #2
    BNE MOBSAVE2X
    JMP MOBSAVE2
MOBSAVE2X:
    ; BITMAP_MODE_MULTICOLOR
    CMP #3
    BNE MOBSAVE3X
    JMP MOBSAVE3
MOBSAVE3X:
    ; TILEMAP_MODE_STANDARD
    CMP #0
    BNE MOBSAVE0X
    JMP MOBSAVE0
MOBSAVE0X:
    ; TILEMAP_MODE_MULTICOLOR
    CMP #1
    BNE MOBSAVE1X
    JMP MOBSAVE1
MOBSAVE1X:
    ; TILEMAP_MODE_EXTENDED
    CMP #4
    BNE MOBSAVE4X
    JMP MOBSAVE4
MOBSAVE4X:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SAVE MODE 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This routine will increment the position of the operation to the
; next byte (row) of the current cell.
MOBSAVE2_INC:
    CLC
    LDA MOBADDR
    ADC #1
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    CLC
    LDA PLOTDEST
    ADC #1
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #0
    STA PLOTDEST+1
    RTS

; This entry point is needed do save the screen into the reserved area,
; in standard BITMAP MODE (2).
MOBSAVE2:

    SEI
    STA $FF3F

    LDX MOBI

    LDA MOBDESCRIPTORS_SIZEL,X
    STA MOBSIZE
    LDA MOBDESCRIPTORS_SIZEH,X
    STA MOBSIZE+1

    JSR MOBALLOC

    LDA MOBADDR
    STA MOBDESCRIPTORS_SL, X
    LDA MOBADDR+1
    STA MOBDESCRIPTORS_SH, X

    ;-------------------------
    ;calc Y-cell, divide by 8
    ;y/8 is y-cell table index
    ;-------------------------
    LDA MOBDESCRIPTORS_YL, X
    LSR                         ;/ 2
    LSR                         ;/ 4
    LSR                         ;/ 8
    TAY                         ;tbl_8,y index

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;divide 2-byte PLOTX / 8
    ;------------------------
    LDA MOBDESCRIPTORS_XL, X
    ROR MOBDESCRIPTORS_XH, X   ;rotate the high byte into carry flag
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

    ; +---+---...---+---+
    ; |xxx|xxxxxxxxx|xxx|
    ; +---+---...---+---+
    ; |   |         |   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+

    LDX MOBI

    ; Calculate how many times we have to repeat
    ; the row copying. If the image's height is less than
    ; 8 pixels, we skip this part.
    LDA MOBDESCRIPTORS_H, X
    LSR
    LSR
    LSR
    BNE MOBSAVE2L3X1
    JMP MOBSAVE2L3

MOBSAVE2L3X1:

    CLC
    ADC #1
    STA MOBDRAW_I

    ; Calculate how many times we have to repeat
    ; the cell copying. If the image's width is less than
    ; 9 pixels, we skip this part.
    LDA MOBDESCRIPTORS_W, X
    LSR
    LSR
    LSR
    BNE MOBSAVE2L3X2
    JMP MOBSAVE2L3
MOBSAVE2L3X2:

    CLC
    ADC #1
    STA MOBDRAW_J
    STA MOBDRAW_C

    ; Repeate an entire cell copy for each column
MOBSAVE2L2A:    
    LDY #0
MOBSAVE2L2:
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    LDA (PLOTDEST),Y       ; D
    STA (MOBADDR),Y       ; S
    ; LDA #$55
    ; STA (PLOTDEST),Y
    INY
    DEC MOBDRAW_J
    BEQ MOBSAVE2L2X
    JMP MOBSAVE2L2

MOBSAVE2L2X:

    CLC
    LDA PLOTDEST
    ADC #$40
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #$1
    STA PLOTDEST+1

    CLC
    LDA MOBADDR
    ADC MOBW
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    CLC
    LDA MOBADDR
    ADC #8
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    LDA MOBDRAW_C
    STA MOBDRAW_J
    DEC MOBDRAW_I
    BEQ MOBSAVE2L2AX
    JMP MOBSAVE2L2A

MOBSAVE2L2AX:

MOBSAVE2L3:

    STA $FF3E
    CLI

    RTS

MOBSAVE3:
    RTS

MOBSAVE0:
MOBSAVE1:
MOBSAVE4:
    RTS

; MOBRESTORE(X:indeX) -> chipset
MOBRESTORE:
    LDA CURRENTMODE
    ; BITMAP_MODE_STANDARD
    CMP #2
    BNE MOBRESTORE2X
    JMP MOBRESTORE2
MOBRESTORE2X:
    ; BITMAP_MODE_MULTICOLOR
    CMP #3
    BNE MOBRESTORE3X
    JMP MOBRESTORE3
MOBRESTORE3X:
    ; TILEMAP_MODE_STANDARD
    CMP #0
    BNE MOBRESTORE0X
    JMP MOBRESTORE0
MOBRESTORE0X:
    ; TILEMAP_MODE_MULTICOLOR
    CMP #1
    BNE MOBRESTORE1X
    JMP MOBRESTORE1
MOBRESTORE1X:
    ; TILEMAP_MODE_EXTENDED
    CMP #4
    BNE MOBRESTORE4X
    JMP MOBRESTORE4
MOBRESTORE4X:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RESTORE MODE 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This routine will do a simple copy of the screen pixels over the
; save area one, replacing them.
MOBRESTORE2_COPY:
    LDY #0
    LDA (MOBADDR),Y       ; S
    ; LDA #$AA
    STA (PLOTDEST),Y       ; D
    RTS

; This routine will increment the position of the operation to the
; next byte (row) of the current cell.
MOBRESTORE2_INC:
    CLC
    LDA MOBADDR
    ADC #1
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    CLC
    LDA PLOTDEST
    ADC #1
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #0
    STA PLOTDEST+1
    RTS

MOBRESTORE2_INCL:
    CLC
    LDA PLOTDEST
    ADC #$40
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #$1
    STA PLOTDEST+1

    SEC
    LDA PLOTDEST
    SBC MOBW
    STA PLOTDEST
    LDA PLOTDEST+1
    SBC #$0
    STA PLOTDEST+1

    RTS

; This entry point is needed do save the screen into the reserved area,
; in standard BITMAP MODE (2).
MOBRESTORE2:

    SEI
    STA $FF3F

    LDX MOBI

    LDA MOBDESCRIPTORS_SL, X
    STA MOBADDR
    LDA MOBDESCRIPTORS_SH, X
    STA MOBADDR+1

    ;-------------------------
    ;calc Y-cell, divide by 8
    ;y/8 is y-cell table index
    ;-------------------------
    LDA MOBDESCRIPTORS_PYL, X
    LSR                         ;/ 2
    LSR                         ;/ 4
    LSR                         ;/ 8
    TAY                         ;tbl_8,y index

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;divide 2-byte PLOTX / 8
    ;------------------------
    LDA MOBDESCRIPTORS_PXL, X
    ROR MOBDESCRIPTORS_PXH, X   ;rotate the high byte into carry flag
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

    ; +---+---...---+---+
    ; |xxx|xxxxxxxxx|xxx|
    ; +---+---...---+---+
    ; |   |         |   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+

    LDX MOBI

    ; Calculate how many times we have to repeat
    ; the row copying. If the image's height is less than
    ; 8 pixels, we skip this part.
    LDA MOBDESCRIPTORS_H, X
    LSR
    LSR
    LSR
    BEQ MOBRESTORE2L3
    CLC
    ADC #1
    STA MOBDRAW_I

    ; Calculate how many times we have to repeat
    ; the cell copying. If the image's width is less than
    ; 9 pixels, we skip this part.
    LDA MOBDESCRIPTORS_W, X
    LSR
    LSR
    LSR
    BEQ MOBRESTORE2L3
    CLC
    ADC #1
    STA MOBDRAW_J
    STA MOBDRAW_C
    ASL
    ASL
    ASL
    STA MOBW

    LDX MOBI
    LDA MOBVBL
    BEQ MOBRESTORENOVBL
    CLC
    LDA MOBDESCRIPTORS_PYL,X
    ADC #28
    ADC MOBDESCRIPTORS_H,X
    ADC MOBDESCRIPTORS_H,X
    JSR MOBWAITLINE

MOBRESTORENOVBL:

    ; Repeate an entire cell copy for each column
MOBRESTORE2L2A:    
MOBRESTORE2L2:
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    JSR MOBRESTORE2_COPY
    JSR MOBRESTORE2_INC
    DEC MOBDRAW_J
    BNE MOBRESTORE2L2A

    JSR MOBRESTORE2_INCL

    LDA MOBDRAW_C
    STA MOBDRAW_J
    DEC MOBDRAW_I
    BNE MOBRESTORE2L2A

MOBRESTORE2L3:

    LDX MOBI

    LDA MOBDESCRIPTORS_SIZEL,X
    STA MOBSIZE
    LDA MOBDESCRIPTORS_SIZEH,X
    STA MOBSIZE+1

    JSR MOBFREE

    LDA #0
    STA MOBDESCRIPTORS_SL, X
    LDA #0
    STA MOBDESCRIPTORS_SH, X

    STA $FF3E
    CLI

    RTS

MOBRESTORE3:
    RTS

MOBRESTORE0:
MOBRESTORE1:
MOBRESTORE4:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Chipset specific drawing routine
; MOBDRAW(X:indeX) -> chipset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MOBDRAW:
    LDA CURRENTMODE
    ; BITMAP_MODE_STANDARD
    CMP #2
    BNE MOBDRAW2X
    JMP MOBDRAW2
MOBDRAW2X:
    ; BITMAP_MODE_MULTICOLOR
    CMP #3
    BNE MOBDRAW3X
    JMP MOBDRAW3
MOBDRAW3X:
    ; TILEMAP_MODE_STANDARD
    CMP #0
    BNE MOBDRAW0X
    JMP MOBDRAW0
MOBDRAW0X:
    ; TILEMAP_MODE_MULTICOLOR
    CMP #1
    BNE MOBDRAW1X
    JMP MOBDRAW1
MOBDRAW1X:
    ; TILEMAP_MODE_EXTENDED
    CMP #4
    BNE MOBDRAW4X
    JMP MOBDRAW4
MOBDRAW4X:

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW MODE 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This routine will do nothing, by skipping the
; number of bytes (rows in a cell) given by 
; MOBDRAW_DY parameters. 
MOBDRAW2_NOP:
    CLC
    LDA MOBADDR
    ADC MOBDRAW_DY
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1
    CLC
    LDA PLOTDEST
    ADC MOBDRAW_DY
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #0
    STA PLOTDEST+1
    RTS

; This routine will do nothing, by skipping the
; number of bytes (rows in a cell) given by 
; 8-MOBDRAW_DY parameters. 
MOBDRAW2_NOP2:
    CLC
    LDA MOBADDR
    ADC #8
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1
    SEC
    LDA MOBADDR
    SBC MOBDRAW_DY
    STA MOBADDR
    LDA MOBADDR+1
    SBC #0
    STA MOBADDR+1

    CLC
    LDA PLOTDEST
    ADC #8
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #0
    STA PLOTDEST+1
    SEC
    LDA PLOTDEST
    SBC MOBDRAW_DY
    STA PLOTDEST
    LDA PLOTDEST+1
    SBC #0
    STA PLOTDEST+1
    RTS

; This routine will do a "left mask", by taking the original pixels
; from the drawing, protecting the first MOBDRAW_DX pixels and
; replacing the others. 
MOBDRAW2_LEFTMASK:
    LDX MOBDRAW_DX
    LDA MOBDRAW2_MASKX,X       ; maskX
    EOR #$FF                       ; ~ maskX
    LDY #0
    AND (PLOTDEST),Y           ; B & ~ maskX
    STA MOBDRAW_TMP
    LDX MOBDRAW_DX
    LDA MOBDRAW2_MASKX,X       ; maskX
    LDY #0
    AND (MOBADDR),Y           ; S & maskX
    ORA MOBDRAW_TMP
    STA (PLOTDEST),Y
    RTS

; This routine will do a "right mask", by taking the original pixels
; from the drawing, protecting the last MOBDRAW_DX pixels and
; replacing the others.
MOBDRAW2_RIGHTMASK:
    LDX MOBDRAW_DX
    LDA MOBDRAW2_MASKX,X       ; maskX
    LDY #0
    AND (PLOTDEST),Y           ; B & maskX
    STA MOBDRAW_TMP
    LDX MOBDRAW_DX
    LDA MOBDRAW2_MASKX,X       ; maskX
    EOR #$FF                       ; ~ maskX
    LDY #0
    AND (MOBADDR),Y           ; S & ~ maskX
    ORA MOBDRAW_TMP
    STA (PLOTDEST),Y
    RTS

; This routine will do a simple copy of the drawing pixels over the
; original one, replacing them.
MOBDRAW2_COPY:
    LDY #0
    LDA (MOBADDR),Y       ; S
    STA (PLOTDEST),Y       ; D
    RTS

; This routine will increment the position of the operation to the
; next byte (row) of the current cell.
MOBDRAW2_INC:
    CLC
    LDA MOBADDR
    ADC #1
    STA MOBADDR
    LDA MOBADDR+1
    ADC #0
    STA MOBADDR+1

    CLC
    LDA PLOTDEST
    ADC #1
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #0
    STA PLOTDEST+1
    RTS

MOBDRAW2_INCL:
    CLC
    LDA PLOTDEST
    ADC #$40
    STA PLOTDEST
    LDA PLOTDEST+1
    ADC #$1
    STA PLOTDEST+1

    SEC
    LDA PLOTDEST
    SBC MOBW
    STA PLOTDEST
    LDA PLOTDEST+1
    SBC #$0
    STA PLOTDEST+1

    SEC
    LDA PLOTDEST
    SBC #$8
    STA PLOTDEST
    LDA PLOTDEST+1
    SBC #$0
    STA PLOTDEST+1

    RTS

; This entry point is needed do draw the image over the screen,
; in standard BITMAP MODE (2).
MOBDRAW2:

    SEI
    STA $FF3F

    STX MOBI

    LDA MOBDESCRIPTORS_DL, X
    STA MOBADDR
    LDA MOBDESCRIPTORS_DH, X
    STA MOBADDR+1

    ;-------------------------
    ;calc Y-cell, divide by 8
    ;y/8 is y-cell table index
    ;-------------------------
    LDA MOBDESCRIPTORS_YL, X
    LSR                         ;/ 2
    LSR                         ;/ 4
    LSR                         ;/ 8
    TAY                         ;tbl_8,y index

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;divide 2-byte PLOTX / 8
    ;------------------------
    LDA MOBDESCRIPTORS_XL, X
    ROR MOBDESCRIPTORS_XH, X   ;rotate the high byte into carry flag
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

    LDX MOBI

    ; Calculate the effective offset of the image,
    ; in order to know how many pixels we have to
    ; skip / mask.
    LDA MOBDESCRIPTORS_YL, X
    AND #$07
    STA MOBDRAW_DY
    STA MOBDRAW_DY2
    STA MOBDRAW_I

    LDA MOBDESCRIPTORS_XL, X
    AND #$07
    STA MOBDRAW_DX
    STA MOBDRAW_J

    ; +---+---...---+---+
    ; |XXX|         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+

    LDA MOBDRAW_DY2
    STA MOBDRAW_DY
    
    ; Skip DY rows
    JSR MOBDRAW2_NOP

    ; Copy (masked) 8-DY rows
    SEC
    LDA #8
    SBC MOBDRAW_DY
    STA MOBDRAW_I
MOBDRAW2L1:
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    DEC MOBDRAW_I
    BNE MOBDRAW2L1

    ; +---+---...---+---+
    ; |   |xxxxxxxxx|   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+

    LDX MOBI

    ; Calculate how many times we have to repeat
    ; the cell copying. If the image's width is less than
    ; 9 pixels, we skip this part.

    LDA MOBDESCRIPTORS_W, X
    LSR
    LSR
    LSR
    BEQ MOBDRAW2L3
    STA MOBDRAW_J
    STA MOBDRAW_C
    ASL
    ASL
    ASL
    STA MOBW

    DEC MOBDRAW_J

;     ; Repeate an entire cell copy for each column
MOBDRAW2L2A:    
    LDA MOBDRAW_DY2
    STA MOBDRAW_DY
    
;     ; Skip DY rows
    JSR MOBDRAW2_NOP

;     ; Copy (masked) 8-DY rows
    SEC
    LDA #8
    SBC MOBDRAW_DY
    STA MOBDRAW_I
MOBDRAW2L2:
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    DEC MOBDRAW_I
    BNE MOBDRAW2L2

    DEC MOBDRAW_J
    BNE MOBDRAW2L2A

MOBDRAW2L3:

;     ; +---+---...---+---+
;     ; |   |         |xxx|
;     ; +---+---...---+---+
;     ; |   |         |   |
;     ; .   .         .   .
;     ; |   |         |   |
;     ; +---+---...---+---+
;     ; |   |         |   |
;     ; +---+---...---+---+

    LDX MOBI

    LDA MOBDRAW_DY2
    STA MOBDRAW_DY
    
;     ; Skip DY rows
    JSR MOBDRAW2_NOP

;     ; Copy (masked) 8-DY rows
    SEC
    LDA #8
    SBC MOBDRAW_DY
    STA MOBDRAW_I
MOBDRAW2L3B:
    JSR MOBDRAW2_RIGHTMASK
    DEC MOBDRAW_I
    BEQ MOBDRAW2L3BX
    JSR MOBDRAW2_INC
    JMP MOBDRAW2L3B

MOBDRAW2L3BX:

    LDX MOBI

    ; Calculate how many times we have to repeat
    ; the row copying. If the image's height is less than
    ; 8 pixels, we skip this part.
    LDA MOBDESCRIPTORS_H, X
    LSR
    LSR
    LSR
    BNE MOBDRAW2L6X
    JMP MOBDRAW2L6
MOBDRAW2L6X:
    SEC
    SBC #1
    BNE MOBDRAW2L6X2
    JMP MOBDRAW2L6
MOBDRAW2L6X2:

    STA MOBDRAW_I

MOBDRAW2L4:

    JSR MOBDRAW2_INCL

    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+
    ; |xxx|         |   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+

    ; Copy "left masked" the left most cell.
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC

    ; Calculate how many times we have to repeat
    ; the cell copying. If the image's width is less than
    ; 9 pixels, we skip this part.
    LDA MOBDRAW_C
    STA MOBDRAW_J
    DEC MOBDRAW_J

    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |xxxxxxxxx|   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+

    ; Repeate an entire cell copy for each column
    
MOBDRAW2L4A:
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    DEC MOBDRAW_J
    BNE MOBDRAW2L4A

;     ; +---+---...---+---+
;     ; |   |         |   |
;     ; +---+---...---+---+
;     ; |   |         |xxx|
;     ; .   .         .   .
;     ; |   |         |   |
;     ; +---+---...---+---+
;     ; |   |         |   |
;     ; +---+---...---+---+

;     ; Copy "right masked" the left most cell.
MOBDRAW2L5:
    
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC

    DEC MOBDRAW_I
    BEQ MOBDRAW2L4X
    JMP MOBDRAW2L4

MOBDRAW2L4X:

MOBDRAW2L6:

    JSR MOBDRAW2_INCL

    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |XXX|         |   |
    ; +---+---...---+---+

    LDX MOBI

    ; Copy (masked) DY rows
    LDA MOBDRAW_DY2
    STA MOBDRAW_DY
    STA MOBDRAW_I
    BNE MOBDRAW2L7
    JMP MOBDRAW2E
MOBDRAW2L7:
    JSR MOBDRAW2_LEFTMASK
    JSR MOBDRAW2_INC
    DEC MOBDRAW_I
    BEQ MOBDRAW2L1X2
    JMP MOBDRAW2L7

MOBDRAW2L1X2:

    ; Ignore 8-DY rows
    JSR MOBDRAW2_NOP2

    ; +---+---...---+---+
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |         |   |
    ; .   .         .   .
    ; |   |         |   |
    ; +---+---...---+---+
    ; |   |XXXXXXXXX|   |
    ; +---+---...---+---+

    LDX MOBI

    ; Calculate how many times we have to repeat
    ; the cell copying. If the image's width is less than
    ; 9 pixels, we skip this part.
    LDA  MOBDRAW_C
    STA  MOBDRAW_J
    DEC  MOBDRAW_J

    ; Repeate an entire cell copy for each column
MOBDRAW2L8A:    
    ; Copy DY rows
    LDA MOBDRAW_DY
    STA MOBDRAW_I
MOBDRAW2L8:
    JSR MOBDRAW2_COPY
    JSR MOBDRAW2_INC
    DEC MOBDRAW_I
    BNE MOBDRAW2L8
    ; Skip 8-DY rows
    JSR MOBDRAW2_NOP2

    DEC MOBDRAW_J
    BNE MOBDRAW2L8A

MOBDRAW2L9:

    LDX MOBI

    ; Copy by right masking DY rows
    LDA MOBDRAW_DY
    STA MOBDRAW_I
MOBDRAW2L9B:
    JSR MOBDRAW2_RIGHTMASK
    JSR MOBDRAW2_INC
    DEC MOBDRAW_I
    BNE MOBDRAW2L9B

    ; Skip 8-DY rows
    JSR MOBDRAW2_NOP2

MOBDRAW2E:

    STA $FF3E
    CLI

    RTS

MOBDRAW3:

    RTS

MOBDRAW0:
MOBDRAW1:
MOBDRAW4:

    RTS

MOBATCS:

    SEI
    STA $FF3F

    LDX MOBI

    ; Now we must adjust the image inside the larger
    ; clip, by right and bottom shifting it, accordingly
    ; to the (relative) position (x,y)
    ;
    ; DX for *next* position (DXn)
    LDA MOBDESCRIPTORS_XL, X
    STA MOBX
    AND #$07
    STA MOBDRAW_DX

    ; DX for *previous* position (DXp)
    LDA MOBDESCRIPTORS_PXL, X
    AND #$07

    ; DX = (DXp-DXn)
    ; So: if DX > 0 ---> DXp > DXn ---> shift left
    ;     if DX < 0 ---> DXp < DXn ---> shift right
    SEC
    SBC MOBDRAW_DX
    STA MOBDRAW_DX

    ; DY for *next* position (DYn)
    LDA MOBDESCRIPTORS_YL, X
    STA MOBY
    AND #$07
    STA MOBDRAW_DY

    ; DY for *previous* position (DYp)
    LDA MOBDESCRIPTORS_PYL, X
    AND #$07

    ; DY = (DYp-DYn)
    ; So: if DY > 0 ---> DYp > DYn ---> shift up
    ;     if DY < 0 ---> DYp < DYn ---> shift down
    SEC
    SBC MOBDRAW_DY
    STA MOBDRAW_DY

    LDA MOBDRAW_DX
    BEQ MOBATCS_VERT
    AND #$80
    BEQ MOBATCS_LEFT

MOBATCS_RIGHT:

    LDA MOBDRAW_DX
    CLC
    EOR #$FF
    ADC #1
    STA MOBDRAW_DX
    JSR MOBDRAW2_SHIFTRIGHT
    JMP MOBATCS_VERT

MOBATCS_LEFT:

    JSR MOBDRAW2_SHIFTLEFT
    JMP MOBATCS_VERT

MOBATCS_VERT:

    LDA MOBDRAW_DY
    BEQ MOBATCS_DONE
    AND #$80
    BEQ MOBATCS_UP

MOBATCS_DOWN:

    LDA MOBDRAW_DY
    CLC
    EOR #$FF
    ADC #1
    STA MOBDRAW_DY
    JSR MOBDRAW2_SHIFTDOWN
    JMP MOBATCS_DONE

MOBATCS_UP:

    JSR MOBDRAW2_SHIFTUP

MOBATCS_DONE:

    STA $FF3E
    CLI

    RTS

MOBWAITLINE:
    CMP $FF1D
    BCS MOBWAITLINE
    RTS
    
; Mask for bit selection / unselection on a single cell
; during drawing operations.
MOBDRAW2_MASKX:
    .byte %11111111
    .byte %01111111
    .byte %00111111
    .byte %00011111
    .byte %00001111
    .byte %00000111
    .byte %00000011
    .byte %00000001

