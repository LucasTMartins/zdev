*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLMO_T_PRODUTO..................................*
DATA:  BEGIN OF STATUS_ZLMO_T_PRODUTO                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLMO_T_PRODUTO                .
CONTROLS: TCTRL_ZLMO_T_PRODUTO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLMO_T_PRODUTO                .
TABLES: ZLMO_T_PRODUTO                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
