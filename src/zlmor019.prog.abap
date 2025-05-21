*&---------------------------------------------------------------------*
*& Domain       : WM                                                   *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 05.09.2023                                           *
*& Description  : Criando programa de classe                           *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name  :                                                      *
*& Date         :                                                      *
*& Request      :                                                      *
*& Description  :                                                      *
*&---------------------------------------------------------------------*
REPORT zlmor019.

**&---------------------------------------------------------------------*
**& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
**&---------------------------------------------------------------------*
TABLES : sscrfields.
*
**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS : gc_add TYPE string VALUE 'Adicionar',
            gc_sub TYPE string VALUE 'Subtrair',
            gc_mul TYPE string VALUE 'Multiplicar',
            gc_div TYPE string VALUE 'Dividir'
            .

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA: go_classe   TYPE REF TO zcl_primeira_classe_lmo,
      gv_auxiliar TYPE c,
      gv_result   TYPE int4.
*
**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  " Operador 1 e operador 2
  PARAMETERS: p_op1 TYPE int4 OBLIGATORY,
              p_op2 TYPE int4 OBLIGATORY.
  SELECTION-SCREEN SKIP 1.

  " botoes de somar, subtrair, multiplicar e dividir
  SELECTION-SCREEN PUSHBUTTON /1(15) p_but1 USER-COMMAND but1.
  SELECTION-SCREEN PUSHBUTTON 17(15) p_but2 USER-COMMAND but2.
  SELECTION-SCREEN PUSHBUTTON 33(15) p_but3 USER-COMMAND but3.
  SELECTION-SCREEN PUSHBUTTON 49(15) p_but4 USER-COMMAND but4.

  " resultado
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN COMMENT    /1(50) p_result.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
INITIALIZATION.
**----------------------------------------------------------------------*
  p_but1 = gc_add.
  p_but2 = gc_sub.
  p_but3 = gc_mul.
  p_but4 = gc_div.
*
**----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
**----------------------------------------------------------------------*
  " escondendo botão de executar
  DATA lt_itab TYPE TABLE OF sy-ucomm WITH HEADER LINE.
  APPEND 'ONLI' TO lt_itab.

  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
    EXPORTING
      p_status  = sy-pfkey
    TABLES
      p_exclude = lt_itab.

  " deixar o campo invisivel
  LOOP AT SCREEN.
    IF screen-name = 'P_RESULT'.
      IF p_result IS INITIAL.
        screen-invisible = 1.
      ELSE.
        screen-invisible = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

**----------------------------------------------------------------------*
AT SELECTION-SCREEN.
**----------------------------------------------------------------------*
  CLEAR gv_auxiliar.

  CREATE OBJECT go_classe.

  " executando as diferentes equações
  CASE sscrfields.
    WHEN 'BUT1'.
      CALL METHOD zcl_primeira_classe_lmo=>adicionar
        EXPORTING
          im_operador1 = p_op1
          im_operador2 = p_op2
        RECEIVING
          re_result    = gv_result.
    WHEN 'BUT2'.
      CALL METHOD zcl_primeira_classe_lmo=>subtrair
        EXPORTING
          im_operador1 = p_op1
          im_operador2 = p_op2
        RECEIVING
          re_result    = gv_result.
    WHEN 'BUT3'.
      CALL METHOD zcl_primeira_classe_lmo=>multiplicar
        EXPORTING
          im_operador1 = p_op1
          im_operador2 = p_op2
        RECEIVING
          re_result    = gv_result.
    WHEN 'BUT4'.
      CALL METHOD go_classe->dividir
        EXPORTING
          im_operador1 = p_op1
          im_operador2 = p_op2
        RECEIVING
          re_result    = gv_result.
  ENDCASE.

  " checando variavel auxiliar
  IF gv_auxiliar IS INITIAL.
    p_result = gv_result.
    CONDENSE p_result NO-GAPS. "Retira espaços em branco
  ENDIF.

  CONCATENATE 'Resultado:' p_result INTO p_result SEPARATED BY space.
