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