*&---------------------------------------------------------------------*
*& Report ZLMOR037
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zlmor037top                            .    " Global Data

* INCLUDE ZLMOR0037O01                            .  " PBO-Modules
* INCLUDE ZLMOR0037I01                            .  " PAI-Modules
*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*
  gv_repid                    = sy-repid.                   "Nome do programa
  gs_layout-colwidth_optimize = abap_true.                  "Otimizar a largura da coluna
  gs_layout-zebra             = abap_true.                  "Cores zebra

  INCLUDE zlmor037f01                            .  " FORM-Routines

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM f_buscar_dados.   "buscando dados
  PERFORM f_fieldcat_init.  "construindo fieldcat
  PERFORM f_imprimir_dados. "imprimindo dados
