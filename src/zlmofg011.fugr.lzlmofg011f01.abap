*----------------------------------------------------------------------*
***INCLUDE LZLMOFG011F01.
*----------------------------------------------------------------------*
FORM f_gerar_log.
  "------------------------------- Constantes Locais
  CONSTANTS: lc_data_pre(12) TYPE c VALUE 'LS_DATA_NEW-'. "Prefixo do nome da estrutura para concatenação - LEMBRAR DE ALTERAR AO MUDAR NOME DA ESTRUTURA
  "-------------------------------

  "------------------------------- Variáveis Locais
  FIELD-SYMBOLS: <lfs_value>,
                 <lfs_field>.

  DATA: lt_comp         TYPE TABLE OF rstrucinfo,
        lt_data_new     TYPE TABLE OF zzlmot022,  "Estrutura criada pela função de LOG
        lt_data_old     TYPE TABLE OF zzlmot022,  "Estrutura criada pela função de LOG
        ls_data         TYPE zlmot022,            "Tabela usada na função de LOG
        ls_data_new     TYPE zzlmot022,           "Estrutura criada pela função de LOG
        ls_data_old     TYPE zzlmot022,           "Estrutura criada pela função de LOG
        ls_comp         TYPE rstrucinfo,
        lv_field        TYPE c LENGTH 50.
  "-------------------------------

  "------------------------------- Busca os campos que a tabela apresenta
  SELECT fieldname
      INTO ls_comp-compname
      FROM dd03l
     WHERE tabname EQ 'ZLMOT022'.
    APPEND ls_comp TO lt_comp.
  ENDSELECT.
  "-------------------------------

  "------------------------------- Loop pelos dados da SM30
  FREE: lt_data_new, lt_data_old.
  LOOP AT total.

    CHECK <action> <> space.
    "------------------------------- Validando se o tipo de ação é de Criação, Modificação ou Eliminação
    IF <action> = 'N' OR <action> = 'U' OR <action> = 'D'.

      "------------------------------- LOOP para preencher work area LS_DATA_NEW com os valores digitados na tela
      LOOP AT lt_comp INTO ls_comp.
        CONCATENATE lc_data_pre ls_comp-compname INTO lv_field. "lc_data_pre = 'LS_DATA_NEW-'
        ASSIGN (lv_field) TO <lfs_field>.
        CHECK sy-subrc = 0.

        ASSIGN COMPONENT ls_comp-compname OF STRUCTURE <vim_total_struc> TO <lfs_value>.
        IF sy-subrc = 0.
          <lfs_field> = <lfs_value>.
        ENDIF.
      ENDLOOP.
      "-------------------------------

      "------------------------------- Modificação e Eliminação
      "Ação de modificação -> Busca registros antigos. Se não for modificação
      "então não tem o porque trazer a estrutura ls_zlmot022_old preenchida
      IF <action> = 'U' OR <action> = 'D'.
        SELECT SINGLE *
          INTO ls_data
          FROM zlmot022
         WHERE guid EQ ls_data_new-guid.

        "Valor campos antigos
        MOVE-CORRESPONDING ls_data TO ls_data_old.
        APPEND ls_data_old TO lt_data_old.
      ENDIF.
      "-------------------------------

      "------------------------------- Criação
      "Valor campos novos
      APPEND ls_data_new TO lt_data_new.

      PERFORM grava_modificacao TABLES lt_data_new
                                       lt_data_old
                                 USING ls_data_new-guid
                                       <action>.
      "-------------------------------

    ENDIF.
    "-------------------------------
  ENDLOOP.
"-------------------------------
ENDFORM.

FORM grava_modificacao TABLES pt_data_new STRUCTURE zzlmot022
                              pt_data_old STRUCTURE zzlmot022
                        USING pv_GUID     TYPE numc10
                              pv_processo TYPE any.

  "------------------------------- Variáveis Locais
  DATA: lt_cdtxt TYPE TABLE OF cdtxt.
  DATA: ls_cdtxt TYPE cdtxt.
  "-------------------------------

  "------------------------------- Armazenando texto e processo em tabela de texto de modificação
  CONCATENATE sy-mandt pv_guid INTO ls_cdtxt-teilobjid.
  ls_cdtxt-textspr = sy-langu.
  ls_cdtxt-updkz   = pv_processo.
  APPEND ls_cdtxt TO lt_cdtxt.
  "-------------------------------

  "------------------------------- Convertendo processo de criação
  IF pv_processo = 'N'. "Processo de criação / inserção
    pv_processo = 'I'.
  ENDIF.
  "-------------------------------

  "------------------------------- Gera o log de modificação criado na SCDO
  CALL FUNCTION 'ZLMOCD_STUDENT2_WRITE_DOCUMENT'
    EXPORTING
      objectid               = 'ZLMOCD_STUDENT2'
      tcode                  = sy-tcode
      utime                  = sy-uzeit
      udate                  = sy-datum
      username               = sy-uname
      upd_zlmot022           = pv_processo
    TABLES
      icdtxt_zlmocd_student2 = lt_cdtxt
      xzlmot022              = pt_data_new
      yzlmot022              = pt_data_old.
  "-------------------------------
ENDFORM.                    " GRAVA_MODIFICACAO

MODULE z_mostrar_log INPUT.
  IF sy-ucomm = 'ZLOG'. "Validando código de função
    "Chama programa standard que lista os Logs de moficação
    SUBMIT rsscd100 WITH objekt   = 'ZLMOCD_STUDENT2'
                    WITH objectid = space
                    WITH dat_bis  = space
                    AND RETURN.
  ENDIF.
ENDMODULE.
