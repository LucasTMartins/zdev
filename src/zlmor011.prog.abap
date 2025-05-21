*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 17.08.2023                                                   *
*& Description : Exercicio criando a primeira funcao                   *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name :                                                       *
*& Date :                                                              *
*& Request :                                                           *
*& Description :                                                       *
*&---------------------------------------------------------------------*
REPORT zlmor011.

DATA: gv_result type p DECIMALS 2.        "variavel de resultado da funcao

SELECTION-SCREEN BEGIN OF BLOCK b0.
  PARAMETERS: p_op1 type p DEFAULT 2 OBLIGATORY,    "parametro do operador 1
              p_opr type c DEFAULT '+' OBLIGATORY,    "parametro da operacao
              p_op2 type p DEFAULT 2 OBLIGATORY.    "parametro do operador 2
SELECTION-SCREEN END OF BLOCK b0.

START-OF-SELECTION.
  CALL FUNCTION 'ZF_LMO_PRIMEIRA_FUNCAO_003' "chamando funcao de calculo
    EXPORTING
      im_operador1                  = p_op1
      im_operacao                   = p_opr
      im_operador2                  = p_op2
   IMPORTING
     EX_RESULT                     = gv_result
   EXCEPTIONS
     OPERATION_NOT_SUPPORTED       = 1
     OTHERS                        = 2
            .

  WRITE: / 'Resultado:', gv_result.         "mostrando resultado final
