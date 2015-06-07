require_relative 'player'

class InvalidInputError < StandardError
end

class IllegalBetError < StandardError
end

class HumanPlayer < Player

  def check_or_bet
    puts "Your hand is:"
    @hand.display
    puts "Action is on you, would you like to check or bet?"
    puts "(enter 'c' or 'b, <amt>')"

    begin
      action = parse_bets(gets.chomp)
    rescue InvalidInputError
      puts "Invalid input, please retry"
      retry
    rescue IllegalBetError
      puts "Illegal bet size, please retry"
      retry
    end

    action
  end

  def call_raise_or_fold(current_bet, current_account)
    puts "Your hand is:"
    @hand.display
    puts "Action is on you, would you like to fold, call, or raise?"
    puts "(enter 'f' or 'b, <amt>')"

    begin
      action = parse_bets(gets.chomp)
      return nil if action.nil?
      raise IllegalBetError if action < current_bet - current_account
    rescue InvalidInputError
      puts "Invalid input, please retry"
      retry
    rescue IllegalBetError
      puts "Illegal bet size, please retry"
      retry
    end

    action
  end

  def parse_bets(input)
    input_arr = input.split(",").map{ |item| item.strip.downcase }
    option = input_arr[0]
    raise InvalidInputError unless option == "c" || option == "b" || option == "f"
    raise InvalidInputError if (caller_locations(1,1)[0].label == :check_or_bet) && option == "f"
    raise InvalidInputError if (caller_locations(1,1)[0].label == :call_raise_or_fold) && option == "c"

    return nil if option == "c" || option == "f"

    bet_amt = input_arr[1].to_i
    raise IllegalBetError unless bet_amt.between?(2, @bankroll)
    bet_amt
  end

  def choose_discards
    puts "Your hand is:"
    @hand.display
    puts "Which cards would you like to discard? (maximum 3)"
    puts "(enter card number from top to bottom like '1, 3, 4')"

    begin
      discards = parse_discards(gets.chomp)
    rescue InvalidInputError
      puts "Invalid input, please retry"
      retry
    end

    discards
  end

  def parse_discards
    discard_arr = input.split(",").map{ |item| item.strip.to_i }
    raise InvalidInputError unless discard_arr.count.between(0,3)
    raise InvalidInputError unless discard_arr.all? { |i| i.between(1,5) }
    raise InvalidInputError unless discard_arr == discard_arr.uniq

    discard_arr
  end
end
