require_relative 'player'

class ComputerPlayer < Player

  def check_or_bet
    nil
  end

  def call_raise_or_fold(current_bet, current_account)
    nil
  end

  def choose_discards
    []
  end
end
