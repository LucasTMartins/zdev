class ZCL_PRIMEIRA_CLASSE_LMO definition
  public
  final
  create public .

public section.

  events NO_VALUE
    exporting
      value(IM_OPERADOR1) type INT4
      value(IM_OPERADOR2) type INT4 .

  class-methods ADICIONAR
    importing
      !IM_OPERADOR1 type INT4
      !IM_OPERADOR2 type INT4
    returning
      value(RE_RESULT) type INT4 .
  class-methods SUBTRAIR
    importing
      !IM_OPERADOR1 type INT4
      !IM_OPERADOR2 type INT4
    returning
      value(RE_RESULT) type INT4 .
  class-methods MULTIPLICAR
    importing
      !IM_OPERADOR1 type INT4
      !IM_OPERADOR2 type INT4
    returning
      value(RE_RESULT) type INT4 .
  methods DIVIDIR
    importing
      !IM_OPERADOR1 type INT4
      !IM_OPERADOR2 type INT4
    returning
      value(RE_RESULT) type INT4 .
protected section.
private section.

  methods HANDLE_OPERACAO
    for event NO_VALUE of ZCL_PRIMEIRA_CLASSE_LMO
    importing
      !IM_OPERADOR1
      !IM_OPERADOR2 .
ENDCLASS.



CLASS ZCL_PRIMEIRA_CLASSE_LMO IMPLEMENTATION.


  method ADICIONAR.
    re_result = im_operador1 + im_operador2.
  endmethod.


  method DIVIDIR.
    IF im_operador2 <> '0'.
      re_result = im_operador1 / im_operador2.
    else.
       set HANDLER handle_operacao for ALL INSTANCES.
       RAISE EVENT no_value EXPORTING im_operador1 = im_operador1
                                      im_operador2 = im_operador2.
    ENDIF.
  endmethod.


  method HANDLE_OPERACAO.
    IF im_operador2 = '0'.
      MESSAGE i398(00) WITH TEXT-001.
    ENDIF.
  endmethod.


  method MULTIPLICAR.
    re_result = im_operador1 * im_operador2.
  endmethod.


  method SUBTRAIR.
    re_result = im_operador1 - im_operador2.
  endmethod.
ENDCLASS.
