CLASS zcl_undir_graph DEFINITION
  PUBLIC
  INHERITING FROM zcl_graph
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Type definitions
    TYPES: BEGIN OF st_paths,
             node      TYPE i,
             prev_node TYPE i,
             distance  TYPE i,
             visited   TYPE abap_bool,
           END OF st_paths.

    TYPES tt_paths TYPE STANDARD TABLE OF st_paths WITH DEFAULT KEY.

    " Methods
    METHODS: add_edge REDEFINITION,
      remove_edge REDEFINITION.

    METHODS get_neighbors
      IMPORTING
        iv_node             TYPE i
      RETURNING
        VALUE(rt_neighbors) TYPE tt_node_list.

    METHODS get_shortest_paths
      IMPORTING
        iv_start                 TYPE i
      RETURNING
        VALUE(rt_shortest_paths) TYPE tt_paths.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_undir_graph IMPLEMENTATION.
  METHOD add_edge.
    me->gt_edges = VALUE #( BASE me->gt_edges
        ( from = iv_from to = iv_to weight = iv_weight ) ).
    me->gt_edges = VALUE #( BASE me->gt_edges
        ( from = iv_to to = iv_from weight = iv_weight ) ).
  ENDMETHOD.

  METHOD remove_edge.
    DELETE TABLE me->gt_edges FROM VALUE #( from = iv_from to = iv_to ).
    DELETE TABLE me->gt_edges FROM VALUE #( from = iv_to to = iv_from ).
  ENDMETHOD.

  METHOD get_neighbors.
    LOOP AT me->gt_edges ASSIGNING FIELD-SYMBOL(<fs_adjacency_line>) WHERE from = iv_node.
      rt_neighbors = VALUE #( BASE rt_neighbors ( node = <fs_adjacency_line>-to ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD get_shortest_paths.
    " Initialize table
    rt_shortest_paths = VALUE #( BASE rt_shortest_paths
      ( node = iv_start distance = 0 visited = abap_false )
    ).
    LOOP AT me->gt_nodes ASSIGNING FIELD-SYMBOL(<fs_node>) WHERE node NE iv_start.
      rt_shortest_paths = VALUE #( BASE rt_shortest_paths
        ( node = <fs_node>-node distance = 2147483647 visited = abap_false  )
      ).
    ENDLOOP.
    "Compute shortest paths
    WHILE line_exists( rt_shortest_paths[ visited = abap_false ] ).
      SORT rt_shortest_paths ASCENDING BY visited distance.
      READ TABLE rt_shortest_paths ASSIGNING FIELD-SYMBOL(<fs_current_line>) INDEX 1.
      <fs_current_line>-visited = abap_true.
      LOOP AT me->get_neighbors( <fs_current_line>-node ) INTO DATA(neighbor).
        READ TABLE rt_shortest_paths ASSIGNING FIELD-SYMBOL(<fs_neighbor_line>) WITH KEY node = neighbor-node.
        IF <fs_neighbor_line>-visited = abap_false.
          DATA(alternate_dist) = CONV int8( <fs_current_line>-distance ) + me->gt_edges[ from = <fs_current_line>-node to = <fs_neighbor_line>-node ]-weight.
          IF alternate_dist LT <fs_neighbor_line>-distance.
            <fs_neighbor_line>-distance = alternate_dist.
            <fs_neighbor_line>-prev_node = <fs_current_line>-node.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDWHILE.
    SORT rt_shortest_paths ASCENDING BY node.
  ENDMETHOD.
ENDCLASS.
