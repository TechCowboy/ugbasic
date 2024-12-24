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

FPSINGLECMP:
	PUSH BC
	PUSH HL
	PUSH DE
	INC HL
	INC HL
	LD A, (HL)
	ADD A, A
	INC HL
	LD A, H
	RLA
	DEC HL
	DEC HL
	DEC HL
	PUSH AF
	LD BC, FPSCRAP
	CALL FPSINGLESUB
	LD A, (FPSCRAP+2)
	ADD A, A
	LD A, (FPSCRAP+3)
	ADC A, A
	POP BC
	POP DE
	POP HL
	JR Z, FPSINGLECMP_EQUAL
	INC A
	JR NZ, FPSINGLECMP_EQUALL1

	LD BC, (FPSCRAP)
	LD A, (FPSCRAP+2)
	ADD A, A
	OR B
	OR C
	JR Z, FPSINGLECMP_NOTEQUAL
	LD A, -1
	ADD A, A
	POP BC
	RET

FPSINGLECMP_EQUALL1:
	SUB B
	ADD A, 2
	JR C, FPSINGLECMP_EQUAL
FPSINGLECMP_NOTEQUAL:
	POP BC

	LD A, (FPSCRAP+3)
	OR $7F
	ADD A, A
	RET

FPSINGLECMP_EQUAL:
	POP BC
	XOR A
	RET

