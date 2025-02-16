; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file except in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http://www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless r=ired by applicable law or agreed to in writing, software
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
;*                          FUJINET SUPPORT ON ATARI                           *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

fujiOpNet               =     $E3

fujiCmdReady            =     $00
fujiCmdResponse         =     $01
fujiCmdError            =     $2
fujiCmdOpen             =     'O'
fujiCmdClose            =     'C'
fujiCmdParseJson        =     'P'
fujiCmdQueryJson        =     'Q'
fujiCmdRead             =     'R'
fujiCmdStatus           =     'S'
fujiCmdWrite            =     'W'
fujiCmdSetChannelMode   =     $fc
fujiCmdSetLogin         =     $fd
fujiCmdSetPassword      =     $fe


FUJINETDEVICEID:
    .BYTE $00
FUJINETBYTESWAITING:
    .WORD $0000
FUJINETCONNECTED:
    .BYTE $00
FUJINETERRORCODE:
    .BYTE $00

; *****************************************************************************
; *****************************************************************************
; *****************************************************************************
; *** 
; *** SERIAL SUPPORT
; ***
; *****************************************************************************
; *****************************************************************************
; *****************************************************************************

; FUJINET PACKET STAGE AREA
; -------------------------
FUJINETPACKETSERIAL:
    .BYTE fujiOpNet, $00, $00, $00, $00
FUJINETPACKETSERIAL_DID       =     (FUJINETPACKETSERIAL+1)
FUJINETPACKETSERIAL_CMD       =     (FUJINETPACKETSERIAL+2)
FUJINETPACKETSERIAL_DAT       =     (FUJINETPACKETSERIAL+3)

; -------------------------------------------------------
; WRITE A FUJINET PACKET ON SERIAL
; -------------------------------------------------------

FUJINETPACKETWRITESERIAL:
    LDA #<FUJINETPACKETSERIAL
    STA TMPPTR
    LDA #>FUJINETPACKETSERIAL
    STA TMPPTR+1
    LDA #5
    STA MATHPTR0
    JSR SERIALWRITE
    RTS    

; -------------------------------------------------------
; MAKE SURE THAT FUJINET NETWORK IS READY
; -------------------------------------------------------
; Input:    
; Output:   A = status

FUJINETREADYSERIAL:
    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdReady
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL
    JSR SERIALREADBYTE
    RTS

; -------------------------------------------------------
; READ THE LAST ERROR FROM FUJINET
; -------------------------------------------------------
; Input:    
; Output:   A = error code

FUJINETERRORSERIAL:
    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdError
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL
    JSR SERIALREADBYTE
    RTS

; -------------------------------------------------------
; READ A RESPONSE FROM FUJINET
; -------------------------------------------------------
; Input:    
;           MATHPTR2 = number of bytes to read
;           TMPPTR2 = destination address
; Output:

FUJINETGETRESPONSESERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdResponse
    STA FUJINETPACKETSERIAL_CMD
    LDA MATHPTR2
    STA FUJINETPACKETSERIAL_DAT
    LDA #0
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    LDA MATHPTR2
    STA MATHPTR0
    LDA TMPPTR2
    STA TMPPTR
    LDA TMPPTR2+1
    STA TMPPTR+1
    JSR SERIALREAD

    RTS

; -------------------------------------------------------
; OPEN A RESOURCE ON FUJINET
; -------------------------------------------------------
; Input:    
;           MATHPTR2 = number of bytes of url
;           TMPPTR2 = url
;           MATHPTR3 = mode (high) 
;           MATHPTR4 = trans (low)
; Output:

FUJINETOPENSERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdOpen
    STA FUJINETPACKETSERIAL_CMD
    LDA MATHPTR3
    STA FUJINETPACKETSERIAL_DAT
    LDA MATHPTR4
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    LDA MATHPTR2
    STA MATHPTR0
    LDA TMPPTR2
    STA TMPPTR
    LDA TMPPTR2+1
    STA TMPPTR+1
    JSR SERIALWRITE

    SEC
    LDA #00
    SBC MATHPTR2
    STA MATHPTR0
    LDA #0
    JSR SERIALWRITECONST

    JSR FUJINETREADYSERIAL

    JSR FUJINETERRORSERIAL

    RTS

; -------------------------------------------------------
; CLOSE A RESOURCE ON FUJINET
; -------------------------------------------------------
; Input:    
; Output:

FUJINETCLOSESERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdClose
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL
    RTS
    
; -------------------------------------------------------
; GET STATUS FROM FUJINET 
; -------------------------------------------------------
; Input:    
; Output:

FUJINETGETSTATUSSERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdStatus
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL
 
    LDA #4
    STA MATHPTR2
    LDA #<FUJINETBYTESWAITING
    STA TMPPTR2
    LDA #>FUJINETBYTESWAITING
    STA TMPPTR2+1
    JSR FUJINETGETRESPONSESERIAL

    JSR FUJINETERRORSERIAL

    RTS

; -------------------------------------------------------
; READ DATA FROM FUJINET CONNECTION
; -------------------------------------------------------
; Input:    MATHPTR2 = bytes to read
;           TMPPTR2 = address to read to
; Output:

FUJINETREADSERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdRead
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    LDA MATHPTR2
    STA MATHPTR0
    LDA TMPPTR2
    STA TMPPTR
    LDA TMPPTR2+1
    STA TMPPTR+1
    JSR FUJINETGETRESPONSESERIAL

    RTS

; -------------------------------------------------------
; WRITE DATA TO FUJINET CONNECTION
; -------------------------------------------------------
; Input:    MATHPTR2 = bytes to write
;           TMPPTR2 = address to write from
; Output:

FUJINETWRITESERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdWrite
    STA FUJINETPACKETSERIAL_CMD
    LDA MATHPTR2
    STA FUJINETPACKETSERIAL_DAT
    LDA #0
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    LDA MATHPTR2
    STA MATHPTR0
    LDA TMPPTR2
    STA TMPPTR
    LDA TMPPTR2+1
    STA TMPPTR+1
    JSR SERIALWRITE

	RTS

; -------------------------------------------------------
; SET CHANNEL MODE ON FUJINET
; -------------------------------------------------------
; Input:    MATHPTR2 = mode
; Output:

FUJINETSETCHANNELMODESERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdSetChannelMode
    STA FUJINETPACKETSERIAL_CMD
    LDA MATHPTR2
    STA FUJINETPACKETSERIAL_DAT
    LDA #0
    STa FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL
    RTS

; -------------------------------------------------------
; PARSE JSON ON FUJINET
; -------------------------------------------------------
; Input:    
; Output:

FUJINETPARSEJSONSERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdParseJson
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    JSR FUJINETERRORSERIAL

    RTS

; -------------------------------------------------------
; SET JSON QUERY ON FUJINET
; -------------------------------------------------------
; Input:    MATHPTR2 = bytes to write
;           TMPPTR2 = address to write from
; Output:

FUJINETSETJSONQUERYSERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdQueryJson
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    LDA MATHPTR2
    STA MATHPTR0
    LDA TMPPTR2
    STA TMPPTR
    LDA TMPPTR2+1
    STA TMPPTR+1
    JSR SERIALWRITE

    SEC
    LDA #00
    SBC MATHPTR2
    STA MATHPTR0
    LDA #0
    JSR SERIALWRITECONST

    JSR FUJINETERRORSERIAL

    RTS

; -------------------------------------------------------
; SEND LOGIN ON FUJINET
; -------------------------------------------------------
; Input:    MATHPTR2 = bytes to write
;           TMPPTR2 = address to write from
; Output:

FUJINETLOGINSERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdSetLogin
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    LDA MATHPTR2
    STA MATHPTR0
    LDA TMPPTR2
    STA TMPPTR
    LDA TMPPTR2+1
    STA TMPPTR+1
    JSR SERIALWRITE

    SEC
    LDA #00
    SBC MATHPTR2
    SBC MATHPTR2
    STA MATHPTR0
    LDA #0
    JSR SERIALWRITECONST

    RTS

; -------------------------------------------------------
; SEND PASSWORD ON FUJINET
; -------------------------------------------------------
; Input:    B = bytes to write
;           Y = address to write from
; Output:

FUJINETPASSWORDSERIAL:
    JSR FUJINETREADYSERIAL

    LDA FUJINETDEVICEID
    STA FUJINETPACKETSERIAL_DID
    LDA #fujiCmdSetPassword
    STA FUJINETPACKETSERIAL_CMD
    LDA #0
    STA FUJINETPACKETSERIAL_DAT
    STA FUJINETPACKETSERIAL_DAT+1
    JSR FUJINETPACKETWRITESERIAL

    LDA MATHPTR2
    STA MATHPTR0
    LDA TMPPTR2
    STA TMPPTR
    LDA TMPPTR2+1
    STA TMPPTR+1
    JSR SERIALWRITE

    SEC
    LDA #00
    SBC MATHPTR2
    SBC MATHPTR2
    STA MATHPTR0
    LDA #0
    JSR SERIALWRITECONST

    RTS

; *****************************************************************************
; *****************************************************************************
; *****************************************************************************
; *** 
; *** SIO SUPPORT
; ***
; *****************************************************************************
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
; *****************************************************************************
; *****************************************************************************
; *** 
; *** GENERAL ENTRY
; ***
; *****************************************************************************
; *****************************************************************************
; *****************************************************************************

FUJINETREADY:
    JMP FUJINETREADYSERIAL

FUJINETERROR:
    JMP FUJINETERRORSERIAL

FUJINETGETRESPONSE:
    JMP FUJINETGETRESPONSESERIAL

FUJINETOPEN:
    JMP FUJINETOPENSERIAL

FUJINETCLOSE:
    JSR FUJINETCLOSESERIAL

FUJINETGETSTATUS:
    JMP FUJINETGETSTATUSSERIAL

FUJINETREAD:
    JMP FUJINETREADSERIAL

FUJINETWRITE:
    JSR FUJINETWRITESERIAL

FUJINETSETCHANNELMODE:
    JMP FUJINETSETCHANNELMODESERIAL

FUJINETPARSEJSON:
    JMP FUJINETPARSEJSONSERIAL

FUJINETSETJSONQUERY:
    JMP FUJINETSETJSONQUERYSERIAL

FUJINETLOGIN:
    JMP FUJINETLOGINSERIAL

FUJINETPASSWORD:
    JMP FUJINETPASSWORDSERIAL