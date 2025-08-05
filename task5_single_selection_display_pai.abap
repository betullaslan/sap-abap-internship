MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'LISTELE'.
      CLEAR gt_fieldcat.
      REFRESH gt_fieldcat.
      IF gv_rad1 = abap_true.
        PERFORM SIPARIS_GOSTERME.
      ELSEIF gv_rad2 = abap_true.
        PERFORM MUSTERI_GOSTERME.
      ELSEIF gv_rad3 = abap_true.
        PERFORM MALZEME_GOSTERME.
      ENDIF.
  ENDCASE.
ENDMODULE.