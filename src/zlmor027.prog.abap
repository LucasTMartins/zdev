*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 26.09.2023                                           *
*& Description  : Criando ALV split                                    *
*&---------------------------------------------------------------------*
INCLUDE zlmor027top                             .    " Global Data

INCLUDE zlmor027o01                             .  " PBO-Modules
INCLUDE zlmor027i01                             .  " PAI-Modules

START-OF-SELECTION.
  CALL SCREEN 0100.

  "" FORM F_CREATE_CONTAINER
FORM f_create_container.
  "criando objeto container
  CREATE OBJECT go_custom_container
    EXPORTING
      container_name = c_container_name. "MAIN_CONT
ENDFORM.

"" FORM F_SPLI_MAIN_CONT
FORM f_spli_main_cont.
  "Criando splitter para dividir o container em dois
  CREATE OBJECT go_split_container
    EXPORTING
      parent  = go_custom_container
      rows    = 2
      columns = 1.

  "Criando primeira parte do container
  CALL METHOD go_split_container->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = go_cont_part1.

  "Criando segunda parte do container
  CALL METHOD go_split_container->get_container
    EXPORTING
      row       = 2
      column    = 1
    RECEIVING
      container = go_cont_part2.
ENDFORM.

"" FORM F_DISP_ALV1
FORM f_disp_alv1.
  "Definindo primeiro ALV do container
  CREATE OBJECT go_alv_grid1
    EXPORTING
      i_parent = go_cont_part1.

  SELECT *
    FROM mara
    INTO TABLE gt_mara.

  SORT gt_mara BY matnr.

  CALL METHOD go_alv_grid1->set_table_for_first_display
    EXPORTING
      i_structure_name = 'MARA'
    CHANGING
      it_outtab        = gt_mara.
ENDFORM.

"" FORM F_DISP_ALV2
FORM f_disp_alv2.
  "Definindo segundo ALV do container
  CREATE OBJECT go_alv_grid2
    EXPORTING
      i_parent = go_cont_part2.

  SELECT *
    FROM makt
    INTO TABLE gt_makt
    FOR ALL ENTRIES IN gt_mara
    WHERE matnr = gt_mara-matnr.

  DELETE ADJACENT DUPLICATES FROM gt_makt COMPARING matnr.

*  SORT gt_makt by matnr.

  "Imprime ALV
  CALL METHOD go_alv_grid2->set_table_for_first_display
    EXPORTING
      i_structure_name = 'MAKT'
    CHANGING
      it_outtab        = gt_makt.
ENDFORM.
