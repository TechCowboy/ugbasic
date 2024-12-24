; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2024 Marco Spedaletti (asimov@mclink.it)
;  * Inspired from modules/z80float, copyright 2018 Zeda A.K. Thomas
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

FPSINGLE_MULU8_DIVPOW2:
	CALL FPPUSHPOP
	PUSH BC
	PUSH DE
	LD C, D

	LD E, (HL)
	INC HL
	LD D, (HL)
	INC HL
	LD A, (HL)
	ADD A, A
	LD B, A
	INC HL
	LD A, (HL)
	ADC A, A
	JR Z, FPSINGLE_MULU8_DIVPOW2_ZERO
	INC A
	JR Z, FPSINGLE_MULU8_DIVPOW2_INFNAN
	INC C
	DEC C
	JR Z, FPSINGLE_MULU8_DIVPOW2_ZERO

	POP HL	;
	PUSH AF

	LD A, L
	ADD A, A
	SBC A, A
	LD H, A
	PUSH HL

	SCF
	RR B
	CALL FP_C_TIMES_BDE	;CAHL
	LD B, A
	POP DE
	POP AF
	PUSH AF

	ADD A, E
	JR NC, $+3
	INC D

	ADD A, 7
	JR NC, $+3
	INC D

	INC D
	JR Z, FPSINGLE_MULU8_DIVPOW2_ZERO2
	DEC D
	JR NZ, FPSINGLE_MULU8_DIVPOW2_INF2

	LD E, A
	INC C
	DEC C
	JR FPSINGLE_MULU8_DIVPOW2_ADJUST
FPSINGLE_MULU8_DIVPOW2_LOOP:
	DEC DE
	ADD HL, HL
	RL B
	RL C
FPSINGLE_MULU8_DIVPOW2_ADJUST:
	JP P, FPSINGLE_MULU8_DIVPOW2_LOOP
	SLA C
	POP AF
	LD A, E
	LD E, H
	LD D, B
	LD B, C
	DEFB $21 ;START OF `LD HL,**` TO EATT THE NEXT 2 BYTES (DEC A \ POP DE)
FPSINGLE_MULU8_DIVPOW2_INFNAN:
	DEC A
FPSINGLE_MULU8_DIVPOW2_ZERO:
	POP DE
FPSINGLE_MULU8_DIVPOW2_RETURN:
	RRA
	RR B
	POP HL
	LD (HL), E
	INC HL
	LD (HL), D
	INC HL
	LD (HL), B
	INC HL
	LD (HL), A
	RET
FPSINGLE_MULU8_DIVPOW2_INF2:
	LD A, -1
	DEFB $FE
FPSINGLE_MULU8_DIVPOW2_ZERO2:
	XOR A
	LD DE, 0
	LD B, D
	JR FPSINGLE_MULU8_DIVPOW2_RETURN
