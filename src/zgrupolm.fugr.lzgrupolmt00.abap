*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFUNCIONARIO_LMA................................*
DATA:  BEGIN OF STATUS_ZFUNCIONARIO_LMA              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFUNCIONARIO_LMA              .
CONTROLS: TCTRL_ZFUNCIONARIO_LMA
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFUNCIONARIO_LMA              .
TABLES: ZFUNCIONARIO_LMA               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
