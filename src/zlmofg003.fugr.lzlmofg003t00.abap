*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLMOT005........................................*
DATA:  BEGIN OF STATUS_ZLMOT005                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLMOT005                      .
CONTROLS: TCTRL_ZLMOT005
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZV_LMOT006......................................*
TABLES: ZV_LMOT006, *ZV_LMOT006. "view work areas
CONTROLS: TCTRL_ZV_LMOT006
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZV_LMOT006. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZV_LMOT006.
* Table for entries selected to show on screen
DATA: BEGIN OF ZV_LMOT006_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZV_LMOT006.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZV_LMOT006_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZV_LMOT006_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZV_LMOT006.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZV_LMOT006_TOTAL.

*.........table declarations:.................................*
TABLES: *ZLMOT005                      .
TABLES: ZLMOT005                       .
TABLES: ZLMOT006                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
