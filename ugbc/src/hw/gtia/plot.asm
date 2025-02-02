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
;*                            PLOT ROUTINE ON GTIA                             *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

PLOTX    = $90 ; $91
PLOTY    = $92
PLOTM    = $93
PLOTOMA  = $94
PLOTAMA  = $95
PLOTCPE    = $96

;--------------

PLOT:

@IF scaleX > 0
    ASL PLOTX
    ROL PLOTX+1
@ENDIF

@IF scaleX > 1
    ASL PLOTX
    ROL PLOTX+1
@ENDIF

@IF offsetX > 0
@EMIT offsetX AS offsetX
    CLC
    LDA PLOTX
    ADC #offsetX
    STA PLOTX
    LDA PLOTX+1
    ADC #0
    STA PLOTX+1
@ENDIF

@IF scaleY > 0
    ASL PLOTY
@ENDIF

@IF scaleY > 1
    ASL PLOTY
@ENDIF

@IF offsetY > 0
@EMIT offsetY AS offsetY
    CLC
    LDA PLOTY
    ADC offsetY
    STA PLOTY
@ENDIF

    CLC

@IF optionClip

    LDA PLOTY
    CMP CLIPY2
    BCC PLOT2
    BEQ PLOT2
    JMP PLOTP
PLOT2:
    CMP CLIPY1
    BEQ PLOT3
    BCS PLOT3
    JMP PLOTP
PLOT3:
    LDA PLOTX+1
    CMP CLIPX2+1
    BCC PLOT4
    BEQ PLOT3B
    JMP PLOTP
PLOT3B:
    LDA PLOTX
    CMP CLIPX2
    BCC PLOT4
    BEQ PLOT4
    JMP PLOTP
PLOT4:
    LDA PLOTX+1
    CMP CLIPX1+1
    BCS PLOT5
    BEQ PLOT4B
    JMP PLOTP
PLOT4B:
    LDA PLOTX
    CMP CLIPX1
    BCS PLOT5
    BEQ PLOT5
    JMP PLOTP
PLOT5:

@ENDIF

@IF !vestigialConfig.screenModeUnique 

    LDA CURRENTMODE
    CMP #8
    BEQ PLOTANTIC8
    CMP #9
    BNE PLOTANTIC9X
    JMP PLOTANTIC9
PLOTANTIC9X:
    CMP #10
    BNE PLOTANTIC10X
    JMP PLOTANTIC10
PLOTANTIC10X:
    CMP #11
    BNE PLOTANTIC11X
    JMP PLOTANTIC11
PLOTANTIC11X:
    CMP #13
    BNE PLOTANTIC13X
    JMP PLOTANTIC13
PLOTANTIC13X:
    CMP #15
    BNE PLOTANTIC15X
    JMP PLOTANTIC15
PLOTANTIC15X:
    CMP #12
    BNE PLOTANTIC12X
    JMP PLOTANTIC12
PLOTANTIC12X:
    CMP #14
    BNE PLOTANTIC14X
    JMP PLOTANTIC14
PLOTANTIC14X:
    JMP PLOTP

@ENDIF

; Graphics 3 (ANTIC 8)
; This four-color graphics mode turns a split screen into 20 rows of 40 graphics cells or pixels. 
; Each pixel is 8 x 8 or the size of a normal character. The data in each pixel is encoded as two bit pairs, 
; four per byte. The four possible bit pair combinations 00, 01, 10, and 11 point to one of the four color registers. 
; The bits 00 is assigned to the background color register and the rest refer to the three foreground color registers. 
; When the CTIA/GTIA chip interprets the data for the four adjacent pixels stored within the byte, it refers to the color 
; register encoded in the bit pattern to plot the color.

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 8 ) )

PLOTANTIC8:

    LDA PLOTCPE
    CMP $2C4
    BNE PLOTANTIC8C1
    JMP PLOTANTIC8C1
PLOTANTIC8C1X:
    CMP $2C5
    BNE PLOTANTIC8C2X
    JMP PLOTANTIC8C2
PLOTANTIC8C2X:
    CMP $2C6
    BNE PLOTANTIC8C3X
    JMP PLOTANTIC8C3
PLOTANTIC8C3X:
    JSR FINDLASTCOLORUSED
    CMP #1
    BEQ PLOTANTIC8SC1
    CMP #2
    BEQ PLOTANTIC8SC2
    CMP #3
    BEQ PLOTANTIC8SC3

    JMP PLOTANTIC8SC1

PLOTANTIC8SC1:
@INLINE PALETTEPRESERVE2C4 [PLOTCPE], [#$1]
PLOTANTIC8C1:
    LDA #<PLOTORBIT41
    STA TMPPTR
    LDA #>PLOTORBIT41
    STA TMPPTR+1
    JMP PLOTANTIC8PEN

PLOTANTIC8SC2:
@INLINE PALETTEPRESERVE2C5 [PLOTCPE], [#$1]
PLOTANTIC8C2:
    LDA #<PLOTORBIT42
    STA TMPPTR
    LDA #>PLOTORBIT42
    STA TMPPTR+1
    JMP PLOTANTIC8PEN

PLOTANTIC8SC3:
@INLINE PALETTEPRESERVE2C6 [PLOTCPE], [#$1]
PLOTANTIC8C3:
    LDA #<PLOTORBIT43
    STA TMPPTR
    LDA #>PLOTORBIT43
    STA TMPPTR+1
    JMP PLOTANTIC8PEN

PLOTANTIC8PEN:
    CLC

    ;------------------------
    ;calc X-cell, divide by 4
    ;------------------------
    LDA PLOTX
    AND #$03

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$03
    TAX
    LDA PLOTANDBIT4,x
    STA PLOTAMA

    LDA PLOTX
    LSR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    LDA PLOT4VBASELO,Y          ;table of $9C40 row base addresses
    ADC PLOT4LO,X              ;+ (4 * Xcell)
    STA PLOTDEST               ;= cell address

    LDA PLOT4VBASEHI,Y          ;do the high byte
    ADC PLOT4HI,X
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

; Graphics 4 (ANTIC 9)
; This is a two-color graphics mode with four times the resolution of GRAPHICS 3. The pixels are 4 x 4, and 48 rows of 80 
; pixels fit on a full screen. A single bit is used to store each pixel's color register. A zero refers to the background 
; color register and a one to the foreground color register. The mode is used primarily to conserve screen memory. 
; Only one bit is used for the color, so eight adjacent pixels are encoded within one byte, and only half as much screen 
; memory is needed for a display of similiar-sized pixels.
; 80x48, 2 colors

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 9 ) )

PLOTANTIC9:

    LDA PLOTM
    CMP #3
    BNE PLOTANTIC9PGETX
    JMP PLOTANTIC9PGET
PLOTANTIC9PGETX:
    CMP #4
    BNE PLOTANTIC9PGETCX
    JMP PLOTANTIC9PGETC
PLOTANTIC9PGETCX:

    LDA PLOTCPE
    CMP $2C4
    BEQ PLOTANTIC9C1

PLOTANTIC9SC1:
@INLINE PALETTEPRESERVE2C4 [PLOTCPE], [#$0]
PLOTANTIC9C1:
    LDA #<PLOTORBIT21
    STA TMPPTR
    LDA #>PLOTORBIT21
    STA TMPPTR+1
    JMP PLOTANTIC9PEN

PLOTANTIC9PEN:

PLOTANTIC9PGET:
PLOTANTIC9PGETC:

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;------------------------
    LDA PLOTX
    AND #$07

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$07
    TAX
    LDA PLOTANDBIT2,x
    STA PLOTAMA

    LDA PLOTX
    LSR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    LSR                        ;lo byte / 8
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT4VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT4VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

; Graphics 5 (ANTIC A or 10)
; This is the four color equivalent of GRAPHICS 4 sized pixels. The pixels are 4 x 4, but two bits are required to address 
; the four color registers. With only four adjacent pixels encoded within a byte, the screen uses twice as much memory, 
; about 1K.
; 80x48, 4 colors

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 10 ) )

PLOTANTIC10:

    LDA PLOTM
    CMP #3
    BNE PLOTANTIC10PGETX
    JMP PLOTANTIC10PGET
PLOTANTIC10PGETX:
    CMP #4
    BNE PLOTANTIC10PGETCX
    JMP PLOTANTIC10PGETC
PLOTANTIC10PGETCX:

    LDA PLOTCPE
    CMP $2C4
    BNE PLOTANTIC10C1X
    JMP PLOTANTIC10C1
PLOTANTIC10C1X:
    CMP $2C5
    BNE PLOTANTIC10C2X
    JMP PLOTANTIC10C2
PLOTANTIC10C2X:
    CMP $2C6
    BNE PLOTANTIC10C3X
    JMP PLOTANTIC10C3
PLOTANTIC10C3X:

    JSR FINDLASTCOLORUSED
    CMP #1
    BEQ PLOTANTIC10SC1
    CMP #2
    BEQ PLOTANTIC10SC2
    CMP #3
    BEQ PLOTANTIC10SC3

    JMP PLOTANTIC10SC1

PLOTANTIC10SC1:
@INLINE PALETTEPRESERVE2C4 [PLOTCPE], [#$1]
PLOTANTIC10C1:
    LDA #<PLOTORBIT41
    STA TMPPTR
    LDA #>PLOTORBIT41
    STA TMPPTR+1
    JMP PLOTANTIC10PEN

PLOTANTIC10SC2:
@INLINE PALETTEPRESERVE2C5 [PLOTCPE], [#$1]
PLOTANTIC10C2:
    LDA #<PLOTORBIT42
    STA TMPPTR
    LDA #>PLOTORBIT42
    STA TMPPTR+1
    JMP PLOTANTIC10PEN

PLOTANTIC10SC3:
@INLINE PALETTEPRESERVE2C6 [PLOTCPE], [#$1]
PLOTANTIC10C3:
    LDA #<PLOTORBIT43
    STA TMPPTR
    LDA #>PLOTORBIT43
    STA TMPPTR+1
    JMP PLOTANTIC10PEN

PLOTANTIC10PEN:
PLOTANTIC10PGET:
PLOTANTIC10PGETC:

    CLC

    ;------------------------
    ;calc X-cell, divide by 4
    ;------------------------
    LDA PLOTX
    AND #$03

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$03
    TAX
    LDA PLOTANDBIT4,x
    STA PLOTAMA

    LDA PLOTX
    LSR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

; Graphics 6 (ANTIC B or 11)
; This two color graphics mode has reasonably fine resolution. The 2 x 2 sized pixels allow 96 rows of 160 pixels to fit 
; on a full screen. Although only a single bit is used to encode the color, screen memory still requires approximately 2K.
; 160x96, 2 colors

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 11 ) )

PLOTANTIC11:

    LDA PLOTM
    CMP #3
    BNE PLOTANTIC11PGETX
    JMP PLOTANTIC11PGET
PLOTANTIC11PGETX:
    CMP #4
    BNE PLOTANTIC11PGETCX
    JMP PLOTANTIC11PGETC
PLOTANTIC11PGETCX:

    LDA PLOTCPE
    CMP _PAPER
    BEQ PLOTANTIC11C0

    LDA PLOTCPE
    CMP $2C8
    BEQ PLOTANTIC11C0

    LDA PLOTCPE
    CMP $2C4
    BEQ PLOTANTIC11C1

PLOTANTIC11SC1:
@INLINE PALETTEPRESERVE2C4 [PLOTCPE], [#$0]
PLOTANTIC11C1:
    LDA #<PLOTORBIT21
    STA TMPPTR
    LDA #>PLOTORBIT21
    STA TMPPTR+1
    JMP PLOTANTIC11PEN

PLOTANTIC11SC0:
@INLINE PALETTEPRESERVE2C8 [PLOTCPE], [#$0]
PLOTANTIC11C0:
    LDA #<PLOTORBIT20
    STA TMPPTR
    LDA #>PLOTORBIT20
    STA TMPPTR+1
    JMP PLOTANTIC11PEN

PLOTANTIC11PEN:

PLOTANTIC11PGET:
PLOTANTIC11PGETC:

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;------------------------
    LDA PLOTX
    AND #$07

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$07
    TAX
    LDA PLOTANDBIT2,x
    STA PLOTAMA

    LDA PLOTX
    LSR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    LSR                        ;lo byte / 8
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

@ENDIF

;;;;;;;;;;;;;;;;;;;

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 13 ) )

PLOTANTIC13:

    LDA PLOTM
    CMP #3
    BNE PLOTANTIC13PGETX
    JMP PLOTANTIC13PGET
PLOTANTIC13PGETX:
    CMP #4
    BNE PLOTANTIC13PGETCX
    JMP PLOTANTIC13PGETC
PLOTANTIC13PGETCX:

    LDA PLOTCPE
    CMP $2C8
    BNE PLOTANTIC13C0X
    JMP PLOTANTIC13C0
PLOTANTIC13C0X:
    LDA PLOTCPE
    CMP $2C4
    BNE PLOTANTIC13C1X
    JMP PLOTANTIC13C1
PLOTANTIC13C1X:
    CMP $2C5
    BNE PLOTANTIC13C2X
    JMP PLOTANTIC13C2
PLOTANTIC13C2X:
    CMP $2C6
    BNE PLOTANTIC13C3X
    JMP PLOTANTIC13C3
PLOTANTIC13C3X:

    JSR FINDLASTCOLORUSED
    CMP #1
    BEQ PLOTANTIC13SC1
    CMP #2
    BEQ PLOTANTIC13SC2
    CMP #3
    BEQ PLOTANTIC13SC3

    JMP PLOTANTIC13SC1

PLOTANTIC13C0:
    LDA #<PLOTORBIT40
    STA TMPPTR
    LDA #>PLOTORBIT40
    STA TMPPTR+1
    JMP PLOTANTIC13PEN

PLOTANTIC13SC1:
@INLINE PALETTEPRESERVE2C4 [PLOTCPE], [#$1]
PLOTANTIC13C1:
    LDA #<PLOTORBIT41
    STA TMPPTR
    LDA #>PLOTORBIT41
    STA TMPPTR+1
    JMP PLOTANTIC13PEN

PLOTANTIC13SC2:
@INLINE PALETTEPRESERVE2C5 [PLOTCPE], [#$1]
PLOTANTIC13C2:
    LDA #<PLOTORBIT42
    STA TMPPTR
    LDA #>PLOTORBIT42
    STA TMPPTR+1
    JMP PLOTANTIC13PEN

PLOTANTIC13SC3:
@INLINE PALETTEPRESERVE2C6 [PLOTCPE], [#$1]
PLOTANTIC13C3:
    LDA #<PLOTORBIT43
    STA TMPPTR
    LDA #>PLOTORBIT43
    STA TMPPTR+1
    JMP PLOTANTIC13PEN

PLOTANTIC13PEN:
PLOTANTIC13PENX:


PLOTANTIC13PGET:
PLOTANTIC13PGETC:

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;------------------------
    LDA PLOTX
    AND #$03

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$03
    TAX
    LDA PLOTANDBIT4,x
    STA PLOTAMA

    LDA PLOTX
    LSR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT6VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT6VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

; Graphics 8 (ANTIC F or 15)
; This mode is definitely the finest resolution available on the Atari. Individual dot-sized pixels can be addressed in 
; this one-color, two-luminance mode. There are 192 rows of 320 dots in the full screen mode. Graphics 8 is memory 
; intensive; it takes 8K bytes (eight pixels/byte) to address an entire screen. The color scheme is quite similar to that 
; in GRAPHICS mode 0. Color register #2 sets the background color. Color register #1 sets the luminance. Changing the color
; in this register has no effect, but, this doesn't mean that you are limited to just one color.
; Fortunately, the pixels are each one half of a color clock. It takes two pixels to span one color clock made up of
; alternating columns of complementary colors. If the background is set to black, these columns consist of blue and 
; green stripes. If only the odd-columned pixels are plotted, you get blue pixels. If only the odd-columned pixels 
; are plotted, you get green pixels. And if pairs of adjacent pixels are plotted, you get white. So by cleverly 
; staggering the pixel patterns, you can achieve three colors. This method is called artifacting. This all depends
; on background color and luminance.
; 320x192, 3 colors

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 15 ) )

PLOTANTIC15:

    LDA PLOTM
    CMP #3
    BNE PLOTANTIC15PGETX
    JMP PLOTANTIC15PGET
PLOTANTIC15PGETX:
    CMP #4
    BNE PLOTANTIC15PGETCX
    JMP PLOTANTIC15PGETC
PLOTANTIC15PGETCX:

    LDA #$0
    CMP $2C5
    BEQ PLOTANTIC15B1
@INLINE PALETTEPRESERVE2C5 [#$0], [#$0]

PLOTANTIC15B1:
    LDA #$f
    CMP $2C6
    BEQ PLOTANTIC15B2
@INLINE PALETTEPRESERVE2C6 [#$f], [#$0]

PLOTANTIC15B2:
    LDA #<PLOTORBIT21
    STA TMPPTR
    LDA #>PLOTORBIT21
    STA TMPPTR+1

PLOTANTIC15PEN:

PLOTANTIC15PGET:
PLOTANTIC15PGETC:

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;------------------------
    LDA PLOTX
    AND #$07

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$07
    TAX
    LDA PLOTANDBIT2,x
    STA PLOTAMA

    LDA PLOTX
    ROR PLOTX+1                ;rotate the high byte into carry flag
    ROR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    LSR                        ;lo byte / 8
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT6XVBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT6XVBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

; Antic C (Graphics 14-XL computers only)
; This two-color, bit-mapped mode the eight bits correspond directly to the pixels on the screen. If a pixel is lit 
; it receives its color information from color register #0, otherwise the color is set to the background color 
; register #4. Each pixel is one scan line high and one color clock wide. This mode's advantages are that it 
; only uses 4K of screen memory and doesn't have artifacting problems.
; 320x192, 2 colors

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 12 ) )

PLOTANTIC12:

    LDA PLOTM
    CMP #3
    BNE PLOTANTIC12PGETX
    JMP PLOTANTIC12PGET
PLOTANTIC12PGETX:
    CMP #4
    BNE PLOTANTIC12PGETCX
    JMP PLOTANTIC12PGETC
PLOTANTIC12PGETCX:

    LDA PLOTCPE
    CMP $2C5
    BEQ PLOTANTIC12B1
@INLINE PALETTEPRESERVE2C5 [PLOTCPE], [#$0]

PLOTANTIC12B1:
    LDA #<PLOTORBIT21
    STA TMPPTR
    LDA #>PLOTORBIT21
    STA TMPPTR+1

PLOTANTIC12PEN:

PLOTANTIC12PGET:
PLOTANTIC12PGETC:

    CLC

    ;------------------------
    ;calc X-cell, divide by 8
    ;------------------------
    LDA PLOTX
    AND #$07

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$07
    TAX
    LDA PLOTANDBIT2,x
    STA PLOTAMA

    LDA PLOTX
    ROR PLOTX+1                ;rotate the high byte into carry flag
    ROR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    LSR                        ;lo byte / 8
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

; Antic E (Graphics 15-XL computers only)
; This four-color, bit-mapped mode is sometimes known as BASIC 7 1/2. Its resolution is 160 x 192 or twice that of 
; GRAPHIC 7. Each byte is divided into four pairs of bits. Like the character data in ANTIC 4, the bit pairs point to a
; particular color register. The screen data, however, is not character data but individual bytes. The user has a lot
; more control, but this mode uses a lot more memory, approximately
; 160x192, 4 colors

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 14 ) )

PLOTANTIC14:

    LDA PLOTM
    CMP #3
    BNE PLOTANTIC14PGETX
    JMP PLOTANTIC14PGET
PLOTANTIC14PGETX:
    CMP #4
    BNE PLOTANTIC14PGETCX
    JMP PLOTANTIC14PGETC
PLOTANTIC14PGETCX:

    LDA PLOTCPE
    CMP $2C5
    BNE PLOTANTIC14C1X
    JMP PLOTANTIC14C1
PLOTANTIC14C1X:
    CMP $2C6
    BNE PLOTANTIC14C2X
    JMP PLOTANTIC14C2
PLOTANTIC14C2X:
    CMP $2C7
    BNE PLOTANTIC14C3X
    JMP PLOTANTIC14C3
PLOTANTIC14C3X:

    JSR FINDLASTCOLORUSED
    CMP #1
    BEQ PLOTANTIC14SC1
    CMP #2
    BEQ PLOTANTIC14SC2
    CMP #3
    BEQ PLOTANTIC14SC3

    JMP PLOTANTIC14SC1

PLOTANTIC14SC1:
@INLINE PALETTEPRESERVE2C5 [PLOTCPE], [#$1]
PLOTANTIC14C1:
    LDA #<PLOTORBIT41
    STA TMPPTR
    LDA #>PLOTORBIT41
    STA TMPPTR+1
    JMP PLOTANTIC14PEN

PLOTANTIC14SC2:
@INLINE PALETTEPRESERVE2C6 [PLOTCPE], [#$1]
PLOTANTIC14C2:
    LDA #<PLOTORBIT42
    STA TMPPTR
    LDA #>PLOTORBIT42
    STA TMPPTR+1
    JMP PLOTANTIC14PEN

PLOTANTIC14SC3:
@INLINE PALETTEPRESERVE2C7 [PLOTCPE], [#$1]
PLOTANTIC14C3:
    LDA #<PLOTORBIT43
    STA TMPPTR
    LDA #>PLOTORBIT43
    STA TMPPTR+1
    JMP PLOTANTIC14PEN

PLOTANTIC14PEN:
PLOTANTIC14PENX:

PLOTANTIC14PGET:
PLOTANTIC14PGETC:

    CLC

    ;------------------------
    ;calc X-cell, divide by 4
    ;------------------------
    LDA PLOTX
    AND #$03

    CLC

    ADC TMPPTR
    STA TMPPTR
    LDA #0
    ADC TMPPTR+1
    STA TMPPTR+1
    LDY #0
    LDA (TMPPTR),Y
    STA PLOTOMA

    LDA PLOTX
    AND #$03
    TAX
    LDA PLOTANDBIT4,x
    STA PLOTAMA

    LDA PLOTX
    LSR                        ;lo byte / 2
    LSR                        ;lo byte / 4
    TAX                        ;tbl_8,x index

    ;-------------------------
    ;calc Y-cell
    ;-------------------------
    LDA PLOTY
    TAY                         ;tbl_8,y index

    ;----------------------------------
    ;add x & y to calc cell point is in
    ;----------------------------------
    CLC

    TXA
    ADC PLOT5VBASELO,Y          ;table of $9C40 row base addresses
    STA PLOTDEST               ;= cell address

    LDA #0
    ADC PLOT5VBASEHI,Y          ;do the high byte
    STA PLOTDEST+1
    
    JMP PLOTGENERIC

@ENDIF

PLOTGENERIC:

    ;---------------------------------
    ;get in-cell offset to point (0-3)
    ;---------------------------------
    ; LDA PLOTX                  ;get PLOTX offset from cell topleft
    ; AND #%00000011             ;2 lowest bits = (0-3)
    ; TAX                        ;put into index register

    ; LDA PLOTY                  ;get PLOTY offset from cell topleft
    ; AND #%00000111             ;3 lowest bits = (0-7)
    ; TAY                        ;put into index register

    ;----------------------------------------------
    ;depending on PLOTM, routine draws or erases
    ;----------------------------------------------

    LDA PLOTM                  ;(0 = erase, 1 = set, 2 = get pixel, 3 = get color)
    CMP #0
    BEQ PLOTE4                  ;if = 0 then branch to clear the point
    CMP #1
    BEQ PLOTD4                  ;if = 1 then branch to draw the point
    CMP #2
    BEQ PLOTG4                  ;if = 2 then branch to get the point (0...3)
    CMP #3
    BNE PLOTC4X                  ;if = 3 then branch to get the color index (0...15)
    JMP PLOTC4
PLOTC4X:
    JMP PLOTP

PLOTD4:
    ;---------
    ;set point
    ;---------
    LDY #0
    LDA (PLOTDEST),y           ;get row with point in it
    AND PLOTAMA
    ORA PLOTOMA
    STA (PLOTDEST),y           ;write back to $A000
    JMP PLOTP                  ;skip the erase-point section

    ;-----------
    ;erase point
    ;-----------
PLOTE4:                          ;handled same way as setting a point
    LDY #0
    LDA (PLOTDEST),y            ;just with opposite bit-mask
    AND PLOTAMA
    STA (PLOTDEST),y            ;write back to $A000

    JMP PLOTP

PLOTG4:

    LDA PLOTAMA
    EOR #$FF
    STA PLOTAMA

@IF !vestigialConfig.screenModeUnique 

    LDA CURRENTMODE
    CMP #8
    BEQ PLOTG4ANTIC8
    CMP #9
    BNE PLOTG4ANTIC9X
    JMP PLOTG4ANTIC9
PLOTG4ANTIC9X:
    CMP #10
    BNE PLOTG4ANTIC10X
    JMP PLOTG4ANTIC10
PLOTG4ANTIC10X:
    CMP #11
    BNE PLOTG4ANTIC11X
    JMP PLOTG4ANTIC11
PLOTG4ANTIC11X:
    CMP #13
    BNE PLOTG4ANTIC13X
    JMP PLOTG4ANTIC13
PLOTG4ANTIC13X:
    CMP #15
    BNE PLOTG4ANTIC15X
    JMP PLOTG4ANTIC15
PLOTG4ANTIC15X:
    CMP #12
    BNE PLOTG4ANTIC12X
    JMP PLOTG4ANTIC12
PLOTG4ANTIC12X:
    CMP #14
    BNE PLOTG4ANTIC14X
    JMP PLOTG4ANTIC14
PLOTG4ANTIC14X:
    JMP PLOTP

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 8 ) ) || ( ( currentMode == 10 ) ) || ( ( currentMode == 13 ) ) || ( ( currentMode == 14 ) )

PLOTG4ANTIC8:
PLOTG4ANTIC10:
PLOTG4ANTIC13:
PLOTG4ANTIC14:
    LDA PLOTX
    AND #$03
    STA PLOTM
    SEC
    LDA #3
    SBC PLOTM
    TAX 
    LDY #0
    LDA (PLOTDEST),y            
    AND PLOTAMA
    CPX #0
    BEQ PLOTG4ANTIC8G0
PLOTG4ANTIC8G1:
    LSR A
    LSR A
    DEX
    BNE PLOTG4ANTIC8G1
PLOTG4ANTIC8G0:
    STA PLOTM
    JMP PLOTP   

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 9 ) ) || ( ( currentMode == 11 ) ) || ( ( currentMode == 15 ) ) || ( ( currentMode == 12 ) )

PLOTG4ANTIC9:
PLOTG4ANTIC11:
PLOTG4ANTIC15:
PLOTG4ANTIC12:
    LDA PLOTX
    AND #$07
    STA PLOTM
    SEC
    LDA #7
    SBC PLOTM
    TAX 
    LDY #0
    LDA (PLOTDEST),y            
    AND PLOTAMA
    CPX #0
    BEQ PLOTG4ANTIC9G0
PLOTG4ANTIC9G1:
    LSR A
    DEX
    BNE PLOTG4ANTIC9G1
PLOTG4ANTIC9G0:
    STA PLOTM
    JMP PLOTP            

@ENDIF

;;;;;;;;;;;;;;;;;;;;;;

PLOTC4:

@IF !vestigialConfig.screenModeUnique 

    LDA CURRENTMODE
    CMP #8
    BEQ PLOTC4ANTIC8
    CMP #9
    BNE PLOTC4ANTIC9X
    JMP PLOTC4ANTIC9
PLOTC4ANTIC9X:
    CMP #10
    BNE PLOTC4ANTIC10X
    JMP PLOTC4ANTIC10
PLOTC4ANTIC10X:
    CMP #11
    BNE PLOTC4ANTIC11X
    JMP PLOTC4ANTIC11
PLOTC4ANTIC11X:
    CMP #13
    BNE PLOTC4ANTIC13X
    JMP PLOTC4ANTIC13
PLOTC4ANTIC13X:
    CMP #15
    BNE PLOTC4ANTIC15X
    JMP PLOTC4ANTIC15
PLOTC4ANTIC15X:
    CMP #12
    BNE PLOTC4ANTIC12X
    JMP PLOTC4ANTIC12
PLOTC4ANTIC12X:
    CMP #14
    BNE PLOTC4ANTIC14X
    JMP PLOTC4ANTIC14
PLOTC4ANTIC14X:
    JMP PLOTP

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 8 )) || ( ( currentMode == 10 )) || ( ( currentMode == 13 ))

PLOTC4ANTIC8:
PLOTC4ANTIC10:
PLOTC4ANTIC13:
    JSR PLOTG4
    LDA $2C8
    LDX PLOTM
    BEQ PLOTC4ANTIC8DONE
    ; 1 
    LDA $2C4
    DEX
    BEQ PLOTC4ANTIC8DONE
    ; 2
    LDA $2C5
    DEX
    BEQ PLOTC4ANTIC8DONE
    ; 3
    LDA $2C6
PLOTC4ANTIC8DONE:
    STA PLOTM
    JMP PLOTP            

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 9 )) || ( ( currentMode == 11 ))

PLOTC4ANTIC9:
PLOTC4ANTIC11:
    JSR PLOTG4
    LDA $2C8
    LDX PLOTM
    BEQ PLOTC4ANTIC9DONE
    LDA $2C4
PLOTC4ANTIC9DONE:
    STA PLOTM
    JMP PLOTP            

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 15 ))

PLOTC4ANTIC15:
    JSR PLOTG4
    LDA $2C8
    LDX PLOTM
    BEQ PLOTC4ANTIC15DONE
    LDA $2C6
PLOTC4ANTIC15DONE:
    STA PLOTM
    JMP PLOTP                 

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 12 ))

PLOTC4ANTIC12:
    JSR PLOTG4
    LDA $2C8
    LDX PLOTM
    BEQ PPLOTG4ANTIC12DONE
    LDA $2C5
PPLOTG4ANTIC12DONE:
    STA PLOTM
    JMP PLOTP         

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 14 ))

PLOTC4ANTIC14:
    JSR PLOTG4
    LDA $2C8
    LDX PLOTM
    BEQ PLOTC4ANTIC14DONE
    ; 1 
    LDA $2C5
    DEX
    BEQ PLOTC4ANTIC14DONE
    ; 2
    LDA $2C6
    DEX
    BEQ PLOTC4ANTIC14DONE
    ; 3
    LDA $2C7
PLOTC4ANTIC14DONE:
    STA PLOTM
    JMP PLOTP              

@ENDIF

PLOTP:
    RTS

;----------------------------------------------------------------

PLOTORBIT:
    .byte %10000000
    .byte %01000000
    .byte %00100000
    .byte %00010000
    .byte %00001000
    .byte %00000100
    .byte %00000010
    .byte %00000001

PLOTANDBIT:
    .byte %01111111
    .byte %10111111
    .byte %11011111
    .byte %11101111
    .byte %11110111
    .byte %11111011
    .byte %11111101
    .byte %11111110

PLOTANDBIT4:
    .byte %00111111
    .byte %11001111
    .byte %11110011
    .byte %11111100

PLOTORBIT40:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

PLOTORBIT41:
    .byte %01000000
    .byte %00010000
    .byte %00000100
    .byte %00000001

PLOTORBIT42:
    .byte %10000000
    .byte %00100000
    .byte %00001000
    .byte %00000010

PLOTORBIT43:
    .byte %11000000
    .byte %00110000
    .byte %00001100
    .byte %00000011

PLOTORBIT20:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

PLOTORBIT21:
    .byte %10000000
    .byte %01000000
    .byte %00100000
    .byte %00010000
    .byte %00001000
    .byte %00000100
    .byte %00000010
    .byte %00000001

PLOTANDBIT2:
    .byte %01111111
    .byte %10111111
    .byte %11011111
    .byte %11101111
    .byte %11110111
    .byte %11111011
    .byte %11111101
    .byte %11111110
