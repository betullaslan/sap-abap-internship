DATA: gv_detay TYPE xfeld,
      	  gv_ozet TYPE xfeld.

TYPES: BEGIN OF ty_urun,
         urun_kod   TYPE char10,
         urun_adi   TYPE char50,
         kategori   TYPE char20,
         stok       TYPE i,
         fiyat      TYPE i,
       END OF ty_urun.

DATA: gt_urun TYPE STANDARD TABLE OF ty_urun,
          gs_urun TYPE ty_urun.