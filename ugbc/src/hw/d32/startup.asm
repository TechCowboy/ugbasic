; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
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
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                                                                             *
;*                          STARTUP ROUTINE ON DRAGON 32                       *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

IRQSVC
    PSHS D
    PSHS X
    PSHS Y
    PSHS U
    PSHS DP
    PSHS CC
IRQSVC2
    NOP
    NOP
    NOP
    PULS CC
    PULS DP
    PULS U
    PULS Y
    PULS X
    PULS D
    RTS

OLDISVC
    fdb $0

ISVCIRQ
    JSR IRQSVC
    JSR TIMERMANAGER
    PSHS D
    LDD DRGTIMER
    ADDD #$1
    STD DRGTIMER
    LDD #0
    STD $00e3
    PULS D
    JMP [OLDISVC]

D32STARTUP

    LDD OLDISVC
    BNE D32STARTUPNOIRQREDEF

    LDD $010D
    STD OLDISVC

    LDD #ISVCIRQ
    STD $010D
    
D32STARTUPNOIRQREDEF

    LDA #0
    STA $011f

@IF dataSegment
    LDD #DATAFIRSTSEGMENT
    STD DATAPTR
@ENDIF

    LDD #$0
D32STARTUPL1
    ADDD 1
    STD <MATHPTR0
    CMPD #$3100
    BNE D32STARTUPL1

    LDA DRGTIMER+1
    CMPA #5
    BGE D32NTSC

D32PAL
    LDA #50
    STA TICKSPERSECOND
    JMP D32STARTUPDONE

D32NTSC
    LDA #60
    STA TICKSPERSECOND
    JMP D32STARTUPDONE

D32STARTUPDONE

SYSCALLDONE
    RTS
SYSCALL
SYSCALL0
    JSR $0000
    BRA SYSCALLDONE