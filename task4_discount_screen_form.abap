 FORM ISLEM.
  gv_temp = 100 - gv_indirim_oran.
  gv_son_tutar =  gv_temp * gv_siparis_tutar / 100.
  IF gv_musteri_tipi EQ 'K'.
    gv_son_tutar = gv_son_tutar * 101 / 100.
  ENDIF.
ENDFORM.