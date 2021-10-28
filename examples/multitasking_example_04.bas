REM @english
REM MULTI TASKING FOR DUMMIES (4)
REM
REM This example will show how to use a separate variable for each task.
REM
REM @italian
REM USARE IL MULTITASKING CON UN ESEMPIO (4)
REM
REM Questo esempio mostrerà come usare variabili separate per ogni task.

    DIM x WITH 0 (3)
    GLOBAL x

    PARALLEL PROCEDURE example
        DO
            [x] = [x] + 1
            PRINT [x];" ";
        LOOP
    END PROC

    SPAWN example
    SPAWN example
    SPAWN example

    DO
            RUN PARALLEL
    LOOP

    HALT
