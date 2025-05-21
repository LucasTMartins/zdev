*&---------------------------------------------------------------------*
*& Include          MZLMO007O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  CLEAR gv_pos.
  PERFORM f_get_user_ud. "pega o dado de UD do usuário
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR  '0200'.

  PERFORM f_pagebut_view. "define se os botões de página estarão visiveis ou não
  PERFORM f_prepare_data. "passa os dados da tabela para a tela
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS '0300'.
  SET TITLEBAR  '0300'.

  CLEAR gv_ldest.
ENDMODULE.
