PARAMETERS: p_vbeln TYPE vbeln_va OBLIGATORY.

DATA: gs_vbak TYPE vbak,
      gt_vbap TYPE STANDARD TABLE OF vbap,
      gs_vbap TYPE vbap,
      lv_fm_name   TYPE rs38l_fnam,
      ls_docparams TYPE sfpdocparams,
      ls_outputparams TYPE sfpoutputparams.

SELECT SINGLE * INTO gs_vbak
FROM vbak WHERE vbeln = p_vbeln.

IF sy-subrc <> 0.
  WRITE: / 'Girilen sipariş numarası bulunamadı.'.
  EXIT.
ENDIF.

SELECT * INTO TABLE gt_vbap
FROM vbap WHERE vbeln = p_vbeln.

**********************************************
*WRITE: / 'SİPARİŞ BAŞLIK BİLGİLERİ',
*       / 'Sipariş No   :', gs_vbak-vbeln,
*       / 'Müşteri No   :', gs_vbak-kunnr,
*       / 'Satış Org.   :', gs_vbak-vkorg,
*       / 'Belge Tarihi :', gs_vbak-audat.
*
*SKIP.
*WRITE 'SİPARİŞ KALEM BİLGİLERİ'.
*
*LOOP AT gt_vbap INTO gs_vbap.
*  WRITE: / 'Kalem No   :', gs_vbap-posnr,
*         / 'Malzeme    :', gs_vbap-matnr,
*         / 'Miktar     :', gs_vbap-kwmeng,
*         / 'Birim      :', gs_vbap-vrkme.
*ENDLOOP.
**********************************************

CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams = ls_outputparams
  EXCEPTIONS
    cancel         = 1
    usage_error    = 2
    system_error   = 3
    internal_error = 4.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    i_name     = 'ZBA_SIPARIS_FORM'
  IMPORTING
    e_funcname = lv_fm_name.

CALL FUNCTION lv_fm_name
  EXPORTING
    /1bcdwb/docparams = ls_docparams
    gs_vbak           = gs_vbak
    gt_vbap           = gt_vbap.

CALL FUNCTION 'FP_JOB_CLOSE'
  IMPORTING
    e_result = ls_outputparams
  EXCEPTIONS
    usage_error    = 1
    system_error   = 2
    internal_error = 3.