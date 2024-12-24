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

FPSINGLEFROM8S:

	PUSH HL
	PUSH AF

	OR A
	JP P, $+6
	NEG
	SCF

	LD H, B
	LD L, C
	LD (HL), 0
	INC HL
	LD (HL), 0
	INC HL

	JR NZ, $+8
	LD (HL), A
	INC HL
	LD (HL), A
	POP AF
	POP HL
	RET

	PUSH BC
	RL C
	LD B, $7F+8

	DEC B
	ADD A, A
	JR NC, $-2

	RR C
	RR B
	RRA
	LD (HL), A
	INC HL
	LD (HL), B

	POP BC
	POP AF
	POP HL
	RET

FPSINGLEFROM8U:

	PUSH HL
	PUSH AF

	LD H,B
	LD L,C
	LD (HL),0
	INC HL
	LD (HL),0
	INC HL

	OR A
	JR NZ,$+8
	LD (HL),A
	INC HL
	LD (HL),A
	POP AF
	POP HL
	RET

	PUSH BC
	RL C
	LD B, $7F+8

	DEC B
	ADD A, A
	JR NC, $-2

	RR C
	RR B
	RRA
	LD (HL), A
	INC HL
	LD (HL),B

	POP BC
	POP AF
	POP HL
	RET



