@Date
@Client_FirstName @Client_LastName
@Client_Street
@Client_City , @Client_Province , @Client_Postal

Dear @Client_Title @Client_LastName

Enclosed are two copies of your completed 1995 Individual Income Tax Return.
Please review your return carefully to ensure there are no ommissions or inaccuracies.

@If @Line_484 >0 then
As you will note on your return you have a Tax Refund in the amount of @Line_484
@Else
As you will note on your return there is a balance due by you in the amount of @Line_485
@Endif

@If @Line_101 >0 then
Please attach the following to your tax return:
@Else
@Endif

@If @Line_101 >0 then
 Copy 2 of T4 slips
@Else
@Endif
@If @Line_113 >0 then
 Copy of T4A slip
@Else
@Endif
@If @Line_114 >0 then
 Copy of T4A(P) slip
@Endif
@If @Line_115 >0 then
 Copy 3 of T4A slips
@Endif
@If @Line_119 >0 then
 Copy 2 of T4U slip
@Endif
@If @Line_120 >0 then
 T5/T3 slips
@Endif
@If @Line_129 >0 then
 T4RSP slips
@Endif
@If @Line_208 >0 then
 RRSP receipts
@Endif
@If @Line_212 >0 then
 Union/Prof. dues receipts
@Endif
@If @Line_215 >0 then
 Form T929-Attendant care expenses
@Endif
@If @Line_217 >0 then
 Schedule of Allowable Bus Invstm Losses
@Endif
@If @Line_229 >0 then
 Form T2200 or TL2
@Endif
@If @Line_255 >0 then
 Form T2222-Northern Res. Ded
@Endif
@If @Line_320 >0 then
 Form T2202A or receipts
@Endif
@If @Line_322 >0 then
 Form T2202 or T2202A
@Endif
@If @Line_332 >0 then
 Medical receipts
@Endif
@If @Line_340 >0 then
 Charitable Donations receipts
@Endif
@If @Line_342 >0 then
 Gift receipts
@Endif
@If @Line_414 >0 then
 Labor-Sponsored Funds receipts
@Endif

@If @Line_101 >0 then
Please Sign the following:
@Endif

@If @Line_479 >0 then
 Provincial Tax Credits
@Endif

@If @Line_219 > 0 then
 The Moving Expenses Schedule (T1-M)
@Endif
 The Loss Carry-Back form (T1A)
@If @Line_215 > 0 then
 The Attendant Care expenses (T929)
@Endif
 The Forward Avrg Withdrawal (T581)
@If @Line_412 > 0 then
 The Investment Tax Credit (T2038)
@Endif
@If @Line_480 > 0 then
 The Alb. Stock Sav Credit (T89)
@Endif
 The Designation of transfers to an RRSP form
 The Capital Gains Election form (T664)
 The Reconciliation of income Form (T1139)
 The Annual Accrual Can. Savings Bonds form (T1 CSB)
 The Overseas Empl. Tax Credit form (T626)
 The Employee and Partner GST Rebate form
 The Direct Deposit Application form (T1-DD)


Yours Sincerely
