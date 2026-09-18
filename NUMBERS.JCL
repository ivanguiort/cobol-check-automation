//NUMBERSJ JOB 1,NOTIFY=&SYSUID
//*******************************************************
//* COMPILACIÓN Y ENLAZADO DEL PROGRAMA COBOL CON TESTS
//*******************************************************
//COBRUN EXEC IGYWCL
//COBOL.SYSIN DD DSN=&SYSUID..CBL(NUMBERS),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(NUMBERS),DISP=SHR
//*******************************************************
//* EJECUCIÓN: SI LA COMPILACIÓN FUE EXITOSA (RC = 0)
//*******************************************************
// IF RC = 0 THEN
//RUN EXEC PGM=NUMBERS
//STEPLIB DD DSN=&SYSUID..LOAD,DISP=SHR
//ACCTREC DD DSN=&SYSUID..DATOS(DAT),DISP=SHR
//PRTLINE DD SYSOUT=*,OUTLIM=15000
//SYSOUT  DD SYSOUT=*,OUTLIM=15000
//CEEDUMP DD DUMMY
//SYSUDUMP DD DUMMY
// ENDIF
