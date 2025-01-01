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
;*                           IMAGES ROUTINE FOR EF936X                         *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;--------------

GETIMAGE
@IF vestigialConfig.doubleBufferSelected

@ELSE

    ; Check if double buffering is active -- in case,
    ; whe should use a different version.
    LDA DOUBLEBUFFERENABLED
    CMPA #0
    LBEQ GETIMAGEORIG

@ENDIF

; ----------------------------------------------
; Version active on double buffering ON
; ----------------------------------------------

@IF ! vestigialConfig.doubleBufferSelected || vestigialConfig.doubleBuffer

GETIMAGEDB

    ORCC #$50

@IF PC128OP

    PSHS D
    LDA BANKSHADOW
    STA BASE_SEGMENT+$E5
    PULS D

@ENDIF

@IF vestigialConfig.screenModeUnique

@ELSE
    LDA CURRENTMODE
    CMPA #0
    BNE GETIMAGE0XDB
    JMP GETIMAGE0DB
GETIMAGE0XDB
    CMPA #1
    BNE GETIMAGE1XDB
    JMP GETIMAGE1DB
GETIMAGE1XDB
    CMPA #2
    BNE GETIMAGE2XDB
    JMP GETIMAGE2DB
GETIMAGE2XDB
    CMPA #3
    BNE GETIMAGE3XDB
    JMP GETIMAGE3DB
GETIMAGE3XDB
    CMPA #4
    BNE GETIMAGE4XDB
    JMP GETIMAGE4DB
GETIMAGE4XDB

@IF PC128OP

    PSHS D
    LDA #7
    STA BASE_SEGMENT+$E5
    PULS D

@ENDIF

    ANDCC #$AF

    RTS
@ENDIF

@IF ! vestigialConfig.screenModeUnique || ( (currentMode == 1) || (currentMode == 4) )

GETIMAGE1DB
GETIMAGE4DB

@IF PC128OP

    PSHS D
    LDA #7
    STA BASE_SEGMENT+$E5
    PULS D

@ENDIF

    ANDCC #$AF

    RTS

@ENDIF

@IF ! vestigialConfig.screenModeUnique || ( (currentMode == 0) || (currentMode == 2) )

GETIMAGE0DB
GETIMAGE2DB

    PSHS Y

    LDX BITMAPADDRESS

    ANDCC #$FE
    LDD <IMAGEY
    LSLB
    ROLA
    LSLB
    ROLA

    LSLB
    ROLA

    TFR D, Y

    ANDCC #$FE
    LDD <IMAGEY
    LSLB
    ROLA
    LSLB
    ROLA

    LSLB
    ROLA
    LSLB
    ROLA
    LSLB
    ROLA

    LEAY D, Y
    TFR Y, D
    LEAX D, X

    ANDCC #$FE
    LDD <IMAGEX
    LSRA
    RORB
    LSRA
    RORB
    LSRA
    RORB
    LEAX D, X

    PULS Y

    LDD ,Y
    LSRA
    RORB
    LSRA
    RORB
    LSRA
    RORB
    STB <IMAGEW
    LDA 2,Y
    STA <IMAGEH
    STA <IMAGEH2

    LEAY 3,Y

    LDA <IMAGEW
    LDB <IMAGEH
    PSHS X,D

    JMP GETIMAGE2YDB

@ENDIF

@IF !vestigialConfig.screenModeUnique || ( currentMode == 3 )

GETIMAGE3DB

    PSHS Y

    CLRA
    STA <(IMAGEY)
    LDB <(IMAGEY+1)
    LSLB
    ROLA
    ADDD #PLOTVBASE
    TFR D, X
    LDD , X
    TFR D, X

    CLRA
    STA <(IMAGEX)
    LDB <(IMAGEX+1)
    LSRB
    LSRB
    LEAX B, X

    PULS Y

    LDD ,Y
    LSRA
    RORB
    LSRA
    RORB
    STB <IMAGEW
    LDA 2,Y
    STA <IMAGEH
    STA <IMAGEH2

    LEAY 3,Y

    LDA <IMAGEW
    LDB <IMAGEH
    PSHS X,D

    JMP GETIMAGE2YDB

@ENDIF

GETIMAGE2YDB
GETIMAGE2YDEFDB
    ; LDA BASE_SEGMENT+$c0
    ; ORA #$01
    ; STA BASE_SEGMENT+$c0

@IF TO8

@ELSE

    LEAX $8000,X

@ENDIF

    LDB <IMAGEW
    DECB
GETIMAGE2L1DB
    LDA B,X
    STA B,Y
    DECB
    CMPB #0
    BGE GETIMAGE2L1DB

    LDB <IMAGEW
    LEAY B, Y

    LDB CURRENTSL
    LEAX B, X

    DEC <IMAGEH
    LDB <IMAGEH
    CMPB #0
    BEQ GETIMAGECOMMONE2DB

    LDB <IMAGEW
    DECB
    JMP GETIMAGE2L1DB

GETIMAGECOMMONE2DB

    PULS X,D

@IF TO8

    LEAX $2000,X

@ELSE

    LEAX $6000,X

@ENDIF
    
    STA <IMAGEW
    STB <IMAGEH

    ; LDA BASE_SEGMENT+$c0
    ; ANDA #$fe
    ; STA BASE_SEGMENT+$c0

    LDB <IMAGEW
    DECB
GETIMAGE2L12DB
    LDA B,X
    STA B,Y
    DECB
    CMPB #0
    BGE GETIMAGE2L12DB

    LDB <IMAGEW
    LEAY B, Y

    LDB CURRENTSL
    LEAX B, X

    DEC <IMAGEH
    LDB <IMAGEH
    CMPB #0
    BEQ GETIMAGECOMMONE5DB

    LDB <IMAGEW
    DECB
    JMP GETIMAGE2L12DB

GETIMAGECOMMONE5DB
;     LDA CURRENTMODE
;     CMPA #3
;     BEQ GETIMAGECOMMONE53
;     LDU #4
;     JMP GETIMAGECOMMONE50
; GETIMAGECOMMONE53
;     LDU #16
;     JMP GETIMAGECOMMONE50

; GETIMAGECOMMONE50
;     LDA #0
;     STA BASE_SEGMENT+$DB
; GETIMAGECOMMONE50L1
;     LDD ,Y
;     LEAY 2,Y
;     STB BASE_SEGMENT+$DA
;     STA BASE_SEGMENT+$DA
;     LEAU -1, U
;     CMPU #$FFFF
    ; BNE GETIMAGECOMMONE50L1

GETIMAGECOMMONEDB

@IF PC128OP

    PSHS D
    LDA #7
    STA BASE_SEGMENT+$E5
    PULS D

@ENDIF

    ANDCC #$AF
    
    RTS

@ENDIF

; ----------------------------------------------
; Version active on double buffering OFF
; ----------------------------------------------

@IF ! vestigialConfig.doubleBufferSelected || ! vestigialConfig.doubleBuffer

GETIMAGEORIG
@IF vestigialConfig.screenModeUnique

@ELSE

    LDA CURRENTMODE
    CMPA #0
    BNE GETIMAGE0X
    JMP GETIMAGE0
GETIMAGE0X
    CMPA #1
    BNE GETIMAGE1X
    JMP GETIMAGE1
GETIMAGE1X
    CMPA #2
    BNE GETIMAGE2X
    JMP GETIMAGE2
GETIMAGE2X
    CMPA #3
    BNE GETIMAGE3X
    JMP GETIMAGE3
GETIMAGE3X
    CMPA #4
    BNE GETIMAGE4X
    JMP GETIMAGE4
GETIMAGE4X
    RTS

@ENDIF

@IF ! vestigialConfig.screenModeUnique || ( (currentMode == 1) || (currentMode == 4) )

GETIMAGE1
GETIMAGE4
    RTS

@ENDIF

@IF ! vestigialConfig.screenModeUnique || ( (currentMode == 0) || (currentMode == 2) )

GETIMAGE0
GETIMAGE2

    PSHS Y

    LDX BITMAPADDRESS

    ANDCC #$FE
    LDD <IMAGEY
    LSLB
    ROLA
    LSLB
    ROLA

    LSLB
    ROLA

    TFR D, Y

    ANDCC #$FE
    LDD <IMAGEY
    LSLB
    ROLA
    LSLB
    ROLA

    LSLB
    ROLA
    LSLB
    ROLA
    LSLB
    ROLA

    LEAY D, Y
    TFR Y, D
    LEAX D, X

    ANDCC #$FE
    LDD <IMAGEX
    LSRA
    RORB
    LSRA
    RORB
    LSRA
    RORB
    LEAX D, X

    PULS Y

    LDD ,Y
    LSRA
    RORB
    LSRA
    RORB
    LSRA
    RORB
    STB <IMAGEW
    LDA 2,Y
    STA <IMAGEH
    STA <IMAGEH2

    LEAY 3,Y

    LDA <IMAGEW
    LDB <IMAGEH
    PSHS X,D

    JMP GETIMAGE2Y

@ENDIF

@IF ! vestigialConfig.screenModeUnique || ( currentMode == 3 )

GETIMAGE3

    PSHS Y

    CLRA
    STA <(IMAGEY)
    LDB <(IMAGEY+1)
    LSLB
    ROLA
    ADDD #PLOTVBASE
    TFR D, X
    LDD , X
@IF TO8
    ADDD BITMAPADDRESS
@ENDIF
    TFR D, X

    CLRA
    STA <(IMAGEX)
    LDB <(IMAGEX+1)
    LSRB
    LSRB
    LEAX B, X

    PULS Y

    LDD ,Y
    LSRA
    RORB
    LSRA
    RORB
    STb <IMAGEW
    LDA 2,Y
    STA <IMAGEH
    STA <IMAGEH2

    LEAY 3,Y

    LDA <IMAGEW
    LDB <IMAGEH
    PSHS X,D

    JMP GETIMAGE2Y

@ENDIF

GETIMAGE2Y
GETIMAGE2YDEF

@IF TO8

    LDA BASE_SEGMENT+$c3
    ORA #$01
    STA BASE_SEGMENT+$c3

@ELSE

    LDA BASE_SEGMENT+$c0
    ORA #$01
    STA BASE_SEGMENT+$c0

@ENDIF

    LDB <IMAGEW
    DECB
GETIMAGE2L1
    LDA B,X
    STA B,Y
    DECB
    CMPB #0
    BGE GETIMAGE2L1

    LDB <IMAGEW
    LEAY B, Y

    LDB CURRENTSL
    LEAX B, X

    DEC <IMAGEH
    LDB <IMAGEH
    CMPB #0
    BEQ GETIMAGECOMMONE2

    LDB <IMAGEW
    DECB
    JMP GETIMAGE2L1

GETIMAGECOMMONE2

    PULS X,D

    STA <IMAGEW
    STB <IMAGEH

@IF TO8

    LDA BASE_SEGMENT+$c3
    ANDA #$fe
    STA BASE_SEGMENT+$c3

@ELSE

    LDA BASE_SEGMENT+$c0
    ANDA #$fe
    STA BASE_SEGMENT+$c0

@ENDIF

    LDB <IMAGEW
    DECB
GETIMAGE2L12
    LDA B,X
    STA B,Y
    DECB
    CMPB #0
    BGE GETIMAGE2L12

    LDB <IMAGEW
    LEAY B, Y

    LDB CURRENTSL
    LEAX B, X

    DEC <IMAGEH
    LDB <IMAGEH
    CMPB #0
    BEQ GETIMAGECOMMONE5

    LDB <IMAGEW
    DECB
    JMP GETIMAGE2L12

GETIMAGECOMMONE5
;     LDA CURRENTMODE
;     CMPA #3
;     BEQ GETIMAGECOMMONE53
;     LDU #4
;     JMP GETIMAGECOMMONE50
; GETIMAGECOMMONE53
;     LDU #16
;     JMP GETIMAGECOMMONE50

; GETIMAGECOMMONE50
;     LDA #0
;     STA BASE_SEGMENT+$DB
; GETIMAGECOMMONE50L1
;     LDD ,Y
;     LEAY 2,Y
;     STB BASE_SEGMENT+$DA
;     STA BASE_SEGMENT+$DA
;     LEAU -1, U
;     CMPU #$FFFF
    ; BNE GETIMAGECOMMONE50L1

GETIMAGECOMMONE
    RTS

@ENDIF