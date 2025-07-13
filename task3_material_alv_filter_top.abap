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