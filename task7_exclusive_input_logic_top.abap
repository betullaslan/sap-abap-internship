TYPES: BEGIN OF ty_siparis,
         siparis_no TYPE char10,
         tarih      TYPE d,
         musteri    TYPE char20,
       END OF ty_siparis.

TYPES: BEGIN OF ty_musteri,
         musteri_no TYPE char10,
         musteri_ad TYPE char20,
         sehir      TYPE char15,
       END OF ty_musteri.

TYPES: BEGIN OF ty_malzeme,
         malzeme_no TYPE char10,
         malzeme_ad TYPE char20,
         stok       TYPE i,
       END OF ty_malzeme.

DATA: gt_siparis TYPE STANDARD TABLE OF ty_siparis,
      gt_musteri TYPE STANDARD TABLE OF ty_musteri,
      gt_malzeme TYPE STANDARD TABLE OF ty_malzeme.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv.

DATA: gv_siparis_no  TYPE char10,
      gv_musteri_no  TYPE char10,
      gv_malzeme_no  TYPE char10.
