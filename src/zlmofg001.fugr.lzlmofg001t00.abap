*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLMOT001........................................*
DATA:  BEGIN OF STATUS_ZLMOT001                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLMOT001                      .
CONTROLS: TCTRL_ZLMOT001
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLMOT001                      .
TABLES: ZLMOT001                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
