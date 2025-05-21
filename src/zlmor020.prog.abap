*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 06.09.2023                                           *
*& Description  : Criando classe no se38                               *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name  :                                                      *
*& Date         :                                                      *
*& Request      :                                                      *
*& Description  :                                                      *
*&---------------------------------------------------------------------*
REPORT zlmor020.

CLASS classe_lmo DEFINITION.
  PUBLIC SECTION.
    METHODS:
      adicionar IMPORTING im_operador1     TYPE int4
                          im_operador2     TYPE int4
                RETURNING VALUE(re_result) TYPE int4.
ENDCLASS.

CLASS classe_lmo IMPLEMENTATION.
  "método de soma
  METHOD adicionar.
    re_result = im_operador1 + im_operador2.
  ENDMETHOD.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Variables declaration (Global)
*&---------------------------------------------------------------------*
DATA: go_classe TYPE REF TO classe_lmo,
      gv_result TYPE int4
      .
*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "Operação adicionar
  " Operador 1 e operador 2
  PARAMETERS: p_op1 TYPE int4 OBLIGATORY,
              p_op2 TYPE int4 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  CREATE OBJECT go_classe.

  CALL METHOD go_classe->adicionar
    EXPORTING
      im_operador1 = p_op1
      im_operador2 = p_op2
    RECEIVING
      re_result    = gv_result.

  WRITE gv_result.
