# frozen_string_literal: true

require 'date'
require_relative 'depositor'
require_relative 'deposit'

# list classes
class DepositorList
  attr_reader :depositorlist
  def initialize
    @depositorlist = []
  end

  def add_depositor(depositor)
    @depositorlist.push(depositor)
  end

  def delete_depositor(obj)
    @depositorlist.delete(obj)
  end

  def check_number(nomer)
    @depositorlist.each do |dp|
      return true if dp.account_number == nomer
    end
    false
  end

  def name_number(number)
    @depositorlist.each do |dp|
      return dp.deposit_type if dp.account_number == number
    end
  end

  def top_deposit
    arr = []
    @depositorlist.each do |dp|
      arr.push(dp.deposit_type)
    end

    res = Hash[arr.group_by { |x| x }.map { |k, v| [k, v.count] }]
    a = res.sort_by { |_index, type| type }
    temp = a[a.size - 1]
    [temp[0], sr_sum(temp), last_date_deposit(temp[0])]
  end

  def last_date_deposit(temp)
    arr = []
    @depositorlist.each do |dp|
      arr.push(Date.parse(dp.opening_date)) if dp.deposit_type == temp
    end
    arr = arr.sort.reverse
    arr[0]
  end

  def sr_sum(temp)
    sum = 0
    @depositorlist.each do |dp|
      sum += dp.sum if dp.deposit_type == temp[0]
    end
    (sum / temp[1].to_f).round(2)
  end

  def uniq_depositor
    a = @depositorlist.uniq(&:account_number)
    a.sort_by { |k| k.surname.downcase }
  end

  def each
    @depositorlist.each do |dep|
      yield dep
    end
  end

  def check_surname_and_keyword(surname, keyword, number)
    @depositorlist.each do |dp|
      if dp.account_number == number
        return true if dp.surname == surname && dp.keyword == keyword
      end
    end
    false
  end

  def refill(sum, number)
    @depositorlist.each do |dp|
      dp.change_sum(sum) if dp.account_number == number
    end
  end

  def accrual(closed_date)
    arr = []
    closed_date = Date.parse(closed_date)
    @depositorlist.each do |dp|
      temp = Date.parse(dp.last_date)
      arr.push(dp.account_number) if (closed_date - temp) > 1
    end
    arr
  end
end
