*&---------------------------------------------------------------------*
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 16.01.2025                                                   *
*& Description : Template ALV Simples                                  *
*&---------------------------------------------------------------------*
*& Modifications                                                       *
*&---------------------------------------------------------------------*
*& Author Name :                                                       *
*& Date :                                                              *
*& Request :                                                           *
*& Description :                                                       *
*&---------------------------------------------------------------------*
REPORT zlmor49.

TYPES: BEGIN OF ty_saida,
         ebeln    TYPE ekpo-ebeln, " Nro da ordem de venda
         ebelp    TYPE ekpo-ebelp, " Data de criação
         uniqueid TYPE ekpo-uniqueid, " Criado por
         txz01    TYPE ekpo-txz01, " Data da ordem
         matnr    TYPE ekpo-matnr, " Tipo de ordem
         werks    TYPE ekpo-werks, " Valor líq. da ordem
         lgort    TYPE ekpo-lgort, " Org. de vendas
         menge    TYPE ekpo-menge, " Org. de vendas
       END OF ty_saida,
       BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         bstyp TYPE ekko-bstyp,
         bsart TYPE ekko-bsart,
         aedat TYPE ekko-aedat,
         ernam TYPE ekko-ernam,
         lifnr TYPE ekko-lifnr,
       END OF ty_ekko,
       BEGIN OF ty_mara,
         matnr           TYPE mara-matnr,
         ersda           TYPE mara-ersda,
         created_at_time TYPE mara-created_at_time,
         ernam           TYPE mara-ernam,
         mtart           TYPE mara-mtart,
         mbrsh           TYPE mara-mbrsh,
         matkl           TYPE mara-matkl,
         meins           TYPE mara-meins,
       END OF ty_mara.

DATA: gt_saida     TYPE TABLE OF ty_saida,
      gt_saida_aux TYPE TABLE OF ty_saida,
      gt_ekko      TYPE TABLE OF ty_ekko,
      gt_mara      TYPE TABLE OF ty_mara,
      gs_saida     TYPE ty_saida,
      gs_saida_aux TYPE ty_saida,
      gs_layout    TYPE lvc_s_layo.

DATA: gv_repid LIKE sy-repid.

DATA: gt_fieldcat         TYPE slis_t_fieldcat_alv,
      gt_fieldcat_ekko2   TYPE slis_t_fieldcat_alv,
      gs_fieldcat_hierarq TYPE slis_fieldcat_alv,
      gs_fieldcat_ekko2   TYPE slis_fieldcat_alv,
      gt_fieldcat2        TYPE lvc_t_fcat,
      gt_fieldcat_ekko    TYPE lvc_t_fcat,
      gt_fieldcat_mara    TYPE lvc_t_fcat,
      gs_fieldcat         TYPE lvc_s_fcat.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_ebeln FOR gs_saida-ebeln.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  "Seleciona dados
  PERFORM f_buscar_dados.

  "Indicar campos para exibição na lista
  PERFORM f_fieldcat_init USING gt_fieldcat[].

FORM f_grade_display.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = gv_repid
      it_fieldcat        = gt_fieldcat
      i_save             = 'A'
    TABLES
      t_outtab           = gt_saida
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

* Verificar processamento da função
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM f_buscar_dados.

  PERFORM f_sapgui_progress_indicator USING 'Selecionando dados. Aguarde...'.

  SELECT ebeln ebelp uniqueid txz01 matnr werks lgort menge
        INTO TABLE gt_saida
  FROM ekpo
  WHERE ebeln IN s_ebeln.

  SORT gt_saida BY ebeln ebelp.

ENDFORM.


FORM f_fieldcat_init USING pt_fieldcat TYPE slis_t_fieldcat_alv.

  DATA: ls_fieldcat TYPE slis_fieldcat_alv.

  CLEAR pt_fieldcat[].
  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'EBELN'. " Nome do Campo
  ls_fieldcat-ref_tabname = 'EKPO'. " Tab. de Referência
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat. " Gravar na tab. config.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'EBELP'.
  ls_fieldcat-ref_tabname = 'EKPO'.
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'UNIQUEID'.
  ls_fieldcat-ref_tabname = 'EKPO'.
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'TXZ01'.
  ls_fieldcat-ref_tabname = 'EKPO'.
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'MATNR'.
  ls_fieldcat-ref_tabname = 'EKPO'.
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'WERKS'.
  ls_fieldcat-ref_tabname = 'EKPO'.
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'LGORT'.
  ls_fieldcat-ref_tabname = 'EKPO'.
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'MENGE'.
  ls_fieldcat-ref_tabname = 'EKPO'.
  ls_fieldcat-tabname = 'GT_SAIDA'.
  APPEND ls_fieldcat TO pt_fieldcat.

ENDFORM.

FORM f_sapgui_progress_indicator USING VALUE(pv_text).
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
*     PERCENTAGE = 0
      text = pv_text.

ENDFORM.
