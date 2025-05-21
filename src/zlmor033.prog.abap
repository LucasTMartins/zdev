*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 03.10.2023                                           *
*& Description  : Criando upload xlsx/excel                            *
*&---------------------------------------------------------------------*
REPORT zlmor033 NO STANDARD PAGE HEADING MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS:
  c_dadcad   TYPE string        VALUE 'Dados cadastrados com sucesso',
  c_cpfcad   TYPE string        VALUE 'Existe CPF já cadastrado',
  c_telval   TYPE string        VALUE 'Telefone não contém 11 caracteres',
  c_cpfval   TYPE string        VALUE 'O CPF não existe',
  c_cpath    TYPE string        VALUE 'C:\',
  c_filemask TYPE string        VALUE ',Texto,*.txt,Todos,*.*.',
  c_titent   TYPE string        VALUE 'Arquivo de Entrada',
  c_o        TYPE string        VALUE 'O',
  c_codepage TYPE abap_encoding VALUE '4110',
  c_filetype TYPE char10        VALUE 'ASC'
  .

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_cliente,
         cpf      TYPE char11,
         nome     TYPE char100,
         telefone TYPE char11,
         cidade   TYPE char50,
       END OF gty_cliente.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA:
  gt_arqui    TYPE TABLE OF gty_cliente,
  gt_cliente  TYPE TABLE OF zlmot002,
  gt_zlmot002 TYPE TABLE OF zlmot002
  .

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gs_arqui    TYPE gty_cliente,
  gs_cliente  TYPE zlmot002,
  gs_zlmot002 TYPE zlmot002
  .
**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gv_value     TYPE rlgrap-filename,
  gv_text_data TYPE truxs_t_text_data,
  gv_teltam    TYPE p
  .
**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  PARAMETERS p_dest TYPE rlgrap-filename OBLIGATORY. "Arquivo dos clientes
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
*AT SELECTION-SCREEN.
**----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dest. " Aparece um matchcode
  "Chamando gerenciador de arquivos // file explorer
  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename = space
      def_path     = c_cpath "C:\
      mask         = c_filemask ",Texto,*.txt,Todos,*.*.
      mode         = c_o "O
      title        = c_titent "Arquivo de Entrada
    IMPORTING
      filename     = p_dest
                     EXCEPTIONS OTHERS.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  gv_value = p_dest.

  "Faz o upload do arquivo xlsx e converte para texto
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = abap_true
      i_tab_raw_data       = gv_text_data
      i_filename           = gv_value
    TABLES
      i_tab_converted_data = gt_arqui[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc = 0.
    LOOP AT gt_arqui INTO gs_arqui.
      gs_cliente-cpf      = gs_arqui-cpf.
      gs_cliente-nome     = gs_arqui-nome.
      gs_cliente-telefone = gs_arqui-telefone.
      gs_cliente-cidade   = gs_arqui-cidade.
      APPEND gs_cliente TO gt_cliente.
    ENDLOOP.

    PERFORM f_select_data.
    PERFORM f_prepare_data.

    INSERT zlmot002 FROM TABLE gt_cliente.
    COMMIT WORK.
    MESSAGE i398 WITH c_dadcad. "Dados cadastrados com sucesso
  ENDIF.


  "" FORM F_SELECT_DATA
FORM f_select_data.
  FREE: gt_zlmot002.

  "selecionando dados de clientes
  SELECT *
    FROM zlmot002
    INTO TABLE gt_zlmot002.

  SORT:
    gt_zlmot002 BY cpf
    .
ENDFORM.

"" FORM F_PREPARE_DATA
FORM f_prepare_data.
  LOOP AT gt_cliente INTO gs_cliente.
    "lendo dados de cliente para tratar repetições
    READ TABLE gt_zlmot002
      INTO gs_zlmot002
      WITH KEY cpf = gs_cliente-cpf BINARY SEARCH.

    "verificando repetições de CPF
    IF sy-subrc = 0.
      MESSAGE i398 WITH c_cpfcad. "Existe CPF já cadastrado
      STOP.
    ENDIF.

    "verificando se o CPF é válido
    CALL FUNCTION 'CONVERSION_EXIT_CPFBR_INPUT'
      EXPORTING
        input     = gs_cliente-cpf
      EXCEPTIONS
        not_valid = 1
        OTHERS    = 2.

    IF sy-subrc <> 0.
      MESSAGE i398 WITH c_cpfval. "O CPF não existe
      STOP.
    ENDIF.

    gv_teltam = strlen( gs_cliente-telefone ).

    "nesse caso o campo telefone da tabela zlmot002 tem espaço de 11 digitos.
    "portanto caso o número seja maior que 11 será automaticamente cortado até o 11.
    "o programa só entrará na condição caso seja menor que 11.
    IF gv_teltam <> 11.
      MESSAGE i398 WITH c_telval. "Telefone não contém 11 caracteres
      STOP.
    ENDIF.
  ENDLOOP.
ENDFORM.
