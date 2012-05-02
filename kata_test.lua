require 'lunit'
local kata = require 'kata'

module('kata_test', lunit.testcase)

function test_it_builds_tree()
  local result = kata.build_tree()
  assert_not_nil(result)
end

function test_a_tree_is_a_table()
  local result = kata.build_tree("/foo/bar")
  assert_table(result)
end

function test_the_tree_has_a_root_node()
  local result = kata.build_tree("/foo/bar")
  assert_not_nil(result.foo)
end

function test_deeper_nodes_are_keys_of_their_parents()
  local result = kata.build_tree("/foo/bar")
  assert_not_nil(result.foo.bar)
end

function test_adding_to_an_existing_tree()
  local tree = kata.build_tree("/foo/bar")
  local result = kata.build_tree("/foo/baz", tree)
  assert_not_nil(result.foo.baz)
end
