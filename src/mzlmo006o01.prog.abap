*&---------------------------------------------------------------------*
*& Include          MZLMO006O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  gs_variant-report    = sy-repid.  "Nome do programa
  gs_layout-zebra      = abap_true. "Cores zebra
  gs_layout-cwidth_opt = abap_true. "Otimizando comprimento dos campos

  PERFORM f_create_container. "Criando container e tabela
  PERFORM f_fieldcat_init.    "Criando fieldcat
ENDMODULE.
