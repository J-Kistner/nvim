local M = {}

ts = vim.treesitter;

--- Finds the first instance of a node of type child_type
--- @param node TSNode the staring node
--- @param child_type string the target type
--- @return TSNode? the child node
M.get_node_child = function(node, child_type)
   for child in node:iter_children() do
      if child:type() == child_type then
         return child
      end
      local result = get_node_child(child, child_type)
      if result then
         return result
      end
   end
end

--- Finds the first instance of a node of type parent_type
--- and returns its parent
--- @param node TSNode the staring node
--- @param parent_type string the target type
--- @return TSNode? the parent node
M.get_node_parent = function(node, parent_type)
   if node:parent():type() == parent_type then
      return node:parent()
   end
   parent = node:parent()
   if parent == nil then
      return nil
   end
   return get_node_parent(parent, parent_type)
end

--- Finds the first instance of a node of type type
--- and returns its parent
--- @param node TSNode the staring node
--- @param type string the target type
--- @return TSNode? the parent node
M.get_node_parent_of_type = function(node, type)
   if node:type() == type then
      return node
   end
   parent = node:parent()
   if parent == nil then
      return nil
   end
   return get_node_parent_of_type(parent, type)
end

--- Gets the main node of a file
--- @param node TSNode the starting node
--- @return TSNode the main node
M.get_master_node = function(node)
   parent = node:parent()
   if parent == nil then
      return node
   end
   return get_master_node(parent)
end

--- Finds all nodes of type type in the current file
--- @param type string the target type
--- @return TSNode[] the nodes
M.find_nodes_of_type = function(type)
   parent = get_master_node(ts.get_node())
   for child in parent:iter_children() do
      if child:type() == type then
         table.insert(result, child)
      end
   end
end

--- Finds the closest declaration of a node of type type with pattern of name name
--- @param node TSNode the staring node
--- @param type string the target type
--- @param name string the target name
m.increamental_scope_declaration_search = function(node, scope_type, name)
   parent = node:parent()
   if parent == nil then
      return nil
   end
   if parent:type() == scope_type then
      if parent:field("pattern") then
         if parent:field("pattern"):type() == name then
            return parent
         end
      end
   end
   for node in parent:iter_children() do
      if node:type() == scope_type then
         if node:field("pattern") then
            if node:field("pattern"):type() == name then
               return node
            end
         end
      end
   end

   return increamental_scope_declaration_search(parent, scope_type, name)
end

return M
