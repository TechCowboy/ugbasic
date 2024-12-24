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

FPFASTINV:
	LD C, A
	EX DE, HL
	LD A, $3F
	LD HL, 0

FPFASTDIV:

	LD B, A
	XOR C
	ADD A, A
	LD A, B
	RLA
	RRCA
	LD B, A

	AND $7F
	JP Z, FPFASTDIV_0_X
	INC A
	JP M, FPFASTDIV_INFNAN_X

	LD A, C
	AND $7F
	JR NZ, FPFASTDIVL1
	DEC A
	LD H, A
	LD L, A
	RET

FPFASTDIVL1:
	INC A
	JP M,FPFASTDIV_X_INFNAN

	RES 7, C
	LD A, B
	AND $7F
	ADD A, 63
	SUB C
	JR NC, $+4
	XOR A
	RET

	CP $7F
	JR C, FPFASTDIV_RETURN_INFL1

FPFASTDIV_RETURN_INF:
	LD A, B
	OR %01111111
	LD HL, 0
	RET
FPFASTDIV_RETURN_INFL1:

	OR A
	LD C, 0
	SBC HL, DE
	JR NC, FPFASTDIV_READY

	DEC A
	RET Z
	ADD HL, DE
	ADD HL, HL
	RL C
	INC C
	SBC HL, DE
	JR NC, FPFASTDIV_READY
	DEC C
FPFASTDIV_READY:
	PUSH BC
	PUSH AF

	CALL FPFASTDIV_DIV16

	POP DE
	POP BC
	ADC A, D
	JP P, FPFASTDIV_READYL1
FPFASTDIV_RETURN_NAN:
	DEC A
	LD H, A
	LD L, A
FPFASTDIV_READYL1:
	XOR B
	AND $7F
	XOR B
	RET

FPFASTDIV_DIV16:
	XOR A
	SUB E
	LD E, A
	LD A, 0
	SBC A, D
	LD D, A
	SBC A, A
	DEC A
	LD B, A

	LD A, C
	CALL FPFASTDIV_DIV8
	RL C
	PUSH BC
	CALL FPFASTDIV_DIV8
	RL C

	ADD HL, HL
	ADC A, A
	ADD HL, DE
	ADC A, B

	POP HL
	LD H, L
	LD L, C
	LD BC, 0
	LD A, B
	ADC HL, BC
	RET

FPFASTDIV_DIV8:
	CALL FPFASTDIV_DIV4
FPFASTDIV_DIV4:
	CALL FPFASTDIV_DIV2
FPFASTDIV_DIV2:
	CALL FPFASTDIV_DIV1
FPFASTDIV_DIV1:
	RL C
	ADD HL, HL
	ADC A, A
	RET Z
	ADD HL, DE
	ADC A, B
	RET C
	SBC HL, DE
	SBC A, B
	RET

FPFASTDIV_0_X:
	LD A, C
	AND $7F
	JR Z, FPFASTDIV_RETURN_NAN
	INC A
	JP M, FPFASTDIV_0_XL1
	XOR A
	RET
FPFASTDIV_0_XL1:
	LD A, D
	OR E
	RET Z
	LD A, C
	EX DE, HL
	RET

FPFASTDIV_X_INFNAN:
	LD A, D
	OR E
	RET Z
	LD A, C
FPFASTDIV_X_INFNANL1:
	EX DE, HL
	RET

FPFASTDIV_INFNAN_X:
	LD A, H
	OR L
	LD A, B
	RET NZ
	LD A, C
	AND $7F
	JR Z, FPFASTDIV_RETURN_NAN
	INC A
	JP M, FPFASTDIV_RETURN_NAN
	LD A, B
	RET
    