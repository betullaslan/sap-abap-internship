TYPE-POOLS: slis.
TABLES: sflight.

SELECT-OPTIONS: s_carrid FOR sflight-carrid.

TYPES: BEGIN OF ty_sflight,
         carrid        LIKE sflight-carrid,
         connid        LIKE sflight-connid,
         fldate        LIKE sflight-fldate,
         price         LIKE sflight-price,
         currency      LIKE sflight-currency,
         planetype     LIKE sflight-planetype,
         seatsmax      LIKE sflight-seatsmax,
         seatsocc      LIKE sflight-seatsocc,
         seatsmax_b    LIKE sflight-seatsmax_b,
         seatsocc_b    LIKE sflight-seatsocc_b,
         seatsmax_f    LIKE sflight-seatsmax_f,
         seatsocc_f    LIKE sflight-seatsocc_f,
         paymentsum    LIKE sflight-paymentsum,
         doluluk_orani TYPE p DECIMALS 2,
         line_color TYPE slis_specialcol_alv,
       END OF ty_sflight.

DATA: gt_sflight  TYPE STANDARD TABLE OF ty_sflight,
      gs_sflight  TYPE ty_sflight.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

DATA: lv_max TYPE p LENGTH 7 DECIMALS 0,
      lv_occ TYPE p LENGTH 7 DECIMALS 0.
