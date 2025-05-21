*&---------------------------------------------------------------------*
*& Include          ZLMOR026CL01
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      handle_item_double_click
        FOR EVENT item_double_click
        OF cl_gui_alv_tree
        IMPORTING node_key fieldname,
      handle_node_double_click
        FOR EVENT node_double_click OF cl_gui_alv_tree
        IMPORTING node_key sender,
      handle_link_click
        FOR EVENT link_click OF cl_gui_alv_tree
        IMPORTING node_key fieldname.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_item_double_click.
    MESSAGE i398 WITH TEXT-004. "Duplo clique item
  ENDMETHOD.

  METHOD handle_node_double_click.
    MESSAGE i398 WITH TEXT-005. "Duplo clique nó
  ENDMETHOD.

  METHOD handle_link_click.
    MESSAGE i398 WITH TEXT-006. "Clique hotspot
  ENDMETHOD.

ENDCLASS.
