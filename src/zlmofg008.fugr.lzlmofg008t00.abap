*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLMOT015........................................*
DATA:  BEGIN OF STATUS_ZLMOT015                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLMOT015                      .
CONTROLS: TCTRL_ZLMOT015
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLMOT015                      .
TABLES: ZLMOT015                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
