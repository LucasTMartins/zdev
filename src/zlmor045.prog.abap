*&---------------------------------------------------------------------*
*& VB_Alimentos # Alterar prioridade das OTs                           *
*&---------------------------------------------------------------------*
*& Domain :                                                            *
*& Program type : Report                                               *
*& Author Name : Lucas Martins de Oliveira                             *
*& Date : 22.02.2024                                                   *
*& Description : Alterar prioridade das OTs                            *
*&---------------------------------------------------------------------*

INCLUDE zlmor045top.

INCLUDE zlmor045c01.
INCLUDE zlmor045o01.
INCLUDE zlmor045i01.
INCLUDE zlmor045f01.

**----------------------------------------------------------------------*
INITIALIZATION.
**----------------------------------------------------------------------*
  PERFORM f_initialization.

**----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
**----------------------------------------------------------------------*
  LOOP AT SCREEN.
    IF screen-name = gc_lgnum.
      screen-input = gc_zero.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  CALL SCREEN '0100'.
