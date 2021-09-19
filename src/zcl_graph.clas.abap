CLASS zcl_graph DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Type definitions
    TYPES: BEGIN OF st_adjacency_matrix,
             from   TYPE i,
             to     TYPE i,
             weight TYPE i,
           END OF st_adjacency_matrix.

    TYPES tt_adjacency_matrix TYPE SORTED TABLE OF st_adjacency_matrix
    WITH UNIQUE KEY from to.

    TYPES: BEGIN OF st_node_list,
             node TYPE i,
           END OF st_node_list.

    TYPES tt_node_list TYPE SORTED TABLE OF st_node_list
    WITH UNIQUE KEY node.

    " Methods
    METHODS add_node
      IMPORTING
        iv_node TYPE i.

    METHODS remove_node
      IMPORTING
        iv_node TYPE i.

    METHODS add_edge ABSTRACT
      IMPORTING
        iv_from   TYPE i
        iv_to     TYPE i
        iv_weight TYPE i.

    METHODS remove_edge ABSTRACT
      IMPORTING
        iv_from TYPE i
        iv_to   TYPE i.

    METHODS get_adjacency_matrix
      RETURNING
        VALUE(rt_adjacency_matrix) TYPE tt_adjacency_matrix.

    METHODS get_node_list
      RETURNING
        VALUE(rt_node_list) TYPE tt_node_list.

  PROTECTED SECTION.
    DATA gt_node_list TYPE tt_node_list.
    DATA gt_adjacency_matrix TYPE tt_adjacency_matrix.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_graph IMPLEMENTATION.
  METHOD add_node.
    me->gt_node_list = VALUE #( BASE me->gt_node_list
        ( node = iv_node ) ).
  ENDMETHOD.

  METHOD remove_node.
    DELETE TABLE me->gt_node_list FROM VALUE #( node = iv_node ).
  ENDMETHOD.

  METHOD get_adjacency_matrix.
    rt_adjacency_matrix = me->gt_adjacency_matrix.
  ENDMETHOD.

  METHOD get_node_list.
    rt_node_list = me->gt_node_list.
  ENDMETHOD.
ENDCLASS.
