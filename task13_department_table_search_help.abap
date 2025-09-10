TABLES: ZBA_DEPARTMAN.

PARAMETERS: p_deptid TYPE ZBA_DEPT_ID_DE
            MATCHCODE OBJECT ZBA_DEPT_SH.

START-OF-SELECTION.

  DATA: lt_dept TYPE TABLE OF ZBA_DEPARTMAN.

  SELECT * FROM ZBA_DEPARTMAN
  INTO TABLE lt_dept WHERE dept_id = p_deptid.

  IF sy-subrc = 0.
    cl_salv_table=>factory(
      IMPORTING r_salv_table = DATA(lo_alv)
      CHANGING  t_table      = lt_dept ).

    lo_alv->display( ).
  ELSE.
    MESSAGE 'Seçilen departman bulunamadı' TYPE 'I'.
  ENDIF.