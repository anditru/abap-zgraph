*&---------------------------------------------------------------------*
*& Report z_dijkstra_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_dijkstra_test.

DATA go_graph TYPE REF TO zcl_undir_graph.
go_graph = NEW #( ).

DO 9 TIMES.
    go_graph->add_node( sy-index ).
ENDDO.

go_graph->add_edge( iv_from = 1 iv_to = 2 iv_weight = 2 ).
go_graph->add_edge( iv_from = 2 iv_to = 3 iv_weight = 4 ).
go_graph->add_edge( iv_from = 3 iv_to = 4 iv_weight = 2 ).
go_graph->add_edge( iv_from = 4 iv_to = 5 iv_weight = 1 ).
go_graph->add_edge( iv_from = 5 iv_to = 6 iv_weight = 6 ).
go_graph->add_edge( iv_from = 6 iv_to = 1 iv_weight = 9 ).
go_graph->add_edge( iv_from = 1 iv_to = 7 iv_weight = 15 ).
go_graph->add_edge( iv_from = 2 iv_to = 7 iv_weight = 6 ).
go_graph->add_edge( iv_from = 7 iv_to = 8 iv_weight = 15 ).
go_graph->add_edge( iv_from = 8 iv_to = 9 iv_weight = 4 ).
go_graph->add_edge( iv_from = 9 iv_to = 7 iv_weight = 2 ).
go_graph->add_edge( iv_from = 6 iv_to = 8 iv_weight = 11 ).
go_graph->add_edge( iv_from = 5 iv_to = 8 iv_weight = 3 ).
go_graph->add_edge( iv_from = 4 iv_to = 9 iv_weight = 1 ).
go_graph->add_edge( iv_from = 3 iv_to = 9 iv_weight = 15 ).

DATA(gt_shortest_paths) = go_graph->get_shortest_paths( 1 ).

DATA go_alv TYPE REF TO cl_salv_table.
cl_salv_table=>factory(
    IMPORTING
      r_salv_table = go_alv
    CHANGING
      t_table      = gt_shortest_paths ).
go_alv->display( ).
