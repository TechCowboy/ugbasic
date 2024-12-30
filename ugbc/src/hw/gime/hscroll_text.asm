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
;*                          HORIZONTAL SCROLL ON GIME                          *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

HSCROLLSINGLELINELEFT

    PSHS X
    PSHS Y
    PSHS U
    LDA #0
    LDB CONSOLEW
    TFR D, U
HSCROLLSINGLELINELEFTL2
    LDD , Y
    STD , X
    LEAX 2, X
    LEAY 2, Y
    LEAU -1, U
    CMPU #0
    BNE HSCROLLSINGLELINELEFTL2

    LDA EMPTYTILE
    LDB <PLOTC
    
    STD , Y
    PULS U
    PULS Y
    PULS X

    RTS

HSCROLLST
    LDA CURRENTTILEMODE
    BNE HSCROLLSTX
    RTS

HSCROLLSTX
    PSHS A,B,X,Y,U

    LDB _PEN
    JSR GIMESELECTPALETTEPEN
    LSLA
    LSLA
    LSLA
    STA <PLOTC
    LDB _PAPER
    JSR GIMESELECTPALETTEPAPER
    ORA <PLOTC
    STA <PLOTC

    LDX TEXTADDRESS

    LDB CONSOLEY1
    LDA CURRENTTILESWIDTH
    MUL
    LEAX D, X
    LEAX D, X
    LDB CONSOLEX1
    LEAX B, X
    LEAX B, X
    TFR X, Y
    LEAY 2, Y

    LDA <DIRECTION
    CMPA #0
    BGT HSCROLLSTRIGHT

    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKVIDEO

HSCROLLSTLEFT
    LDA #0
    LDB CONSOLEH
    TFR D, U
HSCROLLSTLEFTL1
    JSR HSCROLLSINGLELINELEFT
    LDB CURRENTTILESWIDTH
    LEAX B, X
    LEAX B, X
    LEAY B, Y
    LEAY B, Y
    LEAU -1, U
    CMPU #0
    BNE HSCROLLSTLEFTL1

    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKROM

    PULS A,B,X,Y,U
    RTS    

HSCROLLSINGLELINERIGHT
    PSHS U
    LDB CONSOLEW
    DECB
    LSLB
HSCROLLSINGLELINERIGHTL2
    LDU B, X
    STU B, Y
    DECB
    DECB
    BNE HSCROLLSINGLELINERIGHTL2

    LDA EMPTYTILE
    LDB <PLOTC

    STD , X
    PULS U
    RTS

HSCROLLSTRIGHT

    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKVIDEO

    LDA #0
    LDB CONSOLEH
    TFR D, U
HSCROLLSTRIGHTL1
    JSR HSCROLLSINGLELINERIGHT
    LDB CURRENTTILESWIDTH
    LEAX B, X
    LEAX B, X
    LEAY B, Y
    LEAY B, Y
    LEAU -1, U
    CMPU #0
    BNE HSCROLLSTRIGHTL1

    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKROM

    PULS A,B,X,Y,U
    RTS    

HSCROLLLT
    LDA CURRENTTILEMODE
    BNE HSCROLLLTX
    RTS

HSCROLLLTX
    PSHS A,B,X,Y,U

    LDB _PEN
    JSR GIMESELECTPALETTEPEN
    LSLA
    LSLA
    LSLA
    STA <PLOTC
    LDB _PAPER
    JSR GIMESELECTPALETTEPAPER
    ORA <PLOTC
    STA <PLOTC

    LDA <CLINEY
    LDB CURRENTTILESWIDTH
    MUL
    LSLB
    ROLA
    ADDD TEXTADDRESS
    TFR D, X
    TFR D, Y
    LEAY 2, X

    LDA <DIRECTION
    CMPA #0
    BGT HSCROLLTTRIGHT

HSCROLLTLEFT
    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKVIDEO

    JSR HSCROLLSINGLELINELEFT

    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKROM

    PULS A,B,X,Y,U
    RTS    

HSCROLLTTRIGHT

    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKVIDEO

    JSR HSCROLLSINGLELINERIGHT

    ; The HSCROLL command do not need to switch from one bank to another 
    ; during video RAM operation. This routine can simply bank in video 
    ; memory at the beginning of execution and bank out at the end.

    JSR GIMEBANKROM

    PULS A,B,X,Y,U
    RTS    
    