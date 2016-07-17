require_relative 'tic_tac_toe'


class TicTacToeNode

  attr_reader :board, :next_mover_mark, :prev_move_pos, :opponent_mark

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @opponent_mark = [:x,:o].select { |mark| mark != @next_mover_mark}[0]
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if @board.over?
      return false if @board.winner.nil?
      return true unless @board.winner == evaluator
      return false
    end

    if @next_mover_mark == evaluator
      children.all? { |child| child.losing_node?(evaluator) }
    else
      children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    if @board.over?
      return true if @board.winner == evaluator
      return false
    end

    if @next_mover_mark == evaluator
      children.any? { |child| child.winning_node?(evaluator) }
    else
      children.all? { |child| child.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    states = []
    (0...@board.rows.size).each do |i|
      (0...@board.rows[0].size).each do |j|
        if @board.empty?([i, j])
          temp_board = @board.dup
          temp_board[[i, j]] = @next_mover_mark
          node = TicTacToeNode.new(temp_board, @opponent_mark, [i, j])
          states << node
        end
      end
    end
    states
  end
end
