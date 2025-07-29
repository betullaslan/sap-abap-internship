TYPES: BEGIN OF ty_siparis,
        siparis_no TYPE char10,
        musteri_no TYPE char10,
        malzeme_no TYPE char10,
        miktar TYPE i,
        net_tutar TYPE i,
        line_color  TYPE c LENGTH 4,
       END OF ty_siparis.

DATA: gt_siparis TYPE TABLE OF ty_siparis,
      gs_siparis TYPE ty_siparis.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

***********************************************************************
INITIALIZATION.

gs_siparis-siparis_no = '1000000010'.
gs_siparis-musteri_no = 'MUST0001'.
gs_siparis-malzeme_no = 'MAT001'.
gs_siparis-miktar     = 15.
gs_siparis-net_tutar  = 1500.
APPEND gs_siparis TO gt_siparis.

gs_siparis-siparis_no = '1000000011'.
gs_siparis-musteri_no = 'MUST0002'.
gs_siparis-malzeme_no = 'MAT002'.
gs_siparis-miktar     = 8.
gs_siparis-net_tutar  = 620.
APPEND gs_siparis TO gt_siparis.

gs_siparis-siparis_no = '1000000012'.
gs_siparis-musteri_no = 'MUST0003'.
gs_siparis-malzeme_no = 'MAT003'.
gs_siparis-miktar     = 25.
gs_siparis-net_tutar  = 3125.
APPEND gs_siparis TO gt_siparis.

LOOP AT gt_siparis INTO gs_siparis.
  IF gs_siparis-net_tutar > 2000.
    gs_siparis-line_color = 'C610'.
  ENDIF.
  MODIFY gt_siparis FROM gs_siparis.
ENDLOOP.

***********************************************************************
START-OF-SELECTION.

* SIPARIS_NO
CLEAR gs_fieldcat.
gs_fieldcat-fieldname   = 'SIPARIS_NO'.
gs_fieldcat-seltext_l   = 'Sipariş No'.
gs_fieldcat-outputlen   = 12.
APPEND gs_fieldcat TO gt_fieldcat.

* MUSTERI_NO
CLEAR gs_fieldcat.
gs_fieldcat-fieldname   = 'MUSTERI_NO'.
gs_fieldcat-seltext_l   = 'Müşteri No'.
gs_fieldcat-outputlen   = 12.
APPEND gs_fieldcat TO gt_fieldcat.

* MALZEME_NO
CLEAR gs_fieldcat.
gs_fieldcat-fieldname   = 'MALZEME_NO'.
gs_fieldcat-seltext_l   = 'Malzeme No'.
gs_fieldcat-outputlen   = 12.
APPEND gs_fieldcat TO gt_fieldcat.

* MIKTAR
CLEAR gs_fieldcat.
gs_fieldcat-fieldname   = 'MIKTAR'.
gs_fieldcat-seltext_l   = 'Miktar'.
gs_fieldcat-outputlen   = 8.
gs_fieldcat-do_sum = 'X'.
APPEND gs_fieldcat TO gt_fieldcat.

* NET_TUTAR
CLEAR gs_fieldcat.
gs_fieldcat-fieldname   = 'NET_TUTAR'.
gs_fieldcat-seltext_l   = 'Net Tutar'.
gs_fieldcat-outputlen   = 10.
gs_fieldcat-do_sum = 'X'.
APPEND gs_fieldcat TO gt_fieldcat.

***********************************************************************
gs_layout-zebra = 'X'.
gs_layout-colwidth_optimize = 'X'.
gs_layout-info_fieldname = 'LINE_COLOR'.

***********************************************************************
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program = sy-repid
    i_callback_top_of_page   = 'TOP_OF_PAGE'
    i_callback_user_command = 'USER_COMMAND'
    is_layout          = gs_layout
    it_fieldcat        = gt_fieldcat
  TABLES
    t_outtab           = gt_siparis.

***********************************************************************
FORM top_of_page.

  DATA: lt_header TYPE slis_t_listheader,
        ls_header TYPE slis_listheader,
        lv_date   TYPE char10.

  CLEAR ls_header.
  ls_header-typ  = 'H'.
  ls_header-info = 'Sipariş Listesi Raporu'.
  APPEND ls_header TO lt_header.

  CLEAR ls_header.
  ls_header-typ  = 'S'.
  ls_header-key = 'Oluşturan:'.
  ls_header-info = sy-uname.
  APPEND ls_header TO lt_header.

  CLEAR ls_header.
  ls_header-typ = 'S'.
  ls_header-key = 'Tarih:'.

  CONCATENATE sy-datum+6(2)
              '.'
              sy-datum+4(2)
              '.'
              sy-datum+0(4)
              INTO lv_date.

  ls_header-info = lv_date.
  APPEND ls_header TO lt_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
ENDFORM.

***********************************************************************
FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  IF r_ucomm = '&IC1'.
    READ TABLE gt_siparis INTO gs_siparis INDEX rs_selfield-tabindex.
    IF sy-subrc = 0.
      MESSAGE |Sipariş: { gs_siparis-siparis_no }, Müşteri: { gs_siparis-musteri_no }, Malzeme: { gs_siparis-malzeme_no }, Miktar: { gs_siparis-miktar }, Tutar: { gs_siparis-net_tutar }| TYPE 'I'.
    ELSE.
      MESSAGE 'Satır bulunamadı!' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.