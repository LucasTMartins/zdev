*&---------------------------------------------------------------------*
*& Include MZLMO004TOP                              - PoolMóds.        SAPMZLMO004
*&---------------------------------------------------------------------*
PROGRAM sapmzlmo004.

TYPES: BEGIN OF ty_likp,
         mark(1) TYPE c,
         vbeln   TYPE likp-vbeln,
         ernam   TYPE likp-ernam,
         erzet   TYPE likp-erzet,
         erdat   TYPE likp-erdat,
       END OF ty_likp.

DATA: gt_likp TYPE TABLE OF ty_likp,
      gs_likp TYPE          ty_likp.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_LIKP' ITSELF
CONTROLS: tc_likp TYPE TABLEVIEW USING SCREEN 0100.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_LIKP'
DATA:     g_tc_likp_lines  LIKE sy-loopc.

DATA:     ok_code LIKE sy-ucomm.
