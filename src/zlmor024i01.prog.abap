*----------------------------------------------------------------------*
***INCLUDE ZLMOR024I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN gc_ucomm-back OR gc_ucomm-exit OR gc_ucomm-cancel.
      LEAVE TO SCREEN 0.
    WHEN gc_ucomm-impr_ole.
      PERFORM f_imprimir_ole.
  ENDCASE.
ENDMODULE.
