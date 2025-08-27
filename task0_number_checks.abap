DATA: gv_num TYPE int4,
      gv_tek TYPE int4,
      gv_cift TYPE int4.

gv_num = 0.
gv_tek = 0.
gv_cift = 0.

WHILE gv_num < 101.
  IF gv_num MOD 2 EQ 0.
    WRITE: / 'Cift Sayi:', gv_num.
    gv_cift = gv_cift + 1.
  ELSE.
    WRITE: / 'Tek Sayi: ', gv_num.
    gv_tek = gv_tek + 1.
  ENDIF.

  gv_num = gv_num + 1.
ENDWHILE.

WRITE: /.
WRITE: / 'Tek sayi adedi:  ', gv_tek.
WRITE: / 'Çift sayi adedi: ', gv_cift.

***********************************************************************

DATA: gv_iki TYPE i,
      gv_uc TYPE i,
      gv_bes TYPE i,
      gv_sayi TYPE i.

gv_sayi = 1.
WRITE '2''ye bölünebilen sayılar:'.

WHILE gv_sayi < 101.
  IF gv_sayi MOD 2 EQ 0.
    WRITE gv_sayi.
  ENDIF.
  gv_sayi = gv_sayi + 1.
ENDWHILE.

gv_sayi = 1.
WRITE: / '3''e bölünebilen sayılar:'.

WHILE gv_sayi < 101.
  IF gv_sayi MOD 3 EQ 0.
    WRITE gv_sayi.
  ENDIF.
  gv_sayi = gv_sayi + 1.
ENDWHILE.

gv_sayi = 1.
WRITE: / '5''e bölünebilen sayılar:'.

WHILE gv_sayi < 101.
  IF gv_sayi MOD 5 EQ 0.
    WRITE gv_sayi.
  ENDIF.
  gv_sayi = gv_sayi + 1.
ENDWHILE.

************************************************************************

PARAMETERS: gv_sayi TYPE i.

IF gv_sayi < 0.
  WRITE: / 'Girilen sayi ', gv_sayi.
  WRITE: / '0''dan küçüktür'.
ELSEIF gv_sayi >= 0 AND gv_sayi < 25.
  WRITE: / 'Girilen sayi ', gv_sayi.
  WRITE: / '0 ile 25 arasındadır.'.
ELSEIF gv_sayi >= 25 AND gv_sayi < 50.
  WRITE: / 'Girilen sayi ', gv_sayi.
  WRITE: / '25 ile 50 arasındadır.'.
ELSEIF gv_sayi >= 50 AND gv_sayi < 75.
  WRITE: / 'Girilen sayi ', gv_sayi.
  WRITE: / '50 ile 75 arasındadır.'.
ELSEIF gv_sayi >= 75 AND gv_sayi <= 100.
  WRITE: / 'Girilen sayi ', gv_sayi.
  WRITE: / '75 ile 100 arasındadır.'.
ELSE.
  WRITE: / 'Girilen sayi ', gv_sayi.
  WRITE: / '100''den büyüktür'.
ENDIF.