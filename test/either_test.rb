require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class EitherTest < Test::Unit::TestCase
  include Rumonade
  include MonadAxiomTestHelpers

  def test_when_either_constructor_raises
    assert_raise(TypeError) { Either.new }
  end

  def test_when_left_or_right_returns_new_left_or_right
    assert_equal Left.new("error"), Left("error")
    assert_equal Right.new(42), Right(42)
  end

  def test_predicates_for_left_and_right
    assert Left("error").left?
    assert !Right(42).left?
    assert Right(42).right?
    assert !Left("error").right?
  end

  def test_swap_for_left_and_right
    assert_equal Left(42), Right(42).swap
    assert_equal Right("error"), Left("error").swap
  end

  def test_fold_for_left_and_right
    times_two = lambda { |v| v * 2 }
    times_ten = lambda { |v| v * 10 }
    assert_equal "errorerror", Left("error").fold(times_two, times_ten)
    assert_equal 420, Right(42).fold(times_two, times_ten)
  end

  def test_projections_for_left_and_right
    assert_equal Either::LeftProjection.new(Left("error")), Left("error").left
    assert_equal Either::RightProjection.new(Left("error")), Left("error").right
    assert_equal Either::LeftProjection.new(Right(42)), Right(42).left
    assert_equal Either::RightProjection.new(Right(42)), Right(42).right

    assert_not_equal Either::LeftProjection.new(Left("error")), Left("error").right
    assert_not_equal Either::RightProjection.new(Left("error")), Left("error").left
    assert_not_equal Either::LeftProjection.new(Right(42)), Right(42).right
    assert_not_equal Either::RightProjection.new(Right(42)), Right(42).left
  end

  def test_flat_map_for_left_and_right_projections_returns_eithers
    assert_equal Left("42"), Right(42).right.flat_map { |n| Left(n.to_s) }
    assert_equal Right(42), Right(42).left.flat_map { |n| Left(n.to_s) }
    assert_equal Right("ERROR"), Left("error").left.flat_map { |n| Right(n.upcase) }
    assert_equal Left("error"), Left("error").right.flat_map { |n| Right(n.upcase) }
  end

  def test_any_predicate_for_left_and_right_projections_returns_true_if_correct_type_and_block_returns_true
    assert Left("error").left.any? { |s| s == "error" }
    assert !Left("error").left.any? { |s| s != "error" }
    assert !Left("error").right.any? { |s| s == "error" }

    assert Right(42).right.any? { |n| n == 42 }
    assert !Right(42).right.any? { |n| n != 42 }
    assert !Right(42).left.any? { |n| n == 42 }
  end

  def test_select_for_left_and_right_projects_returns_option_of_either_if_correct_type_and_block_returns_true
    assert_equal Some(Left("error")), Left("error").left.select { |s| s == "error" }
    assert_equal None, Left("error").left.select { |s| s != "error" }
    assert_equal None, Left("error").right.select { |s| s == "error" }

    assert_equal Some(Right(42)), Right(42).right.select { |n| n == 42 }
    assert_equal None, Right(42).right.select { |n| n != 42 }
    assert_equal None, Right(42).left.select { |n| n == 42 }    
  end
  
  def test_all_predicate_for_left_and_right_projections_returns_true_if_correct_type_and_block_returns_true
    assert Left("error").left.all? { |s| s == "error" }
    assert !Left("error").left.all? { |s| s != "error" }
    assert Left("error").right.all? { |s| s == "error" }

    assert Right(42).right.all? { |n| n == 42 }
    assert !Right(42).right.all? { |n| n != 42 }
    assert Right(42).left.all? { |n| n == 42 }
  end  

  def test_each_for_left_and_right_projections_executes_block_if_correct_type
    def side_effect_occurred_on_each(projection)
      side_effect_occurred = false
      projection.each { |s| side_effect_occurred = true }
      side_effect_occurred
    end

    assert side_effect_occurred_on_each(Left("error").left)
    assert !side_effect_occurred_on_each(Left("error").right)

    assert side_effect_occurred_on_each(Right(42).right)
    assert !side_effect_occurred_on_each(Right(42).left)
  end

  def test_unit_for_left_and_right_projections
    assert_equal Left("error").left, Either::LeftProjection.unit("error")
    assert_equal Right(42).right, Either::RightProjection.unit(42)
  end

  def test_empty_for_left_and_right_projections
    assert_equal Right(nil).left, Either::LeftProjection.empty
    assert_equal Left(nil).right, Either::RightProjection.empty
  end

  def test_monad_axioms_for_left_and_right_projections
    assert_monad_axiom_1(Either::LeftProjection, "error", lambda { |x| Left(x * 2).left })
    assert_monad_axiom_2(Left("error").left)
    assert_monad_axiom_3(Left("error").left, lambda { |x| Left(x * 2).left }, lambda { |x| Left(x * 5).left })

    assert_monad_axiom_1(Either::RightProjection, 42, lambda { |x| Right(x * 2).right })
    assert_monad_axiom_2(Right(42).right)
    assert_monad_axiom_3(Right(42).right, lambda { |x| Right(x * 2).right }, lambda { |x| Right(x * 5).right })
  end

  def test_get_for_left_and_right_projections_returns_value_if_correct_type_or_raises
    assert_equal "error", Left("error").left.get
    assert_raises(NoSuchElementError) { Left("error").right.get }
    assert_equal 42, Right(42).right.get
    assert_raises(NoSuchElementError) { Right(42).left.get }
  end
end
