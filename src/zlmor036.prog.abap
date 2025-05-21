*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 13.10.2023                                           *
*& Description  : Usando submit                                        *
*&---------------------------------------------------------------------*
REPORT zlmor036 MESSAGE-ID 00.

*&---------------------------------------------------------------------*
*& SAP Tables declaration : ONLY FOR USE IN SELECTION-SCREEN
*&---------------------------------------------------------------------*
 TABLES : lips.

"" SELECTION-SCREEN
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_vbeln FOR lips-vbeln OBLIGATORY. "Entrega
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
  SUBMIT zlmor026
    WITH s_vbeln in s_vbeln. "Mandando dado de entrega para o programa zlmor026
