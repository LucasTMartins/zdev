FUNCTION zf_lmo_cartao_embarque.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_CARRID) TYPE  SBOOK-CARRID
*"     VALUE(I_CONNID) TYPE  SBOOK-CONNID
*"     VALUE(I_FLDATE) TYPE  SBOOK-FLDATE
*"     VALUE(I_BOOKID) TYPE  SBOOK-BOOKID
*"     VALUE(I_FLAG_LOCAL) TYPE  FLAG OPTIONAL
*"     VALUE(I_FILE) TYPE  RLGRAP-FILENAME OPTIONAL
*"  EXPORTING
*"     VALUE(EV_MSG_SUCESS) TYPE  STRING
*"     VALUE(EV_MSG_ERROR) TYPE  STRING
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Tabelas internas
*&---------------------------------------------------------------------*
  DATA: lt_lines TYPE TABLE OF tline,
        lt_dados TYPE TABLE OF zslmo003.

*&---------------------------------------------------------------------*
*& Constantes
*&---------------------------------------------------------------------*
  CONSTANTS: lc_formname TYPE tdsfname VALUE 'ZLMO_SF_CARTEMBARQ'.

*&---------------------------------------------------------------------*
*& Variáveis
*&---------------------------------------------------------------------*
  DATA:lv_job_output TYPE ssfcrescl,
       lv_size       TYPE i,
       lv_fm_name    TYPE rs38l_fnam,
       lv_filename   TYPE string,
       lv_devtype    TYPE rspoptype.

*&---------------------------------------------------------------------*
*& Estruturas
*&---------------------------------------------------------------------*
  DATA: ls_sbook     TYPE sbook,
        ls_zlmot008  TYPE zlmot008,
        ls_sflight   TYPE sflight,
        ls_spfli     TYPE spfli,
        ls_customid  TYPE scustom,
        ls_ssfcompop TYPE ssfcompop,
        ls_control   TYPE ssfctrlop,
        ls_dados     TYPE zslmo003.

*&---------------------------------------------------------------------*
*& Mensagens de retorno
*&---------------------------------------------------------------------*
  ev_msg_sucess = TEXT-003. "Arquivo foi baixado localmente

*&---------------------------------------------------------------------*
*& Validação
*&---------------------------------------------------------------------*
  IF i_flag_local = abap_true.
    IF i_file IS INITIAL.
      ev_msg_error = TEXT-001. "Caminho do arquivo obrigatório
      RETURN.
    ENDIF.
  ENDIF.

  SELECT SINGLE carrid connid fldate bookid passform passname
    FROM sbook
    INTO CORRESPONDING FIELDS OF ls_sbook
    WHERE carrid   = i_carrid
    AND   bookid   = i_bookid
    AND   reserved = 'X'.

  IF ls_sbook IS INITIAL.
    ev_msg_error = TEXT-002. "Reserva não encontrada!
    RETURN.
  ENDIF.

  SELECT SINGLE seatnum seatrow location
    FROM zlmot008
    INTO CORRESPONDING FIELDS OF ls_zlmot008
    WHERE carrid   = ls_sbook-carrid
    AND   connid   = ls_sbook-connid
    AND   fldate   = ls_sbook-fldate
    AND   bookid   = ls_sbook-bookid.

  IF ls_zlmot008 IS INITIAL.
    ev_msg_error = TEXT-002. "Reserva não encontrada!
    RETURN.
  ENDIF.

  SELECT SINGLE carrid connid
    FROM sflight
    INTO CORRESPONDING FIELDS OF ls_sflight
    WHERE carrid   = ls_sbook-carrid
    AND   connid   = ls_sbook-connid
    AND   fldate   = ls_sbook-fldate.

  IF ls_sflight IS INITIAL.
    ev_msg_error = TEXT-002. "Reserva não encontrada!
    RETURN.
  ENDIF.

  SELECT SINGLE airpfrom airpto cityfrom cityto deptime arrtime
    FROM spfli
    INTO CORRESPONDING FIELDS OF ls_spfli
    WHERE carrid   = ls_sflight-carrid
    AND   connid   = ls_sflight-connid.

  IF ls_spfli IS INITIAL.
    ev_msg_error = TEXT-002. "Reserva não encontrada!
    RETURN.
  ENDIF.

  CLEAR ls_dados.
  lv_filename       = i_file.

  ls_dados-passform = ls_sbook-passform.
  ls_dados-passname = ls_sbook-passname.
  ls_dados-bookid   = ls_sbook-bookid.
  ls_dados-fldate   = ls_sbook-fldate.
  ls_dados-connid   = ls_sbook-connid.
  ls_dados-airpfrom = ls_spfli-airpfrom.
  ls_dados-airpto   = ls_spfli-airpto.
  ls_dados-cityfrom = ls_spfli-cityfrom.
  ls_dados-cityto   = ls_spfli-cityto.
  ls_dados-deptime  = ls_spfli-deptime.
  ls_dados-arrtime  = ls_spfli-arrtime.
  ls_dados-seatnum  = ls_zlmot008-seatnum.
  ls_dados-seatrow  = ls_zlmot008-seatrow.
  ls_dados-location = ls_zlmot008-location.
  APPEND ls_dados TO lt_dados.

*&---------------------------------------------------------------------*
*& Impressão
*&---------------------------------------------------------------------*
*Obtenha o nome do módulo de função usando o nome do formulário
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lc_formname
    IMPORTING
      fm_name            = lv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  "Retorna o valor do tipo de arquivo, nesse caso PDF1
  CALL FUNCTION 'SSF_GET_DEVICE_TYPE'
    EXPORTING
      i_language    = 'E'
      i_application = 'SAPDEFAULT'
    IMPORTING
      e_devtype     = lv_devtype.

*Suprimir caixa de diálogo de impressão
  ls_control-no_dialog   = abap_true.  "Não mostra a tela de impressão
  ls_control-getotf      = abap_true.  "Retorno da tabela OTF. Sem impressão, exibição ou envio fazue.
  ls_ssfcompop-tdprinter = lv_devtype. "Nome do tipo de arquivo
  ls_control-preview     = abap_true.  "Pré-visualização do Arquivo

*Acione o smartform
  CALL FUNCTION lv_fm_name
    EXPORTING
      control_parameters = ls_control
      output_options     = ls_ssfcompop
      wa_dados           = ls_dados
    IMPORTING
      job_output_info    = lv_job_output
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.

  IF i_flag_local = abap_true. "se a flag de download local estiver ativa o programa baixará
    "Converter OTF para PDF
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_filesize          = lv_size
      TABLES
        otf                   = lv_job_output-otfdata
        lines                 = lt_lines
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.

    "Baixe o arquivo PDF
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        bin_filesize            = lv_size
        filename                = lv_filename
        filetype                = 'BIN'
      TABLES
        data_tab                = lt_lines
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        OTHERS                  = 22.

  ELSE.
    "PREVIEW DO PDF
    CALL FUNCTION 'SSFCOMP_PDF_PREVIEW'
      EXPORTING
        i_otf                    = lv_job_output-otfdata
      EXCEPTIONS
        convert_otf_to_pdf_error = 1
        cntl_error               = 2
        OTHERS                   = 3.
  ENDIF.
ENDFUNCTION.
