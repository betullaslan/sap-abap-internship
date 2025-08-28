TYPES: BEGIN OF ty_material,
         matnr   TYPE char20,
         maktx   TYPE char20,
         matpr   TYPE i,
       END OF ty_material.

DATA: gt_materials   TYPE STANDARD TABLE OF ty_material,
      gs_material    TYPE ty_material,
      gt_filtered    TYPE STANDARD TABLE OF ty_material,
      wa_material    TYPE ty_material.

DATA: gt_fieldcat    TYPE slis_t_fieldcat_alv,
      gs_fieldcat    TYPE slis_fieldcat_alv.

SELECT-OPTIONS: s_matnr FOR gs_material-matnr.

*********************************************************

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

*********************************************************

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

*********************************************************

FORM fill_sample_data.
  gs_material-matnr  = '1001'.
  gs_material-maktx  = 'Pencil'.
  gs_material-matpr  = 58.
  APPEND gs_material TO gt_materials.

  gs_material-matnr  = '1002'.
  gs_material-maktx  = 'Eraser'.
  gs_material-matpr  = 35.
  APPEND gs_material TO gt_materials.

  gs_material-matnr  = '1003'.
  gs_material-maktx  = 'Notebook'.
  gs_material-matpr  = 112.
  APPEND gs_material TO gt_materials.

  gs_material-matnr  = '1004'.
  gs_material-maktx  = 'Ruler'.
  gs_material-matpr  = 27.
  APPEND gs_material TO gt_materials.

  gs_material-matnr  = '1005'.
  gs_material-maktx  = 'Sharpener'.
  gs_material-matpr  = 18.
  APPEND gs_material TO gt_materials.
ENDFORM.

*********************************************************

FORM build_fieldcatalog.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname  = 'MATNR'.
  gs_fieldcat-seltext_l  = 'Material Number'.
  gs_fieldcat-col_pos    = 1.
  gs_fieldcat-outputlen = 13.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname  = 'MAKTX'.
  gs_fieldcat-seltext_l  = 'Material Description'.
  gs_fieldcat-col_pos    = 2.
  gs_fieldcat-outputlen = 13.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname  = 'MATPR'.
  gs_fieldcat-seltext_l  = 'Material Price'.
  gs_fieldcat-col_pos    = 3.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.

*********************************************************

FORM filter_data.
  CLEAR gt_filtered.
  LOOP AT gt_materials INTO wa_material.
    IF wa_material-matnr IN s_matnr.
      APPEND wa_material TO gt_filtered.
    ENDIF.
  ENDLOOP.
ENDFORM.