*&---------------------------------------------------------------------*
*& Include ZLMOR028TOP                              - Report ZLMOR028
*&---------------------------------------------------------------------*
REPORT ZLMOR028.

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA:
      gt_mara TYPE STANDARD TABLE OF mara,
      gt_makt TYPE STANDARD TABLE OF makt
      .

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA:
      go_container1 TYPE REF TO cl_gui_docking_container,
      go_container2 TYPE REF TO cl_gui_docking_container,
      go_alv_grid1 TYPE REF TO cl_gui_alv_grid,
      go_alv_grid2 TYPE REF TO cl_gui_alv_grid
      .
