; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file eXcept in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless required by applicable law or agreed to in writing, software
;  * distributed under the License is distributed on an "AS IS" BASIS,
;  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either eXpress or implied.
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
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                                                                             *
;*                           STARTUP ROUTINE ON VIC20                          *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

@IF descriptors

@EMIT descriptors.firstFree AS descriptorsCount

@ENDIF

VIC20STARTUP:

    LDA $EDE4
    CMP #$05
    BEQ VIC20NTSC

VIC20PAL:
    LDA #50
    STA TICKSPERSECOND
    JMP VIC20STARTUPDONE

VIC20NTSC:
    LDA #60
    STA TICKSPERSECOND
    JMP VIC20STARTUPDONE    

VIC20STARTUPDONE:

@IF dataSegment
    LDA #<DATAFIRSTSEGMENT
    STA DATAPTR
    LDA #>DATAFIRSTSEGMENT
    STA DATAPTR+1
    LDY #0
    STY DATAPTRY
@ENDIF

@IF sysCallUsed

SYSCALLDONE:

@ENDIF

    CLI

    RTS

@IF sysCallUsed

SYSCALL:
    SEI
SYSCALL0:
    JSR $0000
    JMP SYSCALLDONE

@ENDIF

WAITTIMER:
    LDA $A2
WAITTIMERL1:
    CMP $A2
    BEQ WAITTIMERL1
    DEX
    CPX #$FF
    BNE WAITTIMER
    DEY
    CPY #$FF
    BNE WAITTIMER
    RTS
