*&---------------------------------------------------------------------*
*& Include MZLMO003TOP                              - PoolMóds.        SAPMZLMO003
*&---------------------------------------------------------------------*
PROGRAM sapmzlmo003.

TABLES: likp.

CONTROLS: tablecontrol TYPE TABLEVIEW USING SCREEN 0100.

TYPES: BEGIN OF ty_likp,
         vbeln TYPE likp-vbeln,
         ernam TYPE likp-ernam,
         erzet TYPE likp-erzet,
         erdat TYPE likp-erdat,
       END OF ty_likp.

DATA: gt_likp       TYPE TABLE OF ty_likp,
      gs_likp       TYPE          ty_likp,
      p_listbox(26) TYPE c.
