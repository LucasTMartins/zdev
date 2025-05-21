*&---------------------------------------------------------------------*
*& Include ZLMOR027TOP                              - Report ZLMOR027
*&---------------------------------------------------------------------*
REPORT zlmor027.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS :
  c_container_name(10) TYPE c VALUE 'MAIN_CONT'
  .

**&---------------------------------------------------------------------*
**& Internal table declaration
**&---------------------------------------------------------------------*
DATA:
  gt_mara TYPE STANDARD TABLE OF mara,
  gt_makt TYPE STANDARD TABLE OF makt.

**&---------------------------------------------------------------------*
**& Variables declaration (Global)
**&---------------------------------------------------------------------*
DATA:
  go_custom_container TYPE REF TO cl_gui_custom_container,
  go_split_container  TYPE REF TO cl_gui_splitter_container,
  go_cont_part1       TYPE REF TO cl_gui_container,
  go_cont_part2       TYPE REF TO cl_gui_container,
  go_alv_grid1        TYPE REF TO cl_gui_alv_grid,
  go_alv_grid2        TYPE REF TO cl_gui_alv_grid
  .
