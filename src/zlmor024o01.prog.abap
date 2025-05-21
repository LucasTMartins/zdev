*----------------------------------------------------------------------*
***INCLUDE ZLMOR024O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  IF go_alv_tree IS INITIAL.
    PERFORM f_create_alvtree_container.
    PERFORM f_create_object_in_container.
    PERFORM f_create_empty_alvtree_control.
    PERFORM f_create_alvtree_hierarchy.
  ENDIF.

  CALL METHOD cl_gui_cfw=>flush.
ENDMODULE.
