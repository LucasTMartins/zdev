*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 23.08.2023                                           *
*& Description  : Relatório documento de vendas                        *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name  :                                                      *
*& Date         :                                                      *
*& Request      :                                                      *
*& Description  :                                                      *
*&---------------------------------------------------------------------*
REPORT zlmor015.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
TABLES : likp. "DADOS CABEÇALHO

*&---------------------------------------------------------------------*
*& Constants declaration
*&---------------------------------------------------------------------*
CONSTANTS : c_vbeln_low TYPE i VALUE '000000000',
            c_vbeln_high TYPE i VALUE '500000000',
            c_erdat_low TYPE date VALUE '20100101',
            c_erdat_high TYPE date VALUE '20221231'.

*&---------------------------------------------------------------------*
*& Types declaration
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

TYPES: BEGIN OF gty_likp_lips, "SAIDA
         vbeln TYPE likp-vbeln, "ENTREGA
         ernam TYPE likp-ernam, "NOME RESPONSAVEL
         erdat TYPE likp-erdat, "DATA
         lfart TYPE likp-lfart, "TIPO
         matnr TYPE lips-matnr, "N° MATERIAL
         matkl TYPE lips-matkl, "GRUPO
         meins TYPE lips-meins, "UNIDADE MEDIDA
       END OF gty_likp_lips,
      BEGIN OF gty_likp,
         vbeln TYPE likp-vbeln, "ENTREGA
         ernam TYPE likp-ernam, "NOME RESPONSAVEL
         erdat TYPE likp-erdat, "DATA
         lfart TYPE likp-lfart, "TIPO
       END OF   gty_likp,
       BEGIN OF gty_lips,
         vbeln TYPE lips-vbeln, "ENTREGA
         matnr TYPE lips-matnr, "N° MATERIAL
         matkl TYPE lips-matkl, "GRUPO
         meins TYPE lips-meins, "UNIDADE MEDIDA
       END OF gty_lips.

*&---------------------------------------------------------------------*
*& Internal table declaration
*&---------------------------------------------------------------------*
DATA: gt_saida    TYPE STANDARD TABLE OF gty_likp_lips,
      gt_likp     TYPE STANDARD TABLE OF gty_likp,
      gt_lips     TYPE STANDARD TABLE OF gty_lips,
      gt_fieldcat TYPE slis_t_fieldcat_alv.

*&---------------------------------------------------------------------*
*& Structure declaration (Global)
*&---------------------------------------------------------------------*
DATA: gs_lips     TYPE gty_lips,
      gs_likp     TYPE gty_likp,
      gs_saida    TYPE gty_likp_lips,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

*&---------------------------------------------------------------------*
*& Variables declaration (Global)
*&---------------------------------------------------------------------*
DATA: gv_repid TYPE sy-repid. "NOME DO PROGRAMA

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "RELATÓRIO
  SELECT-OPTIONS: s_vbeln FOR likp-vbeln OBLIGATORY.          "ENTREGA
  SELECT-OPTIONS: s_erdat FOR likp-erdat.                     "DATA
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*
  gv_repid                    = sy-repid.      "nome do programa
  gs_layout-colwidth_optimize = 'X'.           "otimizar a largura da coluna
  s_vbeln-low                 = c_vbeln_low.   "000000000
  s_vbeln-high                = c_vbeln_high.  "500000000
  APPEND s_vbeln TO s_vbeln.

  s_erdat-low                 = c_erdat_low.   "20100101
  s_erdat-high                = c_erdat_high.    "20221231
  APPEND s_erdat TO s_erdat.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM f_busca_dados.
  PERFORM f_prepara_dados.
  PERFORM f_fieldcat_init.
  PERFORM f_imprime_dados.

*----------------------------------------------------------------------*
END-OF-SELECTION.


*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DADOS
*&---------------------------------------------------------------------*
*       OBTER INFORMAÇÕES PARA LISTA
*----------------------------------------------------------------------*
FORM f_busca_dados.

"MENSAGEM AO USUÁRIO
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = TEXT-002.   "Selecionando dados. Aguarde...

"SEPARANDO OS DADOS CONFORME O FILTRO EM SELECTION-SCREEN
  SELECT vbeln ernam erdat lfart
    INTO TABLE gt_likp
    FROM likp
    WHERE vbeln IN s_vbeln
    AND erdat IN s_erdat.

"VERIFICANDO SE A TABELA ESTÁ VAZIA
  IF gt_likp[] IS INITIAL.
    MESSAGE i398(00) WITH TEXT-003. "Nenhum registro encontrado
  ELSE.
    "SEPARANDO OS DADOS CONFORME O FILTRO EM SELECTION-SCREEN
    SELECT vbeln matnr matkl meins
      INTO TABLE gt_lips
      FROM lips
      FOR ALL ENTRIES IN gt_likp
      WHERE vbeln = gt_likp-vbeln.

"ORDENANDO TABELAS
    SORT gt_likp BY vbeln.
    SORT gt_lips BY vbeln.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_PREPARA_DADOS
*&---------------------------------------------------------------------*
*       PREPARA DADOS
*----------------------------------------------------------------------*
FORM f_prepara_dados.

  CLEAR: gt_saida[], gs_lips, gs_likp.

"JUNTANDO DADOS DAS TABELAS PARA SAIDA
  LOOP AT gt_lips INTO gs_lips.
    READ TABLE gt_likp INTO gs_likp
    WITH KEY vbeln = gs_lips-vbeln BINARY SEARCH.

    IF sy-subrc = 0.
      gs_saida-vbeln = gs_likp-vbeln.
      gs_saida-ernam = gs_likp-ernam.
      gs_saida-erdat = gs_likp-erdat.
      gs_saida-lfart = gs_likp-lfart.
      gs_saida-matnr = gs_lips-matnr.
      gs_saida-matkl = gs_lips-matkl.
      gs_saida-meins = gs_lips-meins.

      APPEND gs_saida TO gt_saida.
    ENDIF.

    CLEAR: gs_likp, gs_lips, gs_saida.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT_INIT
*&---------------------------------------------------------------------*
*       ESTRUTURA DA LISTA
*----------------------------------------------------------------------*
FORM f_fieldcat_init.

  CLEAR: gt_fieldcat[], gs_fieldcat.

  gs_fieldcat-fieldname   = 'VBELN'.
  gs_fieldcat-ref_tabname = 'LIKP'.
  gs_fieldcat-seltext_l   = 'ENTREGA'.
  gs_fieldcat-hotspot     = 'X'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'ERNAM'.
  gs_fieldcat-ref_tabname = 'LIKP'.
  gs_fieldcat-seltext_l   = 'NOME RESPONSAVEL'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'ERDAT'.
  gs_fieldcat-ref_tabname = 'LIKP'.
  gs_fieldcat-seltext_l   = 'DATA'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'LFART'.
  gs_fieldcat-ref_tabname = 'LIKP'.
  gs_fieldcat-seltext_l   = 'TIPO'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MATNR'.
  gs_fieldcat-ref_tabname = 'LIPS'.
  gs_fieldcat-seltext_l   = 'N° MATERIAL'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MATKL'.
  gs_fieldcat-ref_tabname = 'LIPS'.
  gs_fieldcat-seltext_l   = 'GRUPO'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'MEINS'.
  gs_fieldcat-ref_tabname = 'LIPS'.
  gs_fieldcat-seltext_l   = 'UNIDADE MEDIDA'.
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_IMPRIME_DADOS
*&---------------------------------------------------------------------*
*       DISPLAY DA LISTA
*----------------------------------------------------------------------*
FORM f_imprime_dados.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = TEXT-004. "Estruturando dados. Aguarde...

"IMPRIMINDO A TABELA SAIBA
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = gv_repid
     i_callback_pf_status_set = 'F_STATUS_GUI'
      i_callback_user_command = 'F_USER_COMMAND'
      is_layout               = gs_layout
      it_fieldcat             = gt_fieldcat
    TABLES
      t_outtab                = gt_saida
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_STATUS_GUI
*&---------------------------------------------------------------------*
*       DEFINE O STATUS GUI
*----------------------------------------------------------------------*
"MODIFICA O GUI
FORM f_status_gui USING r_flg_popup.
  SET PF-STATUS 'Z_STATUS_GUI'.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_USER_COMMAND
*&---------------------------------------------------------------------*
*       USADO QUANDO CLICAR EM UM HOTSPOT
*----------------------------------------------------------------------*
FORM f_user_command USING p_ucomm LIKE sy-ucomm
                          p_selfield TYPE slis_selfield.
  CASE p_ucomm.
    WHEN '&IC1'. "Se clicou na mãozinha

      "Verifica campo selecionado
      CASE p_selfield-fieldname.
        WHEN 'VBELN'.
          MESSAGE i398(00) WITH TEXT-005. "Clicou no campo
      ENDCASE.
  ENDCASE.
ENDFORM.
