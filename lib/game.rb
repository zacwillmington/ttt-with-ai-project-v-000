
class Game

    attr_accessor  :board, :player_1, :player_2


    WIN_COMBINATIONS =  [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [6,4,2]
    ]

    def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
         @player_1 = player_1
         @player_2 = player_2
         @board = board
    end

    def current_player
       @board.turn_count % 2 == 0 ? @player_1 : @player_2
    end

    def over?
        if won? != false
            return true
        end
        if draw?
            return true
        end
         return false
    end

    def won?
        win = WIN_COMBINATIONS.find do |combo|
             @board.cells.values_at(combo[0],combo[1],combo[2]).all?{|v| v == "X"}  || @board.cells.values_at(combo[0],combo[1],combo[2]).all?{|v| v == "O"}
         end
          if win == nil
              return false
          elsif win != nil
              win
          end
    end

    def draw?
        @board.full? && won? == false ? true : false
    end

    def winner
        won? == false ? nil : @board.cells[won?[0]]
    end

    def turn
        @board.display
        move = current_player.move(@board, WIN_COMBINATIONS)
        if @board.valid_move?(move)
            @board.update(move, current_player)
        end
    end


     def play
         until over?
             turn
             won?
             draw?
        end
        if won? != false
            if winner == "X"
                @board.display
                puts "Congratulations X!"

            else
                @board.display
                puts "Congratulations O!"
            end
        end
        if draw?
           puts "Cat's Game!"
        end
    end

    def self.game_start(input)
        if input == "0" || input == "1" || input == "2"
            if input == "2"
                game = Game.new
                game.play
                game.board.reset!

            elsif input == "1"
                puts "Would like to go first?(y/n)"
                input = gets.strip
                if input == "y"
                    game_p_vs_ai = Game.new(Players::Human.new("X"),Players::Computer.new("O"), Board.new)
                    game_p_vs_ai.play
                    game_p_vs_ai.board.reset!
                elsif input == "n"
                    game_p_vs_ai = Game.new(Players::Computer.new("X"),Players::Human.new("O"), Board.new)
                    game_p_vs_ai.play
                    game_p_vs_ai.board.reset!
                 end


            elsif input == "0"
                game_ai_vs_ai = Game.new(Players::Computer.new("X"),Players::Computer.new("O"), Board.new)
                game_ai_vs_ai.play
                game_ai_vs_ai.board.reset!

            end
        end
    end

    def self.game_replay
        puts "Would you like to play again? (y/n)"
        play_again = gets.strip
         if play_again == "y" || play_again == "Y"
             puts "Which player mode?"
             input = gets.strip
             game_start(input)
         else
             nil
         end
     end
end
