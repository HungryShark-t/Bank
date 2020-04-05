# frozen_string_literal: true

require 'date'
require_relative 'helper'

# check information
module Checker
  def self.check_string(str)
    str != '' && str =~ /\p{Alpha}/
  end

  def self.check_number(number)
    number != '' && number =~ /\p{Digit}/ && !number.to_i.negative?
  end

  def self.check_deposit(params)
    errors = []
    errors.push('Неверно введено имя!') unless check_string(params['name'])
    errors.push('Неверно введены проценты!') unless check_number(params['percent'])

    errors
  end

  def self.check_depositer(params, number)
    errors = []
    errors.push('Неверно введена фамилия!') unless check_string(params['surname'])
    errors.push('Неверно введено имя!') unless check_string(params['name'])
    errors.push('Неверно введено отчество!') unless check_string(params['middle_name'])
    errors.push('Неверно введен номер аккаунта!') unless check_number(params['account_number'])
    errors.push('Неверно введена сумма!') unless check_number(params['sum'])
    errors.push('Неверно введено ключевое слово!') unless check_string(params['keyword'])
    errors.push('Ошибка ввода даты!') if !check_data(params['opening_date'], params['last_date'])
    errors.push('Данный номер уже присутствует в базе, введите другой!') if number

    errors
  end

  def self.check_data(str1, str2)
    return false if str1.empty? || str2.empty?

    Help.suit_time(str1, str2)
  end

  def self.check_new_deposit_file(object)
    return false unless Checker.check_string(object.name)
    return false unless Checker.check_number(object.percent.to_s)
    return false unless Checker.check_string(object.popolnenie.to_s)

    true
  end

  def self.check_new_depositor_file(object)
    return false unless Checker.check_string(object.surname)
    return false unless Checker.check_string(object.name)
    return false unless Checker.check_string(object.middle_name)
    return false unless Checker.check_number(object.account_number.to_s)
    return false unless Checker.check_string(object.deposit_type)
    return false unless Checker.check_number(object.sum.to_s)
    return false unless Checker.check_number(object.opening_date)
    return false unless Checker.check_string(object.keyword)
    return false unless Checker.check_number(object.last_date)

    true
  end

  def self.check_delete_deposit_info(name, date)
    errors = []
    errors.append('Отсутсвуют доступные вклады, добавьте кого-нибудь!') if !check_string(name)
    errors.append('Ошибка ввода даты!') if !check_data(Help.time_now, date)
    errors
  end

  def self.check_refill_info(nomer, chance, sum)
    error = []
    error.append('Отсуствует счет!') if !nomer
    error.append('Сумма неверно введена!') if !check_number(sum)
    if nomer
      error.append('Отсутствует возможность пополнения!') if !chance
    end
    error
  end

  def self.check_date_info(date)
    errors = []
    errors.append('Ошибка ввода даты!') if !check_data(Help.time_now, date)

    errors
  end
end
