*&---------------------------------------------------------------------*
*& Report ZLMOR046
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlmor046.

"------------------------------- Tela de seleção
SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001 NO INTERVALS.
  PARAMETERS: p_id   TYPE numc10,
              p_name TYPE zlmoe_name,
              p_dob  TYPE zlmoe_dob,
              p_city TYPE zlmoe_city,
              p_del  AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK a1.
"-------------------------------

"------------------------------- Tipos de tabela para LOG
TYPES:
  BEGIN OF ty_zlmot022 .
    INCLUDE TYPE zlmot022.                            "Sua tabela
    INCLUDE TYPE if_chdo_object_tools_rel=>ty_icdind. "Estrutura geral para documentos de mudança
TYPES END OF ty_zlmot022 .
"-------------------------------

"------------------------------- Constantes Globais
CONSTANTS: gc_objectid  TYPE cdhdr-objectid VALUE 'ZLMOCD_STUDENT',
           gc_objectid2 TYPE cdhdr-objectid VALUE 'ZLMOCD_STUDENT'.
"-------------------------------

"------------------------------- Variáveis Globais
DATA: gs_old       TYPE zlmot022,             "Estrutura da sua tabela ANTES das alterações
      gs_new       TYPE zlmot022,             "Estrutura da sua tabela DEPOIS das alterações
      gt_table_old TYPE TABLE OF ty_zlmot022, "Sua tabela ANTES das alterações
      gt_table_new TYPE TABLE OF ty_zlmot022, "Sua tabela DEPOIS das alterações
      gt_cdtxt     TYPE TABLE OF cdtxt,       "Tabela para textos de modificação
      go_alv       TYPE REF TO cl_salv_table, "Tabela do ALV
      gv_process.                             "Variável de processo de mudança.
"Ex. processos de mudança:
" U (Modificação)
" I (Inserção)
" E (Eliminação (documentação de campo individual))
" D (Eliminação)
" J (Inserção (documentação de campo individual))
"-------------------------------

"------------------------------- Preenchendo dados antes da modificação e após a modificação
IF p_id IS INITIAL. "Verificando se o ID está vazio
  MESSAGE 'Please enter a valid ID.' TYPE 'S' DISPLAY LIKE 'E'.
  RETURN.
ENDIF.

IF p_del IS NOT INITIAL. "Verificando se a operação é para deletar ou não
  "---------------- OPERAÇÃO DE DELETE
  SELECT SINGLE * FROM zlmot022 INTO gs_old WHERE guid = p_id.

  IF gs_old IS NOT INITIAL.
    DELETE FROM zlmot022 WHERE guid = p_id.
    gv_process = 'D'.
  ELSE.
    MESSAGE 'No entry exists with the given ID.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
  "----------------
ELSE.
  SELECT SINGLE * FROM zlmot022 INTO gs_old WHERE guid = p_id.

  IF gs_old IS NOT INITIAL.
    "---------------- OPERAÇÃO DE UPDATE
    UPDATE zlmot022 SET name = p_name
                        dob  = p_dob
                        city = p_city WHERE guid = p_id.

    gs_new-guid = p_id.
    gs_new-dob  = p_dob.
    gs_new-name = p_name.
    gs_new-city = p_city.
    gv_process  = 'U'.
    "----------------
  ELSE.
    "---------------- OPERAÇÃO DE CREATE
    gs_new-guid = p_id.
    gs_new-dob  = p_dob.
    gs_new-name = p_name.
    gs_new-city = p_city.

    INSERT zlmot022 FROM gs_new.
    gv_process = 'I'.
    "----------------
  ENDIF.
ENDIF.

"---------------- ARMAZENANDO DADOS NAS TABELAS
IF gs_new IS NOT INITIAL.
  gs_new-mandt = sy-mandt.
  APPEND gs_new TO gt_table_new.
ENDIF.

IF gs_old IS NOT INITIAL.
  gs_old-mandt = sy-mandt.
  APPEND gs_old TO gt_table_old.
ENDIF.
"----------------
"-------------------------------

"------------------------------- Alterando LOG com Método da Classe
CALL METHOD zcl_zlmocd_student_chdo=>write  "Salvando alterações nas tabelas de LOG (CDPOS e CDHDR)
  EXPORTING
    objectid     = gc_objectid  "ID Objeto de Documento de Modificação (ZLMOCD_STUDENT)
    tcode        = sy-tcode     "Código de transação
    utime        = sy-uzeit     "Horário
    udate        = sy-datum     "Data
    username     = sy-uname     "Nome de usuário
    xzlmot022    = gt_table_new "Tabela nova
    yzlmot022    = gt_table_old "Tabela antiga
    upd_zlmot022 = gv_process.  "Processo de mudança
"-------------------------------

"------------------------------- Alterando LOG com Função
CALL FUNCTION 'ZLMOCD_STUDENT4_WRITE_DOCUMENT' "Salvando alterações nas tabelas de LOG (CDPOS e CDHDR)
  EXPORTING
    objectid               = gc_objectid2   "ID Objeto de Documento de Modificação (ZLMOCD_STUDENT4)
    tcode                  = sy-tcode       "Código de transação
    utime                  = sy-uzeit       "Horário
    udate                  = sy-datum       "Data
    username               = sy-uname       "Nome de usuário
    upd_zlmot022           = gv_process     "Processo de mudança
  TABLES
    icdtxt_zlmocd_student4 = gt_cdtxt       "Tabela para textos de modificação
    xzlmot022              = gt_table_new   "Tabela nova
    yzlmot022              = gt_table_old.  "Tabela antiga
"-------------------------------

"------------------------------- Abrindo Tabela de LOG
SUBMIT rsscd100 WITH objekt   = gc_objectid2
                WITH objectid = space
                WITH dat_bis  = space
                AND RETURN.
"-------------------------------
