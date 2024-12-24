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

FPFASTGEOMEAN:

	XOR C
	JP P, FPFASTGEOMEANL1
	LD A, $7F
	LD H, A
	RET

FPFASTGEOMEANL1:

	XOR C
	AND $7F
	RET Z	 ;MAY AS WELL EXIT IF THE INPUT IS 0
	CP $7F
	JR Z, FPFASTGEOMEAN_SUB
	LD B, A

	LD A, C
	AND $7F
	RET Z
	CP $7F
	JR Z, FPFASTGEOMEAN_SUB

	ADD A, B
	RRA
	PUSH AF

	LD A, 63
	LD C, A
	ADC A, 0
	CALL FPFASTGEOMEAN_SUB
	POP BC
	ADD A, B
	SUB 63
	RET

FPFASTGEOMEAN_SUB:
	CALL FPFASTMUL
	JP FPFASTSQRT
