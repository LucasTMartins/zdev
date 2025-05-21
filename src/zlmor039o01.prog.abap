*&---------------------------------------------------------------------*
*& Include          ZLMOR038O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  PERFORM f_buscar_dados.     "buscando dados
  PERFORM f_prepare_data.     "preparando dados
  PERFORM f_build_fields.     "criando fieldcat
  PERFORM f_create_container. "criando container e imprimindo
ENDMODULE.
