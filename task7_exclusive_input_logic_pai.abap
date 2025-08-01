MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'SORGULA'.
      DATA(lv_found) = abap_false.

      IF gv_siparis_no IS NOT INITIAL AND gv_musteri_no IS INITIAL AND gv_malzeme_no IS INITIAL.
        READ TABLE gt_siparis WITH KEY siparis_no = gv_siparis_no TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          PERFORM siparis_gosterme.
        ELSE.
          MESSAGE 'Geçersiz Sipariş Numarası!' TYPE 'E'.
        ENDIF.

      ELSEIF gv_musteri_no IS NOT INITIAL AND gv_siparis_no IS INITIAL AND gv_malzeme_no IS INITIAL.
        READ TABLE gt_musteri WITH KEY musteri_no = gv_musteri_no TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          PERFORM musteri_gosterme.
        ELSE.
          MESSAGE 'Geçersiz Müşteri Numarası!' TYPE 'E'.
        ENDIF.

      ELSEIF gv_malzeme_no IS NOT INITIAL AND gv_siparis_no IS INITIAL AND gv_musteri_no IS INITIAL.
        READ TABLE gt_malzeme WITH KEY malzeme_no = gv_malzeme_no TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          PERFORM malzeme_gosterme.
        ELSE.
          MESSAGE 'Geçersiz Malzeme Numarası!' TYPE 'E'.
        ENDIF.

      ELSE.
        MESSAGE 'Lütfen yalnızca bir alan doldurunuz!' TYPE 'I'.
      ENDIF.

    IF gv_siparis_no IS NOT INITIAL OR gv_musteri_no IS NOT INITIAL OR gv_malzeme_no IS NOT INITIAL.
      SET SCREEN 0100.
      LEAVE SCREEN.
    ENDIF.
  ENDCASE.
ENDMODULE.
