*&---------------------------------------------------------------------*
*& Include          ZLMOR043O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  IF gs_material-matnr IS NOT INITIAL AND gs_material-maktx IS INITIAL.
    LOOP AT SCREEN. "Deixar o campo escondido
      IF screen-group1 = 'G1'.
        screen-invisible = 1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
  PERFORM f_buscar_dados.    "buscando dados
  PERFORM f_fieldcat_init.   "construindo fieldcat
  PERFORM f_display_docking. "mostrando ALVs
ENDMODULE.
