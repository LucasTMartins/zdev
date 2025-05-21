*&---------------------------------------------------------------------*
*& Include          ZLMOR043C01
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       CLASS lcl_dragdropobj DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_dragdropobj DEFINITION.
  PUBLIC SECTION.
    DATA: ls_ekko  TYPE ekko.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_application DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_application DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_tree_drag
        FOR EVENT on_drag
        OF cl_gui_simple_tree
        IMPORTING node_key drag_drop_object,
      handle_grid_drop
        FOR EVENT ondrop
        OF cl_gui_alv_grid
        IMPORTING e_dragdropobj,
      handle_tree_drop_complete
        FOR EVENT on_drop_complete
        OF cl_gui_simple_tree
        IMPORTING drag_drop_object,
      handle_node_double_click
        FOR EVENT double_click
        OF cl_gui_alv_grid
        IMPORTING e_row.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS LCL_APPLICATION IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_application IMPLEMENTATION.
*-------------------------------------------------------------------
  METHOD handle_tree_drag.
    DATA: lo_dataobj TYPE REF TO lcl_dragdropobj,
          ls_ekko    TYPE ekko.

    ls_ekko-ebeln = node_key. "Passando documento de compra do nó puxado

    CREATE OBJECT lo_dataobj. "Cria e preenche lo_dataobj para eventos ONDROP e ONDROPCOMPLETE
    MOVE ls_ekko TO lo_dataobj->ls_ekko.

    drag_drop_object->object = lo_dataobj. "Exportando lo_dataobj para outros métodos
  ENDMETHOD.

*--------------------------------------------------------------------
  METHOD handle_grid_drop.
    DATA: lo_dataobj TYPE REF TO lcl_dragdropobj,
          ls_ekko    TYPE ekko.

*!!!
* Muito importante: 'e_dragDropObj->object' pode ter qualquer tipo de instância
* O tipo de conversão necessário pode levar a uma exceção do sistema se o
* elenco não pode ser realizado.
* Por este motivo: use SEMPRE a instrução Catch para ter certeza
* que a operação arrastar e soltar foi abortada corretamente.
*!!!
    CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.

      lo_dataobj ?= e_dragdropobj->object. "Passando objeto dragdrop
      ls_ekko     = lo_dataobj->ls_ekko.

      FREE gt_grid.
      SELECT ebeln ebelp uniqueid aedat matnr "Passando dados para alv grid
        FROM ekpo
        INTO TABLE gt_grid
        WHERE ebeln = ls_ekko-ebeln.   "documento de compra
    ENDCATCH.

    IF sy-subrc <> 0.
      CALL METHOD e_dragdropobj->abort. ""cancelando processo em caso de erro
    ENDIF.
  ENDMETHOD.

*-------------------------------------------------------------------
  METHOD handle_tree_drop_complete.
    ##NEEDED
    DATA: lo_dataobj TYPE REF TO lcl_dragdropobj.

* Again: do not forget to catch this system exception!
    CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
      lo_dataobj ?= drag_drop_object->object.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDCATCH.

    IF sy-subrc <> 0.
      CALL METHOD drag_drop_object->abort.
    ENDIF.
  ENDMETHOD.

  METHOD handle_node_double_click. "Quando a linha recebe duplo click
    DATA: ls_grid TYPE gty_grid.

    CLEAR gs_mara.
    READ TABLE gt_grid INTO ls_grid INDEX e_row.
    SELECT SINGLE matnr mtart matkl meins
      FROM mara
      INTO CORRESPONDING FIELDS OF gs_mara
      WHERE matnr = ls_grid-matnr.

    CLEAR gs_makt.
    SELECT SINGLE maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF gs_makt
      WHERE matnr = ls_grid-matnr
      AND   spras = sy-langu.

    IF gs_makt IS INITIAL.
      SELECT SINGLE maktx
        FROM makt
        INTO CORRESPONDING FIELDS OF gs_makt
        WHERE matnr = ls_grid-matnr
        AND   spras = gc_langu_en.
    ENDIF.

    CLEAR gs_material.
    gs_material-matnr = gs_mara-matnr.
    gs_material-maktx = gs_makt-maktx.
    gs_material-mtart = gs_mara-mtart.
    gs_material-matkl = gs_mara-matkl.
    gs_material-meins = gs_mara-meins.

    LEAVE TO SCREEN 0100.

    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.                    "HANDLE_NODE_DOUBLE_CLICK
ENDCLASS.
