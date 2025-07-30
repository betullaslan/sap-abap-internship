INITIALIZATION.
  PERFORM fill_sample_data.

AT SELECTION-SCREEN.
    IF s_matnr[] IS INITIAL.
    MESSAGE 'Malzeme numarası giriniz.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  PERFORM filter_data.
  PERFORM build_fieldcatalog.
  PERFORM display_data.

FORM display_data.
  IF gt_filtered IS NOT INITIAL.
   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
     i_callback_program = sy-repid
     it_fieldcat        = gt_fieldcat
   TABLES
     t_outtab           = gt_filtered
   EXCEPTIONS
     program_error      = 1
     OTHERS             = 2.

     IF sy-subrc <> 0.
        MESSAGE 'ALV display failed.' TYPE 'E'.
     ENDIF.
  ELSE.
   MESSAGE 'Seçim kriterlerine uyan herhangi bir malzeme bulunamadı.' TYPE 'I'.
   RETURN.
 ENDIF.
ENDFORM.