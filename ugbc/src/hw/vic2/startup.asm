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
;*                           STARTUP ROUTINE ON VIC-II                         *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

CPUMEMMOVE:
    LDY MATHPTR0+1
    BEQ CPUMEMMOVER
    LDY #$0
CPUMEMMOVE2:
    LDA (TMPPTR), Y
    STA (TMPPTR2), Y
    INY
    BNE CPUMEMMOVE2
    INC TMPPTR+1
    INC TMPPTR2+1
    DEC MATHPTR0+1
    BNE CPUMEMMOVE2

CPUMEMMOVER:
    LDY #$0
CPUMEMMOVER2:
    LDA (TMPPTR), Y
    STA (TMPPTR2), Y
    INY
    CPY MATHPTR0
    BNE CPUMEMMOVER2
    RTS
    
@IF vestigialConfig.doubleBufferSelected || vestigialConfig.doubleBuffer

ONSWITCHTILEMAPVOID:
    RTS

ONSWITCHTILEMAP:
    JMP ONSWITCHTILEMAPVOID

@ENDIF

VIC2STARTUP:

    SEI
    LDX #$10
@IF C128
    LDA #$1
    STA $FF00
@ELSE
    LDA #$33
    STA $01
@ENDIF

    LDA #$D0
    STA $FC
    LDY #$00
    STY $FB
    LDA #$90
    STA $FE
    LDY #$00
    STY $FD
VIC2STARTUPL1:
    LDA ($FB),Y
    STA ($FD),Y
    INY
    BNE VIC2STARTUPL1
    INC $FC
    INC $FE
    DEX
    BNE VIC2STARTUPL1

    LDA #0
    STA $FD

@IF C128
    LDA #%00111110
    STA $FF00
@ELSE
    LDA #$35
    STA $01
@ENDIF

;     ; SET_DATA_DIRECTION();
    LDA $dd02
    ORA #$03
    STA $dd02

;     ; SET_BANK(2);
    LDA $dd00
    AND #$fc
    ORA #$01
    STA $dd00

;     ; SET_BACKGROUND_COLOR( MR_COLOR_BLACK );
    LDA #0
    STA $d021

;     ; SET_VIDEO(MR_SCREEN_DEFAULT);
    LDA $d018
    AND #$0f
    ORA #$10
    STA $d018

;     ; SET_BASIC_VIDEO(MR_SCREEN_DEFAULT);
@IF C128
@ELSE
    LDA #$84
    STA $0288
@ENDIF

;     ; SET_CHARSET(MR_TILESET_DEFAULT);
    LDA $d018
    AND #$f0
@IF fontConfig.schema || descriptors
    ORA #$09
@ELSE
    ORA #$07
@ENDIF
    STA $d018

    ; SET STARTUP CURSOR POSITION    
    LDA #0
    STA $D3
    LDA #0
    STA $D6

    LDA $D011
    AND #%11111000;
    ORA YSCROLLPOS
    STA $D011
    LDA $D016
    AND #%11111000
    ORA XSCROLLPOS
    STA $D016

@IF deployed.msprites

    JSR MSPRITESINIT

@ENDIF

    CLI

@IF vestigialConfig.clsImplicit
	JSR CLST
@ENDIF

    RTS

@IF vestigialConfig.doubleBufferSelected || vestigialConfig.doubleBuffer

DOUBLEBUFFERINIT:

    LDA #0
    STA TILEMAPVISIBLE
    JSR COPYTILEMAP01

    RTS

DOUBLEBUFFERCLEANUP:

    LDA TILEMAPVISIBLE
    BEQ DOUBLEBUFFERCLEANUP2
    JSR SWITCHTILEMAP0

DOUBLEBUFFERCLEANUP2:

    LDA $d018
    AND #$0f
    ORA #$10
    STA $d018
    JSR ONSWITCHTILEMAP
    LDA #0
    STA TILEMAPVISIBLE
    LDA #$84
    STA TEXTADDRESS+1
    RTS

COPYTILEMAP01:

    LDX #<(40*25)
    STX MATHPTR0
    LDX #>(40*25)
    STX MATHPTR0+1
    LDA #00
    STA TMPPTR
    LDA #$84
    STA TMPPTR+1
    LDA #0
    STA TMPPTR2
    LDA #$88
    STA TMPPTR2+1
    JMP CPUMEMMOVE

COPYTILEMAP10:

    LDX #<(40*25)
    STX MATHPTR0
    LDX #>(40*25)
    STX MATHPTR0+1
    LDA #00
    STA TMPPTR
    LDA #$88
    STA TMPPTR+1
    LDA #0
    STA TMPPTR2
    LDA #$84
    STA TMPPTR2+1
    JMP CPUMEMMOVE

SWITCHTILEMAP:

    LDA TILEMAPVISIBLE
    BEQ SWITCHTILEMAP1

SWITCHTILEMAP0:
    LDA $d018
    AND #$0f
    ORA #$10
    STA $d018
    JSR ONSWITCHTILEMAP
    LDA #0
    STA TILEMAPVISIBLE
    LDA #$88
    STA TEXTADDRESS+1

    JSR COPYTILEMAP01

    RTS

SWITCHTILEMAP1:
    LDA $d018
    AND #$0f
    ORA #$20
    STA $d018
    JSR ONSWITCHTILEMAP
    LDA #1
    STA TILEMAPVISIBLE
    LDA #$84
    STA TEXTADDRESS+1

    JSR COPYTILEMAP10

    RTS
    
@ENDIF


    ; Decompress RLE encoded images.
    ;
    ; Input: 
    ;   - TMPPTR: pointer to the data to read
    ; Output:
    ;   - A: next byte read
    ;   - C: if EOB
    ;
    ;

RLEY:           .BYTE $0
RLECURRENT:     .BYTE $0
RLECOUNT:       .BYTE $0

RLEREADCHAR:
    LDY #0
    LDA (TMPPTR), Y
    INC TMPPTR
    BNE RLEREADCHARA1
    INC TMPPTR+1
RLEREADCHARA1:
    STA RLECURRENT
    RTS

RLEDECOMPRESSDONE:
    SEC
    LDY RLEY
    RTS

RLEDECOMPRESS:

    STY RLEY

    LDA RLECOUNT

    BEQ RLEDECOMPRESS2
    
    DEC RLECOUNT

    LDA #1
    BNE RLEDECOMPRESSVALUE

RLEDECOMPRESS2:

    ; // Take the current token from the input stream
    ; // and move to the next element of the stream.

    JSR RLEREADCHAR

    ; // A token of zero (0xfe) means "end of block".
    ; // Nothing must be done.

    CMP #$FE
    BEQ RLEDECOMPRESSDONE

    ; // If the value of token is 0xff...

    CMP #$FF
    BEQ RLEDECOMPRESSFF

RLEDECOMPRESSVALUEASIS:
    LDY RLEY
    LDA RLECURRENT
    CLC
    RTS

RLEDECOMPRESSFF:

    ; // Read the next.

    JSR RLEREADCHAR

    ; // If it is 0xff, it means that is 0xff, actually!

    CMP #$FF
    BEQ RLEDECOMPRESSVALUEASIS

    ; // Store the count

    STA RLECOUNT

    ; // Read the next.

    JSR RLEREADCHAR

    ; // Decrement the count

    DEC RLECOUNT

RLEDECOMPRESSVALUE:
    LDY RLEY
    LDA RLECURRENT
    CLC
    RTS



