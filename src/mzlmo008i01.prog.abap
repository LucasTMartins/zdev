*----------------------------------------------------------------------*
***INCLUDE MZLMO008I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN gc_back OR gc_exit OR gc_cancel. "sair do programa
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0120  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0120 INPUT.
  CASE sy-ucomm.
    WHEN gc_enter. "validar checkin
      PERFORM f_valid_checkin.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0130  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0130 INPUT.
  CASE sy-ucomm.
    WHEN gc_save OR gc_enter.
      PERFORM f_valid_reserva.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0150  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0150 INPUT.
  CASE sy-ucomm.
    WHEN gc_enter. "validando marcação de vôo
      PERFORM f_valid_marcar_voo.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  M_LOCATION  INPUT
*&---------------------------------------------------------------------*
MODULE m_location INPUT.
  TYPES: BEGIN OF lty_mc_location, "dados que serão buscados no matchcode
           domvalue_l TYPE char10,
           ddtext     TYPE char60,
         END OF lty_mc_location.

  DATA: lt_mc_location TYPE TABLE OF lty_mc_location,
        lt_return      TYPE STANDARD TABLE OF ddshretval,
        ls_return      TYPE ddshretval.

  SELECT domvalue_l ddtext "buscando dados de valores fixos no dominio zd_location
    FROM dd07v
    INTO TABLE lt_mc_location
    WHERE domname = 'ZD_LOCATION'.

  SORT lt_mc_location BY domvalue_l. "ordenando valores

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST' "chamando matchcode
    EXPORTING
      retfield        = 'DOMVALUE_L'
      dynpprog        = sy-repid
      value_org       = 'S'
    TABLES
      value_tab       = lt_mc_location[]
      return_tab      = lt_return[]
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2.

  IF sy-subrc NE 0. "validando e passando valor do matchcode para o campo
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    READ TABLE lt_return INTO ls_return INDEX 1.
    gv_checkin_param-location = ls_return-fieldval.
  ENDIF.
ENDMODULE.
