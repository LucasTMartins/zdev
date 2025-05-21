*&---------------------------------------------------------------------*
*& Domain       : WM                                                   *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 05.09.2023                                           *
*& Description  : Criando primeira classe                              *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name  :                                                      *
*& Date         :                                                      *
*& Request      :                                                      *
*& Description  :                                                      *
*&---------------------------------------------------------------------*
REPORT zlmor018.
" variavel de resultado
DATA: lv_result TYPE int4.

" chamando método para somar dois números passando 7 e 22, e retornando o resultado para variavel local
CALL METHOD zcl_primeira_classe_lmo=>adicionar
  EXPORTING
    im_operador1 = '7'
    im_operador2 = '22'
  RECEIVING
    re_result    = lv_result.

WRITE lv_result.
