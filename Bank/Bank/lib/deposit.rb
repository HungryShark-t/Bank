# frozen_string_literal: true

# class
class Deposit
  attr_reader :name, :percent, :popolnenie
  def initialize(name, percent, popolnenie)
    @name = name
    @percent = percent
    @popolnenie = popolnenie
  end

  def to_s
    "Вклад #{@name} c годовым процентом #{@percent} %. Возможность пополнения: #{@popolnenie}."
  end
end
