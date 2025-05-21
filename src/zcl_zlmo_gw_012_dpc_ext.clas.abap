CLASS zcl_zlmo_gw_012_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zlmo_gw_012_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS zlmot025set_get_entity
        REDEFINITION .

    METHODS zlmot025set_get_entityset
        REDEFINITION.

    METHODS zlmot025set_update_entity
        REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zlmo_gw_012_dpc_ext IMPLEMENTATION.

  METHOD zlmot025set_get_entity.
    "filtrando os dados necessários
    IF line_exists( it_key_tab[ name = 'Huident' ] ).
      DATA(lv_huident) = it_key_tab[ name = 'Huident' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    SELECT SINGLE *
      FROM zlmot025
      INTO @DATA(ls_saida)
      WHERE huident EQ @lv_huident.

    "passando para a tabela de saida
    MOVE-CORRESPONDING ls_saida TO er_entity.
  ENDMETHOD.

  METHOD zlmot025set_get_entityset.
    SELECT *
      FROM zlmot025
      INTO TABLE @DATA(lt_saida).


    SORT lt_saida BY data_criacao hora_criacao DESCENDING huident ASCENDING.

    "passando para tabela de saida
    MOVE-CORRESPONDING lt_saida TO et_entityset.

    /iwbep/cl_mgw_data_util=>paging(
          EXPORTING
            is_paging = is_paging
          CHANGING
            ct_data   = et_entityset
        ).
  ENDMETHOD.

  METHOD zlmot025set_update_entity.
    DATA: ls_entity TYPE zcl_zlmo_gw_012_mpc=>ts_zlmot025.

    IF line_exists( it_key_tab[ name = 'Huident' ] ).
      DATA(lv_huident) = it_key_tab[ name = 'Huident' ]-value.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    "atualizando dados
    UPDATE zlmot025 SET atribuido = ls_entity-atribuido
                    WHERE huident EQ lv_huident.

    IF sy-subrc NE 0.
      me->mo_context->get_message_container( )->add_message(
        iv_msg_type               = 'E'
        iv_msg_id                 = '2'
        iv_msg_number             = '2'
        iv_msg_v1                 = 'Erro ao atualizar!'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = me->mo_context->get_message_container( ).
    ELSE.
      er_entity = ls_entity.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
