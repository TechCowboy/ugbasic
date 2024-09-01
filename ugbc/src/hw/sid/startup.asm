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
;*                           STARTUP ROUTINE ON SID                            *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

SIDSTARTUP:
    LDA #$7
    LDX #$32
    JSR SIDPROGCTR
    LDA #$7
    LDX #1
    LDY #1
    JSR SIDPROGAD
    LDA #$7
    LDX #2
    LDY #6
    JSR SIDPROGSR
    LDA #<SIDFREQTABLE
    STA SIDTMPPTR2
    LDA #>SIDFREQTABLE
    STA SIDTMPPTR2+1
    LDA #$0
    STA SIDTMPPTR
    STA SIDTMPPTR+1
    STA SIDJIFFIES
    STA SIDJIFFIES+1
    RTS

SIDSTART:
    LSR
    BCC SIDSTART0X
    JSR SIDSTART0
SIDSTART0X:
    LSR
    BCC SIDSTART1X
    JSR SIDSTART1
SIDSTART1X:
    LSR
    BCC SIDSTART2X
    JSR SIDSTART2
SIDSTART2X:
    RTS

SIDSTART0:
    PHA
    LDA SIDSHADOW
    ORA #$1
    STA SIDSHADOW
    STA $D404
    PLA
    LDX #15
    JMP SIDSTARTVOL

SIDSTART1:
    PHA
    LDA SIDSHADOW+1
    ORA #$1
    STA SIDSHADOW+1
    STA $D40B
    PLA
    LDX #15
    JMP SIDSTARTVOL

SIDSTART2:
    PHA
    LDA SIDSHADOW+2
    ORA #$1
    STA SIDSHADOW+2
    STA $D412
    PLA
    LDX #15
    JMP SIDSTARTVOL

SIDSTARTVOL:
    STX $D418
    RTS

SIDFREQ:
    JSR SIDCALCFREQ
    LSR
    BCC SIDFREQ0X
    JSR SIDFREQ0T
SIDFREQ0X:
    LSR
    BCC SIDFREQ1X
    JSR SIDFREQ1T
SIDFREQ1X:
    LSR
    BCC SIDFREQ2X
    JSR SIDFREQ2T
SIDFREQ2X:
    RTS

SIDCALCFREQ:
    PHA
    TXA
    STA MATHPTR0
    TYA
    STA MATHPTR1

    ROL MATHPTR0
    ASL MATHPTR1
    ROL MATHPTR0
    ASL MATHPTR1
    ROL MATHPTR0
    ASL MATHPTR1
    ROL MATHPTR0
    ASL MATHPTR1

    LDA MATHPTR0
    TAX
    LDA MATHPTR1
    TAY
    PLA
    RTS

SIDFREQ0:
    JSR SIDCALCFREQ
SIDFREQ0T:
    JMP SIDPROGFREQ0

SIDFREQ1:
    JSR SIDCALCFREQ
SIDFREQ1T:
    JMP SIDPROGFREQ1

SIDFREQ2:
    JSR SIDCALCFREQ
SIDFREQ2T:
    JMP SIDPROGFREQ2

SIDPROGFREQ:
    LSR
    BCC SIDPROGFREQ0X
    JSR SIDPROGFREQ0
SIDPROGFREQ0X:
    LSR
    BCC SIDPROGFREQ1X
    JSR SIDPROGFREQ1
SIDPROGFREQ1X:
    LSR
    BCC SIDPROGFREQ2X
    JSR SIDPROGFREQ2
SIDPROGFREQ2X:
    RTS

SIDPROGFREQ0:
    PHA
    STX $D400
    STY $D401
    LDA SIDSHADOW
    ORA #$1
    STA SIDSHADOW
    STA $D404
    PLA
    RTS

SIDPROGFREQ1:
    PHA
    STX $D407
    STY $D408
    LDA SIDSHADOW+1
    ORA #$1
    STA SIDSHADOW+1
    STA $D40B
    PLA
    RTS

SIDPROGFREQ2:
    PHA
    STX $D40E
    STY $D40F
    LDA SIDSHADOW+2
    ORA #$1
    STA SIDSHADOW+2
    STA $D412
    PLA
    RTS

SIDPROGPULSE:
    LSR
    BCC SIDPROGPULSE0X
    JSR SIDPROGPULSE0
SIDPROGPULSE0X:
    LSR
    BCC SIDPROGPULSE1X
    JSR SIDPROGPULSE1
SIDPROGPULSE1X:
    LSR
    BCC SIDPROGPULSE2X
    JSR SIDPROGPULSE2
SIDPROGPULSE2X:
    RTS

SIDPROGPULSE0:
    PHA
    STX $D402
    STY $D403
    LDA #$42
    STA SIDSHADOW
    STA $D404
    PLA
    RTS

SIDPROGPULSE1:
    PHA
    STX $D409
    STY $D40A
    LDA #$42
    STA SIDSHADOW+1
    STA $D40B
    PLA
    RTS

SIDPROGPULSE2:
    PHA
    STX $D410
    STY $D411
    LDA #$42
    STA SIDSHADOW+2
    STA $D412
    PLA
    RTS

SIDPROGCTR:
    LSR
    BCC SIDPROGCTR0X
    JSR SIDPROGCTR0
SIDPROGCTR0X:
    LSR
    BCC SIDPROGCTR1X
    JSR SIDPROGCTR1
SIDPROGCTR1X:
    LSR
    BCC SIDPROGCTR2X
    JSR SIDPROGCTR2
SIDPROGCTR2X:
    RTS

SIDPROGCTR0:
    STX SIDSHADOW
    STX $D404
    RTS

SIDPROGCTR1:
    STX SIDSHADOW+1
    STX $D40B
    RTS

SIDPROGCTR2:
    STX SIDSHADOW+2
    STX $D412
    RTS

SIDPROGAD:
    LSR
    BCC SIDPROGAD0X
    JSR SIDPROGAD0
SIDPROGAD0X:
    LSR
    BCC SIDPROGAD1X
    JSR SIDPROGAD1
SIDPROGAD1X:
    LSR
    BCC SIDPROGAD2X
    JSR SIDPROGAD2
SIDPROGAD2X:
    RTS

SIDPROGAD0:
    PHA
    TXA
    ASL
    ASL
    ASL
    ASL
    STA MATHPTR0
    TYA
    AND #$0F
    ORA MATHPTR0
    STA $D405
    PLA
    RTS

SIDPROGAD1:
    PHA
    TXA
    ASL
    ASL
    ASL
    ASL
    STA MATHPTR0
    TYA
    AND #$0F
    ORA MATHPTR0
    STA $D40C
    PLA
    RTS

SIDPROGAD2:
    PHA
    TXA
    ASL
    ASL
    ASL
    ASL
    STA MATHPTR0
    TYA
    AND #$0F
    ORA MATHPTR0
    STA $D413
    PLA
    RTS

SIDPROGSR:
    LSR
    BCC SIDPROGSR0X
    JSR SIDPROGSR0
SIDPROGSR0X:
    LSR
    BCC SIDPROGSR1X
    JSR SIDPROGSR1
SIDPROGSR1X:
    LSR
    BCC SIDPROGSR2X
    JSR SIDPROGSR2
SIDPROGSR2X:
    RTS

SIDPROGSR0:
    PHA
    TXA
    ASL
    ASL
    ASL
    ASL
    STA MATHPTR0
    TYA
    AND #$0F
    ORA MATHPTR0
    STA $D406
    PLA
    RTS

SIDPROGSR1:
    PHA
    TXA
    ASL
    ASL
    ASL
    ASL
    STA MATHPTR0
    TYA
    AND #$0F
    ORA MATHPTR0
    STA $D40D
    PLA
    RTS

SIDPROGSR2:
    PHA
    TXA
    ASL
    ASL
    ASL
    ASL
    STA MATHPTR0
    TYA
    AND #$0F
    ORA MATHPTR0
    STA $D414
    PLA
    RTS

SIDSTOP:
    LSR
    BCC SIDSTOP0X
    JSR SIDSTOP0
SIDSTOP0X:
    LSR
    BCC SIDSTOP1X
    JSR SIDSTOP1
SIDSTOP1X:
    LSR
    BCC SIDSTOP2X
    JSR SIDSTOP2
SIDSTOP2X:
    RTS

SIDSTOP0:
    PHA
    LDA SIDSHADOW
    AND #$FE
    STA SIDSHADOW
    STA $D404
    PLA
    RTS

SIDSTOP1:
    PHA
    LDA SIDSHADOW+1
    AND #$FE
    STA SIDSHADOW+1
    STA $D40B
    PLA
    RTS

SIDSTOP2:
    PHA
    LDA SIDSHADOW+2
    AND #$FE
    STA SIDSHADOW+2
    STA $D412
    PLA
    RTS

SIDSETDURATION:
    LSR
    BCC SIDSETDURATION0X
    JSR SIDSETDURATION0
SIDSETDURATION0X:
    LSR
    BCC SIDSETDURATION1X
    JSR SIDSETDURATION1
SIDSETDURATION1X:
    LSR
    BCC SIDSETDURATION2X
    JSR SIDSETDURATION2
SIDSETDURATION2X:
    RTS

SIDSETDURATION0:
    STX SIDTIMER
    RTS

SIDSETDURATION1:
    STX SIDTIMER+1
    RTS

SIDSETDURATION2:
    STX SIDTIMER+2
    RTS

SIDWAITDURATION:
    LSR
    BCC SIDWAITDURATION0X
    JSR SIDWAITDURATION0
SIDWAITDURATION0X:
    LSR
    BCC SIDWAITDURATION1X
    JSR SIDWAITDURATION1
SIDWAITDURATION1X:
    LSR
    BCC SIDWAITDURATION2X
    JSR SIDWAITDURATION2
SIDWAITDURATION2X:
    RTS

SIDWAITDURATION0:
    LDX SIDTIMER
    BNE SIDWAITDURATION0
    RTS

SIDWAITDURATION1:
    LDX SIDTIMER+1
    BNE SIDWAITDURATION1
    RTS

SIDWAITDURATION2:
    LDX SIDTIMER+2
    BNE SIDWAITDURATION2
    RTS

