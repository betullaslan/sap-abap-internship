INCLUDE <icon>.

CONSTANTS c_tabname TYPE tabname VALUE 'ZBA_TASK_12'.

TABLES: ZBA_TASK_12.

TYPES: BEGIN OF ty_data,
         malz_no    TYPE ZBA_TASK_12-malz_no,
         malz_acik  TYPE ZBA_TASK_12-malz_acik,
         kullanici  TYPE ZBA_TASK_12-kullanici,
       END OF ty_data.

DATA: gt_data     TYPE STANDARD TABLE OF ty_data WITH DEFAULT KEY,
      gs_data     TYPE ty_data.

TYPES: ty_malz_set TYPE HASHED TABLE OF ZBA_TASK_12-malz_no
                    WITH UNIQUE KEY table_line.
DATA: gt_changed_keys TYPE ty_malz_set.

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_grid      TYPE REF TO cl_gui_alv_grid.

DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat,
      gs_layo TYPE lvc_s_layo.

*****************************************************************************

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_data_changed
        FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_data_changed.
    LOOP AT er_data_changed->mt_mod_cells INTO DATA(ls_mod).
      DATA(lv_row) = ls_mod-row_id.
      READ TABLE gt_data INTO DATA(ls_data) INDEX lv_row.
      IF sy-subrc = 0.
        INSERT ls_data-malz_no INTO TABLE gt_changed_keys.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD handle_toolbar.
    DATA ls_button TYPE stb_button.
    CLEAR ls_button.
    ls_button-function  = 'ZSAVE'.
    ls_button-icon      = icon_system_save.
    ls_button-quickinfo = 'Değişiklikleri Kaydet'.
    ls_button-text      = 'Değişiklikleri Kaydet'.
    ls_button-butn_type = 0.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'ZSAVE'.
        IF go_grid IS BOUND.
          go_grid->check_changed_data( ).
        ENDIF.
        IF gt_changed_keys IS INITIAL.
          MESSAGE 'Kaydedilecek değişiklik bulunamadı.' TYPE 'I'.
          RETURN.
        ENDIF.
        DATA(lv_updcnt) = 0.
        LOOP AT gt_changed_keys INTO DATA(lv_malzno).
          READ TABLE gt_data INTO DATA(ls_row) WITH KEY malz_no = lv_malzno.
          IF sy-subrc = 0.
            ls_row-kullanici = sy-uname.
            UPDATE (c_tabname)
              SET malz_acik = ls_row-malz_acik
                  kullanici = ls_row-kullanici
              WHERE malz_no = ls_row-malz_no.
            IF sy-subrc = 0.
              lv_updcnt = lv_updcnt + 1.
            ENDIF.
          ENDIF.
        ENDLOOP.
        COMMIT WORK.
        DATA ls_stbl TYPE lvc_s_stbl.
        ls_stbl-row = 'X'.
        ls_stbl-col = 'X'.
        go_grid->refresh_table_display( is_stable = ls_stbl ).
        CLEAR gt_changed_keys.
        MESSAGE |{ lv_updcnt } kayıt başarıyla güncellendi.| TYPE 'I'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

*****************************************************************************

START-OF-SELECTION.
  CALL SCREEN 0100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  IF go_grid IS INITIAL.
    PERFORM get_data.
    PERFORM build_fcat.
    PERFORM build_screen.
  ENDIF.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

*****************************************************************************

FORM get_data.
  SELECT malz_no   AS malz_no,
         malz_acik AS malz_acik,
         kullanici AS kullanici
    FROM (c_tabname)
    INTO TABLE @gt_data.
ENDFORM.

FORM build_fcat.
  CLEAR gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'MALZ_NO'.
  gs_fcat-coltext   = 'Malzeme Numarası'.
  gs_fcat-outputlen = 10.
  gs_fcat-edit      = ''.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'MALZ_ACIK'.
  gs_fcat-coltext   = 'Malzeme Açıklaması'.
  gs_fcat-outputlen = 30.
  gs_fcat-edit      = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'KULLANICI'.
  gs_fcat-coltext   = 'Değiştiren Kullanıcı'.
  gs_fcat-outputlen = 20.
  gs_fcat-edit      = ''.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_layo.
  gs_layo-zebra      = 'X'.
  gs_layo-cwidth_opt = 'X'.
ENDFORM.

FORM build_screen.
  CREATE OBJECT go_container
    EXPORTING
      container_name = 'CONTAINER'.
  CREATE OBJECT go_grid
    EXPORTING
      i_parent = go_container.
  go_grid->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
  go_grid->set_ready_for_input( 1 ).
  DATA lo_handler TYPE REF TO lcl_event_handler.
  lo_handler = NEW lcl_event_handler( ).
  SET HANDLER lo_handler->handle_data_changed FOR go_grid.
  SET HANDLER lo_handler->handle_toolbar      FOR go_grid.
  SET HANDLER lo_handler->handle_user_command FOR go_grid.
  CALL METHOD go_grid->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layo
    CHANGING
      it_outtab       = gt_data
      it_fieldcatalog = gt_fcat.
ENDFORM.