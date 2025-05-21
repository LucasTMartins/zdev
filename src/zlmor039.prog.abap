*&---------------------------------------------------------------------*
*& Domain       :                                                      *
*& Program type : Report ALV                                           *
*& Author Name  : Lucas Martins de Oliveira                            *
*& Date         : 30.10.2023                                           *
*& Description  : ALV de 5 tabelas com hotspot e popup                 *
*&---------------------------------------------------------------------*

INCLUDE zlmor039top.    " Global Data

INCLUDE zlmor039c01.    " class-routine
INCLUDE zlmor039o01.    " PBO-Modules
INCLUDE zlmor039i01.    " PAI-Modules
INCLUDE zlmor039f01.    " FORM-Routines

*&---------------------------------------------------------------------*
START-OF-SELECTION.
*&---------------------------------------------------------------------*
call screen '0100'.
