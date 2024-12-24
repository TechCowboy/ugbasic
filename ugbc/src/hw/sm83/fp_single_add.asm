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

FPSINGLEADD:

	CALL FPPUSHPOP
	PUSH BC

	LD C, (HL)
	INC HL
	LD B, (HL)
	INC HL
	PUSH BC

	LD C, (HL)
	INC HL
	LD B, (HL)
FPSINGLEADD_PART2:

	EX DE, HL

	LD A, C
	ADD A, A
	LD A, B
	ADC A, A
	LD E, A
	JP Z, FPSINGLE_ADD_0_OP2
	INC A
	JP Z, FPSINGLE_ADD_INFNAN_OP2
	PUSH BC

	LD C, (HL)
	INC HL
	LD B, (HL)
	INC HL
	PUSH BC
	LD C, (HL)
	INC HL
	LD B, (HL)

	LD A, C
	ADD A, A
	LD A, B
	ADC A, A
	JP Z, FPSINGLE_ADD_OP1_0
	INC A
	JP Z, FPSINGLE_ADD_OP1_INFNAN

	DEC A
	SUB E

	JR C, FPSINGLEADD_NEGATE
	LD D, B
	LD E, C
	POP IX
	POP BC
	POP HL
	JR FPSINGLEADD_SWAPPED
FPSINGLEADD_NEGATE:
	NEG
	POP HL
	POP DE
	POP IX
FPSINGLEADD_SWAPPED:

	SLA B
	LD B, A
	LD A, D
	RRA

	AND %11000000
	PUSH AF
	SET 7, C
	XOR A
	INC B
	JR FPSINGLEADD_SHIFT_START
FPSINGLEADD_SHIFT_LOOP:
	SRL C
	RR H
	RR L
	RRA
FPSINGLEADD_SHIFT_START:
	DJNZ FPSINGLEADD_SHIFT_LOOP
	LD B, A

	POP AF
	JP PO, FPSINGLEADD_SUB
FPSINGLEADD_ADD:
	LD A, E
	ADD A, A
	LD A, D
	ADC A, A
	PUSH AF
	LD D, A
	LD A, E
	OR %10000000

	PUSH DE
	PUSH IX
	POP DE
	ADD HL,DE
	POP DE
	ADC A,C

	JR NC, FPSINGLEADD_ADD_ROUND
	INC D
	INC D
	JP Z, FPSINGLEADD_RETURN_INF2
	DEC D
	RRA
	RR H
	RR L
	DEFB $01
FPSINGLEADD_ADD_ROUND:
	RL B
	JR FPSINGLEADD_OUTPUT

FPSINGLEADD_SUB:
	LD A, E
	ADD A, A
	LD A, D
	ADC A, A
	PUSH AF
	LD D, A
	SET 7, E
	XOR A
	SUB B
	LD B, A
	LD A, E
	PUSH DE
	PUSH IX
	POP DE
	EX DE, HL
	SBC HL, DE
	POP DE
	SBC A, C
	LD C, A
	JR NC, FPSINGLEADD_SUB_NEGATED
	POP AF
	CCF
	PUSH AF
	XOR A
	LD E, A
    SBC A, B
    LD B, A
	LD A, E
    SBC A, L
    LD L, A
	LD A, E
    SBC A, H
    LD H, A
	LD A, E
    SBC A, C
    LD C, A
FPSINGLEADD_SUB_NEGATED:
	LD A, B
	OR C
	OR H
	OR L
	JR NZ, FPSINGLEADD_SUB_NORM
	LD B, A
	POP AF
	EX DE, HL
	JR FPSINGLEADD_RETURN_BCDE
FPSINGLEADD_SUB_NORM:
	LD A, C
	SLA B
	INC A
	DEC A
	JP M, FPSINGLEADD_OUTPUT
FPSINGLEADD_SUB_NORM_LOOP:
	DEC D
	JR Z, FPSINGLEADD_OUTPUT
	ADC HL, HL
	ADC A, A
FPSINGLEADD_SUB_NORM_START:
	JP P, FPSINGLEADD_SUB_NORM_LOOP
FPSINGLEADD_OUTPUT:
	EX DE, HL
	LD B, H
	JR NC, FPSINGLEADD_ROUNDED
	INC E
	JR NZ, FPSINGLEADD_ROUNDED
	INC D
	JR NZ, FPSINGLEADD_ROUNDED
	INC A
	JR NZ, FPSINGLEADD_ROUNDED
	INC B
FPSINGLEADD_ROUNDED:
	ADD A, A
	LD C, A
	POP AF
	RR B
	RR C
	JR FPSINGLEADD_RETURN_BCDE

FPSINGLE_ADD_OP1_INFNAN:
	POP DE
	POP HL
	POP HL
	JR FPSINGLEADD_RETURN_BCDE

FPSINGLE_ADD_OP1_0:
	POP BC
	POP BC
	POP DE
FPSINGLEADD_RETURN_BCDE:
	POP HL
	LD (HL), E
	INC HL
	LD (HL), D
	INC HL
	LD (HL), C
	INC HL
	LD (HL), B
	RET

	RET

FPSINGLE_ADD_0_OP2:
	POP BC
	POP DE
	LDI
	LDI
	LD A, (HL)
	ADD A, A
	LDI
	LD A, (HL)
	LD (DE), A
	ADC A, A
	RET NZ
	LD (DE), A
	RET

FPSINGLE_ADD_INFNAN_OP2:
	POP DE
	LD A, C
	ADD A, A
	OR D
	OR E
	JR NZ, FPSINGLEADD_RETURN_BCDE

	LD E, (HL)
	INC HL
	LD D, (HL)
	INC HL
	LD C, (HL)
	INC HL
	LD H, (HL)

	LD A, C
	ADD A, A
	LD A, H
	ADC A, A
	JR Z, FPSINGLE_ADD_RETURN_INF
	INC A
	JR NZ, FPSINGLE_ADD_RETURN_INF
	LD A, H
	XOR B
	JP M, FPSINGLE_ADD_RETURN_NAN
	LD A, C
	ADD A, A
	OR D
	OR E
	JR Z, FPSINGLEADD_RETURN_BCDE
FPSINGLE_ADD_RETURN_NAN:
	LD C, -1
	LD D, C
	LD E, C
	JR FPSINGLEADD_RETURN_BCDE

FPSINGLEADD_RETURN_INF2:
	POP AF
	LD B, -1
	RR B
FPSINGLE_ADD_RETURN_INF:
	LD C, 80H
	LD DE, 0
	JR FPSINGLEADD_RETURN_BCDE
