TYPE-POOLS lvc.

TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,
         kunnr TYPE vbak-kunnr,
         erdat TYPE vbak-erdat,
         auart TYPE vbak-auart,
       END OF ty_vbak.

TYPES: BEGIN OF ty_vbap,
         vbeln TYPE vbap-vbeln,
         posnr TYPE vbap-posnr,
         matnr TYPE vbap-matnr,
         arktx TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
         vrkme  TYPE vbap-vrkme,
       END OF ty_vbap.

CLASS lcl_event_receiver DEFINITION DEFERRED.

DATA: gt_fcat_top TYPE lvc_t_fcat,
      gt_fcat_bot TYPE lvc_t_fcat.

DATA: gt_vbak TYPE STANDARD TABLE OF ty_vbak WITH DEFAULT KEY,
      gt_vbap TYPE STANDARD TABLE OF ty_vbap WITH DEFAULT KEY.

DATA: go_cc1         TYPE REF TO cl_gui_custom_container,
      go_cc2         TYPE REF TO cl_gui_custom_container,
      go_alv_top     TYPE REF TO cl_gui_alv_grid,
      go_alv_bottom  TYPE REF TO cl_gui_alv_grid.

DATA: go_events TYPE REF TO lcl_event_receiver.

CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS on_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no.
ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD on_double_click.
    DATA: ls_vbak TYPE ty_vbak.

    READ TABLE gt_vbak INTO ls_vbak INDEX es_row_no-row_id.
    IF sy-subrc <> 0 OR ls_vbak-vbeln IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR gt_vbap.
    SELECT vbeln, posnr,matnr,arktx,kwmeng,vrkme
    FROM vbap INTO TABLE @gt_vbap
    WHERE vbeln = @ls_vbak-vbeln
    ORDER BY posnr.

    DATA ls_layout_bot TYPE lvc_s_layo.
    ls_layout_bot-zebra      = 'X'.
    ls_layout_bot-cwidth_opt = 'X'.

    IF go_alv_bottom IS BOUND.
      go_alv_bottom->set_frontend_layout( ls_layout_bot ).
      go_alv_bottom->refresh_table_display(
        EXPORTING is_stable = VALUE lvc_s_stbl( row = 'X' col = 'X' ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

******************************************************************************

START-OF-SELECTION.
  CALL SCREEN 0100.

MODULE status_0100 OUTPUT.
 SET PF-STATUS '0100'.
ENDMODULE.

MODULE pbo_0100 OUTPUT.
  PERFORM init_containers_and_alvs.

  IF go_events IS INITIAL.
    CREATE OBJECT go_events.
    SET HANDLER go_events->on_double_click FOR go_alv_top.
  ENDIF.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

******************************************************************************

FORM init_containers_and_alvs.
  IF go_cc1 IS INITIAL.
    CREATE OBJECT go_cc1 EXPORTING container_name = 'CC1'.
    CREATE OBJECT go_cc2 EXPORTING container_name = 'CC2'.

    CREATE OBJECT go_alv_top    EXPORTING i_parent = go_cc1.
    CREATE OBJECT go_alv_bottom EXPORTING i_parent = go_cc2.

    PERFORM load_vbak_data.

    PERFORM build_fcat_top.

    DATA ls_layout_top TYPE lvc_s_layo.
    ls_layout_top-zebra      = 'X'.
    ls_layout_top-cwidth_opt = 'X'.
    ls_layout_top-sel_mode   = 'A'.

    go_alv_top->set_table_for_first_display(
      EXPORTING is_layout       = ls_layout_top
      CHANGING  it_outtab       = gt_vbak
                it_fieldcatalog = gt_fcat_top ).

    PERFORM build_fcat_bot.

    DATA ls_layout_bot TYPE lvc_s_layo.
    ls_layout_bot-zebra      = 'X'.
    ls_layout_bot-cwidth_opt = 'X'.
    ls_layout_bot-sel_mode   = 'A'.

    CLEAR gt_vbap.
    go_alv_bottom->set_table_for_first_display(
      EXPORTING is_layout       = ls_layout_bot
      CHANGING  it_outtab       = gt_vbap
                it_fieldcatalog = gt_fcat_bot ).
  ENDIF.
ENDFORM.

FORM load_vbak_data.
  IF gt_vbak IS INITIAL.
    SELECT vbeln, kunnr, erdat, auart
    FROM vbak
    INTO TABLE @gt_vbak
    UP TO 300 ROWS
    ORDER BY erdat DESCENDING.
  ENDIF.
ENDFORM.

FORM build_fcat_top.
  CLEAR gt_fcat_top.

  APPEND VALUE lvc_s_fcat( fieldname = 'VBELN' coltext = 'Sipariş No'  outputlen = 12 key = 'X' ) TO gt_fcat_top.
  APPEND VALUE lvc_s_fcat( fieldname = 'KUNNR' coltext = 'Müşteri No'  outputlen = 12           ) TO gt_fcat_top.
  APPEND VALUE lvc_s_fcat( fieldname = 'ERDAT' coltext = 'Tarih'       outputlen = 10           ) TO gt_fcat_top.
  APPEND VALUE lvc_s_fcat( fieldname = 'AUART' coltext = 'Belge Türü'  outputlen = 6            ) TO gt_fcat_top.
ENDFORM.

FORM build_fcat_bot.
  CLEAR gt_fcat_bot.

  APPEND VALUE lvc_s_fcat( fieldname = 'VBELN' coltext = 'Sipariş No'  outputlen = 12 key = 'X' ) TO gt_fcat_bot.
  APPEND VALUE lvc_s_fcat( fieldname = 'POSNR' coltext = 'Kalem'       outputlen = 6            ) TO gt_fcat_bot.
  APPEND VALUE lvc_s_fcat( fieldname = 'MATNR' coltext = 'Malzeme'     outputlen = 18           ) TO gt_fcat_bot.
  APPEND VALUE lvc_s_fcat( fieldname = 'ARKTX' coltext = 'Açıklama'    outputlen = 30           ) TO gt_fcat_bot.
  APPEND VALUE lvc_s_fcat( fieldname = 'KWMENG' coltext = 'Miktar'     outputlen = 10           ) TO gt_fcat_bot.
  APPEND VALUE lvc_s_fcat( fieldname = 'VRKME'  coltext = 'Ölçü Br.'   outputlen = 6            ) TO gt_fcat_bot.
ENDFORM.