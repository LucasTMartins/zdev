*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 01.11.2023                                           *
*& Description  : ALV de produtos cadastrados                          *
*&---------------------------------------------------------------------*

INCLUDE zlmor040top.

include zlmor040c01.
include zlmor040o01.
include zlmor040i01.
INCLUDE zlmor040f01.

**----------------------------------------------------------------------*
START-OF-SELECTION.
**----------------------------------------------------------------------*
  CALL SCREEN '0100'.
