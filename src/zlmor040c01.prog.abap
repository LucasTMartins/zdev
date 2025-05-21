*&---------------------------------------------------------------------*
*& Include          ZLMOR040C01
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_toolbar.
    gv_modbut-function  = gc_modbut_func. "MODIF
    gv_modbut-butn_type = gc_modbut_type. "4
    gv_modbut-icon      = gc_modbut_icon. "@3I@
    APPEND gv_modbut TO e_object->mt_toolbar.

    gv_savbut-function  = gc_savbut_func. "SALV
    gv_savbut-butn_type = gc_savbut_type. "4
    gv_savbut-icon      = gc_savbut_icon. "@2L@
    APPEND gv_savbut TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    CLEAR: gs_fieldcat.

    CASE e_ucomm.
      WHEN gc_modbut_func.
        "tornando alv editável ou não editável
        LOOP AT gt_saida INTO gs_saida.
          IF gs_saida-celltab IS INITIAL.
            "alv editável
            gs_stylerow-style = cl_gui_alv_grid=>mc_style_enabled.
            gs_stylerow-fieldname = gc_estoque_disp.
            INSERT gs_stylerow INTO TABLE gt_stylerow.

            INSERT LINES OF gt_stylerow INTO TABLE gs_saida-celltab.
            MODIFY gt_saida FROM gs_saida TRANSPORTING celltab.
            CLEAR: gt_stylerow.
          ELSE.
            "alv não editável
            CLEAR gs_saida-celltab.
            MODIFY gt_saida FROM gs_saida TRANSPORTING celltab.

            "campos de estoque ficam em amarelo ao terem menos de 10 peças no estoque
            gv_index = sy-tabix.
            IF gs_saida-estoque_disp < 10.
              gs_cellcolor-fname = gc_estoque_disp.
              gs_cellcolor-color-col = 3.
              gs_cellcolor-color-int = 1.
              gs_cellcolor-color-inv = 0.
              CLEAR gs_saida-cellcolor.
              APPEND gs_cellcolor TO gs_saida-cellcolor.
              CLEAR: gs_cellcolor.
              MODIFY gt_saida FROM gs_saida INDEX gv_index TRANSPORTING cellcolor.
            ELSE.
              CLEAR gs_saida-cellcolor.
              MODIFY gt_saida FROM gs_saida INDEX gv_index TRANSPORTING cellcolor.
            ENDIF.
          ENDIF.
        ENDLOOP.

        go_grid->check_changed_data( ).  "usado para refletir as mudanças de valor no alv

        "alterando alv para receber ou não input
        IF go_grid->is_ready_for_input( ) EQ 0.
          CALL METHOD go_grid->set_ready_for_input
            EXPORTING
              i_ready_for_input = 1.
        ELSE.
          CALL METHOD go_grid->set_ready_for_input
            EXPORTING
              i_ready_for_input = 0.
        ENDIF.

        "atualizando alv
        go_grid->refresh_table_display( ).
      WHEN gc_savbut_func.
        IF go_grid->is_ready_for_input( ) EQ 0.
          LOOP AT gt_saida INTO gs_saida.
            CLEAR gs_saidabkp.
            READ TABLE gt_saidabkp INTO gs_saidabkp with key estoque_disp = gs_saida-estoque_disp.

            IF gs_saidabkp-estoque_disp NE gs_saida-estoque_disp.  "se a tabela anterior não for igual a tabela atual, atualizar os dados
              CLEAR : gs_transport.
              MOVE-CORRESPONDING gs_saida TO gs_transport.
              MODIFY zlmot007 FROM gs_transport.

              IF sy-subrc NE 0.
                MESSAGE i398 WITH TEXT-012 space space space DISPLAY LIKE 'E'.   "Algo deu errado. Dados não salvos
                LEAVE TO SCREEN 0.
              ENDIF.
            ENDIF.

            CLEAR : gs_saida.
          ENDLOOP.

          "mensagem de dados salvos
          MESSAGE i398 WITH TEXT-013 space space space DISPLAY LIKE 'S'.   "Dados salvos com sucesso
        ELSE.
          MESSAGE i398 WITH TEXT-011 space space space.   "Desative a edição de tabela antes de salvar
        ENDIF.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

DATA event_receiver TYPE REF TO lcl_event_receiver.
