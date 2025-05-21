*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 27.09.2023                                           *
*& Description  : Criando ALV DOCKING                                  *
*&---------------------------------------------------------------------*

INCLUDE zlmor028top                             .    " Global Data

INCLUDE zlmor028o01                             .  " PBO-Modules
INCLUDE zlmor028i01                             .  " PAI-Modules

START-OF-SELECTION.
  CALL screen '0100'.

"" FORM F_CREATE_CONTAINER
FORM f_create_container.
  "criando objeto container 1
  CREATE OBJECT go_container1
    EXPORTING
      repid     = sy-repid
      dynnr     = sy-dynnr
      side      = go_container1->dock_at_bottom "parte de baixo
      extension = 200.

  "criando grid 1 para container 1
  CREATE OBJECT go_alv_grid1
    EXPORTING
      i_parent = go_container1.

  "criando objeto container 2
  CREATE OBJECT go_container2
    EXPORTING
      repid     = sy-repid
      dynnr     = sy-dynnr
      side      = go_container2->dock_at_top "parte de cima
      extension = 200.

  "criando grid 2 para container 2
  CREATE OBJECT go_alv_grid2
    EXPORTING
      i_parent = go_container2.
ENDFORM.

"" FORM F_DISP_ALV1
FORM f_disp_alv1.
  FREE gt_mara.

  "selecionando dados da tabela de dados gerais para a tabela de saida
  SELECT *
    FROM mara
    INTO TABLE gt_mara.

  IF sy-subrc <> 0.
    MESSAGE s000(00) WITH TEXT-001 DISPLAY LIKE 'E'. "Nenhum registro encontrado em dados gerais
    STOP.
  ENDIF.

  SORT gt_mara BY matnr.

  "imprimindo alv
  CALL METHOD go_alv_grid1->set_table_for_first_display
    EXPORTING
      i_structure_name = 'MARA'
    CHANGING
      it_outtab        = gt_mara.
ENDFORM.

"" FORM F_DISP_ALV2
FORM f_disp_alv2.
  FREE gt_makt.

  "selecionando dados da tabela de textos breves para a tabela de saida
  SELECT *
    FROM makt
    INTO TABLE gt_makt.

  IF sy-subrc <> 0.
    MESSAGE s000(00) WITH TEXT-002 DISPLAY LIKE 'E'. "Nenhum registro encontrado em textos breves
    STOP.
  ENDIF.

  DELETE ADJACENT DUPLICATES FROM gt_makt COMPARING matnr.

*  SORT gt_makt by matnr.

  "Imprime ALV
  CALL METHOD go_alv_grid2->set_table_for_first_display
    EXPORTING
      i_structure_name = 'MAKT'
    CHANGING
      it_outtab        = gt_makt.
ENDFORM.
