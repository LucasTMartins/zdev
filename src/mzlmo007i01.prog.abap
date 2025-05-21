*&---------------------------------------------------------------------*
*& Include          MZLMO007I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN gc_avan.
      IF gv_pos IS INITIAL.

      MESSAGE s398(00) DISPLAY LIKE 'E'.

        CALL FUNCTION 'CALL_MESSAGE_SCREEN'
          EXPORTING
            i_msgid          = gc_msgid "00
            i_lang           = sy-langu
            i_msgno          = gc_msgno "398
            i_msgv1          = TEXT-001 "Campo obrigatório
            i_msgv2          = space
            i_msgv3          = space
            i_msgv4          = space
            i_condense       = abap_true
            i_non_lmob_envt  = abap_true
          EXCEPTIONS
            invalid_message1 = 1
            OTHERS           = 2.

        sy-msgty = 'E'.
        sy-msgid = '00'.
        sy-msgno = '398'.
        sy-ftype = 'I'.
        sy-marky = 'A'.

        EXIT.
      ELSE.
        FREE gt_lqua.
        CLEAR gv_lines_lqua.

        ""buscando quantidade
        CALL FUNCTION 'ZF_LMO_BUSCA_QUANTIDADE'
          EXPORTING
            iv_lgnum      = gs_user-lgnum
            iv_pos        = gv_pos
          IMPORTING
            ev_lines_lqua = gv_lines_lqua
          TABLES
            et_lqua       = gt_lqua.

        IF gt_lqua IS NOT INITIAL.
          ""chamando tela de dados de estoque
          CALL SCREEN 0200.
        ENDIF.
      ENDIF.
    WHEN gc_rein.
      "Limpando campo UD/Pos/Material
      CLEAR gv_pos.
    WHEN gc_back OR gc_exit OR gc_cancel OR gc_vltr.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN gc_ant. "botão de voltar página
      ""desativando botão de voltar na primeira tela
      IF gv_pagina > 1.
        gv_pagina = gv_pagina - 1.
      ENDIF.
    WHEN gc_prox. "botão de avançar página
      ""desativando botão de avançar na última tela
      IF gv_pagina < gv_lines_lqua.
        gv_pagina = gv_pagina + 1.
      ENDIF.
    WHEN gc_impri.
      CALL SCREEN 0300.
    WHEN gc_back OR gc_exit OR gc_cancel OR gc_vltr.
      gv_pagina = 1. "definindo tela como número 1 novamente
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE sy-ucomm.
    WHEN gc_impri.
      DATA: lt_lines TYPE TABLE OF tline.

      ""Coletando parametros de impressão
      CALL FUNCTION 'GET_PRINT_PARAMETERS'
        EXPORTING
          destination            = gv_ldest "impressora
          immediately            = abap_true
          no_dialog              = abap_true
        IMPORTING
          out_parameters         = gs_params
          valid                  = gv_valid
        EXCEPTIONS
          archive_info_not_found = 1
          invalid_print_params   = 2
          invalid_archive_params = 3
          OTHERS                 = 4.

      IF gv_valid IS INITIAL.
        CALL FUNCTION 'CALL_MESSAGE_SCREEN'
          EXPORTING
            i_msgid          = gc_msgid "00
            i_lang           = sy-langu
            i_msgno          = gc_msgno "398
            i_msgv1          = TEXT-002 "Impressora inválida
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

      NEW-PAGE PRINT ON PARAMETERS gs_params NO DIALOG.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = gc_etiq_id
          language                = sy-langu
          name                    = gc_etiq_name
          object                  = gc_etiq_object
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.

      ""verificando erros
      IF sy-subrc NE 0.
        NEW-PAGE PRINT OFF.
      ENDIF.

      CALL FUNCTION 'FORMAT_TEXTLINES'
        EXPORTING
          formatwidth = 132
          linewidth   = 80
        TABLES
          lines       = lt_lines
        EXCEPTIONS
          bound_error = 1
          OTHERS      = 2.

      ""verificando erros
      IF sy-subrc NE 0.
        NEW-PAGE PRINT OFF.
      ENDIF.

      ""`Passando dados variáveis para a etiqueta
      LOOP AT gt_label_ud INTO gs_label_ud.
        LOOP AT lt_lines INTO DATA(ls_lines).
          REPLACE 'GV_MATNR' IN ls_lines-tdline  WITH gs_label_ud-matnr.
          REPLACE 'GV_MAKTX' IN ls_lines-tdline  WITH gs_label_ud-maktx.
          REPLACE 'GV_EAN'   IN ls_lines-tdline  WITH gs_label_ud-lenum.
          REPLACE 'LGT'      IN ls_lines-tdline  WITH gs_label_ud-lgtyp.
          REPLACE 'GV_CHARG' IN ls_lines-tdline  WITH gs_label_ud-charg.
          REPLACE 'WERK'     IN ls_lines-tdline  WITH gs_label_ud-werks.
          REPLACE 'LGOR'     IN ls_lines-tdline  WITH gs_label_ud-lgort.
          REPLACE 'LGN'      IN ls_lines-tdline  WITH gs_label_ud-lgnum.
          REPLACE 'GV_BDATU' IN ls_lines-tdline  WITH gs_label_ud-bdatu.
          REPLACE 'GV_LGPLA' IN ls_lines-tdline  WITH gs_label_ud-lgpla.
          WRITE:/ ls_lines-tdline.
          CLEAR ls_lines.
        ENDLOOP.
        CLEAR gs_label_ud.
      ENDLOOP.

      NEW-PAGE PRINT OFF.

      CALL FUNCTION 'CALL_MESSAGE_SCREEN'
        EXPORTING
          i_msgid          = gc_msgid "00
          i_lang           = sy-langu
          i_msgno          = gc_msgno "398
          i_msgv1          = TEXT-003 "Etiqueta impressa
          i_msgv2          = space
          i_msgv3          = space
          i_msgv4          = space
          i_condense       = abap_true
          i_non_lmob_envt  = abap_true
        EXCEPTIONS
          invalid_message1 = 1
          OTHERS           = 2.
    WHEN gc_rein.
      "Limpando campo de impressora
      CLEAR gv_ldest.
    WHEN gc_back OR gc_exit OR gc_cancel OR gc_vltr.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
