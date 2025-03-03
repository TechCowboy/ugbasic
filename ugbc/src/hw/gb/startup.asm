; /*****************************************************************************
;  * ugBASIC - an isomorphic BASIC language compiler for retrocomputers        *
;  *****************************************************************************
;  * Copyright 2021-2024 Marco Spedaletti (asimov@mclink.it)
;  *
;  * Licensed under the Apache License, Version 2.0 (the "License
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
;  * (la "Licenza è proibito usare questo file se non in conformità alla
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
;*                          STARTUP ROUTINE FOR GB                             *
;*                                                                             *
;*                             by Marco Spedaletti                             *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;*
;* Gameboy Hardware definitions
;*
;* Based on Jones' hardware.inc
;* And based on Carsten Sorensen's ideas.
;* Includes adapted by Marco Spedaletti for ugBASIC
;*
;* Rev 1.1 - 15-Jul-97 : Added define check
;* Rev 1.2 - 18-Jul-97 : Added revision check macro
;* Rev 1.3 - 19-Jul-97 : Modified for RGBASM V1.05
;* Rev 1.4 - 27-Jul-97 : Modified for new subroutine prefixes
;* Rev 1.5 - 15-Aug-97 : Added _HRAM, PAD, CART defines
;*                     :  and Nintendo Logo
;* Rev 1.6 - 30-Nov-97 : Added rDIV, rTIMA, rTMA, & rTAC
;* Rev 1.7 - 31-Jan-98 : Added _SCRN0, _SCRN1
;* Rev 1.8 - 15-Feb-98 : Added rSB, rSC
;* Rev 1.9 - 16-Feb-98 : Converted I/O registers to $FFXX format
;* Rev 2.0 -           : Added GBC registers
;* Rev 2.1 -           : Added MBC5 & cart RAM enable/disable defines
;* Rev 2.2 -           : Fixed NR42,NR43, & NR44 equates
;* Rev 2.3 -           : Fixed incorrect _HRAM equate
;* Rev 2.4 - 27-Apr-13 : Added some cart defines (AntonioND)
;* Rev 2.5 - 03-May-15 : Fixed format (AntonioND)
;* Rev 2.6 - 09-Apr-16 : Added GBC OAM and cart defines (AntonioND)
;* Rev 2.7 - 19-Jan-19 : Added rPCMXX (ISSOtm)
;* Rev 2.8 - 03-Feb-19 : Added audio registers flags (Álvaro Cuesta)
;* Rev 2.9 - 28-Feb-20 : Added utility rP1 constants
;* Rev 3.0 - 27-Aug-20 : Register ordering, byte-based sizes, OAM additions, general cleanup (Blitter Object)
;* Rev 4.0 - 03-May-21 : Updated to use RGBDS 0.5.0 syntax, changed IEF_LCDC to IEF_STAT (Eievui)

; If all of these are already defined, don't do it again.

HARDWARE_INC EQU 1

_VRAM        EQU $8000 ; $8000->$9FFF
_VRAM8000    EQU _VRAM
_VRAM8800    EQU _VRAM+$800
_VRAM9000    EQU _VRAM+$1000
_SCRN0       EQU $9800 ; $9800->$9BFF
_SCRN1       EQU $9C00 ; $9C00->$9FFF
_SRAM        EQU $A000 ; $A000->$BFFF
_RAM         EQU $C000 ; $C000->$CFFF / $C000->$DFFF
_RAMBANK     EQU $D000 ; $D000->$DFFF
_OAMRAM      EQU $FE00 ; $FE00->$FE9F
_IO          EQU $FF00 ; $FF00->$FF7F,$FFFF
_AUD3WAVERAM EQU $FF30 ; $FF30->$FF3F
_HRAM        EQU $FF80 ; $FF80->$FFFE

; *** MBC5 Equates ***

rRAMG        EQU $0000 ; $0000->$1fff
rROMB0       EQU $2000 ; $2000->$2fff
rROMB1       EQU $3000 ; $3000->$3fff - If more than 256 ROM banks are present.
rRAMB        EQU $4000 ; $4000->$5fff - Bit 3 enables rumble (if present)


;***************************************************************************
;*
;* Custom registers
;*
;***************************************************************************

; --
; -- P1 ($FF00)
; -- Register for reading joy pad info. (R/W)
; --
rP1 EQU $FF00

P1F_5 EQU %00100000 ; P15 out port, set to 0 to get buttons
P1F_4 EQU %00010000 ; P14 out port, set to 0 to get dpad
P1F_3 EQU %00001000 ; P13 in port
P1F_2 EQU %00000100 ; P12 in port
P1F_1 EQU %00000010 ; P11 in port
P1F_0 EQU %00000001 ; P10 in port

P1F_GET_DPAD EQU P1F_5
P1F_GET_BTN  EQU P1F_4
P1F_GET_NONE EQU P1F_4 | P1F_5


; --
; -- SB ($FF01)
; -- Serial Transfer Data (R/W)
; --
rSB EQU $FF01


; --
; -- SC ($FF02)
; -- Serial I/O Control (R/W)
; --
rSC EQU $FF02


; --
; -- DIV ($FF04)
; -- Divider register (R/W)
; --
rDIV EQU $FF04


; --
; -- TIMA ($FF05)
; -- Timer counter (R/W)
; --
rTIMA EQU $FF05


; --
; -- TMA ($FF06)
; -- Timer modulo (R/W)
; --
rTMA EQU $FF06


; --
; -- TAC ($FF07)
; -- Timer control (R/W)
; --
rTAC EQU $FF07

TACF_START  EQU %00000100
TACF_STOP   EQU %00000000
TACF_4KHZ   EQU %00000000
TACF_16KHZ  EQU %00000011
TACF_65KHZ  EQU %00000010
TACF_262KHZ EQU %00000001


; --
; -- IF ($FF0F)
; -- Interrupt Flag (R/W)
; --
rIF EQU $FF0F


; --
; -- AUD1SWEEP/NR10 ($FF10)
; -- Sweep register (R/W)
; --
; -- Bit 6-4 - Sweep Time
; -- Bit 3   - Sweep Increase/Decrease
; --           0: Addition    (frequency increases???)
; --           1: Subtraction (frequency increases???)
; -- Bit 2-0 - Number of sweep shift (# 0-7)
; -- Sweep Time: (n*7.8ms)
; --
rNR10 EQU $FF10
rAUD1SWEEP EQU rNR10

AUD1SWEEP_UP   EQU %00000000
AUD1SWEEP_DOWN EQU %00001000


; --
; -- AUD1LEN/NR11 ($FF11)
; -- Sound length/Wave pattern duty (R/W)
; --
; -- Bit 7-6 - Wave Pattern Duty (00:12.5% 01:25% 10:50% 11:75%)
; -- Bit 5-0 - Sound length data (# 0-63)
; --
rNR11 EQU $FF11
rAUD1LEN EQU rNR11


; --
; -- AUD1ENV/NR12 ($FF12)
; -- Envelope (R/W)
; --
; -- Bit 7-4 - Initial value of envelope
; -- Bit 3   - Envelope UP/DOWN
; --           0: Decrease
; --           1: Range of increase
; -- Bit 2-0 - Number of envelope sweep (# 0-7)
; --
rNR12 EQU $FF12
rAUD1ENV EQU rNR12


; --
; -- AUD1LOW/NR13 ($FF13)
; -- Frequency low byte (W)
; --
rNR13 EQU $FF13
rAUD1LOW EQU rNR13


; --
; -- AUD1HIGH/NR14 ($FF14)
; -- Frequency high byte (W)
; --
; -- Bit 7   - Initial (when set, sound restarts)
; -- Bit 6   - Counter/consecutive selection
; -- Bit 2-0 - Frequency's higher 3 bits
; --
rNR14 EQU $FF14
rAUD1HIGH EQU rNR14


; --
; -- AUD2LEN/NR21 ($FF16)
; -- Sound Length; Wave Pattern Duty (R/W)
; --
; -- see AUD1LEN for info
; --
rNR21 EQU $FF16
rAUD2LEN EQU rNR21


; --
; -- AUD2ENV/NR22 ($FF17)
; -- Envelope (R/W)
; --
; -- see AUD1ENV for info
; --
rNR22 EQU $FF17
rAUD2ENV EQU rNR22


; --
; -- AUD2LOW/NR23 ($FF18)
; -- Frequency low byte (W)
; --
rNR23 EQU $FF18
rAUD2LOW EQU rNR23


; --
; -- AUD2HIGH/NR24 ($FF19)
; -- Frequency high byte (W)
; --
; -- see AUD1HIGH for info
; --
rNR24 EQU $FF19
rAUD2HIGH EQU rNR24


; --
; -- AUD3ENA/NR30 ($FF1A)
; -- Sound on/off (R/W)
; --
; -- Bit 7   - Sound ON/OFF (1=ON,0=OFF)
; --
rNR30 EQU $FF1A
rAUD3ENA EQU rNR30


; --
; -- AUD3LEN/NR31 ($FF1B)
; -- Sound length (R/W)
; --
; -- Bit 7-0 - Sound length
; --
rNR31 EQU $FF1B
rAUD3LEN EQU rNR31


; --
; -- AUD3LEVEL/NR32 ($FF1C)
; -- Select output level
; --
; -- Bit 6-5 - Select output level
; --           00: 0/1 (mute)
; --           01: 1/1
; --           10: 1/2
; --           11: 1/4
; --
rNR32 EQU $FF1C
rAUD3LEVEL EQU rNR32


; --
; -- AUD3LOW/NR33 ($FF1D)
; -- Frequency low byte (W)
; --
; -- see AUD1LOW for info
; --
rNR33 EQU $FF1D
rAUD3LOW EQU rNR33


; --
; -- AUD3HIGH/NR34 ($FF1E)
; -- Frequency high byte (W)
; --
; -- see AUD1HIGH for info
; --
rNR34 EQU $FF1E
rAUD3HIGH EQU rNR34


; --
; -- AUD4LEN/NR41 ($FF20)
; -- Sound length (R/W)
; --
; -- Bit 5-0 - Sound length data (# 0-63)
; --
rNR41 EQU $FF20
rAUD4LEN EQU rNR41


; --
; -- AUD4ENV/NR42 ($FF21)
; -- Envelope (R/W)
; --
; -- see AUD1ENV for info
; --
rNR42 EQU $FF21
rAUD4ENV EQU rNR42


; --
; -- AUD4POLY/NR43 ($FF22)
; -- Polynomial counter (R/W)
; --
; -- Bit 7-4 - Selection of the shift clock frequency of the (scf)
; --           polynomial counter (0000-1101)
; --           freq=drf*1/2^scf (not sure)
; -- Bit 3 -   Selection of the polynomial counter's step
; --           0: 15 steps
; --           1: 7 steps
; -- Bit 2-0 - Selection of the dividing ratio of frequencies (drf)
; --           000: f/4   001: f/8   010: f/16  011: f/24
; --           100: f/32  101: f/40  110: f/48  111: f/56  (f=4.194304 Mhz)
; --
rNR43 EQU $FF22
rAUD4POLY EQU rNR43


; --
; -- AUD4GO/NR44 ($FF23)
; --
; -- Bit 7 -   Inital
; -- Bit 6 -   Counter/consecutive selection
; --
rNR44 EQU $FF23
rAUD4GO EQU rNR44


; --
; -- AUDVOL/NR50 ($FF24)
; -- Channel control / ON-OFF / Volume (R/W)
; --
; -- Bit 7   - Vin->SO2 ON/OFF (Vin??)
; -- Bit 6-4 - SO2 output level (volume) (# 0-7)
; -- Bit 3   - Vin->SO1 ON/OFF (Vin??)
; -- Bit 2-0 - SO1 output level (volume) (# 0-7)
; --
rNR50 EQU $FF24
rAUDVOL EQU rNR50

AUDVOL_VIN_LEFT  EQU %10000000 ; SO2
AUDVOL_VIN_RIGHT EQU %00001000 ; SO1


; --
; -- AUDTERM/NR51 ($FF25)
; -- Selection of Sound output terminal (R/W)
; --
; -- Bit 7   - Output sound 4 to SO2 terminal
; -- Bit 6   - Output sound 3 to SO2 terminal
; -- Bit 5   - Output sound 2 to SO2 terminal
; -- Bit 4   - Output sound 1 to SO2 terminal
; -- Bit 3   - Output sound 4 to SO1 terminal
; -- Bit 2   - Output sound 3 to SO1 terminal
; -- Bit 1   - Output sound 2 to SO1 terminal
; -- Bit 0   - Output sound 0 to SO1 terminal
; --
rNR51 EQU $FF25
rAUDTERM EQU rNR51

; SO2
AUDTERM_4_LEFT  EQU %10000000
AUDTERM_3_LEFT  EQU %01000000
AUDTERM_2_LEFT  EQU %00100000
AUDTERM_1_LEFT  EQU %00010000
; SO1
AUDTERM_4_RIGHT EQU %00001000
AUDTERM_3_RIGHT EQU %00000100
AUDTERM_2_RIGHT EQU %00000010
AUDTERM_1_RIGHT EQU %00000001


; --
; -- AUDENA/NR52 ($FF26)
; -- Sound on/off (R/W)
; --
; -- Bit 7   - All sound on/off (sets all audio regs to 0!)
; -- Bit 3   - Sound 4 ON flag (read only)
; -- Bit 2   - Sound 3 ON flag (read only)
; -- Bit 1   - Sound 2 ON flag (read only)
; -- Bit 0   - Sound 1 ON flag (read only)
; --
rNR52 EQU $FF26
rAUDENA EQU rNR52

AUDENA_ON    EQU %10000000
AUDENA_OFF   EQU %00000000  ; sets all audio regs to 0!


; --
; -- LCDC ($FF40)
; -- LCD Control (R/W)
; --
rLCDC EQU $FF40

LCDCF_OFF     EQU %00000000 ; LCD Control Operation
LCDCF_ON      EQU %10000000 ; LCD Control Operation
LCDCF_WIN9800 EQU %00000000 ; Window Tile Map Display Select
LCDCF_WIN9C00 EQU %01000000 ; Window Tile Map Display Select
LCDCF_WINOFF  EQU %00000000 ; Window Display
LCDCF_WINON   EQU %00100000 ; Window Display
LCDCF_BG8800  EQU %00000000 ; BG & Window Tile Data Select
LCDCF_BG8000  EQU %00010000 ; BG & Window Tile Data Select
LCDCF_BG9800  EQU %00000000 ; BG Tile Map Display Select
LCDCF_BG9C00  EQU %00001000 ; BG Tile Map Display Select
LCDCF_OBJ8    EQU %00000000 ; OBJ Construction
LCDCF_OBJ16   EQU %00000100 ; OBJ Construction
LCDCF_OBJOFF  EQU %00000000 ; OBJ Display
LCDCF_OBJON   EQU %00000010 ; OBJ Display
LCDCF_BGOFF   EQU %00000000 ; BG Display
LCDCF_BGON    EQU %00000001 ; BG Display
; "Window Character Data Select" follows BG


; --
; -- STAT ($FF41)
; -- LCDC Status   (R/W)
; --
rSTAT EQU $FF41

STATF_LYC     EQU  %01000000 ; LYC=LY Coincidence (Selectable)
STATF_MODE10  EQU  %00100000 ; Mode 10
STATF_MODE01  EQU  %00010000 ; Mode 01 (V-Blank)
STATF_MODE00  EQU  %00001000 ; Mode 00 (H-Blank)
STATF_LYCF    EQU  %00000100 ; Coincidence Flag
STATF_HBL     EQU  %00000000 ; H-Blank
STATF_VBL     EQU  %00000001 ; V-Blank
STATF_OAM     EQU  %00000010 ; OAM-RAM is used by system
STATF_LCD     EQU  %00000011 ; Both OAM and VRAM used by system
STATF_BUSY    EQU  %00000010 ; When set, VRAM access is unsafe


; --
; -- SCY ($FF42)
; -- Scroll Y (R/W)
; --
rSCY EQU $FF42


; --
; -- SCX ($FF43)
; -- Scroll X (R/W)
; --
rSCX EQU $FF43


; --
; -- LY ($FF44)
; -- LCDC Y-Coordinate (R)
; --
; -- Values range from 0->153. 144->153 is the VBlank period.
; --
rLY EQU $FF44


; --
; -- LYC ($FF45)
; -- LY Compare (R/W)
; --
; -- When LY==LYC, STATF_LYCF will be set in STAT
; --
rLYC EQU $FF45


; --
; -- DMA ($FF46)
; -- DMA Transfer and Start Address (W)
; --
rDMA EQU $FF46


; --
; -- BGP ($FF47)
; -- BG Palette Data (W)
; --
; -- Bit 7-6 - Intensity for %11
; -- Bit 5-4 - Intensity for %10
; -- Bit 3-2 - Intensity for %01
; -- Bit 1-0 - Intensity for %00
; --
rBGP EQU $FF47


; --
; -- OBP0 ($FF48)
; -- Object Palette 0 Data (W)
; --
; -- See BGP for info
; --
rOBP0 EQU $FF48


; --
; -- OBP1 ($FF49)
; -- Object Palette 1 Data (W)
; --
; -- See BGP for info
; --
rOBP1 EQU $FF49


; --
; -- WY ($FF4A)
; -- Window Y Position (R/W)
; --
; -- 0 <= WY <= 143
; -- When WY = 0, the window is displayed from the top edge of the LCD screen.
; --
rWY EQU $FF4A


; --
; -- WX ($FF4B)
; -- Window X Position (R/W)
; --
; -- 7 <= WX <= 166
; -- When WX = 7, the window is displayed from the left edge of the LCD screen.
; -- Values of 0-6 and 166 are unreliable due to hardware bugs.
; --
rWX EQU $FF4B


; --
; -- SPEED ($FF4D)
; -- Select CPU Speed (R/W)
; --
rKEY1 EQU $FF4D
rSPD  EQU rKEY1

KEY1F_DBLSPEED EQU %10000000 ; 0=Normal Speed, 1=Double Speed (R)
KEY1F_PREPARE  EQU %00000001 ; 0=No, 1=Prepare (R/W)


; --
; -- VBK ($FF4F)
; -- Select Video RAM Bank (R/W)
; --
; -- Bit 0 - Bank Specification (0: Specify Bank 0; 1: Specify Bank 1)
; --
rVBK EQU $FF4F


; --
; -- HDMA1 ($FF51)
; -- High byte for Horizontal Blanking/General Purpose DMA source address (W)
; -- CGB Mode Only
; --
rHDMA1 EQU $FF51


; --
; -- HDMA2 ($FF52)
; -- Low byte for Horizontal Blanking/General Purpose DMA source address (W)
; -- CGB Mode Only
; --
rHDMA2 EQU $FF52


; --
; -- HDMA3 ($FF53)
; -- High byte for Horizontal Blanking/General Purpose DMA destination address (W)
; -- CGB Mode Only
; --
rHDMA3 EQU $FF53


; --
; -- HDMA4 ($FF54)
; -- Low byte for Horizontal Blanking/General Purpose DMA destination address (W)
; -- CGB Mode Only
; --
rHDMA4 EQU $FF54


; --
; -- HDMA5 ($FF55)
; -- Transfer length (in tiles minus 1)/mode/start for Horizontal Blanking, General Purpose DMA (R/W)
; -- CGB Mode Only
; --
rHDMA5 EQU $FF55

HDMA5F_MODE_GP  EQU %00000000 ; General Purpose DMA (W)
HDMA5F_MODE_HBL EQU %10000000 ; HBlank DMA (W)

; -- Once DMA has started, use HDMA5F_BUSY to check when the transfer is complete
HDMA5F_BUSY EQU %10000000 ; 0=Busy (DMA still in progress), 1=Transfer complete (R)


; --
; -- RP ($FF56)
; -- Infrared Communications Port (R/W)
; -- CGB Mode Only
; --
rRP EQU $FF56

RPF_ENREAD   EQU %11000000
RPF_DATAIN   EQU %00000010 ; 0=Receiving IR Signal, 1=Normal
RPF_WRITE_HI EQU %00000001
RPF_WRITE_LO EQU %00000000


; --
; -- BCPS ($FF68)
; -- Background Color Palette Specification (R/W)
; --
rBCPS EQU $FF68

BCPSF_AUTOINC EQU %10000000 ; Auto Increment (0=Disabled, 1=Increment after Writing)


; --
; -- BCPD ($FF69)
; -- Background Color Palette Data (R/W)
; --
rBCPD EQU $FF69


; --
; -- OCPS ($FF6A)
; -- Object Color Palette Specification (R/W)
; --
rOCPS EQU $FF6A

OCPSF_AUTOINC EQU %10000000 ; Auto Increment (0=Disabled, 1=Increment after Writing)


; --
; -- OCPD ($FF6B)
; -- Object Color Palette Data (R/W)
; --
rOCPD EQU $FF6B


; --
; -- SMBK/SVBK ($FF70)
; -- Select Main RAM Bank (R/W)
; --
; -- Bit 2-0 - Bank Specification (0,1: Specify Bank 1; 2-7: Specify Banks 2-7)
; --
rSVBK EQU $FF70
rSMBK EQU rSVBK


; --
; -- PCM12 ($FF76)
; -- Sound channel 1&2 PCM amplitude (R)
; --
; -- Bit 7-4 - Copy of sound channel 2's PCM amplitude
; -- Bit 3-0 - Copy of sound channel 1's PCM amplitude
; --
rPCM12 EQU $FF76


; --
; -- PCM34 ($FF77)
; -- Sound channel 3&4 PCM amplitude (R)
; --
; -- Bit 7-4 - Copy of sound channel 4's PCM amplitude
; -- Bit 3-0 - Copy of sound channel 3's PCM amplitude
; --
rPCM34 EQU $FF77


; --
; -- IE ($FFFF)
; -- Interrupt Enable (R/W)
; --
rIE EQU $FFFF

IEF_HILO   EQU %00010000 ; Transition from High to Low of Pin number P10-P13
IEF_SERIAL EQU %00001000 ; Serial I/O transfer end
IEF_TIMER  EQU %00000100 ; Timer Overflow
IEF_STAT   EQU %00000010 ; STAT
IEF_VBLANK EQU %00000001 ; V-Blank


;***************************************************************************
;*
;* Flags common to multiple sound channels
;*
;***************************************************************************

; --
; -- Square wave duty cycle
; --
; -- Can be used with AUD1LEN and AUD2LEN
; -- See AUD1LEN for more info
; --
AUDLEN_DUTY_12_5    EQU %00000000 ; 12.5%
AUDLEN_DUTY_25      EQU %01000000 ; 25%
AUDLEN_DUTY_50      EQU %10000000 ; 50%
AUDLEN_DUTY_75      EQU %11000000 ; 75%


; --
; -- Audio envelope flags
; --
; -- Can be used with AUD1ENV, AUD2ENV, AUD4ENV
; -- See AUD1ENV for more info
; --
AUDENV_UP           EQU %00001000
AUDENV_DOWN         EQU %00000000


; --
; -- Audio trigger flags
; --
; -- Can be used with AUD1HIGH, AUD2HIGH, AUD3HIGH
; -- See AUD1HIGH for more info
; --

AUDHIGH_RESTART     EQU %10000000
AUDHIGH_LENGTH_ON   EQU %01000000
AUDHIGH_LENGTH_OFF  EQU %00000000


;***************************************************************************
;*
;* CPU values on bootup (a=type, b=qualifier)
;*
;***************************************************************************

BOOTUP_A_DMG    EQU $01 ; Dot Matrix Game
BOOTUP_A_CGB    EQU $11 ; Color GameBoy
BOOTUP_A_MGB    EQU $FF ; Mini GameBoy (Pocket GameBoy)

; if a=BOOTUP_A_CGB, bit 0 in b can be checked to determine if real CGB or
; other system running in GBC mode
BOOTUP_B_CGB    EQU %00000000
BOOTUP_B_AGB    EQU %00000001   ; GBA, GBA SP, Game Boy Player, or New GBA SP


;***************************************************************************
;*
;* Cart related
;*
;***************************************************************************

; $0143 Color GameBoy compatibility code
CART_COMPATIBLE_DMG     EQU $00
CART_COMPATIBLE_DMG_GBC EQU $80
CART_COMPATIBLE_GBC     EQU $C0

; $0146 GameBoy/Super GameBoy indicator
CART_INDICATOR_GB       EQU $00
CART_INDICATOR_SGB      EQU $03

; $0147 Cartridge type
CART_ROM                     EQU $00
CART_ROM_MBC1                EQU $01
CART_ROM_MBC1_RAM            EQU $02
CART_ROM_MBC1_RAM_BAT        EQU $03
CART_ROM_MBC2                EQU $05
CART_ROM_MBC2_BAT            EQU $06
CART_ROM_RAM                 EQU $08
CART_ROM_RAM_BAT             EQU $09
CART_ROM_MMM01               EQU $0B
CART_ROM_MMM01_RAM           EQU $0C
CART_ROM_MMM01_RAM_BAT       EQU $0D
CART_ROM_MBC3_BAT_RTC        EQU $0F
CART_ROM_MBC3_RAM_BAT_RTC    EQU $10
CART_ROM_MBC3                EQU $11
CART_ROM_MBC3_RAM            EQU $12
CART_ROM_MBC3_RAM_BAT        EQU $13
CART_ROM_MBC5                EQU $19
CART_ROM_MBC5_BAT            EQU $1A
CART_ROM_MBC5_RAM_BAT        EQU $1B
CART_ROM_MBC5_RUMBLE         EQU $1C
CART_ROM_MBC5_RAM_RUMBLE     EQU $1D
CART_ROM_MBC5_RAM_BAT_RUMBLE EQU $1E
CART_ROM_MBC7_RAM_BAT_GYRO   EQU $22
CART_ROM_POCKET_CAMERA       EQU $FC
CART_ROM_BANDAI_TAMA5        EQU $FD
CART_ROM_HUDSON_HUC3         EQU $FE
CART_ROM_HUDSON_HUC1         EQU $FF

; $0148 ROM size
; these are kilobytes
CART_ROM_32KB   EQU $00 ; 2 banks
CART_ROM_64KB   EQU $01 ; 4 banks
CART_ROM_128KB  EQU $02 ; 8 banks
CART_ROM_256KB  EQU $03 ; 16 banks
CART_ROM_512KB  EQU $04 ; 32 banks
CART_ROM_1024KB EQU $05 ; 64 banks
CART_ROM_2048KB EQU $06 ; 128 banks
CART_ROM_4096KB EQU $07 ; 256 banks
CART_ROM_8192KB EQU $08 ; 512 banks
CART_ROM_1152KB EQU $52 ; 72 banks
CART_ROM_1280KB EQU $53 ; 80 banks
CART_ROM_1536KB EQU $54 ; 96 banks

; $0149 SRAM size
; these are kilobytes
CART_SRAM_NONE  EQU 0
CART_SRAM_2KB   EQU 1 ; 1 incomplete bank
CART_SRAM_8KB   EQU 2 ; 1 bank
CART_SRAM_32KB  EQU 3 ; 4 banks
CART_SRAM_128KB EQU 4 ; 16 banks

CART_SRAM_ENABLE  EQU $0A
CART_SRAM_DISABLE EQU $00

; $014A Destination code
CART_DEST_JAPANESE     EQU $00
CART_DEST_NON_JAPANESE EQU $01


;***************************************************************************
;*
;* Keypad related
;*
;***************************************************************************

PADF_DOWN   EQU $80
PADF_UP     EQU $40
PADF_LEFT   EQU $20
PADF_RIGHT  EQU $10
PADF_START  EQU $08
PADF_SELECT EQU $04
PADF_B      EQU $02
PADF_A      EQU $01

PADB_DOWN   EQU $7
PADB_UP     EQU $6
PADB_LEFT   EQU $5
PADB_RIGHT  EQU $4
PADB_START  EQU $3
PADB_SELECT EQU $2
PADB_B      EQU $1
PADB_A      EQU $0


;***************************************************************************
;*
;* Screen related
;*
;***************************************************************************

SCRN_X    EQU 160 ; Width of screen in pixels
SCRN_Y    EQU 144 ; Height of screen in pixels
SCRN_X_B  EQU 20  ; Width of screen in bytes
SCRN_Y_B  EQU 18  ; Height of screen in bytes

SCRN_VX   EQU 256 ; Virtual width of screen in pixels
SCRN_VY   EQU 256 ; Virtual height of screen in pixels
SCRN_VX_B EQU 32  ; Virtual width of screen in bytes
SCRN_VY_B EQU 32  ; Virtual height of screen in bytes


;***************************************************************************
;*
;* OAM related
;*
;***************************************************************************

OAM_COUNT           EQU 40  ; number of OAM entries in OAM RAM

; flags
OAMF_PRI        EQU %10000000 ; Priority
OAMF_YFLIP      EQU %01000000 ; Y flip
OAMF_XFLIP      EQU %00100000 ; X flip
OAMF_PAL0       EQU %00000000 ; Palette number; 0,1 (DMG)
OAMF_PAL1       EQU %00010000 ; Palette number; 0,1 (DMG)
OAMF_BANK0      EQU %00000000 ; Bank number; 0,1 (GBC)
OAMF_BANK1      EQU %00001000 ; Bank number; 0,1 (GBC)

OAMF_PALMASK    EQU %00000111 ; Palette (GBC)

OAMB_PRI        EQU 7 ; Priority
OAMB_YFLIP      EQU 6 ; Y flip
OAMB_XFLIP      EQU 5 ; X flip
OAMB_PAL1       EQU 4 ; Palette number; 0,1 (DMG)
OAMB_BANK1      EQU 3 ; Bank number; 0,1 (GBC)


;*
;* Nintendo scrolling logo
;* (Code won't work on a real GameBoy)
;* (if next lines are altered.)
; NINTENDO_LOGO:
;     DB  $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
;     DB  $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
;     DB  $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E
; ENDM

; Deprecated constants. Please avoid using.

IEF_LCDC   EQU %00000010 ; LCDC (see STAT)

; OAM attributes
; each entry in OAM RAM is 4 bytes (sizeof_OAM_ATTRS)
; RSRESET
OAMA_Y:              DB  1   ; y pos
OAMA_X:              DB  1   ; x pos
OAMA_TILEID:         DB  1   ; tile id
OAMA_FLAGS:          DB  1   ; flags (see below)
sizeof_OAM_ATTRS:    DB  0

WAITSTATE:
    PUSH AF
WAITSTATEL1:
    LDH  A, (rSTAT)
    AND STATF_BUSY
    JR NZ, WAITSTATEL1
    POP AF
    RET

WAITVBL:
    CALL WAITSTATE
    LD A, (rLY)
    CP 144
    JP C, WAITVBL
    RET

SCREENONOFF:
    CP 0
    JR Z, SCREENOFF

    LD A, LCDCF_ON | LCDCF_BGON
    LD [rLCDC], A
    RET
    
SCREENOFF:
    LD A, 0
    LD (rLCDC), A
    RET

WAITSTATEM0:
    PUSH HL
    LD HL, rSTAT
WAITSTATEM0L1:
    BIT 1, (HL)
    JR Z, WAITSTATEM0L1
WAITSTATEM0L2:
.waitBlank
    BIT 1, (HL)
    JR NZ, WAITSTATEM0L2
    POP HL
    RET

IRQSVC:
    PUSH HL
    LD HL,(GBTIMER)
    INC HL
    LD (GBTIMER),HL
    POP HL
@IF deployed.timer
	CALL TIMERMANAGER
@ENDIF
    CALL GBMANAGER
@IF deployed.music
    CALL MUSICPLAYER
@ENDIF
    RETI

IRQTMR:
    RETI

IRQJOY:

@IF deployed.joystick && !joystickConfig.sync
    PUSH AF
    PUSH BC
    CALL JOYSTICKREAD
    POP BC
    POP AF
@ENDIF

    RETI
    
@IF descriptors

@EMIT descriptors.firstFree AS descriptorsCount

COPYUDCCHAR:
    LD HL, UDCCHAR
    LD DE, $8000
    LD BC, descriptorsCount * 8
COPYUDCCHARL1:
    LD A, (HL)
    INC HL
    CALL WAITSTATE
    LD (DE), A
    INC DE
    CALL WAITSTATE
    LD (DE), A
    INC DE
    DEC BC
    LD A, B
    OR C
    JR NZ, COPYUDCCHARL1
    RET    

@ENDIF

GBSTARTUP:
    
    ; Set the default palette.

    CALL WAITSTATE
    LD A, $e4
    LD ($FF47), A
    LD ($FF48), A
    LD ($FF49), A

    LD HL, $FE00
    LD C, 40
GBSTARTUPL1:
    CALL WAITSTATEM0
    LD A, 255
    LD (HL), A
    INC HL
    LD (HL), A
    INC HL
    LD A, 32
    LD (HL), A
    INC HL
    LD A, 0
    LD (HL), A
    INC HL
    DEC C
    JR NZ, GBSTARTUPL1

    LD A, (rLCDC)
    OR $02
    LD (rLCDC), A

@IF deployed.dstring
    CALL DSINIT
@ENDIF

    LD A, $0
    LD ($FF0F), A
    LD A, $15
    LD ($FFFF), A
    EI

    LD HL,GBFREQTABLE
    LD (GBTMPPTR2), HL
    LD HL, GBTMPPTR
    LD A, $0
    LD (HL), A
    INC HL
    LD (HL), A
    LD HL, GBJIFFIES
    LD (HL), A
    LD A, $77
    LD (rAUDVOL), A
    LD A, $FF
    LD (rAUDTERM), A

@IF dataSegment
    LD HL, DATAFIRSTSEGMENT
    LD (DATAPTR), HL
@ENDIF

    RET

SUB_HL_DE:
    PUSH    BC
    LD      B, A

    LD      A, L
    SUB     A, E
    LD      L, A

    LD      A, H
    SBC     A, D
    LD      H, A

    LD      A, B
    POP     BC
    RET

SBC_HL_DE:
    PUSH    BC
    LD      B, A

    LD      A, L
    SBC     A, E
    LD      L, A

    LD      A, H
    SBC     A, D
    LD      H, A

    LD      A, B
    POP     BC
    RET

SBC_HL_BC:
    PUSH    DE
    LD      D, A

    LD      A, L
    SBC     A, C
    LD      L, A

    LD      A, H
    SBC     A, B
    LD      H, A

    LD      A, D
    POP     DE
    RET

ADC_HL_DE:
    JR      NC, ADC_HL_DE_CARRY0
    INC     HL
ADC_HL_DE_CARRY0:
    ADD     HL, DE
    RET

REPLACEMENT_LDIR:
    PUSH    AF

    ; SETUP LOOP
    DEC     BC
    INC     B
    INC     C
REPLACEMENT_LDIR_LOOP:
    LD      A, (HL+)
    LD      (DE+), A

    ; ITERATE
    DEC     C
    JP      NZ, REPLACEMENT_LDIR_LOOP
    DEC     B
    JP      NZ, REPLACEMENT_LDIR_LOOP

    POP     AF
    RET
 
 REPLACEMENT_RLD:
 
    JR      NC, REPLACEMENT_RLD_DORLD

    CALL    REPLACEMENT_RLD_DORLD
    SCF
    RET

REPLACEMENT_RLD_DORLD:

    RLCA
    RLCA
    RLCA
    RLCA

    SLA     A
    RL      (HL)
    ADC     A, 0

    RLA
    RL      (HL)
    ADC     A, 0

    RLA
    RL      (HL)
    ADC     A, 0

    RLA
    RL      (HL)
    ADC     A, 0

    OR      A
    RET

ADC_HL_HL:
    PUSH DE
    LD DE, 0
    RL E
    ADD HL, HL
    ADD HL, DE
    POP DE
    RET

; EXX exchanges BC, DE, and HL with shadow registers with BC', DE', and HL'.
REPLACEMENT_EXX:
    PUSH HL

    LD HL, BC
    PUSH HL
    LD HL, (BCP)
    LD BC, HL
    POP HL
    LD (BCP), HL

    LD HL, DE
    PUSH HL
    LD HL, (DEP)
    LD DE, HL
    POP HL
    LD (DEP), HL

    POP HL

    PUSH DE
    LD DE, HL
    LD HL, (HLP)
    PUSH HL
    LD HL, DE
    LD (HLP), HL
    POP HL
    POP DE

    RET

; ------------------------------------------------------------------------------
; Find the first free tile inside the current last slot.
;  In : -
;  Out: A - free slot, 255 = no free slot present
; ------------------------------------------------------------------------------

TILESETSLOTFINDFREE:

    PUSH HL
    PUSH DE
    PUSH BC
    
    LD B, 32
    LD C, 0

    ; Start from the first tile.

    LD A, (TILESETSLOTLAST)
    SLA A
    SLA A
    SLA A
    SLA A
    SLA A
    LD E, A
    LD D, 0
    LD HL, TILESETSLOTUSED
    ADD HL, DE

TILESETSLOTFINDFREEL1:

    ; Check if, in the actual group of 8 tiles,
    ; any tile is free. If such, move to calculate
    ; the exact number of the tile.

    LD A, (HL)
    CP $FF
    JR NZ, TILESETSLOTFOUNDFREE

    ; Move to the next 8 tiles group.

    INC HL
    INC C

    ; Are there more group tiles?
    ; If so, repeat.

    DEC B
    JR NZ, TILESETSLOTFINDFREEL1

    ; No free tiles left.

    POP BC
    POP DE
    POP HL

    SCF
    CCF

    RET

TILESETSLOTFOUNDFREE:

    ; Calculate the starting offset of the free tiles,
    ; that is the ( group index - last ) x 8.

    LD B, C
    SLA B
    SLA B
    SLA B
    LD C, 0

TILESETSLOTFOUNDFREEL1:

    ; Check if the right most bit is zero. This means
    ; that that tile is free.

    SRA A
    JR NC, TILESETSLOTFOUNDFREEDONE

    ; Increment the offset of the free tile,
    ; and repeat. This branch should always be
    ; executed, since the value must 
    ; have at least one bit to zero.

    INC B
    INC C
    JR TILESETSLOTFOUNDFREEL1

TILESETSLOTFOUNDFREEDONE:

    LD A, B
    
    PUSH AF

    PUSH HL
    LD HL, BITMASK
    LD D, 0
    LD E, C
    ADD HL, DE
    LD A, (HL)
    POP HL
    LD C, A
    LD A, (HL)
    OR C
    LD (HL), A
    
    POP AF

    POP BC
    POP DE
    POP HL

    SCF

    RET

; ------------------------------------------------------------------------------
; Allocate a new slot of used tiles.
;  In : -
;  Out: -
; ------------------------------------------------------------------------------

TILESETSLOTALLOC:
    PUSH HL
    PUSH DE
    PUSH BC

    ; First of all, retrieve the offset inside the
    ; TILESETSLOTUSED for the current last slot.

    LD A, (TILESETSLOTLAST)
    SLA A
    SLA A
    SLA A
    SLA A
    SLA A
    LD E, A
    LD D, 0
    LD HL, TILESETSLOTUSED
    ADD HL, DE

    ; Move to the next last slot: if LAST is reached,
    ; move to the first.

    LD A, (TILESETSLOTLAST)
    INC A
    LD (TILESETSLOTLAST), A
    CP 8
    JR NZ, TILESETSLOTALLOCDONE
    LD A, 1
    LD (TILESETSLOTLAST), A
TILESETSLOTALLOCDONE:

    ; Next, retrieve the offset inside the
    ; TILESETSLOTUSED for the actual last slot.

    PUSH HL

    LD A, (TILESETSLOTLAST)
    SLA A
    SLA A
    SLA A
    SLA A
    SLA A
    LD E, A
    LD D, 0
    LD HL, TILESETSLOTUSED
    ADD HL, DE

    LD D, H
    LD E, L

    POP HL

    ; Copy the 32 bytes (256 used tiles) from
    ; the last to the actual slot.

    LD B, 32
TILESETSLOTALLOCL1:
    LD A, (HL)
    LD (DE), A
    INC HL
    INC DE
    DEC B
    JR NZ, TILESETSLOTALLOCL1

    POP BC
    POP DE
    POP HL

    RET

; ------------------------------------------------------------------------------
; REALLOC THE FREE TILES
;  In : TMPPTR address of IMAGE
;  Out: -
; ------------------------------------------------------------------------------

TILESETSLOTRECALCFREESLOT:

    PUSH HL
    PUSH DE
    PUSH BC

    ; We are going to restore the actual slot with the previous one.
    ; We must do it twice, since we already went forward by 1 slot.

    LD A, (TILESETSLOTLAST)
    DEC A
    CP $0
    JR NZ, TILESETSLOTRECALCFREESLOTA1
    LD A, 7
TILESETSLOTRECALCFREESLOTA1:
    LD (TILESETSLOTLAST), A

    LD A, (TILESETSLOTLAST)
    DEC A
    CP $0
    JR NZ, TILESETSLOTRECALCFREESLOTA2
    LD A, 7
TILESETSLOTRECALCFREESLOTA2:
    LD (TILESETSLOTLAST), A

    CALL TILESETSLOTALLOC

    ; Now wwe retrieve the offset inside the
    ; TILESETSLOTUSED for the current first slot.

    LD A, (TILESETSLOTFIRST)
    SLA A
    SLA A
    SLA A
    SLA A
    SLA A
    LD E, A
    LD D, 0
    LD HL, TILESETSLOTUSED
    ADD HL, DE
; @IF descriptors
;     LD DE, ( descriptorsCount / 8 ) + 1
;     ADD HL, DE
; @ENDIF

    ; Move to the next first slot: if LAST is reached,
    ; move to the first.

    LD A, (TILESETSLOTFIRST)
    INC A
    CP 8
    JR NZ, TILESETSLOTRECALCFREEDONE
    LD A, 1
TILESETSLOTRECALCFREEDONE:
    LD (TILESETSLOTFIRST), A

    ; Next, retrieve the offset inside the
    ; TILESETSLOTUSED for the actual last slot.

    PUSH HL
    LD A, (TILESETSLOTLAST)
    SLA A
    SLA A
    SLA A
    SLA A
    SLA A
    LD E, A
    LD D, 0
    LD HL, TILESETSLOTUSED
    ADD HL, DE
; @IF descriptors
;     LD DE, ( descriptorsCount / 8 ) + 1
;     ADD HL, DE
; @ENDIF
    LD D, H
    LD E, L
    POP HL

    ; Mask the 32 bytes (256 used tiles) from
    ; the first to the actual slot.

    ; LD B, 32 - ( ( descriptorsCount / 8 ) + 1 )
    LD B, 32
TILESETSLOTRECALCL2:
    PUSH HL
    PUSH BC
    LD HL, TILESETSLOTUSED
    LD A, 32
    SBC B
    LD E, A
    LD D, 0
    ADD HL, DE
    LD A, (HL)
    POP BC
    POP HL
    LD C, A
    LD A, (HL)
    XOR $FF
    OR C
    LD C, A
    LD A, (DE)
    AND C
    LD (DE), A
    INC HL
    INC DE
    DEC B
    JR NZ, TILESETSLOTRECALCL2

    POP BC
    POP DE
    POP HL

    RET

TILESETSLOTRESETFREESLOT:
    PUSH HL
    PUSH DE
    PUSH BC

    LD HL, TILESETSLOTUSED
    LD DE, TILESETSLOTUSED+32
    ; LD B, 32 - ( ( descriptorsCount / 8 ) + 1 )
    LD B, 32
TILESETSLOTRESETFREESLOTL1:
    LD A, (HL)
    LD (DE), A
    INC HL
    INC DE
    DEC B
    JR NZ, TILESETSLOTRESETFREESLOTL1

    POP BC
    POP DE
    POP HL

    RET

@IF MSX
PSG_AP: EQU          $a0
PSG_WP: EQU          $a1
PSG_RP: EQU          $a2
@ENDIF

IMF_TOKEN_WAIT1:								EQU $ff
IMF_TOKEN_WAIT2:								EQU $fe
IMF_TOKEN_CONTROL:							EQU $d0
IMF_TOKEN_PROGRAM_CHANGE:					EQU $e0
IMF_TOKEN_NOTE:								EQU $40

IMF_INSTRUMENT_ACOUSTIC_GRAND_PIANO:			EQU $01
IMF_INSTRUMENT_BRIGHT_ACOUSTIC_PIANO:			EQU $02
IMF_INSTRUMENT_ELECTRIC_GRAND_PIANO:			EQU $03
IMF_INSTRUMENT_HONKY_TONK_PIANO:				EQU $04
IMF_INSTRUMENT_ELECTRIC_PIANO1:				EQU $05
IMF_INSTRUMENT_ELECTRIC_PIANO2:				EQU $06
IMF_INSTRUMENT_HARPSICHORD:					EQU $07
IMF_INSTRUMENT_CLAVI:						EQU $08
IMF_INSTRUMENT_CELESTA:						EQU $09
IMF_INSTRUMENT_GLOCKENSPIEL:					EQU $0A
IMF_INSTRUMENT_MUSIC_BOX:					EQU $0B
IMF_INSTRUMENT_VIBRAPHONE:					EQU $0C
IMF_INSTRUMENT_MARIMBA:						EQU $0D
IMF_INSTRUMENT_XYLOPHONE:					EQU $0E
IMF_INSTRUMENT_TUBULAR_BELLS:				EQU $0F
IMF_INSTRUMENT_DULCIMER:						EQU $10
IMF_INSTRUMENT_DRAWBAR_ORGAN:				EQU $11
IMF_INSTRUMENT_PERCUSSIVE_ORGAN:				EQU $12
IMF_INSTRUMENT_ROCK_ORGAN:					EQU $13
IMF_INSTRUMENT_CHURCH_ORGAN:					EQU $14
IMF_INSTRUMENT_REED_ORGAN:					EQU $15
IMF_INSTRUMENT_ACCORDION:					EQU $16
IMF_INSTRUMENT_HARMONICA:					EQU $17
IMF_INSTRUMENT_TANGO_ACCORDION:				EQU $18
IMF_INSTRUMENT_ACOUSTIC_GUITAR_NYLON:			EQU $19
IMF_INSTRUMENT_ACOUSTIC_GUITAR_STEEL:			EQU $1A
IMF_INSTRUMENT_ELECTRIC_GUITAR_JAZZ:			EQU $1B
IMF_INSTRUMENT_ELECTRIC_GUITAR_CLEAN:			EQU $1C
IMF_INSTRUMENT_ELECTRIC_GUITAR_MUTED:			EQU $1D
IMF_INSTRUMENT_OVERDRIVEN_GUITAR:			EQU $1E
IMF_INSTRUMENT_DISTORTION_GUITAR:			EQU $1F
IMF_INSTRUMENT_GUITAR_HARMONICS:				EQU $20
IMF_INSTRUMENT_ACOUSTIC_BASS:				EQU $21
IMF_INSTRUMENT_ELECTRIC_BASS_FINGER:			EQU $22
IMF_INSTRUMENT_ELECTRIC_BASS_PICK:			EQU $23
IMF_INSTRUMENT_FRETLESS_BASS:				EQU $24
IMF_INSTRUMENT_SLAP_BASS_1:					EQU $25
IMF_INSTRUMENT_SLAP_BASS_2:					EQU $26
IMF_INSTRUMENT_SYNTH_BASS_1:					EQU $27
IMF_INSTRUMENT_SYNTH_BASS_2:					EQU $28
IMF_INSTRUMENT_VIOLIN:						EQU $29
IMF_INSTRUMENT_VIOLA:						EQU $2A
IMF_INSTRUMENT_CELLO:						EQU $2B
IMF_INSTRUMENT_CONTRABASS:					EQU $2C
IMF_INSTRUMENT_TREMOLO_STRINGS:				EQU $2D
IMF_INSTRUMENT_PIZZICATO_STRINGS:			EQU $2E
IMF_INSTRUMENT_ORCHESTRAL_HARP:				EQU $2F
IMF_INSTRUMENT_TIMPANI:						EQU $30
IMF_INSTRUMENT_STRING_ENSEMBLE_1:			EQU $31
IMF_INSTRUMENT_STRING_ENSEMBLE_2:			EQU $32
IMF_INSTRUMENT_SYNTHSTRINGS_1:				EQU $33
IMF_INSTRUMENT_SYNTHSTRINGS_2:				EQU $34
IMF_INSTRUMENT_CHOIR_AAHS:					EQU $35
IMF_INSTRUMENT_VOICE_OOHS:					EQU $36
IMF_INSTRUMENT_SYNTH_VOICE:					EQU $37
IMF_INSTRUMENT_ORCHESTRA_HIT:				EQU $38
IMF_INSTRUMENT_TRUMPET:						EQU $39
IMF_INSTRUMENT_TROMBONE:						EQU $3A
IMF_INSTRUMENT_TUBA:							EQU $3B
IMF_INSTRUMENT_MUTED_TRUMPET:				EQU $3C
IMF_INSTRUMENT_FRENCH_HORN:					EQU $3D
IMF_INSTRUMENT_BRASS_SECTION:				EQU $3E
IMF_INSTRUMENT_SYNTHBRASS_1:					EQU $3F
IMF_INSTRUMENT_SYNTHBRASS_2:					EQU $40
IMF_INSTRUMENT_SOPRANO_SAX:					EQU $41
IMF_INSTRUMENT_ALTO_SAX:						EQU $42
IMF_INSTRUMENT_TENOR_SAX:					EQU $43
IMF_INSTRUMENT_BARITONE_SAX:					EQU $44
IMF_INSTRUMENT_OBOE:							EQU $45
IMF_INSTRUMENT_ENGLISH_HORN:					EQU $46
IMF_INSTRUMENT_BASSOON:						EQU $47
IMF_INSTRUMENT_CLARINET:						EQU $48
IMF_INSTRUMENT_PICCOLO:						EQU $49
IMF_INSTRUMENT_FLUTE:						EQU $4A
IMF_INSTRUMENT_RECORDER:						EQU $4B
IMF_INSTRUMENT_PAN_FLUTE:					EQU $4C
IMF_INSTRUMENT_BLOWN_BOTTLE:					EQU $4D
IMF_INSTRUMENT_SHAKUHACHI:					EQU $4E
IMF_INSTRUMENT_WHISTLE:						EQU $4F
IMF_INSTRUMENT_OCARINA:						EQU $50
IMF_INSTRUMENT_LEAD_1_SQUARE:				EQU $51
IMF_INSTRUMENT_LEAD_2_SAWTOOTH:				EQU $52
IMF_INSTRUMENT_LEAD_3_CALLIOPE:				EQU $A7
IMF_INSTRUMENT_LEAD_4_CHIFF:					EQU $54
IMF_INSTRUMENT_LEAD_5_CHARANG:				EQU $55
IMF_INSTRUMENT_LEAD_6_VOICE:					EQU $56
IMF_INSTRUMENT_LEAD_7_FIFTHS:				EQU $57
IMF_INSTRUMENT_LEAD_8_BASS_LEAD:				EQU $58
IMF_INSTRUMENT_PAD_1_NEW_AGE:				EQU $59
IMF_INSTRUMENT_PAD_2_WARM:					EQU $5A
IMF_INSTRUMENT_PAD_3_POLYSYNTH:				EQU $5B
IMF_INSTRUMENT_PAD_4_CHOIR:					EQU $5C
IMF_INSTRUMENT_PAD_5_BOWED:					EQU $5D
IMF_INSTRUMENT_PAD_6_METALLIC:				EQU $5E
IMF_INSTRUMENT_PAD_7_HALO:					EQU $5F
IMF_INSTRUMENT_PAD_8_SWEEP:					EQU $60
IMF_INSTRUMENT_FX_1_RAIN:					EQU $61
IMF_INSTRUMENT_FX_2_SOUNDTRACK:				EQU $62
IMF_INSTRUMENT_FX_3_CRYSTAL:					EQU $63
IMF_INSTRUMENT_FX_4_ATMOSPHERE:				EQU $64
IMF_INSTRUMENT_FX_5_BRIGHTNESS:				EQU $65
IMF_INSTRUMENT_FX_6_GOBLINS:					EQU $66
IMF_INSTRUMENT_FX_7_ECHOES:					EQU $67
IMF_INSTRUMENT_FX_8_SCI_FI:					EQU $68
IMF_INSTRUMENT_SITAR:						EQU $69
IMF_INSTRUMENT_BANJO:						EQU $6A
IMF_INSTRUMENT_SHAMISEN:						EQU $6B
IMF_INSTRUMENT_KOTO:							EQU $6C
IMF_INSTRUMENT_KALIMBA:						EQU $6D
IMF_INSTRUMENT_BAG_PIPE:						EQU $6E
IMF_INSTRUMENT_FIDDLE:						EQU $6F
IMF_INSTRUMENT_SHANAI:						EQU $70
IMF_INSTRUMENT_TINKLE_BELL:					EQU $71
IMF_INSTRUMENT_AGOGO:						EQU $72
IMF_INSTRUMENT_STEEL_DRUMS:					EQU $73
IMF_INSTRUMENT_WOODBLOCK:					EQU $74
IMF_INSTRUMENT_TAIKO_DRUM:					EQU $75
IMF_INSTRUMENT_MELODIC_TOM:					EQU $76
IMF_INSTRUMENT_SYNTH_DRUM:					EQU $77
IMF_INSTRUMENT_REVERSE_CYMBAL:				EQU $78
IMF_INSTRUMENT_GUITAR_FRET_NOISE:			EQU $79
IMF_INSTRUMENT_BREATH_NOISE:					EQU $7A
IMF_INSTRUMENT_SEASHORE:						EQU $7B
IMF_INSTRUMENT_BIRD_TWEET:					EQU $7C
IMF_INSTRUMENT_TELEPHONE_RING:				EQU $7D
IMF_INSTRUMENT_HELICOPTER:					EQU $7E
IMF_INSTRUMENT_APPLAUSE:						EQU $7F
IMF_INSTRUMENT_GUNSHOT:						EQU $80

GBFREQTABLE:    
    DW      -5969,  -5518,  -5094,  -4693,  -4315,  -3958,  -3621,  -3303
    DW      -3002,  -2719,  -2451,  -2199,  -1960,  -1735,  -1523,  -1323
    DW      -1134,   -955,   -787,   -627,   -477,   -336,   -202,    -76
    DW         44,    156,    262,    362,    457,    546,    630,    710
    DW        785,    856,    923,    986,   1046,   1102,   1155,   1205
    DW       1252,    1297,  1339,   1379,   1416,   1452,   1485,   1517
    DW       1547,    1575,  1601,   1626,   1650,   1672,   1693,   1713
    DW       1732,    1750,  1766,   1782,   1797,   1811,   1824,   1837
    DW       1849,    1860,  1870,   1880,   1890,   1899,   1907,   1915
    DW       1922,    1929,  1936,   1942,   1948,   1954,   1959,   1964
    DW       1969,    1973,  1977,   1981,   1985,   1988,   1992,   1995
    DW       1998,    2001,  2003,   2006,   2008,   2010,   2012,   2014
    DW       2016,    2018,  2020,   2021,   2023,   2024,   2025,   2027
    DW       2028,    2029,  2030,   2031,   2032,   2033,   2034,   2034
    DW       2035,    2036,  2036,   2037,   2038,   2038,   2039,   2039

GBSTART:
    SRL A
    JR NC,GBSTART0X
    CALL GBSTART0
GBSTART0X:
    SRL A
    JR NC, GBSTART1X
    CALL GBSTART1
GBSTART1X:
    SRL A
    JR NC, GBSTART2X
    CALL GBSTART2
GBSTART2X:
    SRL A
    JR NC, GBSTART3X
    CALL GBSTART3
GBSTART3X:
    RET

GBSTARTSTOPGEN:
GBSTART0:
    ; PUSH AF
    ; PUSH DE
    ; LD E, $F
    ; CALL GBSTARTVOL0 
    ; POP DE
    ; POP AF
    RET
GBSTART1:
    ; PUSH AF
    ; PUSH DE
    ; LD E, $F
    ; CALL GBSTARTVOL1 
    ; POP DE
    ; POP AF
    RET
GBSTART2:
    ; PUSH AF
    ; PUSH DE
    ; LD E, $F
    ; CALL GBSTARTVOL2 
    ; POP DE
    ; POP AF
    RET
GBSTART3:
    ; PUSH AF
    ; PUSH DE
    ; LD E, $F
    ; CALL GBSTARTVOL3 
    ; LD A, $80
    ; LD (rAUD4GO), A
    ; POP DE
    ; POP AF
    RET

GBSTARTVOL:
    SRL A
    JR NC,GBSTARTVOL0X
    CALL GBSTARTVOL0
GBSTARTVOL0X:
    SRL A
    JR NC, GBSTARTVOL1X
    CALL GBSTARTVOL1
GBSTARTVOL1X:
    SRL A
    JR NC, GBSTARTVOL2X
    CALL GBSTARTVOL2
GBSTARTVOL2X:
    SRL A
    JR NC, GBSTARTVOL3X
    CALL GBSTARTVOL3
GBSTARTVOL3X:
    RET

GBSTARTVOL0:
    PUSH AF
    LD A, E
    AND $0F
    SLA A
    SLA A
    SLA A
    SLA A
    OR $08
    LD (rAUD1ENV), A
    POP AF
    RET

GBSTARTVOL1:
    PUSH AF
    LD A, E
    AND $0F
    SLA A
    SLA A
    SLA A
    SLA A
    OR $08
    LD (rAUD2ENV), A
    POP AF
    RET

GBSTARTVOL2:
    PUSH AF
    LD A, E
    AND $0F
    SRA A
    SRA A
    SLA A
    SLA A
    SLA A
    SLA A
    SLA A
    LD (rAUD3LEVEL), A
    POP AF
    RET

GBSTARTVOL3:
    PUSH AF
    LD A, E
    AND $0F
    SLA A
    SLA A
    SLA A
    SLA A
    OR $08
    LD (rAUD4ENV), A
    POP AF
    RET

GBFREQ:
    CALL GBCALCFREQ
    SRL A
    JR NC, GBFREQ0X
    CALL GBFREQ0T
GBFREQ0X:
    SRL A
    JP NC, GBFREQ1X
    CALL GBFREQ1T
GBFREQ1X:
    SRL A
    JP NC, GBFREQ2X
    CALL GBFREQ2T
GBFREQ2X:
    SRL A
    JP NC, GBFREQ3X
    CALL GBFREQ3T
GBFREQ3X:
    RET

GBCALCFREQ:
    RET

GBFREQ0:
    CALL GBCALCFREQ
GBFREQ0T:
    JMP GBPROGFREQ0

GBFREQ1:
    CALL GBCALCFREQ
GBFREQ1T:
    JMP GBPROGFREQ1

GBFREQ2:
    CALL GBCALCFREQ
GBFREQ2T:
    JMP GBPROGFREQ2

GBFREQ3:
    CALL GBCALCFREQ
GBFREQ3T:
    JMP GBPROGFREQ3

GBPROGFREQ:
    PUSH AF
    SRL A
    JP NC, GBPROGFREQ0X
    CALL GBPROGFREQ0
GBPROGFREQ0X:
    SRL A
    JP NC, GBPROGFREQ1X
    CALL GBPROGFREQ1
GBPROGFREQ1X:
    SRL A
    JP NC, GBPROGFREQ2X
    CALL GBPROGFREQ2
GBPROGFREQ2X:
    SRL A
    JP NC, GBPROGFREQ3X
    CALL GBPROGFREQ3
GBPROGFREQ3X:
    POP AF
    RET

GBPROGFREQ0:
    PUSH AF
    LD A, E
    LD (rAUD1LOW), A
    LD A, D
    OR $80
    LD (rAUD1HIGH), A
    POP AF
    RET

GBPROGFREQ1:
    PUSH AF
    LD A, E
    LD (rAUD2LOW), A
    LD A, D
    OR $80
    LD (rAUD2HIGH), A
    POP AF
    RET

GBPROGFREQ2:
    RET
GBPROGFREQ3:
    PUSH AF
    LD A, D
    AND $f7
    LD (rAUD4POLY), A
    POP AF
    RET

GBPROGDUR:
    SRL A
    JP NC, GBPROGDUR0X
    CALL GBPROGDUR0
GBPROGDUR0X:
    SRL A
    JP NC, GBPROGDUR1X
    CALL GBPROGDUR1
GBPROGDUR1X:
    SRL A
    JP NC, GBPROGDUR2X
    CALL GBPROGDUR2
GBPROGDUR2X:
    SRL A
    JP NC, GBPROGDUR3X
    CALL GBPROGDUR3
GBPROGDUR3X:
    RET

GBPROGDUR0:
    LD (GBAUDIOTIMERS),DE
    RET

GBPROGDUR1:
    LD (GBAUDIOTIMERS+2),DE
    RET

GBPROGDUR2:
    LD (GBAUDIOTIMERS+4),DE
    RET

GBPROGDUR3:
    LD (GBAUDIOTIMERS+6),DE
    RET

GBWAITDUR:
    SRL A
    JP NC, GBWAITDUR0X
    CALL GBWAITDUR0
GBWAITDUR0X:
    SRL A
    JP NC, GBWAITDUR1X
    CALL GBWAITDUR1
GBWAITDUR1X:
    SRL A
    JP NC, GBWAITDUR2X
    CALL GBWAITDUR2
GBWAITDUR2X:
    SRL A
    JP NC, GBWAITDUR3X
    CALL GBWAITDUR3
GBWAITDUR3X:
    RET

READGBTIMER:    
    PUSH HL
    PUSH AF
    LD HL, GBAUDIOTIMERS
    ADD HL, DE
    LD A, (HL)
    LD E, A
    INC HL
    LD A, (HL)
    LD D, A
    POP AF
    POP HL
    RET

WRITEGBTIMER:    
    PUSH HL
    PUSH AF
    LD HL, GBAUDIOTIMERS
    ADD HL, DE
    LD A, E
    LD (HL), A
    INC HL
    LD A, D
    LD (HL), A
    POP AF
    POP HL
    RET

DECGBTIMER:    
    PUSH HL
    PUSH AF
    PUSH DE
    LD HL, GBAUDIOTIMERS
    ADD HL, DE
    LD A, (HL)
    LD E, A
    INC HL
    LD A, (HL)
    LD D, A
    DEC DE
    LD (HL), D
    DEC HL
    LD (HL), E
    POP DE
    POP AF
    POP HL
    RET

GBWAITDUR0:

    LD DE, 0
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBWAITDUR0
    RET
GBWAITDUR1:
    LD DE, 2
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBWAITDUR1
    RET
GBWAITDUR2:
    LD DE, 4
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBWAITDUR2
    RET
GBWAITDUR3:
    LD DE, 6
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBWAITDUR3
    RET

GBPROGPULSE:
    PUSH AF
    SRL A
    JP NC, GBPROGPULSE0X
    CALL GBPROGPULSE0
GBPROGPULSE0X:
    SRL A
    JP NC, GBPROGPULSE1X
    CALL GBPROGPULSE1
GBPROGPULSE1X:
    SRL A
    JP NC, GBPROGPULSE2X
    CALL GBPROGPULSE2
GBPROGPULSE2X:
    SRL A
    JP NC, GBPROGPULSE3X
    CALL GBPROGPULSE3
GBPROGPULSE3X:
    POP AF
    RET

GBPROGPULSE0:
    PUSH AF
    LD A, E
    LD (rAUD1LOW), A
    LD A, (rAUD1HIGH)
    AND $F7
    OR D
    LD (rAUD1HIGH), A
    POP AF
    RET

GBPROGPULSE1:
    PUSH AF
    LD A, E
    LD (rAUD2LOW), A
    LD A, (rAUD2HIGH)
    AND $F7
    OR D
    LD (rAUD2HIGH), A
    POP AF
    RET

GBPROGPULSE2:
GBPROGPULSE3:
    RET

GBPROGCTR:
GBPROGCTR0:
GBPROGCTR1:
GBPROGCTR2:
    RET

GBPROGAD:
GBPROGAD0:
GBPROGAD1:
GBPROGAD2:
    RET

GBPROGSR:
GBPROGSR0:
GBPROGSR1:
GBPROGSR2:
    RET
    
GBSTOP:
    SRL A
    JP NC, GBSTOP0X
    CALL GBSTOP0
GBSTOP0X:
    SRL A
    JP NC, GBSTOP1X
    CALL GBSTOP1
GBSTOP1X:
    SRL A
    JP NC, GBSTOP2X
    CALL GBSTOP2
GBSTOP2X:
    SRL A
    JP NC, GBSTOP3X
    CALL GBSTOP3
GBSTOP3X:
    RET

GBSTOP0:
    PUSH AF
    LD A, (rAUD1ENV)
    AND $07
    LD (rAUD1ENV), A
    POP AF
    RET

GBSTOP1:
    PUSH AF
    LD A, (rAUD2ENV)
    AND $07
    LD (rAUD2ENV), A
    POP AF
    RET

GBSTOP2:
    RET

GBSTOP3:
    PUSH AF
    LD A, (rAUD4ENV)
    AND $07
    LD (rAUD4ENV), A
    POP AF
    RET

GBMANAGER:
    PUSH DE
    PUSH AF
    LD DE, 0
    CALL READGBTIMER
    LD A, E
    OR D
    JR Z, GBMANAGER2D1
    LD DE, 0
    CALL DECGBTIMER
    LD DE, 0
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBMANAGER2D1
    CALL GBSTOP0
GBMANAGER2D1:
    LD DE, 2
    CALL READGBTIMER
    LD A, E
    OR D
    JR Z, GBMANAGER2D2
    LD DE, 2
    CALL DECGBTIMER
    LD DE, 2
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBMANAGER2D2
    CALL GBSTOP1
GBMANAGER2D2:
    LD DE, 4
    CALL READGBTIMER
    LD A, E
    OR D
    JR Z, GBMANAGER2D3
    LD DE, 4
    CALL DECGBTIMER
    LD DE, 4
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBMANAGER2D3
    CALL GBSTOP2
GBMANAGER2D3:
    LD DE, 6
    CALL READGBTIMER
    LD A, E
    OR D
    JR Z, GBMANAGER2D4
    LD DE, 6
    CALL DECGBTIMER
    LD DE, 6
    CALL READGBTIMER
    LD A, E
    OR D
    JR NZ, GBMANAGER2D4
    CALL GBSTOP3
GBMANAGER2D4:
    POP AF
    POP DE
    RET

WAITTIMER:
    LD A, (GBTIMER)
    LD B, A
WAITTIMERL1:
    LD A, (GBTIMER)
    CP B
    JR Z, WAITTIMERL1
    DEC L
    LD A, L
    CP $FF
    JR NZ, WAITTIMER
    DEC H
    LD A, H
    CP $FF
    JR NZ, WAITTIMER
    RET

CONSOLECALCULATE:

    LD A, (CONSOLEH)
    SLA A
    SLA A
    SLA A
    LD (CONSOLEHB), A
    
    LD A, (CONSOLEW)
    LD (CONSOLEWB), A

    RET

CP_DE:
    PUSH AF
    PUSH BC
    LD B, A
    LD A, (DE)
    LD C, A
    LD A, B
    CP C
    POP BC
    POP AF
    RET

ADC_HL_BC:
    JR      NC, ADC_HL_BC_CARRY0
    INC     HL
ADC_HL_BC_CARRY0:
    ADD     HL, BC
    RET

