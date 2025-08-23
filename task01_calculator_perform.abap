DATA: gv_sonuc TYPE p LENGTH 5 DECIMALS 2.

PARAMETERS: gv_sayi1 TYPE p LENGTH 5 DECIMALS 2,
            gv_sayi2 TYPE p LENGTH 5 DECIMALS 2,
            gv_islem TYPE c LENGTH 1.

START-OF-SELECTION.
  CASE gv_islem.
    WHEN 'T'.
      PERFORM toplama.
    WHEN 'C'.
      PERFORM cikarma.
    WHEN 'X'.
      PERFORM carpma.
    WHEN 'B'.
      PERFORM bolme.
    WHEN OTHERS.
      MESSAGE 'Geçersiz işlem türü girdiniz.' TYPE 'I'.
  ENDCASE.

FORM toplama.
  gv_sonuc = gv_sayi1 + gv_sayi2.
  WRITE: / 'Sonuç:', gv_sonuc.
ENDFORM.

FORM cikarma.
  gv_sonuc = gv_sayi1 - gv_sayi2.
  WRITE: / 'Sonuç:', gv_sonuc.
ENDFORM.

FORM carpma.
  gv_sonuc = gv_sayi1 * gv_sayi2.
  WRITE: / 'Sonuç:', gv_sonuc.
ENDFORM.

FORM bolme.
  IF gv_sayi2 NE 0.
    gv_sonuc = gv_sayi1 / gv_sayi2.
    WRITE: / 'Sonuç:', gv_sonuc.
  ELSE.
    MESSAGE 'Sıfıra bölme işlemi gerçekleştirilemez.' TYPE 'I'.
    CLEAR gv_sayi1.
    CLEAR gv_sayi2.
    CLEAR gv_sonuc.
   ENDIF.
ENDFORM.
