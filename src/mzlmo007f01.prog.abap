*&---------------------------------------------------------------------*
*& Include          MZLMO007F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  f_get_user_ud
*&---------------------------------------------------------------------*
FORM f_get_user_ud.
  ""coletando número de depósito do usuário
  CALL FUNCTION 'L_USER_DATA_GET_INT'
    EXPORTING
      i_uname         = sy-uname
    IMPORTING
      e_user          = gs_user
    EXCEPTIONS
      no_entry_found  = 1
      no_unique_entry = 2
      OTHERS          = 3.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_pagebut_view
*&---------------------------------------------------------------------*
FORM f_pagebut_view.
  ""Deixando botões de proximo e anterior invisiveis caso tenha somente 1 resultado
  IF gv_lines_lqua EQ 1."quantidade de resultados
    LOOP AT SCREEN.
      IF screen-name = gc_antbut OR screen-name = gc_proxbut.
        screen-invisible = gc_one.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_prepare_data
*&---------------------------------------------------------------------*
FORM f_prepare_data.
  DATA: lv_lenmaktx     TYPE p,
        lv_vfdatext(10) TYPE c.

  CLEAR gs_label_ud.

  "lendo dados de UD/Pos/Material para tela de dados de estoque
  READ TABLE gt_lqua INTO gs_lqua INDEX gv_pagina.

  "verificando erros
  IF sy-subrc = 0.
    CLEAR gv_lgtyp.
    gv_lgtyp = gs_lqua-lgtyp. "tp. dep

    CLEAR gv_lgpla.
    gv_lgpla = gs_lqua-lgpla. "posição

    CLEAR gv_lenum.
    ""retirando zeros a esquerda do UD
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT' "UD
      EXPORTING
        input  = gs_lqua-lenum
      IMPORTING
        output = gv_lenum.

    CLEAR gv_charg.
    gv_charg = gs_lqua-charg. " Lote

    CLEAR gv_vfdat.
    gv_vfdat = gs_lqua-vfdat. "Data de vencimento
    IF gv_vfdat IS INITIAL.
      ""tornando o campo de data invisivel caso não tenha dados
      LOOP AT SCREEN.
        IF screen-name = gc_vfdat OR screen-name = gc_vfdattext. "campo de data
          screen-invisible = gc_one.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.

    CLEAR gv_matnr.
    ""retirando zeros a esquerda do material
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT' "Material
      EXPORTING
        input  = gs_lqua-matnr
      IMPORTING
        output = gv_matnr.

    CLEAR gv_letyp.
    gv_letyp = gs_lqua-letyp. "TUD

    ""buscando dados de descrição na makt
    SELECT SINGLE maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF gs_makt
      WHERE matnr = gs_lqua-matnr.

    CLEAR gv_maktx.
    lv_lenmaktx = strlen( gs_makt-maktx ). "recebendo tamanho da descrição
    gv_maktx = gs_makt-maktx. "parte 1 da descrição
    IF lv_lenmaktx > 20.
      gv_maktx2 = gs_makt-maktx+20. "parte 2 da descrição
    ENDIF.

    CLEAR gv_verme.
    gv_verme = gs_lqua-verme. "estoque disponivel

    CLEAR gv_meins.
    gv_meins = gs_lqua-meins. "unidade de medida básica

    ""Passando dados para a etiqueta
    gs_label_ud-matnr = gs_lqua-matnr.
    gs_label_ud-maktx = gs_makt-maktx.
    gs_label_ud-lenum = gs_lqua-lenum.
    gs_label_ud-lgtyp = gs_lqua-lgtyp.
    gs_label_ud-charg = gs_lqua-charg.
    gs_label_ud-lgort = gs_lqua-lgort.
    gs_label_ud-lgnum = gs_lqua-lgnum.
    gs_label_ud-bdatu = gs_lqua-bdatu.
    gs_label_ud-lgpla = gs_lqua-lgpla.

    FREE gt_label_ud.
    APPEND gs_label_ud TO gt_label_ud.

    PERFORM f_validando_pagebut. "verificando quantidade de páginas
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_validando_pagebut
*&---------------------------------------------------------------------*
FORM f_validando_pagebut.
  IF gv_pagina = 1.
    ""esconde botão de voltar página
    LOOP AT SCREEN.
      IF screen-name = gc_antbut.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF gv_pagina >= gv_lines_lqua.
    ""mostra botão de avançar página
    LOOP AT SCREEN.
      IF screen-name = gc_proxbut.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
