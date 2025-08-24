TYPE-POOLS: slis.
TABLES: kna1.

SELECT-OPTIONS s_kunnr FOR kna1-kunnr OBLIGATORY.

TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,
         erdat TYPE vbak-erdat,
         auart TYPE vbak-auart,
         vkorg TYPE vbak-vkorg,
         kunnr TYPE vbak-kunnr,
         waerk TYPE vbak-waerk,
       END OF ty_vbak.

TYPES: BEGIN OF ty_vbap,
         vbeln TYPE vbap-vbeln,
         posnr TYPE vbap-posnr,
         matnr TYPE vbap-matnr,
         arktx TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
         vrkme TYPE vbap-vrkme,
         netwr TYPE vbap-netwr,
       END OF ty_vbap.

TYPES: BEGIN OF ty_out,
         vbeln TYPE vbak-vbeln,
         posnr TYPE vbap-posnr,
         erdat TYPE vbak-erdat,
         auart TYPE vbak-auart,
         vkorg TYPE vbak-vkorg,
         kunnr TYPE vbak-kunnr,
         matnr TYPE vbap-matnr,
         arktx TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
         vrkme TYPE vbap-vrkme,
         netwr TYPE vbap-netwr,
         waerk TYPE vbak-waerk,
       END OF ty_out.

DATA: lt_vbak TYPE STANDARD TABLE OF ty_vbak WITH EMPTY KEY,
      lt_vbap TYPE STANDARD TABLE OF ty_vbap WITH EMPTY KEY,
      lt_out  TYPE STANDARD TABLE OF ty_out  WITH EMPTY KEY.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.