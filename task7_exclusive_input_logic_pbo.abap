MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  LOOP AT SCREEN.
     CASE screen-name.
       WHEN 'GV_SIPARIS_NO'.
         IF gv_musteri_no IS NOT INITIAL OR gv_malzeme_no IS NOT INITIAL.
           screen-input = '0'.
         ENDIF.
       WHEN 'GV_MUSTERI_NO'.
         IF gv_siparis_no IS NOT INITIAL OR gv_malzeme_no IS NOT INITIAL.
           screen-input = '0'.
         ENDIF.
       WHEN 'GV_MALZEME_NO'.
         IF gv_siparis_no IS NOT INITIAL OR gv_musteri_no IS NOT INITIAL.
           screen-input = '0'.
         ENDIF.
     ENDCASE.
     MODIFY SCREEN.
   ENDLOOP.
ENDMODULE.
