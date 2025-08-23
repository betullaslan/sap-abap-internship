DATA: gv_sayi1 TYPE p LENGTH 5 DECIMALS 2,
      gv_sayi2 TYPE p LENGTH 5 DECIMALS 2,
      gv_sonuc TYPE p LENGTH 5 DECIMALS 2.

*DATA: gv_sayi1 TYPE int4,
*      gv_sayi2 TYPE int4,
*      gv_sonuc TYPE int4.

START-OF-SELECTION.
CALL SCREEN 0100.

MODULE status_0100 OUTPUT.
 SET PF-STATUS '0100'.
 SET TITLEBAR '0100'.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'TOPLAMA'.
      gv_sonuc = gv_sayi1 + gv_sayi2.
    WHEN 'CIKARMA'.
      gv_sonuc = gv_sayi1 - gv_sayi2.
    WHEN 'CARPMA'.
       gv_sonuc = gv_sayi1 * gv_sayi2.
    WHEN 'BOLME'.
      IF gv_sayi2 NE 0.
        gv_sonuc = gv_sayi1 / gv_sayi2.
      ELSE.
        MESSAGE 'Sıfıra bölme işlemi gerçekleştirilemez.' TYPE 'I'.
        CLEAR gv_sayi1.
        CLEAR gv_sayi2.
        CLEAR gv_sonuc.
      ENDIF.
  ENDCASE.
ENDMODULE.
