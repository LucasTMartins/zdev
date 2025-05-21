*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 03.10.2023                                           *
*& Description  : Criando upload de txt                                *
*&---------------------------------------------------------------------*
REPORT zlmor031 NO STANDARD PAGE HEADING MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS:
  c_dadcad TYPE string VALUE 'Dados cadastrados com sucesso'
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
  gt_arqui TYPE TABLE OF zlmot002,
  gt_line  TYPE TABLE OF gty_line
  .

**&---------------------------------------------------------------------*
**& Structure declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gs_arqui TYPE zcliente,
  gs_line  TYPE gty_line
  .
**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  gv_value TYPE string
  .
**&---------------------------------------------------------------------*
**&  Selection Screen
**&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1.
  PARAMETERS p_dest TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
*AT SELECTION-SCREEN.
**----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dest. " Aparece um matchcode
  "Chamando gerenciador de arquivos // file explorer
  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename = ' '
      def_path     = 'C:\'
      mask         = ',Texto,*.txt,Todos,*.*.'
      mode         = 'O'
      title        = 'Arquivo de Entrada'(004)
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
      filetype = 'ASC'
      codepage = '4110'
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

  IF sy-subrc = 0.
    INSERT zlmot002 FROM TABLE gt_arqui.
    COMMIT WORK.
    MESSAGE i398 WITH c_dadcad. "Dados cadastrados com sucesso
  ENDIF.
