*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 27.09.2023                                           *
*& Description  : Criando ALV split com docking                        *
*&---------------------------------------------------------------------*
""COMENTÁRIO PARA DOCUMENTAÇÃO: ALV split com docking com interação entre as duas tabelas, onde dois
"" cliques na primeira filtram o resultado da segunda.
INCLUDE zlmor029top                             .  " Global Data
INCLUDE zlmor029class                           .  " CLASS-Modules

INCLUDE zlmor029o01                             .  " PBO-Modules
INCLUDE zlmor029i01                             .  " PAI-Modules

START-OF-SELECTION.
  CALL SCREEN '0100'.

  "" FORM F_DEFINE_CONTAINER_HEADER
FORM f_define_container_header.
  DATA: ls_layout TYPE lvc_s_layo.

  IF go_docking IS BOUND AND go_alv_mara IS NOT BOUND.
    "Cria o ALV OO
    CREATE OBJECT go_alv_mara
      EXPORTING
        i_parent          = go_container_mara "Parent Container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.

    "Aqui vamos setar o click duplo no header
    SET HANDLER go_handler->handle_double_click_header FOR go_alv_mara.

    "Layout
    ls_layout-zebra = abap_true.

    "Exibe o ALV OO
    go_alv_mara->set_table_for_first_display(
      EXPORTING is_layout        = ls_layout "Layout
                i_structure_name = 'MARA'
      CHANGING
                it_outtab = gt_mara "Output Table
*               it_fieldcatalog = gt_fcat_order_prod "Field Catlog
      EXCEPTIONS
                invalid_parameter_combination = 1
                program_error                 = 2
                too_many_lines                = 3
                OTHERS                        = 4 ).
  ELSE.
    "Atualiza o ALV OO
    go_alv_mara->refresh_table_display(
      EXCEPTIONS
        finished = 1
        OTHERS   = 2 ).
  ENDIF.
ENDFORM.

FORM f_get_data.
  SELECT *
    FROM mara
    INTO TABLE gt_mara.

  SELECT *
    FROM makt
    INTO TABLE gt_makt
    WHERE spras = sy-langu.

  SORT: gt_mara BY matnr,
        gt_makt BY matnr.
ENDFORM.

FORM f_define_container_item.
  DATA: ls_layout TYPE lvc_s_layo.

  IF go_docking IS BOUND AND go_alv_makt IS NOT BOUND.
    CREATE OBJECT go_alv_makt
      EXPORTING
        i_parent          = go_container_makt "Parent Container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    "Setando o Handler do ALV Item ( Container 1,2 )
    SET HANDLER go_handler->handle_double_click_item FOR go_alv_makt.

    "Layout
    ls_layout-zebra = abap_true.

    go_alv_makt->set_table_for_first_display(
      EXPORTING
        is_layout        = ls_layout "Layout
        i_structure_name = 'Makt'
      CHANGING
        it_outtab = gt_makt "Output Table
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4 ).
  ELSE.
    go_alv_makt->refresh_table_display(
    EXCEPTIONS
      finished = 1
      OTHERS   = 2 ).
  ENDIF.
ENDFORM.
