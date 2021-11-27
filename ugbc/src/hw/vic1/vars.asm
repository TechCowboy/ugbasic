; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021 Marco Spedaletti (asimov@mclink.it)
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
;*                      INTERNAL VARIABLES FOR VIC-I HARDWARE                 *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PLOTDEST = $28 ; $29
PLOTCDEST= $26 ; $27
PLOTC2DEST= $24 ; $25

XGR:    .word 0
YGR:    .word 0
LINE:   .byte $ff, $ff

CLIPX1:    .word 0
CLIPY1:    .word 0
CLIPX2:    .word 319
CLIPY2:    .word 199
LASTCOLOR: .byte 0
CURRENTWIDTH:      .word 176
CURRENTHEIGHT:      .word 184
CURRENTTILESWIDTH:      .byte 22
CURRENTTILESHEIGHT:      .byte 23
CURRENTSL:          .byte 0
TEXTWW:             .byte 3
FONTWIDTH:          .byte 8
FONTHEIGHT:         .byte 8

IMAGEX = $34
IMAGEY = $36
IMAGEW = $32
IMAGEH = $33
IMAGEH2 = $31

; ; ------------------------------------------------------------------------------
; ; BITMAP MODE (MODE #1)
; ; ------------------------------------------------------------------------------

; PLOTVBASELO:
;     .byte <($1800+(0*128)),<($1800+(1*128)),<($1800+(2*128)),<($1800+(3*128))
;     .byte <($1800+(4*128)),<($1800+(5*128)),<($1800+(6*128)),<($1800+(7*128))
;     .byte <($1800+(8*128)),<($1800+(9*128)),<($1800+(10*128)),<($1800+(11*128))
;     .byte <($1800+(12*128)),<($1800+(13*128)),<($1800+(14*128)),<($1800+(15*128))
    
; PLOTVBASEHI:
;     .byte >($1800+(0*128)),>($1800+(1*128)),>($1800+(2*128)),>($1800+(3*128))
;     .byte >($1800+(4*128)),>($1800+(5*128)),>($1800+(6*128)),>($1800+(7*128))
;     .byte >($1800+(8*128)),>($1800+(9*128)),>($1800+(10*128)),>($1800+(11*128))
;     .byte >($1800+(12*128)),>($1800+(13*128)),>($1800+(14*128)),>($1800+(15*128))

; PLOT8LO:
;     .byte <(0*8),<(1*8),<(2*8),<(3*8),<(4*8),<(5*8),<(6*8),<(7*8),<(8*8),<(9*8)
;     .byte <(10*8),<(11*8),<(12*8),<(13*8),<(14*8),<(15*8)
    
; PLOT8HI:
;     .byte >(0*8),>(1*8),>(2*8),>(3*8),>(4*8),>(5*8),>(6*8),>(7*8),>(8*8),>(9*8)
;     .byte >(10*8),>(11*8),>(12*8),>(13*8),>(14*8),>(15*8)

; ; ------------------------------------------------------------------------------
; ; BITMAP MODE (MODE #2)
; ; ------------------------------------------------------------------------------

; PLOTV2BASELO:
;     .byte <($1000+(0*176)),<($1000+(1*176)),<($1000+(2*176)),<($1000+(3*176))
;     .byte <($1000+(4*176)),<($1000+(5*176)),<($1000+(6*176)),<($1000+(7*176))
;     .byte <($1000+(8*176)),<($1000+(9*176)),<($1000+(10*176)),<($1000+(11*176))
;     .byte <($1800+(0*176)),<($1800+(1*176)),<($1800+(2*176)),<($1800+(3*176))
;     .byte <($1800+(4*176)),<($1800+(5*176)),<($1800+(6*176)),<($1800+(7*176))
;     .byte <($1800+(8*176)),<($1800+(9*176)),<($1800+(10*176)),<($1800+(11*176))
    
; PLOTV2BASEHI:
;     .byte >($1000+(0*176)),>($1000+(1*176)),>($1000+(2*176)),>($1000+(3*176))
;     .byte >($1000+(4*176)),>($1000+(5*176)),>($1000+(6*176)),>($1000+(7*176))
;     .byte >($1000+(8*176)),>($1000+(9*176)),>($1000+(10*176)),>($1000+(11*176))
;     .byte >($1800+(0*176)),>($1800+(1*176)),>($1800+(2*176)),>($1800+(3*176))
;     .byte >($1800+(4*176)),>($1800+(5*176)),>($1800+(6*176)),>($1800+(7*176))
;     .byte >($1800+(8*176)),>($1800+(9*176)),>($1800+(10*176)),>($1800+(11*176))

; PLOT82LO:
;     .byte <(0*8),<(1*8),<(2*8),<(3*8),<(4*8),<(5*8),<(6*8),<(7*8),<(8*8),<(9*8)
;     .byte <(10*8),<(11*8),<(12*8),<(13*8),<(14*8),<(15*8),<(16*8),<(17*8),<(18*8)
;     .byte <(19*8),<(20*8),<(21*8)
    
; PLOT82HI:
;     .byte >(0*8),>(1*8),>(2*8),>(3*8),>(4*8),>(5*8),>(6*8),>(7*8),>(8*8),>(9*8)
;     .byte >(10*8),>(11*8),>(12*8),>(13*8),>(14*8),>(15*8),>(16*8),>(17*8),>(18*8)
;     .byte >(19*8),>(20*8),>(21*8)

; PLOTCVBASELO:
;     .byte <($9400+(0*16)),<($9400+(1*16)),<($9400+(2*16)),<($9400+(3*16))
;     .byte <($9400+(4*16)),<($9400+(5*16)),<($9400+(6*16)),<($9400+(7*16))
;     .byte <($9400+(8*16)),<($9400+(9*16)),<($9400+(10*16)),<($9400+(11*16))
;     .byte <($9400+(12*16)),<($9400+(13*16)),<($9400+(14*16)),<($9400+(15*16))

; PLOTCVBASEHI:
;     .byte >($9400+(0*16)),>($9400+(1*16)),>($9400+(2*16)),>($9400+(3*16))
;     .byte >($9400+(4*16)),>($9400+(5*16)),>($9400+(6*16)),>($9400+(7*16))
;     .byte >($9400+(8*16)),>($9400+(9*16)),>($9400+(10*16)),>($9400+(11*16))
;     .byte >($9400+(12*16)),>($9400+(13*16)),>($9400+(14*16)),>($9400+(15*16))

PLOTCVBASELO:
    .byte <($1000+(0*22)),<($1000+(1*22)),<($1000+(2*22)),<($1000+(3*22))
    .byte <($1000+(4*22)),<($1000+(5*22)),<($1000+(6*22)),<($1000+(7*22))
    .byte <($1000+(8*22)),<($1000+(9*22)),<($1000+(10*22)),<($1000+(11*22))
    .byte <($1000+(12*22)),<($1000+(13*22)),<($1000+(14*22)),<($1000+(15*22))
    .byte <($1000+(16*22)),<($1000+(17*22)),<($1000+(18*22)),<($1000+(19*22))
    .byte <($1000+(20*22)),<($1000+(21*22))

PLOTCVBASEHI:
    .byte >($1000+(0*22)),>($1000+(1*22)),>($1000+(2*22)),>($1000+(3*22))
    .byte >($1000+(4*22)),>($1000+(5*22)),>($1000+(6*22)),>($1000+(7*22))
    .byte >($1000+(8*22)),>($1000+(9*22)),>($1000+(10*22)),>($1000+(11*22))
    .byte >($1000+(12*22)),>($1000+(13*22)),>($1000+(14*22)),>($1000+(15*22))
    .byte >($1000+(16*22)),>($1000+(17*22)),>($1000+(18*22)),>($1000+(19*22))
    .byte >($1000+(20*22)),>($1000+(21*22))

PLOTC2VBASELO:
    .byte <($9400+(0*22)),<($9400+(1*22)),<($9400+(2*22)),<($9400+(3*22))
    .byte <($9400+(4*22)),<($9400+(5*22)),<($9400+(6*22)),<($9400+(7*22))
    .byte <($9400+(8*22)),<($9400+(9*22)),<($9400+(10*22)),<($9400+(11*22))
    .byte <($9400+(12*22)),<($9400+(13*22)),<($9400+(14*22)),<($9400+(15*22))
    .byte <($9400+(16*22)),<($9400+(17*22)),<($9400+(18*22)),<($9400+(19*22))
    .byte <($9400+(20*22)),<($9400+(21*22))

PLOTC2VBASEHI:
    .byte >($9400+(0*22)),>($9400+(1*22)),>($9400+(2*22)),>($9400+(3*22))
    .byte >($9400+(4*22)),>($9400+(5*22)),>($9400+(6*22)),>($9400+(7*22))
    .byte >($9400+(8*22)),>($9400+(9*22)),>($9400+(10*22)),>($9400+(11*22))
    .byte >($9400+(12*22)),>($9400+(13*22)),>($9400+(14*22)),>($9400+(15*22))
    .byte >($9400+(16*22)),>($9400+(17*22)),>($9400+(18*22)),>($9400+(19*22))
    .byte >($9400+(20*22)),>($9400+(21*22))
