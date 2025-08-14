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

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM calc_ratio_and_color.
  PERFORM build_fieldcat_and_layout.
  PERFORM display_alv.
