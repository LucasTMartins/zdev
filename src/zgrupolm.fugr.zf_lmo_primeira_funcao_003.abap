FUNCTION zf_lmo_primeira_funcao_003.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_OPERADOR1) TYPE  P
*"     REFERENCE(IM_OPERACAO) TYPE  C
*"     REFERENCE(IM_OPERADOR2) TYPE  P
*"  EXPORTING
*"     REFERENCE(EX_RESULT) TYPE  P
*"  EXCEPTIONS
*"      OPERATION_NOT_SUPPORTED
*"----------------------------------------------------------------------

  CLEAR ex_result.

  CASE im_operacao.
    WHEN '+'.
      ex_result = im_operador1 + im_operador2.
    WHEN  '-'.
      ex_result = im_operador1 - im_operador2.
    WHEN  '*'.
      ex_result = im_operador1 * im_operador2.
    WHEN  '/'.
      IF im_operador2 = 0.
        RAISE operation_not_supported.
      ENDIF.
      ex_result = im_operador1 / im_operador2.
    WHEN OTHERS.
      RAISE operation_not_supported.
  ENDCASE.





ENDFUNCTION.
