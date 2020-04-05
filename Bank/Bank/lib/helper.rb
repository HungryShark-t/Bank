require 'date'

# frozen_string_literal: true
# help
module Help
  def self.profit(old, novay, sum, percent)
    od = Date.parse(old)
    novay = Date.parse(novay)
    (sum + (sum * (percent / 100) * ((novay - od).to_f / 365))).round(2)
  end

  def self.change(generic, added)
    generic + added
  end

  def self.popolnenie(inf)
    return true if inf == 'Да'

    false
  end

  def self.time_now
    current_time = DateTime.now
    current_time.strftime '%Y-%m-%d'
  end

  def self.suit_time(str1, str2)
    old = Date.parse(str1)
    now = Date.parse(str2)
    return false if old > now

    true
  end
end
