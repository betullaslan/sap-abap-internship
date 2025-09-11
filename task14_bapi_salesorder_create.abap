PARAMETERS: p_kunnr TYPE kunnr OBLIGATORY,
            p_matnr TYPE matnr OBLIGATORY,
            p_qty   TYPE kwmeng OBLIGATORY.

CONSTANTS: c_vkorg TYPE vkorg VALUE '1001',
           c_vtweg TYPE vtweg VALUE '10',
           c_spart TYPE spart VALUE '01'.

DATA: gs_header   TYPE bapisdhd1,
      gs_headerx  TYPE bapisdhd1x,
      gt_partner  TYPE STANDARD TABLE OF bapiparnr  WITH DEFAULT KEY,
      gs_partner  TYPE bapiparnr,
      gt_items    TYPE STANDARD TABLE OF bapisditm  WITH DEFAULT KEY,
      gs_item     TYPE bapisditm,
      gt_itemsx   TYPE STANDARD TABLE OF bapisditmx WITH DEFAULT KEY,
      gs_itemx    TYPE bapisditmx,
      gt_sched    TYPE STANDARD TABLE OF bapischdl   WITH DEFAULT KEY,
      gs_sched    TYPE bapischdl,
      gt_schedx   TYPE STANDARD TABLE OF bapischdlx  WITH DEFAULT KEY,
      gs_schedx   TYPE bapischdlx,
      gt_return   TYPE STANDARD TABLE OF bapiret2    WITH DEFAULT KEY,
      gs_return   TYPE bapiret2,
      gv_vbeln    TYPE vbeln_va.

******************************************************************

START-OF-SELECTION.

CLEAR: gs_header, gs_headerx, gt_partner, gt_items, gt_itemsx, gt_sched, gt_schedx, gt_return, gv_vbeln.

gs_header-doc_type   = 'TA'.
gs_header-sales_org  = c_vkorg.
gs_header-distr_chan = c_vtweg.
gs_header-division   = c_spart.

gs_headerx-doc_type   = 'X'.
gs_headerx-sales_org  = 'X'.
gs_headerx-distr_chan = 'X'.
gs_headerx-division   = 'X'.
gs_headerx-updateflag = 'I'.

CLEAR gs_partner.
gs_partner-partn_role = 'AG'.
gs_partner-partn_numb = p_kunnr.
APPEND gs_partner TO gt_partner.

CLEAR gs_partner.
gs_partner-partn_role = 'WE'.
gs_partner-partn_numb = p_kunnr.
APPEND gs_partner TO gt_partner.

CLEAR gs_item.
gs_item-itm_number = '000010'.
gs_item-material   = p_matnr.
gs_item-target_qty = p_qty.
APPEND gs_item TO gt_items.

CLEAR gs_itemx.
gs_itemx-itm_number = '000010'.
gs_itemx-material   = 'X'.
gs_itemx-target_qty = 'X'.
gs_itemx-updateflag = 'I'.
APPEND gs_itemx TO gt_itemsx.

CLEAR gs_sched.
gs_sched-itm_number = '000010'.
gs_sched-sched_line = '0001'.
gs_sched-req_date   = sy-datum.
gs_sched-req_qty    = p_qty.
APPEND gs_sched TO gt_sched.

CLEAR gs_schedx.
gs_schedx-itm_number  = '000010'.
gs_schedx-sched_line  = '0001'.
gs_schedx-req_date    = 'X'.
gs_schedx-req_qty     = 'X'.
gs_schedx-updateflag  = 'I'.
APPEND gs_schedx TO gt_schedx.

******************************************************************

CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
  EXPORTING
    order_header_in  = gs_header
    order_header_inx = gs_headerx
  IMPORTING
    salesdocument    = gv_vbeln
  TABLES
    return               = gt_return
    order_partners       = gt_partner
    order_items_in       = gt_items
    order_items_inx      = gt_itemsx
    order_schedules_in   = gt_sched
    order_schedules_inx  = gt_schedx.

DATA(lv_has_error) = abap_false.
LOOP AT gt_return INTO gs_return WHERE type = 'A' OR type = 'E'.
  lv_has_error = abap_true.
  EXIT.
ENDLOOP.

IF lv_has_error = abap_true.
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  READ TABLE gt_return INTO gs_return WITH KEY type = 'A'.
  IF sy-subrc <> 0.
    READ TABLE gt_return INTO gs_return WITH KEY type = 'E'.
  ENDIF.
  WRITE: / gs_return-message.
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
  IF gv_vbeln IS NOT INITIAL.
    WRITE: / 'Sipariş oluşturuldu: ', gv_vbeln.
  ELSE.
    READ TABLE gt_return INTO gs_return WITH KEY type = 'S'.
    IF sy-subrc = 0.
      WRITE: / gs_return-message.
    ELSE.
      WRITE: / 'İşlem tamamlandı ancak sipariş numarası alınamadı.'.
    ENDIF.
  ENDIF.
ENDIF.