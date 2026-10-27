VSIN:
     DIG1$ = LEFT$(SINUM$, 1)
     DIG2$ = MID$(SINUM$, 2, 1)
     DIG3$ = MID$(SINUM$, 3, 1)
     DIG4$ = MID$(SINUM$, 4, 1)
     DIG5$ = MID$(SINUM$, 5, 1)
     DIG6$ = MID$(SINUM$, 6, 1)
     DIG7$ = MID$(SINUM$, 7, 1)
     DIG8$ = MID$(SINUM$, 8, 1)
     DIG9$ = MID$(SINUM$, 9, 1)
     UNITNUM$ = DIG2$ + DIG4$ + DIG6$ + DIG8$
     UNITNUMB% = VAL(UNITNUM$): UNITNUMB% = UNITNUMB% * 2
     TOT$ = STR$(UNITNUMB%)
     REM dg0$ and dg5$ are dummies for sign and provision for larger length
     DG0$ = LEFT$(TOT$, 1)
     DG1$ = MID$(TOT$, 2, 1)
     DG2$ = MID$(TOT$, 3, 1)
     DG3$ = MID$(TOT$, 4, 1)
     DG4$ = MID$(TOT$, 5, 1)
     DG5$ = MID$(TOT$, 6, 1):
     X = VAL(DG0$) + VAL(DG1$) + VAL(DG2$) + VAL(DG3$) + VAL(DG4$) + VAL(DG5$)
     Y = VAL(DIG1$) + VAL(DIG3$) + VAL(DIG5$) + VAL(DIG7$)
     Z = X + Y
     REM PRINT X,Y,Z
     W% = Z / 10: NEXTNUM = (W% * 10): IF NEXTNUM < Z THEN NEXTNUM = NEXTNUM + 10
     CHECKDG = NEXTNUM - Z: REM PRINT CHECKDG
     IF CHECKDG = VAL(DIG9$) THEN SINSTATUS$ = "y" ELSE SINSTATUS$ = "n"
RETURN
