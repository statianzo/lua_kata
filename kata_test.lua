require 'lunit'
local kata = require 'kata'

module('kata_test', lunit.testcase, package.seeall)

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

function test_will_insert_dual_leaf_node()
  local result = kata.build_tree("/foo/bar|baz")
  assert_table(result.foo.bar)
  assert_table(result.foo.baz)
end

function test_adding_to_an_existing_tree()
  local tree = kata.build_tree("/foo/bar")
  local result = kata.build_tree("/foo/bar/baz|qux", tree)
  assert_table(result.foo.bar.baz)
  assert_table(result.foo.bar.qux)
end


function test_split_will_separate()
  local result = kata.split("/foo/bar/baz|bing", "/")
  assert_table(result)
  assert_equal(result[1], 'foo')
  assert_equal(result[2], 'bar')
  assert_equal(result[3], 'baz|bing')
end

function test_combinations()
  local result = kata.combinations({'foo', 'bar', 'baz'})
  assert_equal('foo', result[1])
  assert_equal('bar', result[2])
  assert_equal('baz', result[3])
  assert_equal('foo-bar', result[4])
  assert_equal('foo-baz', result[5])
  assert_equal('bar-baz', result[6])
  assert_equal('foo-bar-baz', result[7])
  assert_equal(7, #result)
end

function test_combinations_of_four_elements()
  local result = kata.combinations({'foo', 'bar', 'baz', 'qux'})
  assert_equal('foo', result[1])
  assert_equal('bar', result[2])
  assert_equal('baz', result[3])
  assert_equal('qux', result[4])
  assert_equal('foo-bar', result[5])
  assert_equal('foo-baz', result[6])
  assert_equal('foo-qux', result[7])
  assert_equal('bar-baz', result[8])
  assert_equal('bar-qux', result[9])
  assert_equal('baz-qux', result[10])
  assert_equal('foo-bar-baz', result[11])
  assert_equal('foo-bar-qux', result[12])
  assert_equal('foo-baz-qux', result[13])
  assert_equal('bar-baz-qux', result[14])
  assert_equal('foo-bar-baz-qux', result[15])
  assert_equal(15, #result)
end

function test_combine_length_one()
  local result = kata.combine({'a', 'b', 'c'}, 1)
  assert_equal('a', result[1][1])
  assert_equal('b', result[2][1])
  assert_equal('c', result[3][1])
end

function test_combine_length_two()
  local result = kata.combine({'a', 'b', 'c'}, 2)
  assert_equal('a', result[1][1])
  assert_equal('b', result[1][2])

  assert_equal('a', result[2][1])
  assert_equal('c', result[2][2])

  assert_equal('b', result[3][1])
  assert_equal('c', result[3][2])
  assert_equal(3, #result)
end

function test_combine_length_three()
  local result = kata.combine({'a', 'b', 'c'}, 3)
  assert_equal('a', result[1][1])
  assert_equal('b', result[1][2])
  assert_equal('c', result[1][3])

  assert_equal(1, #result)
end

function test_map()
  local result = kata.map({4,5,6}, function(x) return x * 10 end)
  assert_equal(40, result[1])
  assert_equal(50, result[2])
  assert_equal(60, result[3])
end
