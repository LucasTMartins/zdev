*&---------------------------------------------------------------------*
*& Include          MZLMO008CL01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*   INCLUDE COLUMN_TREE_CONTROL_DEMOCL1                                *
*----------------------------------------------------------------------*
CLASS lcl_events DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      handle_node_double_click
        FOR EVENT node_double_click
        OF cl_gui_column_tree
        IMPORTING node_key,
      handle_item_double_click
        FOR EVENT item_double_click
        OF cl_gui_column_tree
        IMPORTING node_key.
ENDCLASS.                    "LCL_APPLICATION DEFINITION

*----------------------------------------------------------------------*
*       CLASS LCL_APPLICATION IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_events IMPLEMENTATION.

  METHOD handle_node_double_click. "Quando o nó recebe duplo click
    IF node_key = gc_nodekey-checkin.         "Nó de checkin
      gv_subscreen = '0120'.                  "Tela de checkin
    ELSEIF node_key = gc_nodekey-marcar_voo.  "Nó de marcar vôo
      gv_subscreen = '0140'.                  "Popup para disponibilidade de assentos
    ELSEIF node_key = gc_nodekey-impr_cartao. "Nó de impressão de cartão de embarque
      gv_subscreen = '0160'.                  "Popup de dados do passageiro
    ENDIF.
  ENDMETHOD.                    "HANDLE_NODE_DOUBLE_CLICK

  METHOD  handle_item_double_click. "Quando o item recebe duplo click
    IF node_key = gc_nodekey-checkin.         "Nó de checkin
      gv_subscreen = '0120'.                  "Tela de checkin
    ELSEIF node_key = gc_nodekey-marcar_voo.  "Nó de marcar vôo
      gv_subscreen = '0140'.                  "Popup para disponibilidade de assentos
    ELSEIF node_key = gc_nodekey-impr_cartao. "Nó de impressão de cartão de embarque
      gv_subscreen = '0160'.                  "Popup de dados do passageiro
    ENDIF.
  ENDMETHOD.                    "HANDLE_ITEM_DOUBLE_CLICK
ENDCLASS.                    "LCL_APPLICATION IMPLEMENTATION
