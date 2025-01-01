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
;*                      TEXT AT GIVEN POSITION ON VDC                          *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

TEXTATTILEMODE:

TEXTATTILEMODENMI2:

    LD A, (CURRENTTILEMODE)
    CP 0
    RET Z

    LD A, C
    CP 0
    JR NZ,TEXTATTILEMODEGO
    JP TEXTATTILEMODEDONE

TEXTATTILEMODEGO:
    PUSH BC
    PUSH DE

    LD A, (CURRENTTILESWIDTH)
    LD E, A
    LD D, 0

    LD A, (CURRENTMODE)
    CP 0
    JR Z,TEXTATTILEMODEGO0
    RET

TEXTATTILEMODEGO0:
TEXTATTILEMODEGO1:
    LD HL, (TEXTADDRESS)
    LD (COPYOFTEXTADDRESS), HL
    LD HL, (COLORMAPADDRESS)
    LD (COPYOFCOLORMAPADDRESS), HL
    JMP TEXTATTILEMODEGOX

TEXTATTILEMODEGOX:
    LD A, 0
    LD B, A
    LD (TABSTODRAW), A

    LD A, (YCURSYS)
    CP 0
    JR Z, TEXTATSKIP
    LD C, A
    LD HL, (COPYOFTEXTADDRESS)
TEXTATLOOP1:
    ADD HL, DE
    DEC C
    JR NZ, TEXTATLOOP1
    LD (COPYOFTEXTADDRESS), HL

TEXTATSKIP:
    LD A, (XCURSYS)
    LD E, A
    LD A, 0
    LD D, 0
    LD HL, (COPYOFTEXTADDRESS)
    ADD HL, DE
    LD (COPYOFTEXTADDRESS), HL

    LD HL, (TEXTADDRESS)
    LD DE, HL
    LD HL, (COPYOFTEXTADDRESS)
    AND A
    SBC HL, DE
    LD DE, HL
    LD HL, (COLORMAPADDRESS)
    ADD HL, DE
    LD (COPYOFCOLORMAPADDRESS), HL
    LD HL, (COPYOFTEXTADDRESS)
    
    POP DE
    POP BC
    
TEXTATLOOP2:

    LD A, (TABSTODRAW)
    CP 0
    JR Z,TEXTATNSKIPTAB
    JMP TEXTATSKIPTAB

TEXTATNSKIPTAB:
    LD A, (DE)

    CP 31
    JR C,TEXTATCC

TEXTATXCC:
    CALL TEXTATDECODE
    JMP TEXTATSP0

TEXTATTAB:
    LD A, (TABCOUNT)
    LD B, A
    LD A, (XCURSYS)
TEXTATTAB2:
    CP B
    JR C, TEXTATTAB3
    SUB A, B
    JMP TEXTATTAB2
TEXTATTAB3:
    LD B, A
    LD A, (TABCOUNT)
    SUB A, B
    LD (TABSTODRAW), A
    JMP TEXTATNEXT

TEXTATCC:
    CP 13
    JR Z, TEXTATLF
    CP 10
    JR Z, TEXTATLF
    CP 9
    JR Z, TEXTATTAB
    CP 1
    JR Z, TEXTATPEN
    CP 2
    JR Z, TEXTATPAPER
    CP 3
    JR Z, TEXTATCMOVEPREPARE
    CP 4
    JR Z, TEXTATXAT
    CP 5
    JR Z, TEXTATCLS
    JMP TEXTATNEXT

TEXTATCLS:
    INC DE
    PUSH AF
    PUSH DE
    PUSH HL
    PUSH BC
    CALL CLST
    POP BC
    POP HL
    POP DE
    POP AF
    JMP TEXTATNEXT

TEXTATLF:
    INC DE
    DEC C
    JMP TEXTATNEXT2

TEXTATXAT:
    JMP TEXTATAT

TEXTATPEN:
    INC DE
    DEC C
    LD A, (DE)
    CP $FF
    JR NZ, TEXTATPEN2
    LD A, 0
TEXTATPEN2:
    LD (_PEN), A
    INC DE
    DEC C
    JMP TEXTATNEXT

TEXTATPAPER:
    INC DE
    DEC C
    LD A, (DE)
    ; STA $d021
    ; STA $d020
    INC DE
    DEC C
    JMP TEXTATNEXT

TEXTATCMOVEPREPARE:
    INC DE
    DEC C
    LD A, (DE)
    LD (CLINEX), A
    INC DE
    DEC C
    LD A, (DE)
    LD (CLINEY), A

TEXTATCMOVE:
    LD A, (XCURSYS)
    LD B, A
    LD A, (CLINEX)
    ADD A, B
    CP $80
    JR NC, TEXTATCMOVESKIPX
    PUSH AF
    LD A, (CURRENTTILESWIDTH)
    LD B, A
    POP AF
    CP B
    JR NC, TEXTATCMOVESKIPX
    LD (XCURSYS), A
    LD A, (CLINEX)

    CP $80
    JR C, TEXTATCMOVEADDPX

TEXTATCMOVESUBPX:
    XOR $FF
    ADD 1
    LD (CLINEX), A

    LD HL, (COPYOFTEXTADDRESS)
    PUSH DE
    LD E, A
    LD D, 0
    SBC HL, DE
    POP DE
    LD (COPYOFTEXTADDRESS), HL

    JMP TEXTATCMOVESKIPX

TEXTATCMOVEADDPX:

    LD (CLINEX), A

    LD HL, (COPYOFTEXTADDRESS)
    PUSH DE
    LD E, A
    LD D, 0
    ADD HL, DE
    POP DE
    LD (COPYOFTEXTADDRESS), HL

    JMP TEXTATCMOVESKIPX

TEXTATCMOVESKIPX:

    LD A, (YCURSYS)
    LD B, A
    LD A, (CLINEY)
    ADD A,B

    CP $80
    JR NC, TEXTATCMOVESKIPY
    CP 26
    JR NC, TEXTATCMOVESKIPY
    LD (YCURSYS), A

TEXTATCMOVEADDPY:
    LD A, (CLINEY)
    CP $80
    JR C, TEXTATCMOVELOOPYP
    JMP TEXTATCMOVELOOPYM

TEXTATCMOVELOOPYP:
    PUSH BC
    LD C, A
    LD HL, (COPYOFTEXTADDRESS)
    PUSH DE
    LD A, (CURRENTTILESWIDTH) 
    LD E, A
    LD D, 0
TEXTATCMOVELOOPY:
    ADD HL, DE
    DEC C
    JR NZ, TEXTATCMOVELOOPY
    POP DE
    LD (COPYOFTEXTADDRESS), HL
    POP BC
    JMP TEXTATCMOVESKIPY

TEXTATCMOVELOOPYM:
    XOR $FF
    ADD A, 1
    LD (CLINEY), A

    PUSH BC
    LD C, A
    LD HL, (COPYOFTEXTADDRESS)
TEXTATCMOVELOOPY2:
    PUSH DE
    LD A, (CURRENTTILESWIDTH) 
    LD E, A
    LD D, 0
    SBC HL, DE
    POP DE
    DEC C
    JR NZ, TEXTATCMOVELOOPY2
    LD (COPYOFTEXTADDRESS), HL
    POP BC
    JMP TEXTATCMOVESKIPY

TEXTATCMOVESKIPY:
    INC DE

    PUSH HL
    PUSH DE
    LD HL, (TEXTADDRESS)
    LD DE, HL
    LD HL, (COPYOFTEXTADDRESS)
    AND A
    SBC HL, DE
    LD DE, HL
    LD HL, (COLORMAPADDRESS)
    ADD HL, DE
    LD (COPYOFCOLORMAPADDRESS), HL
    POP DE
    POP HL

    JMP TEXTATNEXT

TEXTATAT:
    INC DE
    DEC C
    LD A, (XCURSYS)
    LD B, A
    LD A, (DE)
    SUB A, B
    LD (CLINEX), A
    INC DE
    DEC C
    LD A, (YCURSYS)
    LD B, A
    LD A, (DE)
    SUB A, B
    LD (CLINEY), A
    JMP TEXTATCMOVE

TEXTATSP0:
    PUSH DE
    PUSH BC
    LD HL, (COPYOFTEXTADDRESS)

    LD DE, HL
    CALL VDCZPUTCHAR

    PUSH AF
    LD A, (CURRENTMODE)
    CP 0
    JR Z,TEXTAT20
    POP AF
    POP BC
    POP DE
    RET

TEXTAT20:
TEXTAT21:
    PUSH HL
    PUSH AF
    PUSH DE
    PUSH BC

    LD HL, (COPYOFCOLORMAPADDRESS)
    LD DE, HL
    LD A, (_PEN)
    OR $80
    CALL VDCZPUTCHAR
    POP BC
    POP DE
    POP AF
    POP HL
    POP AF

xxxx:

    POP BC
    POP DE

    JMP TEXTATINCX

TEXTATSKIPTAB:
    LD A, (TABSTODRAW)
    DEC A
    JR Z, TEXTATSKIPTAB2
    INC C
TEXTATSKIPTAB2:
    LD (TABSTODRAW),A
    JMP TEXTATINCX

TEXTATINCX:
    LD HL, (COPYOFTEXTADDRESS)
    INC HL
    LD (COPYOFTEXTADDRESS), HL
    LD HL, (COPYOFCOLORMAPADDRESS)
    INC HL
    LD (COPYOFCOLORMAPADDRESS), HL
    INC DE
    LD A, (XCURSYS)
    INC A
    LD (XCURSYS), A
    DEC C
    JP Z, TEXTATEND2
    PUSH AF
    LD A, (CURRENTTILESWIDTH)
    LD B, A
    POP AF
    CP B
    JR Z, TEXTATNEXT2
    JMP TEXTATNEXT
TEXTATNEXT2:
    LD A, 0
    LD (XCURSYS), A
    LD A, (YCURSYS)
    INC A
    LD (YCURSYS), A
    PUSH AF
    LD A, (CURRENTTILESHEIGHT)
    LD B, A
    POP AF
    CP B

    JR Z, TEXTATNEXT3
    JMP TEXTATNEXT
TEXTATNEXT3:

    PUSH AF
    PUSH BC
    PUSH DE
    PUSH HL
    CALL VSCROLLTUP
    POP HL
    POP DE
    POP BC
    POP AF

    LD A, (YCURSYS)
    DEC A
    LD (YCURSYS), A
    LD HL, (COPYOFTEXTADDRESS)
    PUSH DE
    LD A, (CURRENTTILESWIDTH) 
    LD E, A
    LD D, 0
    SBC HL, DE
    POP DE
    LD (COPYOFTEXTADDRESS), HL

    LD HL, (COPYOFCOLORMAPADDRESS)
    PUSH DE
    LD A, (CURRENTTILESWIDTH) 
    LD E, A
    LD D, 0
    SBC HL, DE
    POP DE
    LD (COPYOFCOLORMAPADDRESS), HL

TEXTATNEXT:
    LD A, C
    CP 0
    JR Z, TEXTATEND2
    LD A, (TABSTODRAW)
    CP 0
    JR Z, TEXTATXLOOP2
    JMP TEXTATLOOP2
TEXTATXLOOP2:
    JMP TEXTATLOOP2
TEXTATEND2:
TEXTATEND:
    JP TEXTATTILEMODEDONE

TEXTATTILEMODEDONE:
    RET