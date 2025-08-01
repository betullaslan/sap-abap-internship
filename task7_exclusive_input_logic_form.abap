FORM veri_yukleme.

  APPEND VALUE #( siparis_no = 'S001' tarih = '20250101' musteri = 'AAA BBB' ) TO gt_siparis.
  APPEND VALUE #( siparis_no = 'S002' tarih = '20250105' musteri = 'XXX YYY' ) TO gt_siparis.

  APPEND VALUE #( musteri_no = 'M001' musteri_ad = 'CCC DDD' sehir = 'İstanbul' ) TO gt_musteri.
  APPEND VALUE #( musteri_no = 'M002' musteri_ad = 'EEE FFF' sehir = 'Ankara' ) TO gt_musteri.

  APPEND VALUE #( malzeme_no = 'MLZ001' malzeme_ad = 'Kalem' stok = 100 ) TO gt_malzeme.
  APPEND VALUE #( malzeme_no = 'MLZ002' malzeme_ad = 'Defter' stok = 200 ) TO gt_malzeme.

ENDFORM.

*****************************************************************************************************************************************************

FORM siparis_gosterme.
  CLEAR gt_fieldcat.
  CLEAR gs_fieldcat.

  gs_fieldcat-fieldname = 'SIPARIS_NO'.
  gs_fieldcat-seltext_l = 'Sipariş No'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'TARIH'.
  gs_fieldcat-seltext_l = 'Tarih'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'MUSTERI'.
  gs_fieldcat-seltext_l = 'Müşteri'.
  APPEND gs_fieldcat TO gt_fieldcat.

  DATA lt_result TYPE STANDARD TABLE OF ty_siparis.
  LOOP AT gt_siparis INTO DATA(ls_siparis) WHERE siparis_no = gv_siparis_no.
    APPEND ls_siparis TO lt_result.
  ENDLOOP.

  PERFORM display USING lt_result.
ENDFORM.

*****************************************************************************************************************************************************

FORM musteri_gosterme.
  CLEAR gt_fieldcat.
  CLEAR gs_fieldcat.

  gs_fieldcat-fieldname = 'MUSTERI_NO'.
  gs_fieldcat-seltext_l = 'Müşteri No'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'MUSTERI_AD'.
  gs_fieldcat-seltext_l = 'Müşteri Adı'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEHIR'.
  gs_fieldcat-seltext_l = 'Şehir'.
  APPEND gs_fieldcat TO gt_fieldcat.

  DATA lt_result TYPE STANDARD TABLE OF ty_musteri.
  LOOP AT gt_musteri INTO DATA(ls_musteri) WHERE musteri_no = gv_musteri_no.
    APPEND ls_musteri TO lt_result.
  ENDLOOP.

  PERFORM display USING lt_result.
ENDFORM.

*****************************************************************************************************************************************************

FORM malzeme_gosterme.
  CLEAR gt_fieldcat.
  CLEAR gs_fieldcat.

  gs_fieldcat-fieldname = 'MALZEME_NO'.
  gs_fieldcat-seltext_l = 'Malzeme No'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'MALZEME_AD'.
  gs_fieldcat-seltext_l = 'Malzeme Adı'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'STOK'.
  gs_fieldcat-seltext_l = 'Stok'.
  APPEND gs_fieldcat TO gt_fieldcat.

  DATA lt_result TYPE STANDARD TABLE OF ty_malzeme.
  LOOP AT gt_malzeme INTO DATA(ls_malzeme) WHERE malzeme_no = gv_malzeme_no.
    APPEND ls_malzeme TO lt_result.
  ENDLOOP.

  PERFORM display USING lt_result.
ENDFORM.

*****************************************************************************************************************************************************

FORM display USING pt_table TYPE STANDARD TABLE.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
    TABLES
      t_outtab           = pt_table
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
ENDFORM.
