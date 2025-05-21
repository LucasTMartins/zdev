FUNCTION zf_lmo_busca_quantidade.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_LGNUM) TYPE  LGNUM
*"     REFERENCE(IV_POS) TYPE  CHAR20
*"  EXPORTING
*"     REFERENCE(EV_LINES_LQUA) TYPE  SY-TFILL
*"  TABLES
*"      ET_LQUA STRUCTURE  LQUA
*"----------------------------------------------------------------------
**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
  CONSTANTS: lc_msgid  TYPE t100-arbgb   VALUE '00',
             lc_msgno  TYPE t100-msgnr   VALUE '398',
             lc_valpos TYPE sprot_u-var1 VALUE 'Preencher UD/Posição/Material',
             lc_vallgn TYPE sprot_u-var1 VALUE 'Preencher nº de Depósito'.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
  DATA: lt_lagp TYPE TABLE OF lagp.

**&---------------------------------------------------------------------*
**& Structure declaration
**&---------------------------------------------------------------------*
  DATA: ls_lagp TYPE lagp.

**&---------------------------------------------------------------------*
**& Variable declaration
**&---------------------------------------------------------------------*
  DATA: lv_pos(20) TYPE c,
        lv_mat(18) TYPE c.

  ""validando iv_lgnum
  IF iv_lgnum IS INITIAL.
    CALL FUNCTION 'CALL_MESSAGE_SCREEN'
      EXPORTING
        i_msgid          = lc_msgid "00
        i_lang           = sy-langu
        i_msgno          = lc_msgno "398
        i_msgv1          = lc_vallgn "Preencher nº de Depósito
        i_msgv2          = space
        i_msgv3          = space
        i_msgv4          = space
        i_condense       = abap_true
        i_non_lmob_envt  = abap_true
      EXCEPTIONS
        invalid_message1 = 1
        OTHERS           = 2.

    EXIT.
  ENDIF.

  ""validando iv_pos
  IF iv_pos IS INITIAL.
    CALL FUNCTION 'CALL_MESSAGE_SCREEN'
      EXPORTING
        i_msgid          = lc_msgid "00
        i_lang           = sy-langu
        i_msgno          = lc_msgno "398
        i_msgv1          = lc_valpos "Preencher UD/Posição/Material
        i_msgv2          = space
        i_msgv3          = space
        i_msgv4          = space
        i_condense       = abap_true
        i_non_lmob_envt  = abap_true
      EXCEPTIONS
        invalid_message1 = 1
        OTHERS           = 2.

    EXIT.
  ENDIF.

  ""add zeros a esquerda do valor de posição
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = iv_pos
    IMPORTING
      output = lv_pos.

  ""passando dados de acordo com UD (unidades de depósito)
  SELECT *
    FROM lqua
    INTO TABLE et_lqua
    WHERE lgnum EQ iv_lgnum
    AND lenum EQ lv_pos.

  ""validando tabela de UD
  IF et_lqua[] IS INITIAL.
    ""passando dados de acordo com posição para itab
    SELECT *
      FROM lagp
      INTO TABLE lt_lagp
      WHERE lgnum EQ iv_lgnum
      AND lgpla EQ lv_pos.

    ""validando tabela de posição
    IF lt_lagp[] IS NOT INITIAL.
      ""passando dados de posição para etab
      READ TABLE lt_lagp INTO ls_lagp INDEX 1.
      SELECT *
        FROM lqua
        INTO TABLE et_lqua
        WHERE lgnum EQ iv_lgnum
        AND lgpla EQ ls_lagp-lgpla.
    ELSE.
      ""add zeros a esquerda do valor de material
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = iv_pos
        IMPORTING
          output = lv_mat.

      ""passando dados de material
      SELECT *
        FROM lqua
        INTO TABLE et_lqua
        WHERE lgnum EQ iv_lgnum
        AND matnr EQ lv_mat.
    ENDIF.

    ""validando tabela de exportação (et_lqua)
    IF et_lqua[] IS INITIAL.
      CALL FUNCTION 'CALL_MESSAGE_SCREEN'
        EXPORTING
          i_msgid          = lc_msgid "00
          i_lang           = sy-langu
          i_msgno          = lc_msgno "398
          i_msgv1          = TEXT-003 "Dados não encontrados
          i_msgv2          = space
          i_msgv3          = space
          i_msgv4          = space
          i_condense       = abap_true
          i_non_lmob_envt  = abap_true
        EXCEPTIONS
          invalid_message1 = 1
          OTHERS           = 2.


      EXIT.
    ENDIF.
  ENDIF.
  ""passando número de linhas da tabela
  ev_lines_lqua = lines( et_lqua ).
ENDFUNCTION.
