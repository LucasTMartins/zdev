*&---------------------------------------------------------------------*
*& Include          MZLMO006I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      PERFORM f_buscar_dados.
      PERFORM f_imprimir_dados.
  ENDCASE.
ENDMODULE.
