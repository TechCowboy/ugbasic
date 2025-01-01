; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License
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
;  * (la "Licenza è proibito usare questo file se non in conformità alla
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
;*                      STARTUP ROUTINE FOR COLECO                             *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

rst_8:
    RETI
    NOP

rst_10:
    RETI
    NOP

rst_18:
    JP $1ffd

rst_20:
    RETI
    NOP

rst_28:
    RETI
    NOP

rst_30:
    RETI
    NOP

rst_38:
    RETI
    NOP

jp NMI

NMI:
	PUSH	AF
    LD A, (VDPINUSE)
    CP 1
    JR Z, NMI2
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX
	PUSH	IY
	EX	AF,AF'
	PUSH	AF
	EXX
	PUSH	BC
	PUSH	DE
	PUSH	HL
    LD HL,(COLECOTIMER)
    INC HL
    LD (COLECOTIMER),HL
	LD A, (IRQVECTORREADY)
	CMP 0
	JR Z, IRQVECTORSKIP
    CALL IRQVECTOR
IRQVECTORSKIP:
@IF deployed.sn76489startup
	CALL SN76489MANAGER
@ENDIF
@IF deployed.music
    CALL MUSICPLAYER
@ENDIF
@IF deployed.timer
    CALL TIMERMANAGER
@ENDIF
@IF deployed.joystick && ! joystickConfig.sync
    CALL JOYSTICKMANAGER
@ENDIF
	POP	HL
	POP	DE
	POP	BC
	EXX
	POP	AF
	EX	AF,AF'
	POP	IY
	POP	IX
	POP	HL
	POP	DE
	POP	BC
    IN A, ($bf)
NMI2:
	POP	AF
	RETN

; SET_GAMELOOP_HOOK:
;         LD (GAMELOOP_HOOK+1),HL
;         LD A,$c9
;         LD (GAMELOOP_HOOK+3),A
;         LD A,$cd
;         LD (GAMELOOP_HOOK),A
;         RET

IRQVOID:
    RET

CHECKIF60HZ:
    IN A, ($bf)
    NOP
    NOP
    NOP
VDPSYNC:
    IN A, ($bf)
	AND $80
    CP 0
	JR Z, VDPSYNC
    LD HL, $0
VDPLOOP:
    INC HL
    IN A, ($bf)
    AND $80
    CP 0
	JR Z, VDPLOOP
VDPLOOPD:

    LD A, H
    CMP $06
    JR Z, VDPLOOPDQ0
    LD A, 1
    RET

VDPLOOPDQ0:
    LD A, 0
    RET

COLECOSTARTUP:
    LD	HL, $9b9b
    LD	(CONTROLLER_BUFFER),HL

    LD DE, IRQVOID
    LD HL, IRQVECTOR
    LD A, $c3
    LD (HL), A
    INC HL
    LD A, E
    LD (HL), A
    INC HL
    LD A, D
    LD (HL), A
	LD A, 1
	LD (IRQVECTORREADY), A

    CALL VDPLOCK
    CALL CHECKIF60HZ
    CMP 1
    JR Z, COLECONTSC

COLECOPAL:
    LD A, 50
    LD (TICKSPERSECOND), A
    JP COLECOSTARTUPDONE

COLECONTSC:
    LD A, 60
    LD (TICKSPERSECOND), A
    JP COLECOSTARTUPDONE    

COLECOSTARTUPDONE:
    CALL VDPUNLOCK

    RET

WAITTIMER:
    LD A, (COLECOTIMER)
    LD B, A
WAITTIMERL1:
    LD A, (COLECOTIMER)
    CP B
    JR Z, WAITTIMERL1
    DEC L
    LD A, L
    CP $FF
    JR NZ, WAITTIMER
    DEC H
    LD A, H
    CP $FF
    JR NZ, WAITTIMER
    RET
