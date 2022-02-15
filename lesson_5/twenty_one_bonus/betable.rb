module Betable
  attr_reader :bankroll, :bet

  def settle_bet(dealer_total)
    if busted?
      collect_losses
    elsif dealer_total > 21
      payout
    elsif total > dealer_total
      payout
    elsif dealer_total > total
      collect_losses
    end
  end
  
  def collect_losses
    @bankroll -= @bet
  end

  def payout
    @bankroll += bet
  end
  
  def broke?
    @bankroll <= 0
  end
end