*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLMO_T_CLIENTE..................................*
DATA:  BEGIN OF STATUS_ZLMO_T_CLIENTE                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLMO_T_CLIENTE                .
CONTROLS: TCTRL_ZLMO_T_CLIENTE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLMO_T_CLIENTE                .
TABLES: ZLMO_T_CLIENTE                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
