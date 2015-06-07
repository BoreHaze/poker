require_relative 'player'

class InvalidInputError < StandardError
end

class IllegalBetError < StandardError
end

class HumanPlayer < Player

  def check_or_bet
    puts "Action is on you, would you like to check or bet?"
    puts "(enter 'c' or 'b, <amt>')"

    begin
      action = parse_input(gets.chomp)
      break if action.nil?
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
    puts "Action is on you, would you like to fold, call, or raise?"
    puts "(enter 'f' or 'b, <amt>')"

    begin
      action = parse_input(gets.chomp)
      break if action.nil?
      raise IllegalBetError if action < current_bet - current_account
    rescue InvalidInputError
      puts "Invalid input, please retry"
      retry
    rescue IllegalBetError
      puts "Illegal bet size, please retry"
    end

    action
  end

  def parse_input(input)
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
end
