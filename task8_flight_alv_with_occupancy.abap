TYPE-POOLS: slis.
TABLES: sflight.

SELECT-OPTIONS: s_carrid FOR sflight-carrid.

TYPES: BEGIN OF ty_sflight,
         carrid        LIKE sflight-carrid,
         connid        LIKE sflight-connid,
         fldate        LIKE sflight-fldate,
         price         LIKE sflight-price,
         currency      LIKE sflight-currency,
         planetype     LIKE sflight-planetype,
         seatsmax      LIKE sflight-seatsmax,
         seatsocc      LIKE sflight-seatsocc,
         seatsmax_b    LIKE sflight-seatsmax_b,
         seatsocc_b    LIKE sflight-seatsocc_b,
         seatsmax_f    LIKE sflight-seatsmax_f,
         seatsocc_f    LIKE sflight-seatsocc_f,
         paymentsum    LIKE sflight-paymentsum,
         doluluk_orani TYPE p DECIMALS 2,
         line_color TYPE slis_specialcol_alv,
       END OF ty_sflight.

DATA: gt_sflight  TYPE STANDARD TABLE OF ty_sflight,
      gs_sflight  TYPE ty_sflight.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

DATA: lv_max TYPE p LENGTH 7 DECIMALS 0,
      lv_occ TYPE p LENGTH 7 DECIMALS 0.

**********************************************************

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM calc_ratio_and_color.
  PERFORM build_fieldcat_and_layout.
  PERFORM display_alv.

MODULE status_0100 OUTPUT.
 SET PF-STATUS '0100'.
 SET TITLEBAR '0100'.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.

**********************************************************

FORM get_data.
  SELECT * FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_sflight
    WHERE carrid IN s_carrid.

  IF sy-subrc <> 0.
    MESSAGE 'Kriterlere uyan kayıt bulunamadı.' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.

FORM calc_ratio_and_color.
  LOOP AT gt_sflight INTO gs_sflight.
    lv_max = gs_sflight-seatsmax.
    lv_occ = gs_sflight-seatsocc.

    IF lv_max > 0.
      gs_sflight-doluluk_orani = ( lv_occ * '100.00' ) / lv_max.
    ELSE.
      gs_sflight-doluluk_orani = 0.
    ENDIF.

    CLEAR gs_sflight-line_color.
    IF gs_sflight-doluluk_orani > 90.
      gs_sflight-line_color = 'C610'.
    ENDIF.

    MODIFY gt_sflight FROM gs_sflight.
  ENDLOOP.
ENDFORM.

FORM build_fieldcat_and_layout.
  CLEAR gt_fieldcat.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      ct_fieldcat      = gt_fieldcat.

  DATA(lv_last) = lines( gt_fieldcat ).

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'DOLULUK_ORANI'.
  gs_fieldcat-seltext_m = 'Doluluk Oranı (%)'.
  gs_fieldcat-outputlen = 15.
  gs_fieldcat-just      = 'R'.
  gs_fieldcat-col_pos   = lv_last + 1.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_layout.
  gs_layout-zebra           = 'X'.
  gs_layout-info_fieldname  = 'LINE_COLOR'.
ENDFORM.

FORM display_alv.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      is_layout                = gs_layout
      it_fieldcat              = gt_fieldcat
      i_save                   = 'A'
    TABLES
      t_outtab                 = gt_sflight.
ENDFORM.

FORM set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS '0100' EXCLUDING rt_extab.
ENDFORM.

FORM user_command USING r_ucomm     LIKE sy-ucomm
                         rs_selfield TYPE slis_selfield.

  DATA ls_row TYPE ty_sflight.

  CASE r_ucomm.
    WHEN 'UDETAY'.
      IF rs_selfield-tabindex IS INITIAL.
        MESSAGE 'Lütfen önce bir satır seçin.' TYPE 'I'.
        RETURN.
      ENDIF.

      READ TABLE gt_sflight INTO ls_row INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.
        CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
          EXPORTING
            titel     = 'Uçak Detayı'
            textline1 = |Uçak Tipi: { ls_row-planetype }|.
      ELSE.
        MESSAGE 'Seçilen satır okunamadı.' TYPE 'I'.
      ENDIF.
  ENDCASE.
ENDFORM.