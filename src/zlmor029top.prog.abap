*&---------------------------------------------------------------------*
*& Include ZLMOR029TOP                              - Report ZLMOR029
*&---------------------------------------------------------------------*
REPORT zlmor029.

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
  go_docking        TYPE REF TO cl_gui_docking_container,
  go_splitter       TYPE REF TO cl_gui_splitter_container,
  go_container_mara TYPE REF TO cl_gui_container,
  go_container_makt TYPE REF TO cl_gui_container,
  go_alv_mara       TYPE REF TO cl_gui_alv_grid,
  go_alv_makt       TYPE REF TO cl_gui_alv_grid
.

"" Definindo classe
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_double_click_header
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,
      handle_double_click_item
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no.
ENDCLASS.

 DATA: go_handler TYPE REF TO lcl_event_handler. "Objeto utilizado para a classe lcl_event_handler
