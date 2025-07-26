*****************************************************
*MAIN

DATA: gv_sonuc TYPE i.

PARAMETERS: gv_sayi1 TYPE i,
            gv_sayi2 TYPE i,
            gv_islem TYPE c.

START-OF-SELECTION.

  CALL FUNCTION 'ZBK_ODEV_000_3_FM'
    EXPORTING
      iv_sayi1                = gv_sayi1
      iv_sayi2                = gv_sayi2
      iv_islem                = gv_islem
     IMPORTING
       EV_SONUC                = gv_sonuc
     EXCEPTIONS
       DIVISION_BY_ZERO        = 1
       INVALID_OPERATION       = 2
       OTHERS                  = 3
            .
    CASE sy-subrc.
      WHEN 0.
        WRITE: / 'Sonuç:', gv_sonuc.
      WHEN 1.
        MESSAGE 'Sıfıra bölme yapılamaz.' TYPE 'I'.
      WHEN 2.
        MESSAGE 'Geçersiz işlem türü girdiniz.' TYPE 'I'.
      WHEN OTHERS.
        MESSAGE 'Bilinmeyen bir hata oluştu.' TYPE 'I'.
    ENDCASE.

*****************************************************
* FUNCTION MODULE

CASE iv_islem.
    WHEN 'T'.
      ev_sonuc = iv_sayi1 + iv_sayi2.
    WHEN 'C'.
      ev_sonuc = iv_sayi1 - iv_sayi2.
    WHEN 'X'.
       ev_sonuc = iv_sayi1 * iv_sayi2.
    WHEN 'B'.
     IF iv_sayi2 = 0.
       RAISE DIVISION_BY_ZERO.
     ELSE.
       ev_sonuc = iv_sayi1 / iv_sayi2.
     ENDIF.
    WHEN OTHERS.
      RAISE INVALID_OPERATION.
  ENDCASE.