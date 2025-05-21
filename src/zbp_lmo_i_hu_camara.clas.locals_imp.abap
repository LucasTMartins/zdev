CLASS lhc_zlmo_i_hu_camara DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR HuCamaraFria RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE HuCamaraFria.

    METHODS delete FOR MODIFY
      IMPORTING entities FOR DELETE HuCamaraFria.

    METHODS read FOR READ
      IMPORTING keys FOR READ HuCamaraFria RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK HuCamaraFria.

ENDCLASS.

CLASS lhc_zlmo_i_hu_camara IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA: ls_zlmot024 TYPE zlmot024.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
      ls_zlmot024 = CORRESPONDING #( <lfs_entity> ).
      ls_zlmot024-huident      = |{ ls_zlmot024-huident ALPHA = IN }|.

      IF ls_zlmot024-huident IS INITIAL.
        APPEND VALUE #(
          %msg = new_message(
            id        = '00'
            number    = '398'
            severity  = ms-error
            v1        = 'Campo HU é obrigatório'
          )
        ) TO reported-hucamarafria.

        EXIT.
      ENDIF.

      IF ls_zlmot024-huident CN '1234567890'.
        APPEND VALUE #(
          %msg = new_message(
            id        = '00'
            number    = '398'
            severity  = ms-error
            v1        = 'Campo HU deve conter apenas números'
          )
        ) TO reported-hucamarafria.

        EXIT.
      ENDIF.


      ls_zlmot024-data_criacao = sy-datum.
      ls_zlmot024-hora_criacao = sy-uzeit.
      ls_zlmot024-usuario      = sy-uname.

*      <lfs_entity>-DataCriacao = sy-datum.
*      <lfs_entity>-HoraCriacao = sy-uzeit.
*      <lfs_entity>-Usuario     = sy-uname.

      INSERT zlmot024 FROM ls_zlmot024.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA: ls_zlmot024 TYPE zlmot024.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
      ls_zlmot024 = CORRESPONDING #( <lfs_entity> ).

      DELETE zlmot024 FROM ls_zlmot024.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
*    SELECT huident
*      FROM /scwm/huhdr
*      INTO TABLE @DATA(lt_huhdr)
*      FOR ALL ENTRIES IN @keys
*      WHERE huident EQ @keys-Huident.
*
*    SORT lt_huhdr BY huident.
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_key>).
*      READ TABLE lt_huhdr WITH KEY Huident = <lfs_key>-Huident BINARY SEARCH TRANSPORTING NO FIELDS.
*
*      IF sy-subrc <> 0.
*        APPEND VALUE #(
*          %msg = new_message(
*            id        = '00'
*            number    = '398'
*            severity  = ms-error
*            v1        = 'Campo HU não existente!'
*          )
*        ) TO reported-hucamarafria.
*
*        EXIT.
*      ENDIF.
*    ENDLOOP.


*    SORT result BY huident.
*    LOOP AT lt_huhdr ASSIGNING FIELD-SYMBOL(<lfs_huhdr>).
*      READ TABLE result WITH KEY Huident = <lfs_huhdr> BINARY SEARCH TRANSPORTING NO FIELDS.
*
*      IF sy-subrc <> 0.
*        APPEND VALUE #(
*          %msg = new_message(
*            id        = '00'
*            number    = '398'
*            severity  = ms-error
*            v1        = 'Campo HU não existente!'
*          )
*        ) TO reported-hucamarafria.
*
*        EXIT.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZLMO_I_HU_CAMARA DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZLMO_I_HU_CAMARA IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
