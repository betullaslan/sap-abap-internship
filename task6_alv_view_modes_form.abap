FORM VERI_YUKLEME.
  APPEND VALUE #( urun_kod = '001' urun_adi = 'kalem' kategori = 'kırtasiye' stok = 500 fiyat = 34 ) TO gt_urun.
  APPEND VALUE #( urun_kod = '002' urun_adi = 'telefon' kategori = 'elektronik' stok = 120 fiyat = 2500 ) TO gt_urun.
  APPEND VALUE #( urun_kod = '003' urun_adi = 'masa' kategori = 'eşya' stok = 75 fiyat = 1800 ) TO gt_urun.
  APPEND VALUE #( urun_kod = '004' urun_adi = 'çanta' kategori = 'aksesuar' stok = 250 fiyat = 580 ) TO gt_urun.
  APPEND VALUE #( urun_kod = '005' urun_adi = 'bardak' kategori = 'mutfak eşyası' stok = 700 fiyat = 80 ) TO gt_urun.
ENDFORM.

FORM ALV_GOSTERME .
  DATA: lt_fcat TYPE slis_t_fieldcat_alv,
        ls_fcat TYPE slis_fieldcat_alv.

  CLEAR lt_fcat.

  DEFINE add_col.
  CLEAR ls_fcat.
  ls_fcat-fieldname = &1.
  ls_fcat-seltext_l = &2.
  APPEND ls_fcat TO lt_fcat.
  END-OF-DEFINITION.

  add_col 'URUN_KOD' 'Ürün Kodu'.
  add_col 'URUN_ADI' 'Ürün Adı'.

  IF gv_detay = 'X'.
    add_col 'KATEGORI' 'Kategori'.
    add_col 'STOK'     'Stok'.
    add_col 'FIYAT'    'Fiyat'.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_structure_name = ''
      it_fieldcat      = lt_fcat
    TABLES
      t_outtab         = gt_urun.
ENDFORM.