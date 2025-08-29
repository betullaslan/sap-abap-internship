DATA: gv_siparis_tutar TYPE i,
      gv_indirim_oran TYPE i,
      gv_musteri_tipi TYPE char10,
      gv_son_tutar TYPE p LENGTH 5 DECIMALS 2.

DATA: gv_temp TYPE i.

DATA: gv_id TYPE vrm_id,
      gt_values TYPE VRM_VALUES,
      gs_value TYPE VRM_VALUE.

************************************************

START-OF-SELECTION.
CALL SCREEN 0100.

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

************************************************

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
    WHEN 'HESAPLA'.
       PERFORM ISLEM.
  ENDCASE.
ENDMODULE.

************************************************

 FORM ISLEM.
  gv_temp = 100 - gv_indirim_oran.
  gv_son_tutar =  gv_temp * gv_siparis_tutar / 100.
  IF gv_musteri_tipi EQ 'K'.
    gv_son_tutar = gv_son_tutar * 101 / 100.
  ENDIF.
ENDFORM.