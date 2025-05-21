*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 03.10.2023                                           *
*& Description  : Exercicio validando upload txt                       *
*&---------------------------------------------------------------------*
REPORT zlmor032 NO STANDARD PAGE HEADING MESSAGE-ID 00.

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
  c_filetype TYPE CHAR10        VALUE 'ASC'
  .

**&---------------------------------------------------------------------*
**& Types declaration
**&---------------------------------------------------------------------*
TYPES: BEGIN OF gty_line,
         linha(200) TYPE c,
       END OF gty_line.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA:
  gt_arqui   TYPE TABLE OF zlmot002,
  gt_cliente TYPE TABLE OF zlmot002,
  gt_line    TYPE TABLE OF gty_line
  .

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gs_arqui   TYPE zlmot002,
  gs_cliente TYPE zlmot002,
  gs_line    TYPE gty_line
  .
**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gv_value  TYPE string,
  gv_teltam TYPE p
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

  "Faz o upload do arquivo
  FREE gt_line.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename = gv_value
      filetype = c_filetype "ASC
      codepage = c_codepage "4110
    TABLES
      data_tab = gt_line
    EXCEPTIONS
      OTHERS   = 17.

  FREE gt_arqui.
  LOOP AT gt_line INTO gs_line.
    " o Split quebra a linha e separa por delimitador ';' colocando cada dado
    " em cada campo sequencialmente.
    SPLIT gs_line AT ';' INTO:
      gs_arqui-cpf
      gs_arqui-nome
      gs_arqui-telefone
      gs_arqui-cidade.

    " Add registro na tabela.
    APPEND gs_arqui TO gt_arqui.
  ENDLOOP.

  PERFORM f_select_data.
  PERFORM f_prepare_data.

  IF sy-subrc = 0.
    INSERT zlmot002 FROM TABLE gt_arqui.
    COMMIT WORK.
    MESSAGE i398 WITH c_dadcad. "Dados cadastrados com sucesso
  ENDIF.


  "" FORM F_SELECT_DATA
FORM f_select_data.
  FREE: gt_cliente.

  "selecionando dados de clientes
  SELECT *
    FROM zlmot002
    INTO TABLE gt_cliente.

  SORT:
    gt_cliente BY cpf
    .
ENDFORM.

"" FORM F_PREPARE_DATA
FORM f_prepare_data.
  LOOP AT gt_arqui INTO gs_arqui.
    "lendo dados de cliente para tratar repetições
    READ TABLE gt_cliente
      INTO gs_cliente
      WITH KEY cpf = gs_arqui-cpf BINARY SEARCH.

    "verificando repetições de CPF
    IF sy-subrc = 0.
      MESSAGE i398 WITH c_cpfcad. "Existe CPF já cadastrado
      STOP.
    ENDIF.

    "verificando se o CPF é válido
    CALL FUNCTION 'CONVERSION_EXIT_CPFBR_INPUT'
      EXPORTING
        input     = gs_arqui-cpf
      EXCEPTIONS
        not_valid = 1
        OTHERS    = 2.

    IF sy-subrc <> 0.
      MESSAGE i398 WITH c_cpfval. "O CPF não existe
      STOP.
    ENDIF.

    gv_teltam = strlen( gs_arqui-telefone ).

    "nesse caso o campo telefone da tabela zlmot002 tem espaço de 11 digitos.
    "portanto caso o número seja maior que 11 será automaticamente cortado até o 11.
    "o programa só entrará na condição caso seja menor que 11.
    IF gv_teltam <> 11.
      MESSAGE i398 WITH c_telval. "Telefone não contém 11 caracteres
      STOP.
    ENDIF.
  ENDLOOP.
ENDFORM.
