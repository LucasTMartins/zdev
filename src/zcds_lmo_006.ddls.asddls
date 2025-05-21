define hierarchy zcds_lmo_006
  as parent child hierarchy(
    source zcds_lmo_006_main
    child to parent association _manager
    siblings order by
      EmpId
  )
{
  EmpId,
  EmpName,
  ManagerId,
  CostCenter,
  $node.hierarchy_level       as hier_level,
  $node.hierarchy_rank        as hier_rank,
  $node.hierarchy_is_orphan   as is_orphan,
  $node.hierarchy_parent_rank as hier_parent_rank,
  $node.hierarchy_tree_size   as hier_tree_size,
  $node.node_id               as id_node,
  $node.parent_id             as id_parent
}
