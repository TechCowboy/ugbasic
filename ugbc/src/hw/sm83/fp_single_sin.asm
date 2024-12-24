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

FPSINGLESIN:

	CALL FPPUSHPOP
	LD DE, FPSINGLE_CONST_PI_DIV_2
	CALL FPSINGLERSUB
	LD H, B
	LD L, C
	JP FPSINGLECOS_NOPUSHPOP

FPSINGLESIN_RANGE_REDUCED:

	LD DE, FPSINGLE_CONST_2PI
	CALL FPSINGLEMUL

	LD BC, FPSCRAP+4 ; FPSINGLECOS_Y
	LD D, H
	LD E, L

	CALL FPSINGLEMUL
	LD HL, FPSCRAP+7 ; FPSINGLECOS_Y
	SET 7, (HL)

	POP DE
	LD HL, FPSINGLESIN_A3
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
	LD HL, FPSINGLESIN_A2
	CALL FPSINGLEHORNER_STEP
	LD HL, FPSINGLESIN_A1
	CALL FPSINGLEHORNER_STEP
	LD HL, FPSINGLE_CONST_1
	CALL FPSINGLEHORNER_STEP
	LD HL, FPSCRAP ; FPSINGLECOS_X
	LD D, B
	LD E, C
	JP FPSINGLEMUL

FPSINGLESIN_A3:
  DEFB $11,$97,$4C,$39	;1.951123268E-4
FPSINGLESIN_A2:
  DEFB $AC,$83,$08,$3C	;.0083321742713
FPSINGLESIN_A1:
  DEFB $A4,$AA,$2A,$3E	;.1666665673
