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
;*                      INTERNAL VARIABLES FOR GTIA HARDWARE                   *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

XGR:    .word 0
YGR:    .word 0
LINE:   .byte $ff, $ff

CLIPX1:    .word 0
CLIPY1:    .word 0
CLIPX2:    .word 319
CLIPY2:    .word 199
ORIGINX:   .word 0
ORIGINY:   .word 0
RESOLUTIONX: .word 0
RESOLUTIONY: .word 0

CURRENTWIDTH:      .word 40
CURRENTHEIGHT:      .word 24
CURRENTTILESWIDTH:      .byte 40
CURRENTTILESHEIGHT:      .byte 24
CURRENTTILES:      .byte 255
TEXTBLOCKREMAIN:      .byte 152
TEXTBLOCKREMAINPW:      .byte 192
CURRENTSL:          .byte 0

FONTWIDTH:          .byte 8
FONTHEIGHT:         .byte 8
IMAGEX = $F0
IMAGEY = $F2
IMAGEW = $F4 ; $F5
IMAGEH = $F6
IMAGEH2 = $F8
IMAGET = $F9
IMAGEF = $FA
IMAGEW2 = $FB

XSCROLLPOS:         .byte 0
YSCROLLPOS:         .byte 0
XSCROLL:            .byte 0
YSCROLL:            .byte 0

YSCROLLOFFSET:  .byte 4, 3, 2, 1, 0, 7, 6, 5
XSCROLLOFFSET:  .byte 0, 1, 2, 3, 4, 5, 6, 7

PLOTDEST = $8c ; $8d
PLOTCDEST= $8d ; $8e
PLOTLDEST= $8f ; $90

BLITTMPPTR = $EE ; $EF
BLITTMPPTR2 = $EC ; $ED
BLITS0 = $EB
BLITS1 = $EA
BLITS2 = $E9
BLITR0 = $E8
BLITR1 = $E7
BLITR2 = $E6
BLITR3 = $E5

PORT = $E5

; bit   index      address
; 0     1          $02c4
; 1     2          $02c5
; 2     4          $02c6
; 3     8          $02c7
; 4     16         $02c8
PALETTEPRESERVEUSED:
    .byte $00

;       (x1,y1)  w (chars) / wb (bytes)
;       +----------------+
;  sa ->|*               | h (chars) / hb (bytes)
;       |                |
;       +----------------+ (x2, y2)
;
CONSOLEID:     .byte $ff       ; <-- actual
;
; Text mode
;

@IF lmarginAtariBasicEnabled
CONSOLEX1 = 82                  ; <-- input from program (chars)
@ELSE
CONSOLEX1:     .byte 0          ; <-- input from program (chars)
@ENDIF

CONSOLEY1:     .byte 0         ; <-- input from program (chars)
CONSOLEX2:     .byte 39        ; <-- recalculated (chars)
CONSOLEY2:     .byte 24        ; <-- recalculated (chars)
CONSOLEW:      .byte 40        ; <-- calculated (chars)
CONSOLEH:      .byte 25        ; <-- calculated (chars)
;
; Graphic mode
;
CONSOLESA:     .word 0         ; <-- calculated (address)
CONSOLEWB:     .byte 40        ; <-- calculated (bytes)
CONSOLEHB:     .byte 25        ; <-- calculated (bytes)
;
CONSOLES:      .res 4*8        ; <-- storage for virtual consoles
CONSOLES2:     .res 4*2        ; <-- storage for memorize / remember


CALCPOST:

    TXA
    PHA

    LDA TEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA TEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1
    LDX MATHPTR0
    BEQ CALCPOSTSKIP
CALCPOSTLOOP1:
    CLC
    LDA CURRENTTILESWIDTH
    ADC COPYOFTEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA #0
    ADC COPYOFTEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1
    DEX
    BNE CALCPOSTLOOP1

CALCPOSTSKIP:
    CLC
    LDA MATHPTR1
    ADC COPYOFTEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA #0
    ADC COPYOFTEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1

    PLA
    TAX

    RTS

