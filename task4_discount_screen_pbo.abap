MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  gv_id = 'GV_MUSTERI_TIPI'.

  CLEAR gt_values.
  gs_value-key = 'B'.
  gs_value-text = 'Bireysel'.
  APPEND gs_value TO gt_values.

  gs_value-key = 'K'.
  gs_value-text = 'Kurumsal'.
  APPEND gs_value TO gt_values.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = gv_id
      values                = gt_values.
ENDMODULE.