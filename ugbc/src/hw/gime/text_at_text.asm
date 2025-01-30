; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2025 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License");
;  * you may not use this file except in compliance with the License.
;  * You may obtain a copy of the License at
;  *
;  * http//www.apache.org/licenses/LICENSE-2.0
;  *
;  * Unless required by applicable law or agreed to in writing, software
;  * distributed under the License is distributed on an "AS IS" BASIS
;  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;  * See the License for the specific language governing permissions and
;  * limitations under the License.
;  *----------------------------------------------------------------------------
;  * Concesso in licenza secondo i termini della Licenza Apache, versione 2.0
;  * (la "Licenza"); è proibito usare questo file se non in conformità alla
;  * Licenza. Una copia della Licenza è disponibile all'indirizzo
;  *
;  * http//www.apache.org/licenses/LICENSE-2.0
;  *
;  * Se non richiesto dalla legislazione vigente o concordato per iscritto
;  * il software distribuito nei termini della Licenza è distribuito
;  * "COSì COM'è", SENZA GARANZIE O CONDIZIONI DI ALCUN TIPO, esplicite o
;  * implicite. Consultare la Licenza per il testo specifico che regola le
;  * autorizzazioni e le limitazioni previste dalla medesima.
;  ****************************************************************************/
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                                                                             *
;*                      TEXT AT GIVEN POSITION ON GIME                         *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    ; This small routine is useful to calculate the starting address of
    ; textual video ram, given the current X and Y cursors coordinates.

CALCPOS

    ; Start from the beginning of the video RAM.

    LDX TEXTADDRESS
    STX <COPYOFTEXTADDRESS

    ; Load the number of rows to move ahead.

    LDB <YCURSYS

    ; If zero, we can skip this step.

    BEQ CALCPOSSKIP

    ; Load the size of a video text screen line.

    LDA CURRENTTILESWIDTH

    ; For each row...

CALCPOSLOOP1

    ; Increment the address of the size of a row:
    ; we have to increment the address twice,
    ; since each character has a character code
    ; and a character attribute.

    ANDCC #$FE
    PSHS D
    TFR A, B
    ABX
    ABX
    PULS D

    ; Decrement the number of rows.

    DECB

    ; Until the rows are finished, let's go ahead!

    BNE CALCPOSLOOP1

CALCPOSSKIP

    ; Now we can add the X position. Again, twice.
    LDA <XCURSYS
    PSHS D
    TFR A, B
    ABX
    ABX
    PULS D    

    ; Store the position.
    STX <COPYOFTEXTADDRESS

    RTS

    ; This small routine will print a string on the screen, when
    ; in text mode. This routine will try to avoid to do anything
    ; if in graphic mode and / or the string is empty.

TEXTATTILEMODE

    ; Avoid to do anything if we are in graphic mode.
    LDA CURRENTMODE
    ANDA #$10
    BEQ TEXTATTILEMODEGO
    RTS

TEXTATTILEMODEGO

    ; Avoid to do anything if there is no text to print.
    LDA <TEXTSIZE
    BNE TEXTATGO
    RTS

    ; The routine starts here!

TEXTATGO

    ; Prepare the color

    LDB _PEN
    JSR GIMESELECTPALETTEPEN
    LSLA
    LSLA
    LSLA
    STA <PLOTC
    LDB _PAPER
    JSR GIMESELECTPALETTEPAPER
    ORA <PLOTC
    STA <PLOTC

    ; Load the starting address of the video ram
    ; in a specific location, as a copy. This makes
    ; possible to calculate the exact position where
    ; to write, based on the actual cursor position.

    JSR CALCPOS

    ; Initialize the counter for printing tabs.

    LDA #0
    STA <TABSTODRAW

    ; Load in Y register the starting address of the
    ; string to print on the video RAM.

    LDY <TEXTPTR

    ; Load in B the size of the string.

    LDB <TEXTSIZE

    ; When program reach this point, we are going to
    ; print the next character.

TEXTATLOOP2

    ; If there are TABs to print, we have to skip the printing.

    LDA <TABSTODRAW
    LBNE TEXTATSKIPTAB

    ; Load the character from the string and move it into the
    ; A register, offseted by Y. Move ahead of one character and
    ; decrement the size of the string.

    ; The PRINT primitive should have control if it is necessary to bank 
    ; in the RAM and, if necessary, to differentiate the drawing logic.
    ; However, since the font is probably in the screen segment,
    ; there is no reason to differentiate.

    JSR GIMEBANKROM
    LDA ,Y+
    DECB

    ; All characters from 0 to 31 are special, so we mu9t
    ; parse it, if needed. If the character is higher,
    ; we can simply print it.

    CMPA #31
    LBHI TEXTATSP0

    ; Let's go to decode the special character.

    JMP TEXTATCC

    ; This code will be executed if a TAB character is found
    ; in the string. In that case, the character will be
    ; translated in enough spaces until we reach the next
    ; TAB marker on the screen.

TEXTATTAB

    ; In order to calculate where to print the next character
    ; after the TAB character, we start considering the
    ; current X position. If the current position is greater
    ; than the number of spaces equivalent to a TAB, we subtract
    ; the number of spaces from the current X position, until
    ; we reach that limit. The complement is the number of spaces
    ; that will be printed out to reach the next TAB marker.

    ; Loop until X cursor position is greater than tab count.

    LDA <XCURSYS
TEXTATTAB2
    CMPA TABCOUNT
    BLO TEXTATTAB3
    ANDCC #$01
    SUBA TABCOUNT
    JMP TEXTATTAB2

    ; Calculate the complement for tab count.

TEXTATTAB3
    STA <TMPPTR
    LDA TABCOUNT
    ANDCC #$01
    SUBA <TMPPTR
    STA <TABSTODRAW

    ; Move to the next character to print.

    JMP TEXTATNEXT

    ; This code will be executed if a special character
    ; has to be decoded. 

TEXTATCC

    ; CR -> move ahead and down like a line feed
    CMPA #13
    BEQ TEXTATLF

    ; LF -> move ahead and down like a line feed
    CMPA #10
    BEQ TEXTATLF

    ; TAB -> move to the next tab marker
    CMPA #09
    BEQ TEXTATTAB

    ; PEN -> change the pen color
    CMPA #01    
    BEQ TEXTATPEN

    ; PAPER -> change the paper color
    CMPA #02
    BEQ TEXTATPAPER

    ; CMOVE -> move the cursor to a relative position
    CMPA #03
    LBEQ TEXTATCMOVEPREPARE

    ; AT -> move the cursor to an absolute position
    CMPA #04
    LBEQ TEXTATAT

    ; CLS -> clear the screen
    CMPA #05
    BEQ TEXTATCLS

    ; Move to the next character to print.

    JMP TEXTATNEXT

    ; This routine will process a clear screen embedded command
    ; into the string to print.

TEXTATCLS

    JSR CLST

    ; Move to the next character to print.

    JMP TEXTATNEXT

    ; This routine will process a LF command.

TEXTATLF

    ; ; In order to move to the next line, I have to move ahead of
    ; ; an entire line, and "come back" for a number of character
    ; ; that is equal to the horizontal position. Move one character
    ; ; back and update the address.

    ; LDA CURRENTTILESWIDTH
    ; SUBA <XCURSYS
    ; SUBA #1
    ; PSHS D
    ; TFR A, B
    ; ABX
    ; PULS D

    ; ; Move to the routine that should scroll the video if we are
    ; ; printing on the last line of the screen.

    JMP TEXTATNEXT2

    ; This routine will change the current pen color, used for
    ; the following writing texts.

TEXTATPEN

    ; Load the parameter from the next character.
    LDA , Y+
    DECB

    ; A parameter of $FF means $00.
    CMPA #$FF
    BNE TEXTATPEN2
    LDA #$0
TEXTATPEN2
    PSHS D
    STA _PEN
    LDA <PLOTC
    ANDA #$C7
    STA <PLOTC
    LDB _PEN
    JSR GIMESELECTPALETTEPEN
    LSLA
    LSLA
    LSLA
    ORA <PLOTC
    STA <PLOTC
    PULS D

    ; Move to the next character to print.

    JMP TEXTATNEXT

    ; This routine will change the current paper color, used for
    ; the following writing texts.

TEXTATPAPER

    ; Load the parameter from the next character.
    LDA , Y+
    DECB

    ; Save the paper.
    ; A parameter of $FF means $00.
    CMPA #$FF
    BNE TEXTATPAPER2
    LDA #$0
TEXTATPAPER2
    PSHS D
    STA _PAPER
    LDA <PLOTC
    ANDA #$F8
    STA <PLOTC
    LDB _PAPER
    JSR GIMESELECTPALETTEPAPER
    ORA <PLOTC
    STA <PLOTC
    PULS D

    ; Move to the next character to print.

    JMP TEXTATNEXT

    ; This routine will move the current cursor position on a relative
    ; position.

TEXTATCMOVEPREPARE

    ; Load and store the delta on abscissa.

    LDA , Y+
    DECB
    STA <CLINEX

    ; Load and store the delta on ordinate.
    
    LDA , Y+
    DECB
    STA <CLINEY

    ; This routine will move the current cursor position
    ; on an absolute position.

TEXTATCMOVE

    ; To calculate the absolute position we are going to
    ; add the delta to the current horizontal position.

    ANDCC #$FE
    LDA <CLINEX
    ADDA <XCURSYS

    ; If the calculated horizontal position is negative,
    ; we have nothing to do.

    CMPA #$0
    BLT TEXTATCMOVESKIPX

    ; If the calculated horizontal position is over
    ; the lenght of the line, we have nothing to do.

    CMPA CURRENTTILESWIDTH
    BGE TEXTATCMOVESKIPX

    ; Store the new horizontal position.

    STA <XCURSYS

    ; Update the address by delta.

    LDA <CLINEX
    ;LDX <COPYOFTEXTADDRESS
    PSHS D
    TFR A, B
    ABX
    ABX
    PULS D
    ;STX <COPYOFTEXTADDRESS

TEXTATCMOVESKIPX

    ; To calculate the absolute position we are going to
    ; add the delta to the current vertical position.

    ANDCC #$FE
    LDA <CLINEY
    ADDA <YCURSYS

    ; If the calculated vertical position is negative,
    ; we have nothing to do.

    CMPA #$0
    BLT TEXTATCMOVESKIPY

    ; If the calculated vertical position is over
    ; the lenght of the screen, we have nothing to do.

    CMPA CURRENTTILESHEIGHT
    BGE TEXTATCMOVESKIPY

    ; Store the new vertical position.

    STA <YCURSYS

    ; Update the address by delta.

    PSHS D
    LDA <CLINEY
    ANDA #$80
    CMPA #$80
    BEQ TEXTATCMOVELOOPYM
    LDA CURRENTTILESWIDTH
    LDB <CLINEY
    MUL
    LSLB
    ROLA
    LEAX D, X
    JMP TEXTATCMOVELOOPY0
TEXTATCMOVELOOPYM
    LDA CURRENTTILESWIDTH
    LDB <CLINEY
    NEGB
    MUL
    LSLB
    ROLA
    NEGA
    NEGB
    SBCA #0
    LEAX D, X
    JMP TEXTATCMOVELOOPY0
TEXTATCMOVELOOPY0
    ; STX <COPYOFTEXTADDRESS
    PULS D

TEXTATCMOVESKIPY

    ; Move to the next character to print.

    JMP TEXTATNEXT

    ; This routine will prepare the delta to move the cursor
    ; to an absolute position, to print.

TEXTATAT

    ; The horizontal delta is calculated started from
    ; the current position.

    LDA , Y+
    DECB
    ANDCC #$01
    SUBA <XCURSYS
    ADDA CONSOLEX1
    STA <CLINEX

    ; The vertical delta is calculated started from
    ; the current position.

    LDA , Y+
    DECB
    ANDCC #$01
    SUBA <YCURSYS
    ADDA CONSOLEY1
    STA <CLINEY

    ; Change the position like a CMOVE.

    JMP TEXTATCMOVE

    ; Print the character on the screen.

TEXTATSP0

    JSR GIMEBANKVIDEO
    STA , X+

TEXTATSP0C

    LDA <PLOTC
    STA , X
    LEAX 1, X
    JMP TEXTATINCX

    ; If the program reach this point, it means that must skip
    ; the character in order to move the cursor ahead by one
    ; character, to move to the next tab marker.

TEXTATSKIPTAB
    DEC <TABSTODRAW
    LEAX 1, X
    JMP TEXTATINCX

    ; Go ahead by one character.

TEXTATINCX

    ; Increment the current horizontal position.

    INC <XCURSYS

    ; Exit if the string is ended
    
    LDA <TABSTODRAW
    CMPA 0
    BNE TEXTATNEXT

    CMPB #0
    LBEQ TEXTATEND2

    ; If the current horizontal position is at the end
    ; of the line, we must increment the vertical position.

    LDA <XCURSYS
    CMPA CONSOLEX2
    BGT TEXTATNEXT2

    ; Move to the next character to print.

    JMP TEXTATNEXT

TEXTATNEXT2

    ; Put 0 as horizontal position.

    LDA CONSOLEX1
    STA <XCURSYS

    ; Increment the vertical position.

    INC <YCURSYS

    ; Update the video ram address.

    STX <COPYOFTEXTADDRESS

    ; If the current vertical position is at the end
    ; of the screen, we must scroll the screen.

    LDA <YCURSYS
    CMPA CONSOLEY2
    BGT TEXTATNEXT3

    ; Move to the next character to print.

    JMP TEXTATNEXT

TEXTATNEXT3

    ; Let's scroll vertically

    LDA #$FE
    STA <DIRECTION
    JSR VSCROLLT

    ; Decrement the current vertical position, since
    ; now the last line is not last anymore.

    DEC <YCURSYS

    ; Update the current address video RAM, as well.

    ANDCC #$01
    LDA #0
    SUBA CURRENTTILESWIDTH
    LDX <COPYOFTEXTADDRESS
    PSHS D
    TFR A, B
    ABX
    ABX
    PULS D
    STX <COPYOFTEXTADDRESS

    ; Manage for the next character to print.

TEXTATNEXT

    ; If there are characters to skip to reach
    ; tabs marker, move ahead and loop.

    LDA <TABSTODRAW
    LBNE TEXTATLOOP2

    ; If there are still characters to print,
    ; loop again.
    
    CMPB #0
    BEQ TEXTATEND2
    
    ; JSR GIMEBANKROM

    JMP TEXTATLOOP2

TEXTATEND2
    RTS
