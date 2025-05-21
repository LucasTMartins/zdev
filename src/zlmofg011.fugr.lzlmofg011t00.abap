*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLMOT022........................................*
DATA:  BEGIN OF STATUS_ZLMOT022                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLMOT022                      .
CONTROLS: TCTRL_ZLMOT022
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLMOT022                      .
TABLES: ZLMOT022                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
