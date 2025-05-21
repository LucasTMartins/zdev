*&---------------------------------------------------------------------*
*& Include          ZLMOR045C01
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       CLASS lcl_application DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_application DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar_grid
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      save_data.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS LCL_APPLICATION IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_application IMPLEMENTATION.

*---------------------------------------------------------------------*
*       METHOD handle_toolbar_grid.
*---------------------------------------------------------------------*
  METHOD handle_toolbar_grid.
    CLEAR gs_but_salv.
    gs_but_salv-function  = gc_savebut-func.     "SAVEPR
    gs_but_salv-icon      = gc_savebut-icon.     "@2L@
    gs_but_salv-butn_type = gc_savebut-type.     "4
    gs_but_salv-text      = TEXT-012.            "Salvar
    APPEND gs_but_salv TO e_object->mt_toolbar.
  ENDMETHOD.

*---------------------------------------------------------------------*
*       METHOD handle_user_command.
*---------------------------------------------------------------------*
  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN gc_savebut-func. "SAVEPR
        CALL METHOD me->save_data.
    ENDCASE.
  ENDMETHOD.

  METHOD save_data.
    DATA: ls_saida_copy TYPE gty_saida,
          ls_modificado TYPE bool VALUE abap_false,
          lv_tabix      TYPE i.

    CLEAR gs_saida.
    LOOP AT gt_saida INTO gs_saida. "passando por todos os dados da tabela e verificando se foram modificados baseado na tabela de cópia com os valores originais
      lv_tabix = sy-tabix. "armazenando index

      CLEAR ls_saida_copy.
      READ TABLE gt_saida_copy INTO ls_saida_copy INDEX lv_tabix. "lendo tabela de cópia com os valores originais

      IF sy-subrc <> 0.
        MESSAGE i398 WITH TEXT-015 space space space DISPLAY LIKE gc_display-e. "Erro ao modificar tabela
        LEAVE TO SCREEN 0100.
      ENDIF.

      IF ls_saida_copy NE gs_saida.  "caso os dados não sejam iguais, atualizar a tabela standard
        ls_modificado = abap_true. "registrando que a tabela foi modificada

        CALL FUNCTION 'L_RFMON_TAPRI_CHANGE'
          EXPORTING
            iv_lgnum  = gs_saida-lgnum
            iv_tanum  = gs_saida-tanum
            iv_tapri  = gs_saida-tapri
          exceptions
            not_found = 1
            confirmed = 2
            no_change = 3
            failed    = 4
            others    = 5.

        IF sy-subrc NE 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          MESSAGE i398 WITH TEXT-015 space space space DISPLAY LIKE gc_display-e. "Erro ao modificar tabela
          LEAVE TO SCREEN 0100.
        ENDIF.
      ENDIF.
    ENDLOOP.

    MESSAGE i398 WITH TEXT-014 space space space DISPLAY LIKE gc_display-s. "Tabela salva com sucesso

    IF ls_modificado = abap_true. "passando os dados atualizados para a tabela de cópia
      PERFORM f_buscar_dados.
      PERFORM f_prepara_dados.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
