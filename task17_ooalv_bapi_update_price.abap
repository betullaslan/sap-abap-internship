CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
                IMPORTING e_object e_interactive,
             handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
                IMPORTING e_ucomm.
ENDCLASS.

TYPES: BEGIN OF ty_mat,
         matnr      TYPE matnr,
         maktx      TYPE maktx,
         bwkey      TYPE mbew-bwkey,
         vprsv      TYPE mbew-vprsv,
         verpr      TYPE mbew-verpr,
         stprs      TYPE mbew-stprs,
         yeni_fiyat TYPE mbew-stprs,
         durum      TYPE char50,
         color      TYPE char4,
       END OF ty_mat.

DATA: gt_mat TYPE STANDARD TABLE OF ty_mat,
      gs_mat TYPE ty_mat.

DATA: go_container      TYPE REF TO cl_gui_custom_container,
      go_alv            TYPE REF TO cl_gui_alv_grid,
      gr_event_receiver TYPE REF TO lcl_event_receiver.

DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_toolbar.
    DATA: ls_button TYPE stb_button.
    CLEAR ls_button.
    ls_button-function  = 'FIYATGUNCELLE'.
    ls_button-icon      = icon_change.
    ls_button-quickinfo = 'Fiyat Güncelle'.
    ls_button-text      = 'Fiyat Güncelle'.
    APPEND ls_button TO e_object->mt_toolbar.
  ENDMETHOD.

****************************************************************************

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'FIYATGUNCELLE'.
        PERFORM fiyat_guncelle.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  SELECT a~matnr,
         b~maktx,
         c~bwkey,
         c~vprsv,
         c~verpr,
         c~stprs
    INTO TABLE @gt_mat
    FROM mara AS a
    INNER JOIN makt AS b ON b~matnr = a~matnr
    INNER JOIN mbew AS c ON c~matnr = a~matnr
    UP TO 50 ROWS
    WHERE c~vprsv = 'S'.

  CALL SCREEN 100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING container_name = 'CC'.

    CREATE OBJECT go_alv
      EXPORTING i_parent = go_container.

    CREATE OBJECT gr_event_receiver.
    SET HANDLER gr_event_receiver->handle_toolbar FOR go_alv.
    SET HANDLER gr_event_receiver->handle_user_command FOR go_alv.

    PERFORM build_fcat.

    DATA(ls_layo) = VALUE lvc_s_layo(
                       sel_mode   = 'D'
                       info_fname = 'COLOR'
                     ).

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout        = ls_layo
      CHANGING
        it_outtab        = gt_mat
        it_fieldcatalog  = gt_fcat.
  ENDIF.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

****************************************************************************

FORM build_fcat.
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'MATNR'. gs_fcat-coltext = 'Malzeme'. gs_fcat-outputlen = 18.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'MAKTX'. gs_fcat-coltext = 'Açıklama'. gs_fcat-outputlen = 30.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'BWKEY'. gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'VPRSV'. gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'VERPR'. gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'STPRS'. gs_fcat-coltext = 'Eski Fiyat'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'YENI_FIYAT'. gs_fcat-coltext = 'Yeni Fiyat'. gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'DURUM'. gs_fcat-coltext = 'Durum'. gs_fcat-outputlen = 50.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.

FORM fiyat_guncelle.
  DATA: lt_rows  TYPE lvc_t_row,
        ls_row   TYPE lvc_s_row,
        ls_mat   TYPE ty_mat,
        lv_index TYPE i,
        lv_ok    TYPE abap_bool,
        lv_msg   TYPE string.

  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  IF lt_rows IS INITIAL.
    MESSAGE 'Lütfen en az bir satır seçin.' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  LOOP AT lt_rows INTO ls_row.
    lv_index = ls_row-index.
    READ TABLE gt_mat INTO ls_mat INDEX lv_index.
    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    IF ls_mat-vprsv <> 'S'.
      lv_msg = 'Yalnızca standard fiyat güncellenebilir'.
      PERFORM set_result USING lv_index abap_false lv_msg.
      CONTINUE.
    ENDIF.

    IF ls_mat-yeni_fiyat IS INITIAL OR ls_mat-yeni_fiyat <= 0.
      lv_msg = |Yeni fiyat geçersiz|.
      PERFORM set_result USING lv_index abap_false lv_msg.
      CONTINUE.
    ENDIF.

    CLEAR: lv_ok, lv_msg.
    PERFORM bapi_update_price USING    ls_mat-matnr
                                       ls_mat-bwkey
                                       ls_mat-yeni_fiyat
                              CHANGING lv_ok
                                       lv_msg.

    PERFORM set_result USING lv_index lv_ok lv_msg.

    IF lv_ok = abap_true.
      ls_mat-stprs = ls_mat-yeni_fiyat.
      MODIFY gt_mat FROM ls_mat INDEX lv_index.
    ENDIF.
  ENDLOOP.

  CALL METHOD go_alv->refresh_table_display.
ENDFORM.

FORM set_result USING    p_index TYPE i
                          p_ok    TYPE abap_bool
                          p_msg   TYPE string.
  DATA ls_mat TYPE ty_mat.

  READ TABLE gt_mat INTO ls_mat INDEX p_index.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  ls_mat-durum = p_msg.

  IF p_ok = abap_true.
    ls_mat-color = 'C510'.
  ELSE.
    ls_mat-color = 'C610'.
  ENDIF.

  MODIFY gt_mat FROM ls_mat INDEX p_index.
ENDFORM.

FORM bapi_update_price USING    p_matnr      TYPE matnr
                                p_bwkey      TYPE bwkey
                                p_new_price  TYPE mbew-stprs
                       CHANGING p_success    TYPE abap_bool
                                p_msg        TYPE string.

  DATA: ls_head   TYPE bapimathead,
        ls_val    TYPE bapi_mbew,
        ls_valx   TYPE bapi_mbewx,
        lt_return TYPE TABLE OF bapiret2,
        ls_return TYPE bapiret2.

  CLEAR: ls_head, ls_val, ls_valx, p_success, p_msg.

  ls_head-material   = p_matnr.
  ls_head-ind_sector = 'M'.
  ls_head-matl_type  = 'FERT'.

  ls_val-val_area   = p_bwkey.
  ls_val-std_price  = p_new_price.
  ls_val-price_ctrl = 'S'.

  ls_valx-val_area   = p_bwkey.
  ls_valx-std_price  = 'X'.
  ls_valx-price_ctrl = 'X'.

  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      headdata       = ls_head
      valuationdata  = ls_val
      valuationdatax = ls_valx
    IMPORTING
      return         = ls_return
    TABLES
      returnmessages = lt_return.

  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc = 0.
    p_success = abap_false.
    p_msg     = ls_return-message.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    EXIT.
  ENDIF.

  LOOP AT lt_return INTO ls_return WHERE type = 'W'.
    CONCATENATE p_msg ls_return-message INTO p_msg SEPARATED BY space.
  ENDLOOP.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.

  p_success = abap_true.
  IF p_msg IS INITIAL.
    p_msg = 'İşlem tamamlandı'.
  ENDIF.

ENDFORM.