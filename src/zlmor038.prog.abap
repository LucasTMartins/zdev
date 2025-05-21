*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 25.10.2023                                           *
*& Description  : ALV de 5 tabelas                                     *
*&---------------------------------------------------------------------*

INCLUDE zlmor038top                             .    " Global Data

*INCLUDE zlmor038o01                             .  " PBO-Modules
*INCLUDE zlmor038i01                             .  " PAI-Modules
INCLUDE zlmor038f01                             .  " FORM-Routines

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM f_buscar_dados.   "buscando dados
  PERFORM f_prepare_data.   "preparando dados
  PERFORM f_build_fields.   "construindo fieldcat
  PERFORM f_imprimir_dados. "imprimindo dados
