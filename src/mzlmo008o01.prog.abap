*----------------------------------------------------------------------*
***INCLUDE MZLMO008O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'.

  IF go_tree IS INITIAL.                "verificando se o container ainda não foi criado
    PERFORM f_create_alvtree_container. "criando container
  ENDIF.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  PERFORM f_fetch_binary_data.
  PERFORM f_create_url.

  IF go_home_img IS INITIAL.
    CREATE OBJECT go_home_img
      EXPORTING
        container_name = gc_container_name_himg. "HOME_IMG
    CREATE OBJECT go_pic
      EXPORTING
        parent = go_home_img.
    go_pic->load_picture_from_url( EXPORTING url = gv_url ).
  ENDIF.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0140 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0140 OUTPUT.
  PERFORM f_popup_marcar_voo. "popup para marcar vôo
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0150 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0150 OUTPUT.
  "PASSANDO DADOS INEDITÁVEIS PARA A TELA
  gs_sbook-carrid = gv_popup_param-carrid.
  gs_sbook-connid = gv_popup_param-connid.
  gs_sbook-fldate = gv_popup_param-fldate.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0160 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0160 OUTPUT.
  PERFORM f_popup_impr. "popup de impressão de cartão de embarque
ENDMODULE.
