**&---------------------------------------------------------------------*
**& Domain       :                                                      *
**& Program type : Report ALV                                           *
**& Author Name  : Lucas Martins de Oliveira                            *
**& Date         : 12.09.2023                                           *
**& Description  : Programa calculadora com tela                        *
**&---------------------------------------------------------------------*
PROGRAM zlmor021.

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA: gv_ok_code TYPE sy-ucomm,
      gv_value1  TYPE p DECIMALS 2,
      gv_value2  TYPE p DECIMALS 2,
      gv_result  TYPE p DECIMALS 2
      .

**----------------------------------------------------------------------*
INITIALIZATION.
**----------------------------------------------------------------------*
  SET PF-STATUS '9999'. "status gui da tela
  CALL SCREEN   '9999'. "chamando tela

  INCLUDE zlmor021_user_command_9999i01.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9999  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9999 INPUT.
  CASE gv_ok_code.
    WHEN 'ADD'.      "function code ADD
      COMPUTE gv_result = gv_value1 + gv_value2.
    WHEN 'SUBTRACT'. "function code SUBTRACT
      COMPUTE gv_result = gv_value1 - gv_value2.
    WHEN 'BACK' OR 'LEAVE' OR 'CANCEL'.
      LEAVE TO SCREEN 0. "ou LEAVE PROGRAM.
  ENDCASE.

  CLEAR gv_ok_code.
ENDMODULE.
