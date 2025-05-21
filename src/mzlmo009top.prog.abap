*&---------------------------------------------------------------------*
*& Include MZLMO009TOP                              - PoolMóds.        SAPMZLMO009
*&---------------------------------------------------------------------*
PROGRAM sapmzlmo009 MESSAGE-ID 00.

**&---------------------------------------------------------------------*
**& Constants declaration
**&---------------------------------------------------------------------*
CONSTANTS : BEGIN OF gc_ucomm, "para dados do sy-ucomm
              cancel TYPE string VALUE 'CANCEL', "cancelar
              exit   TYPE string VALUE 'EXIT',   "sair
              back   TYPE string VALUE 'BACK',   "voltar
            END OF gc_ucomm.
