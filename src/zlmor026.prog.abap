*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report                                               *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 22.09.2023                                           *
*& Description  : ALV TREE de 3 niveis                                 *
*&---------------------------------------------------------------------*

INCLUDE zlmor026top.    " Global Data

INCLUDE zlmor026o01.  " PBO-Modules
INCLUDE zlmor026i01.  " PAI-Modules
INCLUDE zlmor026cl01.

"" SELECTION-SCREEN
SELECTION-SCREEN BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_vbeln FOR lips-vbeln. "Entrega
SELECTION-SCREEN END OF BLOCK b1.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  PERFORM: f_select_data.
  PERFORM: f_prepare_data.
  PERFORM: f_print.

INCLUDE zlmor026f01. " FORMS
