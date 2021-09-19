CLASS zcl_graph DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Type definitions
    TYPES: BEGIN OF st_edge_list,
             from   TYPE i,
             to     TYPE i,
             weight TYPE i,
           END OF st_edge_list.

    TYPES tt_edge_list TYPE SORTED TABLE OF st_edge_list
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

    METHODS get_edges
      RETURNING
        VALUE(rt_edges) TYPE tt_edge_list.

    METHODS get_nodes
      RETURNING
        VALUE(rt_nodes) TYPE tt_node_list.

  PROTECTED SECTION.
    DATA gt_nodes TYPE tt_node_list.
    DATA gt_edges TYPE tt_edge_list.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_graph IMPLEMENTATION.
  METHOD add_node.
    me->gt_nodes = VALUE #( BASE me->gt_nodes
        ( node = iv_node ) ).
  ENDMETHOD.

  METHOD remove_node.
    DELETE TABLE me->gt_nodes FROM VALUE #( node = iv_node ).
  ENDMETHOD.

  METHOD get_edges.
    rt_edges = me->gt_edges.
  ENDMETHOD.

  METHOD get_nodes.
    rt_nodes = me->gt_nodes.
  ENDMETHOD.
ENDCLASS.
