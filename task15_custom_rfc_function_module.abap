PARAMETERS: p_matnr TYPE matnr OBLIGATORY.

DATA: ls_out TYPE ZBA_MALZEME.

CALL FUNCTION 'ZBA_MALZEME'
  DESTINATION 'NONE'
  EXPORTING
    iv_matnr = p_matnr
  IMPORTING
    ev_mara  = ls_out
  EXCEPTIONS
    invalid_input = 1
    not_found     = 2
    OTHERS        = 3.

IF sy-subrc = 0.
  WRITE: / 'Malzeme No:', ls_out-malz_no.
  WRITE: / 'Malzeme Türü:', ls_out-malz_tur.
  WRITE: / 'Açıklama:', ls_out-malz_acik.
ELSEIF sy-subrc = 1.
  WRITE: / 'Giriş hatalı (IV_MATNR).'.
ELSEIF sy-subrc = 2.
  WRITE: / 'Kayıt bulunamadı.'.
ELSE.
  WRITE: / 'Hata kodu:', sy-subrc.
ENDIF.