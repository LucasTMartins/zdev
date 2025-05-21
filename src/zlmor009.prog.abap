*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 15.08.2023                                                   *
*& Description : Exemplo exit de conversão                             *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name :                                                       *
*& Date :                                                              *
*& Request :                                                           *
*& Description :                                                       *
*&---------------------------------------------------------------------*
REPORT zlmor009.

DATA: gv_cpf TYPE char80.

SELECTION-SCREEN BEGIN OF BLOCK b0. "passando o parametro do cpf
  PARAMETERS: p_cpf TYPE char80 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b0.

START-OF-SELECTION.

  CALL FUNCTION 'ZF_LMO_CONVERT_CPF_001'
    EXPORTING
      input  = p_cpf
    IMPORTING
      output = gv_cpf.

*CALL FUNCTION 'ZF_LMO_CONVERT_CPF_002'
* EXPORTING
*   INPUT         = p_cpf
*   IMPORTING
*     OUTPUT = gv_cpf.

  WRITE: gv_cpf.



end-of-SELECTION.
