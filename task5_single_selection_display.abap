TYPES: BEGIN OF ty_siparis,
         siparis_no TYPE char10,
         tarih      TYPE d,
         musteri    TYPE char20,
       END OF ty_siparis.

TYPES: BEGIN OF ty_musteri,
         musteri_no TYPE char10,
         musteri_ad         TYPE char20,
         sehir      TYPE char15,
       END OF ty_musteri.

TYPES: BEGIN OF ty_malzeme,
         malzeme_no TYPE char10,
         malzeme_ad TYPE char20,
         stok       TYPE i,
       END OF ty_malzeme.

DATA: gv_rad1 TYPE xfeld,
      gv_rad2 TYPE xfeld,
      gv_rad3 TYPE xfeld.

DATA: gt_siparis TYPE STANDARD TABLE OF ty_siparis,
      gt_musteri TYPE STANDARD TABLE OF ty_musteri,
      gt_malzeme TYPE STANDARD TABLE OF ty_malzeme.

DATA: gs_siparis TYPE ty_siparis,
      gs_musteri TYPE ty_musteri,
      gs_malzeme TYPE ty_malzeme.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv.

**************************************************

INITIALIZATION.
  PERFORM VERI_YUKLEME.

START-OF-SELECTION.
CALL SCREEN 0100.

MODULE status_0100 OUTPUT.
 SET PF-STATUS '0100'.
 SET TITLEBAR '0100'.
ENDMODULE.

**************************************************

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'LISTELE'.
      CLEAR gt_fieldcat.
      REFRESH gt_fieldcat.
      IF gv_rad1 = abap_true.
        PERFORM SIPARIS_GOSTERME.
      ELSEIF gv_rad2 = abap_true.
        PERFORM MUSTERI_GOSTERME.
      ELSEIF gv_rad3 = abap_true.
        PERFORM MALZEME_GOSTERME.
      ENDIF.
  ENDCASE.
ENDMODULE.

**************************************************

FORM VERI_YUKLEME.

  APPEND VALUE #( siparis_no = 'S001' tarih = '20250101' musteri = 'AAA BBB' ) TO gt_siparis.
  APPEND VALUE #( siparis_no = 'S002' tarih = '20250105' musteri = 'XXX YYY' ) TO gt_siparis.

  APPEND VALUE #( musteri_no = 'M001' musteri_ad = 'CCC DDD' sehir = 'İstanbul' ) TO gt_musteri.
  APPEND VALUE #( musteri_no = 'M002' musteri_ad = 'EEE FFF' sehir = 'Ankara' ) TO gt_musteri.

  APPEND VALUE #( malzeme_no = 'MLZ001' malzeme_ad = 'Kalem' stok = 100 ) TO gt_malzeme.
  APPEND VALUE #( malzeme_no = 'MLZ002' malzeme_ad = 'Defter' stok = 200 ) TO gt_malzeme.

ENDFORM.

FORM SIPARIS_GOSTERME.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'SIPARIS_NO'.
  gs_fieldcat-seltext_l   = 'Sipariş No'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'TARIH'.
  gs_fieldcat-seltext_l   = 'Tarih'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MUSTERI'.
  gs_fieldcat-seltext_l   = 'Müşteri Adı'.
  APPEND gs_fieldcat TO gt_fieldcat.

  PERFORM DISPLAY.
ENDFORM.

FORM MUSTERI_GOSTERME.
  gs_fieldcat-fieldname = 'MUSTERI_NO'.
  gs_fieldcat-seltext_l = 'Müşteri No'.
  APPEND gs_fieldcat TO gt_fieldcat.

  gs_fieldcat-fieldname = 'MUSTERI_AD'.
  gs_fieldcat-seltext_l = 'Müşteri Adı'.
  APPEND gs_fieldcat TO gt_fieldcat.

  gs_fieldcat-fieldname = 'SEHIR'.
  gs_fieldcat-seltext_l = 'Şehir'.
  APPEND gs_fieldcat TO gt_fieldcat.

  PERFORM DISPLAY.
ENDFORM.

FORM MALZEME_GOSTERME.
  gs_fieldcat-fieldname = 'MALZEME_NO'.
  gs_fieldcat-seltext_l = 'Malzeme No'.
  APPEND gs_fieldcat TO gt_fieldcat.

  gs_fieldcat-fieldname = 'MALZEME_AD'.
  gs_fieldcat-seltext_l = 'Malzeme Adı'.
  APPEND gs_fieldcat TO gt_fieldcat.

  gs_fieldcat-fieldname = 'STOK'.
  gs_fieldcat-seltext_l = 'Stok'.
  APPEND gs_fieldcat TO gt_fieldcat.

  PERFORM DISPLAY.
ENDFORM.

FORM DISPLAY.
  FIELD-SYMBOLS: <lt_outtab> TYPE STANDARD TABLE.

  IF gv_rad1 = abap_true.
    ASSIGN gt_siparis TO <lt_outtab>.
  ELSEIF gv_rad2 = abap_true.
    ASSIGN gt_musteri TO <lt_outtab>.
  ELSEIF gv_rad3 = abap_true.
    ASSIGN gt_malzeme TO <lt_outtab>.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
    TABLES
      t_outtab           = <lt_outtab>.
ENDFORM.