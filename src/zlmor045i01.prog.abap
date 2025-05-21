*&---------------------------------------------------------------------*
*& Include          ZLMOR045I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN gc_ucomm-back OR gc_ucomm-exit OR gc_ucomm-cancel.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
