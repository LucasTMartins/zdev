*----------------------------------------------------------------------*
***INCLUDE MZLMO001_USER_COMMAND_0100I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  IF sy-ucomm = 'BACK' OR
     sy-ucomm = 'EXIT' OR
     sy-ucomm = 'CANCEL'.

    LEAVE PROGRAM.
  ELSEIF sy-ucomm = 'OPCAO1'.
    CALL TRANSACTION 'VA03'.  "Exibir ordens do cliente
  ELSEIF sy-ucomm = 'OPCAO2'.
    CALL TRANSACTION 'ME23N'. "Exibir pedido
  ELSEIF sy-ucomm = 'OPCAO3'.
    CALL TRANSACTION 'FB03'.  "Exibir documento
  ENDIF.

ENDMODULE.
