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

FPSINGLECOS:
	CALL FPPUSHPOP

FPSINGLECOS_NOPUSHPOP:

	PUSH BC
	LD DE, FPSCRAP ; FPSINGLECOS_X
	LDI
	LDI
	LD A, (HL)
	ADD A, A
	LDI
	LD A, (HL)

	ADC A, A
	RRA
	LD (DE), A
	JP Z, FPSINGLECOS_RETURN_1
	ADC A, A
	INC A
	JP Z, FPSINGLECOS_RETURN_NAN

	LD HL, FPSCRAP ; FPSINGLECOS_X
	LD B, H
	LD C, L
	LD DE, FPSINGLE_CONST_2PI_INV
	CALL FPSINGLEMUL

	LD DE, FPSINGLE_CONST_P5
	CALL FPSINGLEADD

	CALL FPSINGLEMOD1

FPSINGLECOS_STEPIN:

	LD DE, FPSINGLE_CONST_P5
	CALL FPSINGLESUB

	LD HL, FPSCRAP+2 ; FPSINGLECOS_X
	LD A, (HL)
	ADD A, A
	INC HL
	RES 7, (HL)
	LD A, (HL)
	ADC A, A
	JR Z, FPSINGLECOS_RETURN_1

	POP BC
	CP $7D
	JR C, FPSINGLECOS_STEPINL1

	PUSH BC
	LD BC, FPSCRAP ; FPSINGLECOS_X
	LD H, B
	LD L, C
	CALL FPSINGLERSUB
	LD HL, FPSCRAP+2 ; FPSINGLECOS_X
	LD A, (HL)
	ADD A, A
	INC HL
	LD A, (HL)
	ADC A, A
	POP BC
	CALL FPSINGLECOS_STEPINL1
	LD H, B
	LD L, C
	JP FPSINGLENEG
FPSINGLECOS_STEPINL1:
	PUSH BC
	LD BC, FPSCRAP ; FPSINGLECOS_X

	CP $7C
	JR C, FPSINGLECOS_RANGE_REDUCED

	LD HL, FPSCRAP ; FPSINGLECOS_X
	LD DE, FPSINGLE_CONST_P25
	CALL FPSINGLERSUB
	JP FPSINGLESIN_RANGE_REDUCED

FPSINGLECOS_RANGE_REDUCED:

	LD HL, FPSCRAP ; FPSINGLECOS_X
	LD DE, FPSINGLE_CONST_2PI
	CALL FPSINGLEMUL

	LD BC, FPSCRAP+4 ; FPSINGLECOS_Y
	LD D, H
	LD E, L

	CALL FPSINGLEMUL
	LD HL, FPSCRAP+7 ; FPSINGLECOS_Y
	SET 7, (HL)

	POP DE
	LD HL, FPSINGLECOS_A3
	LDI
	LDI
	LDI
	LD A, (HL)
	LD (DE), A

	LD B, D
	LD C, E
	DEC BC
	DEC BC
	DEC BC
	LD DE, FPSCRAP+4 ; FPSINGLECOS_Y
	LD HL, FPSINGLECOS_A2
	CALL FPSINGLEHORNER_STEP
	LD HL, FPSINGLECOS_A1
	CALL FPSINGLEHORNER_STEP
	LD HL, FPSINGLE_CONST_1
	JP FPSINGLEHORNER_STEP

FPSINGLECOS_RETURN_NAN:
	LD HL, FPSINGLE_CONST_NAN
	JR FPSINGLECOS_RETURN

FPSINGLECOS_RETURN_1:
	LD HL,FPSINGLE_CONST_1

FPSINGLECOS_RETURN:
	POP DE
	JP FPMOV4

FPSINGLECOS_A3:
  DEFB $52,$26,$B2,$3A	;.0013591743
FPSINGLECOS_A2:
  DEFB $5C,$9F,$2A,$3D	;.041655882
FPSINGLECOS_A1:
  DEFB $DA,$FF,$FF,$3E	;.49999887
