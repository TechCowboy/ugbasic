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
;*                      TEXT AT GIVEN POSITION ON TED                          *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

.localchar      '?'

TEXTATTMREADCHAR:
    TYA
    PHA
    LDY #0
    LDA (TEXTPTR), Y
    STA SCREENCODE
    INC TEXTPTR
    BNE TEXTATTMREADCHAR1
    INC TEXTPTR+1
TEXTATTMREADCHAR1:
    DEc TEXTSIZE
    PLA
    TAY
    RTS

TEXTATTILEMODE:

@IF !vestigialConfig.screenModeUnique || ( ( currentMode == 0 ) || ( currentMode == 1 ) || ( currentMode == 4 ) )

    LDA TEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA TEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1
    LDA #0
    STA TABSTODRAW
    LDA COLORMAPADDRESS
    STA COPYOFCOLORMAPADDRESS
    LDA COLORMAPADDRESS+1
    STA COPYOFCOLORMAPADDRESS+1
    
@IF printSafe
@IF deployed.timer
    LDA TIMERRUNNING
    BNE ?skipsafe
@ENDIF
    SEI
@IF deployed.timer
?skipsafe:
@ENDIF
@ENDIF

    LDX YCURSYS
    BEQ TEXTATSKIP
TEXTATLOOP1:
    CLC
    LDA #40
    ADC COPYOFTEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA #0
    ADC COPYOFTEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1
    DEX
    BNE TEXTATLOOP1

    LDX YCURSYS
TEXTATLOOPC1:
    CLC
    LDA #40
    ADC COPYOFCOLORMAPADDRESS
    STA COPYOFCOLORMAPADDRESS
    LDA #0
    ADC COPYOFCOLORMAPADDRESS+1
    STA COPYOFCOLORMAPADDRESS+1
    DEX
    BNE TEXTATLOOPC1

TEXTATSKIP:
    CLC
    LDA XCURSYS
    ADC COPYOFTEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA #0
    ADC COPYOFTEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1

    CLC
    LDA XCURSYS
    ADC COPYOFCOLORMAPADDRESS
    STA COPYOFCOLORMAPADDRESS
    LDA #0
    ADC COPYOFCOLORMAPADDRESS+1
    STA COPYOFCOLORMAPADDRESS+1

    LDX TEXTSIZE
    LDY #$0
TEXTATLOOP2:

    LDA TABSTODRAW
    BEQ TEXTATNSKIPTAB
    JMP TEXTATSKIPTAB

TEXTATNSKIPTAB:
    JSR TEXTATTMREADCHAR
    LDA SCREENCODE

    CMP #31
    BCS TEXTATXCC
    JMP TEXTATCC

TEXTATXCC:
    JSR TEXTATDECODE
    JMP TEXTATSP0

TEXTATTAB:
    LDA XCURSYS
TEXTATTAB2:
    CMP TABCOUNT
    BCC TEXTATTAB3
    SEC
    SBC TABCOUNT
    JMP TEXTATTAB2
TEXTATTAB3:
    STA TMPPTR
    LDA TABCOUNT
    SEC
    SBC TMPPTR
    STA TABSTODRAW
    JMP TEXTATNEXT

TEXTATCC:
    CMP #13
    BEQ TEXTATLF
    CMP #10
    BEQ TEXTATLF
    CMP #09
    BEQ TEXTATTAB
    CMP #01
    BEQ TEXTATPEN
    CMP #02
    BEQ TEXTATPAPER
    CMP #03
    BEQ TEXTATCMOVEPREPARE
    CMP #04
    BEQ TEXTATXAT
    CMP #05
    BEQ TEXTATCLS
    JMP TEXTATNEXT

TEXTATCLS:
    JSR CLST
    JMP TEXTATNEXT

TEXTATXAT:
    JMP TEXTATAT

TEXTATLF:
    JMP TEXTATNEXT2

TEXTATPEN:
    JSR TEXTATTMREADCHAR
    LDA SCREENCODE
    CMP #$FF
    BNE TEXTATPEN2
    LDA #$0
TEXTATPEN2:       
    STA _PEN
    JMP TEXTATNEXT

TEXTATPAPER:
    JSR TEXTATTMREADCHAR
    STA _PAPER
    JMP TEXTATNEXT

TEXTATCMOVEPREPARE:
    JSR TEXTATTMREADCHAR
    LDA SCREENCODE
    STA CLINEX
    JSR TEXTATTMREADCHAR    
    LDA SCREENCODE
    STA CLINEY

TEXTATCMOVE:
    CLC
    LDA CLINEX
    ADC XCURSYS
    CMP #$80
    BCS TEXTATCMOVESKIPX
    CMP #40
    BCS TEXTATCMOVESKIPX
    STA XCURSYS
    LDA CLINEX

    CMP #$80
    BCC TEXTATCMOVEADDPX

TEXTATCMOVESUBPX:
    EOR #$FF
    CLC
    ADC #$1
    STA CLINEX
    SEC
    LDA COPYOFTEXTADDRESS
    SBC CLINEX
    STA COPYOFTEXTADDRESS
    LDA COPYOFTEXTADDRESS+1
    SBC #0
    STA COPYOFTEXTADDRESS+1

    SEC
    LDA COPYOFCOLORMAPADDRESS
    SBC CLINEX
    STA COPYOFCOLORMAPADDRESS
    LDA COPYOFCOLORMAPADDRESS+1
    SBC #0
    STA COPYOFCOLORMAPADDRESS+1

    JMP TEXTATCMOVESKIPX

TEXTATCMOVEADDPX:

    CLC
    ADC COPYOFTEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA #0
    ADC COPYOFTEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1
    JMP TEXTATCMOVESKIPX

TEXTATCMOVESKIPX:

    CLC
    LDA CLINEY
    ADC YCURSYS
    CMP #$80
    BCS TEXTATCMOVESKIPY
    CMP #26
    BCS TEXTATCMOVESKIPY
    STA YCURSYS

TEXTATCMOVEADDPY:
    TXA
    PHA
    LDA CLINEY
    CMP #$80
    BCC TEXTATCMOVELOOPYP
    JMP TEXTATCMOVELOOPYM

TEXTATCMOVELOOPYP:
    TAX
TEXTATCMOVELOOPY:

    CLC
    LDA #40
    ADC COPYOFTEXTADDRESS
    STA COPYOFTEXTADDRESS
    LDA #0
    ADC COPYOFTEXTADDRESS+1
    STA COPYOFTEXTADDRESS+1

    CLC
    LDA #40
    ADC COPYOFCOLORMAPADDRESS
    STA COPYOFCOLORMAPADDRESS
    LDA #0
    ADC COPYOFCOLORMAPADDRESS+1
    STA COPYOFCOLORMAPADDRESS+1

    DEX
    BNE TEXTATCMOVELOOPY
    PLA
    TAX
    JMP TEXTATCMOVESKIPY

TEXTATCMOVELOOPYM:
    EOR #$FF
    CLC
    ADC #$1
    STA CLINEY
    TAX
TEXTATCMOVELOOPY2:

    SEC
    LDA COPYOFTEXTADDRESS
    SBC #40
    STA COPYOFTEXTADDRESS
    LDA COPYOFTEXTADDRESS+1
    SBC #0
    STA COPYOFTEXTADDRESS+1

    SEC
    LDA COPYOFCOLORMAPADDRESS
    SBC #40
    STA COPYOFCOLORMAPADDRESS
    LDA COPYOFCOLORMAPADDRESS+1
    SBC #0
    STA COPYOFCOLORMAPADDRESS+1

    DEX
    BNE TEXTATCMOVELOOPY2
    PLA
    TAX
    JMP TEXTATCMOVESKIPY

TEXTATCMOVESKIPY:
    JMP TEXTATNEXT

TEXTATAT:
    JSR TEXTATTMREADCHAR
    LDA SCREENCODE
    SEC
    SBC XCURSYS
    CLC
    ADC CONSOLEX1
    STA CLINEX
    JSR TEXTATTMREADCHAR
    LDA SCREENCODE
    SEC
    SBC YCURSYS
    CLC
    ADC CONSOLEY1
    STA CLINEY
    JMP TEXTATCMOVE

TEXTATSP0:
    LDY #0
    STA (COPYOFTEXTADDRESS),Y
    LDA _PEN
    ORA #$30
    STA (COPYOFCOLORMAPADDRESS),Y
    JMP TEXTATINCX

TEXTATSKIPTAB:
    INC XCURSYS
    DEC TABSTODRAW
    BNE TEXTATSKIPTAB2
TEXTATSKIPTAB2:
    JMP TEXTATEND2X

TEXTATINCX:
    INC COPYOFTEXTADDRESS
    BNE TEXTATINCX1
    INC COPYOFTEXTADDRESS+1
TEXTATINCX1:
    INC COPYOFCOLORMAPADDRESS
    BNE TEXTATINCX2
    INC COPYOFCOLORMAPADDRESS+1
TEXTATINCX2:

    INC XCURSYS
    LDX TEXTSIZE
    CPX #0
    BNE TEXTATEND2X
    JMP TEXTATEND2
TEXTATEND2X:
    LDA XCURSYS
    CMP #40
    BEQ TEXTATNEXT2
    JMP TEXTATNEXT
TEXTATNEXT2:
    LDA #0
    STA XCURSYS
    INC YCURSYS
    LDA YCURSYS
    CMP #25

    BEQ TEXTATNEXT3
    JMP TEXTATNEXT
TEXTATNEXT3:

    LDA COPYOFTEXTADDRESS
    PHA
    LDA COPYOFTEXTADDRESS+1
    PHA

    LDA #$FE
    STA DIRECTION
    JSR VSCROLLT

    PLA
    STA COPYOFTEXTADDRESS+1
    PLA
    STA COPYOFTEXTADDRESS
    
    DEC YCURSYS
    SEC
    LDA COPYOFTEXTADDRESS
    SBC #40
    STA COPYOFTEXTADDRESS
    LDA COPYOFTEXTADDRESS+1
    SBC #0
    STA COPYOFTEXTADDRESS+1

    SEC
    LDA COPYOFCOLORMAPADDRESS
    SBC #40
    STA COPYOFCOLORMAPADDRESS
    LDA COPYOFCOLORMAPADDRESS+1
    SBC #0
    STA COPYOFCOLORMAPADDRESS+1

TEXTATNEXT:
    LDA TABSTODRAW
    BEQ TEXTATXLOOP2
    JMP TEXTATLOOP2
TEXTATXLOOP2:
    LDX TEXTSIZE
    CPX #0
    BEQ TEXTATEND
    JMP TEXTATLOOP2
TEXTATEND2:
TEXTATEND:

@IF printSafe
@IF deployed.timer
    LDA TIMERRUNNING
    BNE ?skipsafe
@ENDIF
    CLI
@IF deployed.timer
?skipsafe:
@ENDIF
@ENDIF

@ENDIF

    RTS
