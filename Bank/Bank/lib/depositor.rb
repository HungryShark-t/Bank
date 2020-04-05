# frozen_string_literal: true

require_relative 'helper'

# class
class Depositor
  attr_reader :surname, :name, :middle_name, :account_number, :deposit_type, :sum, :opening_date, :keyword, :last_date
  def initialize(surname, name, middle_name, account_number, deposit_type, sum, opening_date, keyword, last_date)
    @surname = surname
    @name = name
    @middle_name = middle_name
    @account_number = account_number
    @deposit_type = deposit_type
    @sum = sum
    @opening_date = opening_date
    @keyword = keyword
    @last_date = last_date
  end

  def nachislenie(percent, date)
    @sum = Help.profit(@last_date, date, sum, percent)
  end

  def change_sum(sum)
    @sum = Help.change(@sum, sum)
  end

  def change_last_date(new_date)
    @last_date = new_date
  end
end
