FORM VERI_YUKLEME.

  APPEND VALUE #( siparis_no = 'S001' tarih = '20250101' musteri = 'AAA BBB' ) TO gt_siparis.
  APPEND VALUE #( siparis_no = 'S002' tarih = '20250105' musteri = 'XXX YYY' ) TO gt_siparis.

  APPEND VALUE #( musteri_no = 'M001' musteri_ad = 'CCC DDD' sehir = 'İstanbul' ) TO gt_musteri.
  APPEND VALUE #( musteri_no = 'M002' musteri_ad = 'EEE FFF' sehir = 'Ankara' ) TO gt_musteri.

  APPEND VALUE #( malzeme_no = 'MLZ001' malzeme_ad = 'Kalem' stok = 100 ) TO gt_malzeme.
  APPEND VALUE #( malzeme_no = 'MLZ002' malzeme_ad = 'Defter' stok = 200 ) TO gt_malzeme.

ENDFORM.

*****************************************************************************************************************************************************

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

*****************************************************************************************************************************************************

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

*****************************************************************************************************************************************************

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

*****************************************************************************************************************************************************

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