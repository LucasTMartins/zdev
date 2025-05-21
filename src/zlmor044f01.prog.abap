*&---------------------------------------------------------------------*
*& Include          ZLMOR044F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM f_busca_dados
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
FORM f_buscar_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 40
      text       = TEXT-001. "Selecionando dados. Aguarde...

  "Passando dados de documento de vendas
  FREE gt_lmot011.
  SELECT *
    FROM zlmot011
    INTO TABLE gt_lmot011
    WHERE id IN s_id            "Ordem de Venda
    AND   dt_venda IN s_dtvend. "Data de venda

  "verificando se a tabela está vazia
  IF gt_lmot011[] IS INITIAL.
    MESSAGE i398 WITH TEXT-002 space space space.   "Ordens de venda não encontradas!
    STOP.
  ENDIF.

  "Passando dados de Mestre de Clientes
  FREE gt_lmot009.
  SELECT *
    FROM zlmot009
    INTO TABLE gt_lmot009
    FOR ALL ENTRIES IN gt_lmot011
    WHERE id EQ gt_lmot011-id_cliente. "Id cliente

  "verificando se a tabela está vazia
  IF gt_lmot009[] IS INITIAL.
    MESSAGE i398 WITH TEXT-003 space space space.   "Clientes não encontrados!
    STOP.
  ENDIF.

  "Passando dados de Mestre de Materiais
  FREE gt_lmot010.
  SELECT *
    FROM zlmot010
    INTO TABLE gt_lmot010
    FOR ALL ENTRIES IN gt_lmot011
    WHERE id EQ gt_lmot011-id_mat. "Id cliente

  "verificando se a tabela está vazia
  IF gt_lmot010[] IS INITIAL.
    MESSAGE i398 WITH TEXT-004 space space space.   "Materiais não encontrados para ordens de venda!
    STOP.
  ENDIF.

  SORT: gt_lmot009  BY id,
        gt_lmot010  BY id,
        gt_lmot011  BY id id_cliente id_mat.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_prepare_data
*&---------------------------------------------------------------------*
FORM f_prepare_data.
  LOOP AT gt_lmot011 INTO gs_lmot011.
    "lendo dados para tabela de saida
    READ TABLE gt_lmot010
      INTO gs_lmot010
      WITH KEY id = gs_lmot011-id_cliente BINARY SEARCH.

    "verificando erros
    IF sy-subrc = 0.
      gs_saida-ordem_de_venda = gs_lmot011-id.
      gs_saida-quantidade     = gs_lmot011-quantidade.
      gs_saida-dt_venda       = gs_lmot011-dt_venda.
      gs_saida-hr_venda       = gs_lmot011-hr_venda.
      gs_saida-usuario        = gs_lmot011-us_venda.
      gs_saida-valor_tot      = gs_lmot011-valor_tot.
      gs_saida-status         = gs_lmot010-ativo.
      gs_saida-material       = gs_lmot010-id.
      gs_saida-grp_merc       = gs_lmot010-grp_merc.
      gs_saida-um             = gs_lmot010-um.
      gs_saida-imposto        = gs_lmot010-imposto.
      gs_saida-valor          = gs_lmot010-valor.

      "repassando dados para tabela de saida
      APPEND gs_saida TO gt_saida.
      CLEAR gs_saida.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM f_fieldcat_init.
ENDFORM.

FORM f_imprime_dados.
ENDFORM.
