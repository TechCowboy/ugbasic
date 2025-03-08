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
;*                       INTERNAL VARIABLES FOR GIME HARDWARE                  *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

PLOTDEST equ $0b ; $29
PLOTCDEST equ $0d ; $27
PLOTC2DEST equ $0f ; $25

XGR    fdb 0
YGR    fdb 0
LINE   fcb $ff, $ff

ORIGINX    fdb 0
ORIGINY    fdb 0
RESOLUTIONX    fdb 0
RESOLUTIONY    fdb 0

CLIPX1    fdb 0
CLIPY1    fdb 0
CLIPX2    fdb 319
CLIPY2    fdb 199

LASTCOLOR fcb 0
CURRENTWIDTH      fdb 320
CURRENTHEIGHT      fdb 200
CURRENTTILESWIDTH      fcb 40
CURRENTTILESHEIGHT      fcb 25
CURRENTTILES            fcb 128
CURRENTFRAMESIZE   fdb 40*25
CURRENTSL          fcb 40
FONTWIDTH       fcb 8
FONTHEIGHT      fcb 8

IMAGEX EQU $41 ; $42
IMAGEY EQU $43 ; $44
IMAGEW EQU $45
IMAGEH EQU $47 ; $48
IMAGEH2 EQU $49 ; $50
IMAGET EQU $51
IMAGEF EQU $52
IMAGEW2 EQU $54 ; $55

BLITTMPPTR fdb $0
BLITTMPPTR2 fdb $0
BLITS0 fcb $0
BLITS1 fcb $0
BLITS2 fcb $0
BLITR0 fcb $0
BLITR1 fcb $0
BLITR2 fcb $0
BLITR3 fcb $0

PLOTX   EQU $41 ; $42
PLOTY   EQU $43
PLOTC   EQU $45

; PALETTEPAPER               fcb $12, $24, $0b, $07, $3f, $1f, $09, $26
; PALETTEPEN                 fcb $00, $12, $00, $3f, $00, $12, $00, $26
PALETTEPAPER               fcb $00, $00, $00, $00, $00, $00, $00, $00
PALETTEPEN                 fcb $00, $00, $00, $00, $00, $00, $00, $00

PALETTEPENUNUSED           fcb 0
PALETTEPAPERUNUSED         fcb 0
PALETTELIMIT               fcb 0
GIMEVIDMSHADOW             fcb 0
GIMEMMUSTART               fcb 3
GIMEMMUCOUNT               fcb 1
GIMEINIT1BACKUP            fcb 0
GIMEINIT1SHADOW            fcb 0

GIMESCREENCURRENT          fcb $8

;       (x1,y1)  w (chars) / wb (bytes)
;       +----------------+
;  sa ->|*               | h (chars) / hb (bytes)
;       |                |
;       +----------------+ (x2, y2)
;
CONSOLEID     fcb $ff       ; <-- actual
;
; Text mode
;
CONSOLEX1     fcb 0         ; <-- input from program (chars)
CONSOLEY1     fcb 0         ; <-- input from program (chars)
CONSOLEX2     fcb 31        ; <-- recalculated (chars)
CONSOLEY2     fcb 15        ; <-- recalculated (chars)
CONSOLEW      fcb 32        ; <-- calculated (chars)
CONSOLEH      fcb 16        ; <-- calculated (chars)
;
; Graphic mode
;
CONSOLESA     fdb 0         ; <-- calculated (address)
CONSOLEWB     fcb 32        ; <-- calculated (bytes)
CONSOLEHB     fcb 16        ; <-- calculated (bytes)
;
CONSOLES      rzb 4*8        ; <-- storage for virtual consoles
CONSOLES2     rzb 4*2        ; <-- storage for memorize / remember on console

CONSOLECALCULATE
    LDA <YCURSYS
    LDB #8
    MUL
    STD <PLOTY
    LDA <XCURSYS
    LDB #8
    MUL
    STD <PLOTX
    JSR GIMECALCPOSBM
    STX CONSOLESA

    LDA CONSOLEW
    STA CONSOLEWB

    ASL CONSOLEWB
CONSOLECALCULATESKIPD
    LDA CONSOLEH
    STA CONSOLEHB
    ASL CONSOLEHB
    ASL CONSOLEHB
    ASL CONSOLEHB

    RTS    
