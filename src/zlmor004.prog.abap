*&---------------------------------------------------------------------*
*& Report ZLMOR004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlmor004.

SELECTION-SCREEN BEGIN OF BLOCK b1002 WITH FRAME.
    PARAMETERS: p_teste TYPE string.
SELECTION-SCREEN END OF BLOCK b1002.

MESSAGE 'Testando mensagens' TYPE 'I' DISPLAY LIKE 'E'.
MESSAGE 'Testando mensagens' TYPE 'E' DISPLAY LIKE 'I'.
