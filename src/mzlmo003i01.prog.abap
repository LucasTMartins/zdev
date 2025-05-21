*----------------------------------------------------------------------*
***INCLUDE MZLMO003_USER_COMMAND_0100I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
*  DATA: lv_value TYPE vrm_value,
*        lv_list  TYPE vrm_values.

  CONSTANTS: lc_back     TYPE string VALUE 'BACK',
             lc_exit     TYPE string VALUE 'EXIT',
             lc_cancel   TYPE string VALUE 'CANCEL'
*             lc_sair     TYPE string VALUE 'F_SAIR',
*             lc_combo    TYPE string VALUE 'F_COMBO',
*             lc_listname TYPE vrm_id VALUE 'LISTBOX'
             .



  IF sy-ucomm EQ lc_back OR
     sy-ucomm EQ lc_exit OR
     sy-ucomm EQ lc_cancel.
    LEAVE TO SCREEN 0.
  ENDIF.
*  case sy-ucomm.
*WHEN lc_combo.
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = lc_listname
*      values          = lv_list
*    EXCEPTIONS
*      id_illegal_name = 0
*      OTHERS          = 0.
*
*WHEN lc_back OR lc_cancel OR lc_exit OR lc_sair.
*  LEAVE TO SCREEN 0.
*ENDCASE.
ENDMODULE.
