﻿REM OTHER CONTRIBUTIONS ASSEMBLY FOR BEGINNERS (SHARP SM83)
REM
REM This is a short program that shows how easy it is to learn assembly 
REM with ugBASIC. Since version 1.14.1, in fact, it allows you to insert 
REM assembly code online. Clearly accessing all the BASIC features. 
REM This program shows how a 16-bit (2 x 8-bit) addition works under
REM the SHARP SM83 processor.
REM 
REM @italian
REM VARI ALTRI CONTRIBUTI ASSEMBLY PER PRINCIPIANTI (ZILOG Z80)
REM
REM Questo è un breve programma che mostra come sia facile imparare 
REM l'assembly con ugBASIC. Dalla versione 1.14.1, infatti, permette
REM di inserire codice assembly in linea. Accedendo, chiaramente, a 
REM tutte le caratteristiche del BASIC. Questo programma mostra come 
REM si opera una somma a 16 bit (2 x 8 bit) con il processore SHARP SM83.
REM 
REM @include gb

	DIM x AS INTEGER, y AS INTEGER, z AS INTEGER

	CLS

	x = 10: y = 40: z = 0

	PRINT x;" + "; y; " = ";

	ON CPUSM83 BEGIN ASM

		LD HL, (_x)
		LD DE, HL
		LD HL, (_y)
		
		ADD HL, DE
		
		LD (_z), HL
		
	END ASM

	PRINT z
