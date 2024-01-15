# Initialize the game board
board = Array.new(3) { Array.new(3, ' ') }

# Method to display the game board
# the board show the coordinate of each cell
def display_board(board)
    # Display column coordinates
    puts "    0   1   2"
    puts "  -------------"
    board.each_with_index do |row, i|
        print "#{i} |" # Display row coordinate
        row.each do |cell|
            print " #{cell} |"
        end
        puts "\n  -------------"
    end
end

# Method to check if the game is over for a specific player
def game_over?(board, player)
    # Check rows
    board.each do |row|
        return true if row.uniq.length == 1 && row[0] == player
    end

    # Check columns
    board.transpose.each do |column|
        return true if column.uniq.length == 1 && column[0] == player
    end

    # Check diagonals
    return true if [board[0][0], board[1][1], board[2][2]].uniq.length == 1 && board[0][0] == player
    return true if [board[0][2], board[1][1], board[2][0]].uniq.length == 1 && board[0][2] == player

    false
end
# Method to get the player's move
def get_move(board)
    puts "Enter your move (row, column):"
    move = gets.chomp.split(',').map(&:to_i)
    until valid_move?(board, move)
        puts "Invalid move. Please try again:"
        move = gets.chomp.split(',').map(&:to_i)
    end
    move
end

# Method to check if the move is valid
def valid_move?(board, move)
    row, col = move
    return false if row.nil? || col.nil?
    return false if row < 0 || row >= board.length
    return false if col < 0 || col >= board[0].length
    return false if board[row][col] != ' '
    true
end

# Method to update the game board with the player's move
def update_board(board, move, player)
    row, col = move
    board[row][col] = player
end

# Method to switch players
def switch_player(player)
    player == 'X' ? 'O' : 'X'
end


# Method to find the best move for the AI
def ai_move(board, ai, player)
    # Check if AI can win in the next move
    for i in 0...board.length
        for j in 0...board[0].length
            if valid_move?(board, [i, j])
                board[i][j] = ai
                if game_over?(board, ai)
                    return [i, j]
                end
                board[i][j] = ' '
            end
        end
    end

    # Check if player can win in the next move and block them
    for i in 0...board.length
        for j in 0...board[0].length
            if valid_move?(board, [i, j])
                board[i][j] = player
                if game_over?(board, player)
                    return [i, j]
                end
                board[i][j] = ' '
            end
        end
    end

    # If no winning move, pick a random spot
    available_moves = []
    for i in 0...board.length
        for j in 0...board[0].length
            if valid_move?(board, [i, j])
                available_moves << [i, j]
            end
        end
    end

    available_moves.sample
end


# Main game loop
current_player = 'X'
loop do
    display_board(board)
    if current_player == 'O' # Assuming 'O' is the AI player
        move = ai_move(board, 'O', 'X')
    else
        move = get_move(board)
    end
    update_board(board, move, current_player)
    break if game_over?(board,current_player)
    current_player = switch_player(current_player)
end

display_board(board)
puts "Game over!"
