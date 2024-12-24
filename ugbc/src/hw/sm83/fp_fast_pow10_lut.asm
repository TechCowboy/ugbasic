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

FPFASTPOW10_LUT:
    DEFB $8E,$15,$7E  ;1E19
    DEFB $17,$BC,$7A  ;1E18
    DEFB $45,$63,$77  ;1E17
    DEFB $38,$1C,$74  ;1E16
    DEFB $BF,$C6,$70  ;1E15
    DEFB $CC,$6B,$6D  ;1E14
    DEFB $0A,$23,$6A  ;1E13
    DEFB $A9,$D1,$66  ;1E12
    DEFB $87,$74,$63  ;1E11
    DEFB $06,$2A,$60  ;1E10
    DEFB $D6,$DC,$5C  ;1E9
    DEFB $78,$7D,$59  ;1E8
    DEFB $2D,$31,$56  ;1E7
    DEFB $48,$E8,$52  ;1E6
    DEFB $A0,$86,$4F  ;1E5
    DEFB $80,$38,$4C  ;1E4
    DEFB $00,$F4,$48  ;1E3
    DEFB $00,$90,$45  ;1E2
FPFASTCONST_10:
    DEFB $00,$40,$42  ;1E1
    DEFB $00,$00,$3F  ;1E0
    DEFB $9A,$99,$3B  ;1E-1
    DEFB $AE,$47,$38  ;1E-2
    DEFB $25,$06,$35  ;1E-3
    DEFB $6E,$A3,$31  ;1E-4
    DEFB $8B,$4F,$2E  ;1E-5
    DEFB $6F,$0C,$2B  ;1E-6
    DEFB $7F,$AD,$27  ;1E-7
    DEFB $99,$57,$24  ;1E-8
    DEFB $E1,$12,$21  ;1E-9
    DEFB $CE,$B7,$1D  ;1E-10
    DEFB $D8,$5F,$1A  ;1E-11
    DEFB $7A,$19,$17  ;1E-12
    DEFB $5C,$C2,$13  ;1E-13
    DEFB $4A,$68,$10  ;1E-14
    DEFB $3B,$20,$0D  ;1E-15
    DEFB $2B,$CD,$09  ;1E-16
    DEFB $EF,$70,$06  ;1E-17
    DEFB $26,$27,$03  ;1E-18
