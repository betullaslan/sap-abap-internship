TYPES: BEGIN OF ty_siparis,
         siparis_no TYPE char10,
         tarih      TYPE d,
         musteri    TYPE char20,
       END OF ty_siparis.

TYPES: BEGIN OF ty_musteri,
         musteri_no TYPE char10,
         musteri_ad         TYPE char20,
         sehir      TYPE char15,
       END OF ty_musteri.

TYPES: BEGIN OF ty_malzeme,
         malzeme_no TYPE char10,
         malzeme_ad TYPE char20,
         stok       TYPE i,
       END OF ty_malzeme.

DATA: gv_rad1 TYPE xfeld,
      gv_rad2 TYPE xfeld,
      gv_rad3 TYPE xfeld.

DATA: gt_siparis TYPE STANDARD TABLE OF ty_siparis,
      gt_musteri TYPE STANDARD TABLE OF ty_musteri,
      gt_malzeme TYPE STANDARD TABLE OF ty_malzeme.

DATA: gs_siparis TYPE ty_siparis,
      gs_musteri TYPE ty_musteri,
      gs_malzeme TYPE ty_malzeme.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv.