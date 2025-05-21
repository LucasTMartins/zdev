*&---------------------------------------------------------------------*
*& Domain       : WM                                                   *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 28.08.2023                                           *
*& Description  : Exercicio relampago ALV                              *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name  :                                                      *
*& Date         :                                                      *
*& Request      :                                                      *
*& Description  :                                                      *
*&---------------------------------------------------------------------*
REPORT zlmor016.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : mseg, "Segmento de documento - material
         mara. "Dados gerais de material

*&---------------------------------------------------------------------*
*& Constants declaration
*&---------------------------------------------------------------------*
CONSTANTS : gc_mblnr_low TYPE p      VALUE '0000000001', "Num doc
            gc_mblnr_high TYPE p      VALUE '9000000000', "Num doc
            gc_matnr_high TYPE string VALUE 'Z',          "Material
            gc_ersda_low  TYPE date   VALUE '20100101',   "Data
            gc_ersda_high TYPE date   VALUE '20221231'    "Data
            .

*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_mseg,
         mblnr TYPE mseg-mblnr, "Num doc
         mjahr TYPE mseg-mjahr, "Ano
         zeile TYPE mseg-zeile, "Item
         matnr TYPE mseg-matnr, "Material
         werks TYPE mseg-werks, "Centro
       END OF gty_mseg,
       BEGIN OF gty_mara,
         matnr TYPE mara-matnr, "Material
         ernam TYPE mara-ernam, "Responsavel
         mtart TYPE mara-mtart, "Tipo material
       END OF gty_mara,
       BEGIN OF gty_saida,
         box,                   "Checkbox
         mblnr TYPE mseg-mblnr, "Num doc
         mjahr TYPE mseg-mjahr, "Ano
         zeile TYPE mseg-zeile, "Item
         matnr TYPE mseg-matnr, "Material
         werks TYPE mseg-werks, "Centro
         ernam TYPE mara-ernam, "Responsavel
         mtart TYPE mara-mtart, "Tipo material
         maktx TYPE makt-maktx, "Descrição
       END OF gty_saida,
       BEGIN OF gty_makt,
         matnr TYPE makt-matnr, "Material
         spras TYPE makt-spras, "Idioma
         maktx TYPE makt-maktx, "Descrição
       END OF gty_makt.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: gt_mseg     TYPE STANDARD TABLE OF gty_mseg,
      gt_mara     TYPE STANDARD TABLE OF gty_mara,
      gt_saida    TYPE STANDARD TABLE OF gty_saida,
      gt_makt     TYPE STANDARD TABLE OF gty_makt,
      gt_zlmot001 TYPE STANDARD TABLE OF zlmot001,
      gt_fieldcat TYPE slis_t_fieldcat_alv.

*&---------------------------------------------------------------------*
*& Structure declaration (Global)
*&---------------------------------------------------------------------*
DATA: gs_mseg     TYPE gty_mseg,
      gs_mara     TYPE gty_mara,
      gs_saida    TYPE gty_saida,
      gs_makt     TYPE gty_makt,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv,
      gs_zlmot001 TYPE zlmot001.

*&---------------------------------------------------------------------*
*& Variables declaration (Global)
*&---------------------------------------------------------------------*
DATA: gv_repid TYPE sy-repid.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_mblnr FOR mseg-mblnr OBLIGATORY. "Num doc
  SELECT-OPTIONS: s_matnr FOR mseg-matnr.            "Material
  SELECT-OPTIONS: s_ersda FOR mara-ersda.            "Data
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*
  gv_repid                    = sy-repid.                   "Nome do programa
  gs_layout-colwidth_optimize = abap_true.                  "Otimizar a largura da coluna
  s_mblnr-low                 = gc_mblnr_low.                "0000000001
  s_mblnr-high                = gc_mblnr_high.              "9000000000

  APPEND s_mblnr TO s_mblnr.

  s_matnr-high                = gc_matnr_high.               "Z
  APPEND s_matnr TO s_matnr.

  s_ersda-low                 = gc_ersda_low.                "20100101
  s_ersda-high                = gc_ersda_high.               "20221231
  APPEND s_ersda TO s_ersda.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM f_buscar_dados.
  PERFORM f_preparar_dados.
  PERFORM f_layout_build.
  PERFORM f_fieldcat_init.
  PERFORM f_imprimir_dados.

*----------------------------------------------------------------------*
END-OF-SELECTION.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
*       Busca os dados para o ALV
*----------------------------------------------------------------------*
FORM f_buscar_dados.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 40
      text       = TEXT-002. "Selecionando dados. Aguarde...

  " Passando dados do segmento de documento do material para tabela interna(GT_MSEG)
  FREE gt_mseg.
  SELECT mblnr mjahr zeile matnr werks "Num doc//Ano//Item//Material//Centro
    FROM mseg
    INTO TABLE gt_mseg
    WHERE mblnr IN s_mblnr "Num doc
    AND matnr IN s_matnr.  "Material

  " Verificando se há dados na tabela interna(gt_mseg)
  IF gt_mseg[] IS INITIAL.
    MESSAGE i398(00) WITH TEXT-003.   "Nenhum registro encontrado
    stop.
  ELSE.
    " Passando dados gerais de material para tabela interna(GT_MARA)
    FREE gt_mara.
    SELECT matnr ernam mtart "Material//Responsavel//Tipo material
      FROM mara
      INTO TABLE gt_mara
      FOR ALL ENTRIES IN gt_mseg
      WHERE matnr = gt_mseg-matnr "Material
      AND ersda IN s_ersda. "Data

    " Passando textos breves de material para tabela interna(GT_MAKT)
    free gt_makt.
    SELECT matnr maktx "Material//Descrição
      FROM makt
      INTO TABLE gt_makt
      FOR ALL ENTRIES IN gt_mseg
      WHERE matnr = gt_mseg-matnr "Material
      AND spras = sy-langu. "Idioma
  ENDIF.

  SORT: gt_mseg BY matnr,
        gt_mara BY matnr,
        gt_makt BY matnr. "Material
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_PREPARAR_DADOS
*&---------------------------------------------------------------------*
*       Prepara os dados para o ALV
*----------------------------------------------------------------------*
FORM f_preparar_dados.
  CLEAR: gt_saida[], gs_mara, gs_mseg, gs_makt.

  " Juntando os dados do material na tabela interna de saida
  LOOP AT gt_mseg INTO gs_mseg.
    READ TABLE gt_mara INTO gs_mara
    WITH KEY matnr = gs_mseg-matnr BINARY SEARCH.

    IF sy-subrc = 0.
      gs_saida-mblnr = gs_mseg-mblnr.
      gs_saida-mjahr = gs_mseg-mjahr.
      gs_saida-zeile = gs_mseg-zeile.
      gs_saida-matnr = gs_mseg-matnr.
      gs_saida-werks = gs_mseg-werks.
      gs_saida-ernam = gs_mara-ernam.
      gs_saida-mtart = gs_mara-mtart.
      gs_saida-maktx = gs_makt-maktx.

      READ TABLE gt_makt INTO gs_makt
      WITH KEY matnr = gs_mseg-matnr BINARY SEARCH.

      IF sy-subrc = 0.
        gs_saida-maktx = gs_makt-maktx.
      ENDIF.

      APPEND gs_saida TO gt_saida.
    ENDIF.

    CLEAR: gs_mseg, gs_mara, gs_saida, gs_makt.
  ENDLOOP.

  SORT gt_saida BY mblnr zeile.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT_INIT
*&---------------------------------------------------------------------*
*       Estrutura da lista
*----------------------------------------------------------------------*
FORM f_fieldcat_init.
  CLEAR: gt_fieldcat[], gs_fieldcat.

  PERFORM f_add_campo USING 'MBLNR' 'MSEG' 'N° DOC'.
  PERFORM f_add_campo USING 'MJAHR' 'MSEG' 'ANO'.
  PERFORM f_add_campo USING 'ZEILE' 'MSEG' 'ITEM'.
  PERFORM f_add_campo USING 'MATNR' 'MSEG' 'N° MAT'.
  PERFORM f_add_campo USING 'WERKS' 'MSEG' 'CENTRO'.
  PERFORM f_add_campo USING 'ERNAM' 'MARA' 'RESPONSÁVEL'.
  PERFORM f_add_campo USING 'MTART' 'MARA' 'TIPO MAT'.
  PERFORM f_add_campo USING 'MAKTX' 'MAKT' 'DESCRIÇÃO'.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_IMPRIMIR_DADOS
*&---------------------------------------------------------------------*
*       DISPLAY DA LISTA
*----------------------------------------------------------------------*
FORM f_imprimir_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 60
      text       = TEXT-004.

  " Imprimindo ALV GRID
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = gv_repid
      i_callback_pf_status_set = 'F_PF_STATUS'
      i_callback_user_command  = 'F_USER_COMMAND'
      is_layout                = gs_layout
      it_fieldcat              = gt_fieldcat
    TABLES
      t_outtab                 = gt_saida
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       LAYOUT DE SAIDA
*----------------------------------------------------------------------*
*       --> GS_LAYOUT - ESTRUTURA  PARA LAYOUT DE SAIDA DA LISTA
*----------------------------------------------------------------------*
FORM f_layout_build.
  " Criando checkbox
  gs_layout-group_change_edit = abap_true.

  gs_layout-box_fieldname   = 'BOX'.
  gs_layout-box_tabname = 'GT_SAIDA'.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_PF_STATUS
*&---------------------------------------------------------------------*
*       STATUS DO GUI
*----------------------------------------------------------------------*
FORM f_pf_status USING r_flg_popup.
  SET PF-STATUS 'Z_STATUS_GUI'.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_USER_COMMAND
*&---------------------------------------------------------------------*
*       COMANDOS DO USUARIO
*----------------------------------------------------------------------*
FORM f_user_command USING pv_ucomm TYPE sy-ucomm
                          pv_selfield TYPE slis_selfield.

  CASE pv_ucomm.
    WHEN '&EXCLUIR'.
      " Exclui as linhas selecionadas
      DELETE gt_saida WHERE box = abap_true.

      pv_selfield-refresh = abap_true.
    WHEN '&GRAVAR'.
      " Grava as linhas selecionadas na tabela externa
      CLEAR: gs_saida, gs_zlmot001.

      LOOP AT gt_saida INTO gs_saida WHERE box = abap_true.
        MOVE: gs_saida-matnr TO gs_zlmot001-matnr,
              gs_saida-maktx TO gs_zlmot001-maktx,
              gs_saida-werks TO gs_zlmot001-werks,
              gs_saida-ernam TO gs_zlmot001-ernam,
              gs_saida-mtart TO gs_zlmot001-mtart.

        APPEND gs_zlmot001 TO gt_zlmot001.
        CLEAR: gs_saida, gs_zlmot001.
      ENDLOOP.

      MODIFY zlmot001 FROM TABLE gt_zlmot001.

      IF sy-subrc = '0'.
        COMMIT WORK.
        MESSAGE i368(00) WITH text-005.
      ELSE.
        ROLLBACK WORK.
        MESSAGE i368(00) WITH text-006.
      ENDIF.

      CLEAR: gt_zlmot001.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_ADD_CAMPO
*&---------------------------------------------------------------------*
*       CONSTRUÇÃO FIELDCAT
*----------------------------------------------------------------------*
FORM f_add_campo USING pv_fieldname
                       pv_tabname
                       pv_seltext_l.

  " Criando fieldcat
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = pv_fieldname.
  gs_fieldcat-tabname = pv_tabname.
  gs_fieldcat-seltext_l = pv_seltext_l.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
