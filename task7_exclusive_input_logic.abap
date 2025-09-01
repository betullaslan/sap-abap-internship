TYPES: BEGIN OF ty_siparis,
         siparis_no TYPE char10,
         tarih      TYPE d,
         musteri    TYPE char20,
       END OF ty_siparis.

TYPES: BEGIN OF ty_musteri,
         musteri_no TYPE char10,
         musteri_ad TYPE char20,
         sehir      TYPE char15,
       END OF ty_musteri.

TYPES: BEGIN OF ty_malzeme,
         malzeme_no TYPE char10,
         malzeme_ad TYPE char20,
         stok       TYPE i,
       END OF ty_malzeme.

DATA: gt_siparis TYPE STANDARD TABLE OF ty_siparis,
      gt_musteri TYPE STANDARD TABLE OF ty_musteri,
      gt_malzeme TYPE STANDARD TABLE OF ty_malzeme.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv.

DATA: gv_siparis_no  TYPE char10,
      gv_musteri_no  TYPE char10,
      gv_malzeme_no  TYPE char10.

********************************************************************************************************

INITIALIZATION.
  PERFORM veri_yukleme.

START-OF-SELECTION.
  CALL SCREEN 0100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  LOOP AT SCREEN.
     CASE screen-name.
       WHEN 'GV_SIPARIS_NO'.
         IF gv_musteri_no IS NOT INITIAL OR gv_malzeme_no IS NOT INITIAL.
           screen-input = '0'.
         ENDIF.
       WHEN 'GV_MUSTERI_NO'.
         IF gv_siparis_no IS NOT INITIAL OR gv_malzeme_no IS NOT INITIAL.
           screen-input = '0'.
         ENDIF.
       WHEN 'GV_MALZEME_NO'.
         IF gv_siparis_no IS NOT INITIAL OR gv_musteri_no IS NOT INITIAL.
           screen-input = '0'.
         ENDIF.
     ENDCASE.
     MODIFY SCREEN.
   ENDLOOP.
ENDMODULE.

********************************************************************************************************

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'SORGULA'.
      DATA(lv_found) = abap_false.

      IF gv_siparis_no IS NOT INITIAL AND gv_musteri_no IS INITIAL AND gv_malzeme_no IS INITIAL.
        READ TABLE gt_siparis WITH KEY siparis_no = gv_siparis_no TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          PERFORM siparis_gosterme.
        ELSE.
          MESSAGE 'Geçersiz Sipariş Numarası!' TYPE 'E'.
        ENDIF.

      ELSEIF gv_musteri_no IS NOT INITIAL AND gv_siparis_no IS INITIAL AND gv_malzeme_no IS INITIAL.
        READ TABLE gt_musteri WITH KEY musteri_no = gv_musteri_no TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          PERFORM musteri_gosterme.
        ELSE.
          MESSAGE 'Geçersiz Müşteri Numarası!' TYPE 'E'.
        ENDIF.

      ELSEIF gv_malzeme_no IS NOT INITIAL AND gv_siparis_no IS INITIAL AND gv_musteri_no IS INITIAL.
        READ TABLE gt_malzeme WITH KEY malzeme_no = gv_malzeme_no TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          PERFORM malzeme_gosterme.
        ELSE.
          MESSAGE 'Geçersiz Malzeme Numarası!' TYPE 'E'.
        ENDIF.

      ELSE.
        MESSAGE 'Lütfen yalnızca bir alan doldurunuz!' TYPE 'I'.
      ENDIF.

    IF gv_siparis_no IS NOT INITIAL OR gv_musteri_no IS NOT INITIAL OR gv_malzeme_no IS NOT INITIAL.
      SET SCREEN 0100.
      LEAVE SCREEN.
    ENDIF.
  ENDCASE.
ENDMODULE.

********************************************************************************************************

FORM veri_yukleme.

  APPEND VALUE #( siparis_no = 'S001' tarih = '20250101' musteri = 'AAA BBB' ) TO gt_siparis.
  APPEND VALUE #( siparis_no = 'S002' tarih = '20250105' musteri = 'XXX YYY' ) TO gt_siparis.

  APPEND VALUE #( musteri_no = 'M001' musteri_ad = 'CCC DDD' sehir = 'İstanbul' ) TO gt_musteri.
  APPEND VALUE #( musteri_no = 'M002' musteri_ad = 'EEE FFF' sehir = 'Ankara' ) TO gt_musteri.

  APPEND VALUE #( malzeme_no = 'MLZ001' malzeme_ad = 'Kalem' stok = 100 ) TO gt_malzeme.
  APPEND VALUE #( malzeme_no = 'MLZ002' malzeme_ad = 'Defter' stok = 200 ) TO gt_malzeme.

ENDFORM.

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