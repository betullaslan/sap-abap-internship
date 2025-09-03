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

****************************************************************************************

START-OF-SELECTION.
  PERFORM get_vbak.
  IF lt_vbak IS INITIAL.
    MESSAGE 'Seçilen müşteriler için sipariş bulunamadı.' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  PERFORM get_vbap.
  IF lt_vbap IS INITIAL.
    MESSAGE 'Başlıklar bulundu ancak bu siparişlere ait kalem yok.' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  PERFORM build_output.
  PERFORM display_alv.

****************************************************************************************

FORM get_vbak.
  SELECT vbeln,erdat,auart,vkorg,kunnr,waerk
  FROM vbak INTO TABLE @lt_vbak
  WHERE kunnr IN @s_kunnr.

  SORT lt_vbak BY vbeln.
  DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING vbeln.
ENDFORM.

FORM get_vbap.
  SELECT vbeln, posnr, matnr, arktx,kwmeng,vrkme,netwr
  FROM vbap INTO TABLE @lt_vbap
  FOR ALL ENTRIES IN @lt_vbak
  WHERE vbeln = @lt_vbak-vbeln.

  SORT lt_vbap BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM lt_vbap COMPARING vbeln posnr.
ENDFORM.

FORM build_output.
  DATA ls_out  TYPE ty_out.
  DATA ls_vbak TYPE ty_vbak.

  LOOP AT lt_vbap INTO DATA(ls_vbap).
    READ TABLE lt_vbak INTO ls_vbak
         WITH KEY vbeln = ls_vbap-vbeln
         BINARY SEARCH.
    IF sy-subrc = 0.
      CLEAR ls_out.
      ls_out-vbeln = ls_vbak-vbeln.
      ls_out-posnr = ls_vbap-posnr.
      ls_out-erdat = ls_vbak-erdat.
      ls_out-auart = ls_vbak-auart.
      ls_out-vkorg = ls_vbak-vkorg.
      ls_out-kunnr = ls_vbak-kunnr.
      ls_out-matnr = ls_vbap-matnr.
      ls_out-arktx = ls_vbap-arktx.
      ls_out-kwmeng = ls_vbap-kwmeng.
      ls_out-vrkme  = ls_vbap-vrkme.
      ls_out-netwr  = ls_vbap-netwr.
      ls_out-waerk  = ls_vbak-waerk.
      APPEND ls_out TO lt_out.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM build_fieldcatalog.
  DATA ls_fcat TYPE slis_fieldcat_alv.

  DEFINE add_fcat.
    CLEAR ls_fcat.
    ls_fcat-fieldname = &1.
    ls_fcat-seltext_l = &2.
    APPEND ls_fcat TO gt_fieldcat.
  END-OF-DEFINITION.

  add_fcat 'VBELN' 'Sipariş No'.
  add_fcat 'POSNR' 'Kalem No'.
  add_fcat 'ERDAT' 'Sipariş Tarihi'.
  add_fcat 'AUART' 'Sipariş Türü'.
  add_fcat 'VKORG' 'Satış Org.'.
  add_fcat 'KUNNR' 'Müşteri'.
  add_fcat 'MATNR' 'Malzeme'.
  add_fcat 'ARKTX' 'Malzeme Açıklaması'.
  add_fcat 'KWMENG' 'Miktar'.
  add_fcat 'VRKME' 'Birim'.
  add_fcat 'NETWR' 'Tutar'.
  add_fcat 'WAERK' 'Para Birimi'.
ENDFORM.

FORM display_alv.
  PERFORM build_fieldcatalog.

  CLEAR gs_layout.
  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat
    TABLES
      t_outtab    = lt_out
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.