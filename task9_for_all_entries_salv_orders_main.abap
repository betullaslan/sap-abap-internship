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