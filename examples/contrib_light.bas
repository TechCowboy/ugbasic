REM @english
REM OTHER CONTRIBUTIONS LIGHT!
REM
REM This small example will put an image on the screen.
REM 
REM @italian
REM VARI ALTRI CONTRIBUTI LIGHT!
REM
REM Questo piccolo esempio disegna una immagine sullo schermo.
REM

    BITMAP ENABLE(16)
    CLS
    COLOR BORDER BLACK
    light := LOAD IMAGE("examples/light.png")

    PUT IMAGE light AT 0,0