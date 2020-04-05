# frozen_string_literal: true

require 'yaml'
require_relative 'deposit'
require_relative 'depositor'
require_relative 'deposit_list'
require_relative 'depositor_list'
require_relative 'checker'

# read file infromation
module Dao
  def self.read_deposit
    abort('File not found in catalog!') unless File.exist?(File.expand_path('../data/data.yaml', __dir__))
    deposit_list = DepositList.new
    data = Psych.load_file(File.expand_path('../data/data.yaml', __dir__))
    data_deposit = data['deposit']
    data_deposit.each do |line|
      keys = %w[name percent popolnenie]
      values = line.values_at(*keys)
      deposit = Deposit.new(*values)
      deposit_list.add_deposit(deposit) if Checker.check_new_deposit_file(deposit)
    end

    deposit_list
  end

  def self.read_depositor
    abort('File not found in catalog!') unless File.exist?(File.expand_path('../data/data.yaml', __dir__))
    depositor_list = DepositorList.new
    data = Psych.load_file(File.expand_path('../data/data.yaml', __dir__))
    data_depositor = data['depositor']
    data_depositor.each do |line|
      keys = %w[surname name middle_name account_number deposit_type sum opening_date keyword last_date]
      values = line.values_at(*keys)
      depositor = Depositor.new(*values)
      depositor_list.add_depositor(depositor) if Checker.check_new_depositor_file(depositor)
    end
    depositor_list
  end
end
