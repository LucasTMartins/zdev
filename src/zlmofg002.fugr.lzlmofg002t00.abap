*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLMOT003........................................*
DATA:  BEGIN OF STATUS_ZLMOT003                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLMOT003                      .
CONTROLS: TCTRL_ZLMOT003
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZV_T004.........................................*
TABLES: ZV_T004, *ZV_T004. "view work areas
CONTROLS: TCTRL_ZV_T004
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZV_T004. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZV_T004.
* Table for entries selected to show on screen
DATA: BEGIN OF ZV_T004_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZV_T004.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZV_T004_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZV_T004_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZV_T004.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZV_T004_TOTAL.

*.........table declarations:.................................*
TABLES: *ZLMOT003                      .
TABLES: ZLMOT003                       .
TABLES: ZLMOT004                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
