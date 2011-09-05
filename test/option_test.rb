require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class OptionTest < Test::Unit::TestCase
  include Rumonade
  include MonadAxiomTestHelpers

  def test_when_option_with_nil_returns_none_singleton
    assert_same None, Option.unit(nil)
    assert_same None, Option(nil)
    assert_same NoneClass.instance, None
  end

  def test_when_option_with_value_returns_some
    assert_equal Some(42), Option.unit(42)
    assert_equal Some(42), Option(42)
    assert_equal Some(42), Some.new(42)
    assert_not_equal None, Some(nil)
  end

  def test_monad_axioms
    f = lambda { |x| Option(x && x * 2) }
    g = lambda { |x| Option(x && x * 5) }
    [nil, 42].each do |value|
      assert_monad_axiom_1(Option, value, f)
      assert_monad_axiom_2(Option(value))
      assert_monad_axiom_3(Option(value), f, g)
    end
  end

  def test_when_value_on_some_returns_value_but_on_none_raises
    assert_equal "foo", Some("foo").value
    assert_raise(NoMethodError) { None.value }
  end

  def test_when_get_on_some_returns_value_but_on_none_raises
    assert_equal "foo", Some("foo").get
    assert_raise(NoSuchElementError) { None.get }
  end

  def test_when_get_or_else_on_some_returns_value_but_on_none_returns_value_or_executes_block_or_lambda
    assert_equal "foo", Some("foo").get_or_else("bar")
    assert_equal "bar", None.get_or_else("bar")
    assert_equal "blk", None.get_or_else { "blk" }
    assert_equal "lam", None.get_or_else(lambda { "lam"} )
  end

end