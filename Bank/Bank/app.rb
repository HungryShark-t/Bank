# frozen_string_literal: true

require 'sinatra'
require_relative 'lib/deposit_list'
require_relative 'lib/depositor_list'
require_relative 'lib/deposit'
require_relative 'lib/depositor'
require_relative 'lib/checker'
require_relative 'lib/dao'

configure do
  set :deposit_list, Dao.read_deposit
  set :depositor_list, Dao.read_depositor
end

get '/' do
  erb :main
end

get '/deposit/new' do
  @deposit = Deposit.new('', '', '')
  erb :new_deposit
end

post '/deposit/new' do
  @errors = Checker.check_deposit(params)
  @deposit = Deposit.new(params['name'], params['percent'].to_i, Help.popolnenie(params['popolnenie']))
  if @errors.empty?
    settings.deposit_list.add_deposit(@deposit)
    redirect to('/')
  else
    erb :new_deposit
  end
end

get '/depositor/new' do
  @depositor = Depositor.new('', '', '', '', '', '', '', '', '')
  @deposit_list = settings.deposit_list
  erb :new_depositor
end

post '/depositor/new' do
  @errors = Checker.check_depositer(params, settings.depositor_list.check_number(params['account_number'].to_i))
  @depositor = Depositor.new(params['surname'], params['name'], params['middle_name'], params['account_number'].to_i,
                             params['deposit_type'], params['sum'].to_i, params['opening_date'],
                             params['keyword'], params['last_date'])
  if @errors.empty?
    settings.depositor_list.add_depositor(@depositor)
    redirect to('/')
  else
    @deposit_list = settings.deposit_list
    erb :new_depositor
  end
end

get '/deposit/delete' do
  @deposit_list = settings.deposit_list
  erb :delete_deposit
end

post '/deposit/delete' do
  @suitable_list = []
  @name = params['deposit_type']
  @data = params['closed_date']

  @alert = Checker.check_delete_deposit_info(@name, @data)
  if @alert.empty?
    settings.depositor_list.each do |dp|
      next unless dp.deposit_type == @name

      dp.nachislenie(settings.deposit_list.get_percent(@name), @data)
      settings.depositor_list.delete_depositor(dp)
      @suitable_list.append(dp)
    end
    settings.deposit_list.delete_deposit(@name)

    if @suitable_list.empty?
      redirect to('/')
    else
      erb :suitable_depositor
    end

  else
    @deposit_list = settings.deposit_list
    erb :delete_deposit
  end
end

get '/depositor/delete' do
  @depositor_list = settings.depositor_list
  erb :delete_depositor
end

get '/depositor/delete/:number' do |_number|
  erb :extra_delete_depositor
end

post '/depositor/delete/:number' do |number|
  @suitable_list = []
  @errors = Checker.check_date_info(params['closed_date'])
  if @errors.empty?
    settings.depositor_list.each do |dp|
      next unless dp.account_number == number.to_i

      dp.nachislenie(settings.deposit_list.get_percent(settings.depositor_list.name_number(number.to_i)),
                     params['closed_date'])
      @suitable_list.append(dp)
      settings.depositor_list.delete_depositor(dp)
    end
    erb :suitable_depositor
  else
    erb :extra_delete_depositor
  end
end

get '/deposit/all' do
  @deposit_list = settings.deposit_list
  erb :list_deposit
end

get '/depositor/all' do
  @depositor_list = settings.depositor_list
  erb :list_depositor
end

get '/deposit/refill' do
  erb :refill
end

post '/deposit/refill' do
  @a = params['account_number'].to_i
  @b = params['sum']
  @errors = Checker.check_refill_info(settings.depositor_list.check_number(@a),
                                      settings.deposit_list.chance_refill(settings.depositor_list.name_number(@a)), @b)
  if @errors.empty?
    redirect to("/deposit/refill/#{@a}/#{@b}")
  else
    erb :refill
  end
end

get '/deposit/refill/:account_number/:sum' do |_account_number, _sum|
  erb :refill_extra
end

post '/deposit/refill/:account_number/:sum' do |account_number, sum|
  if settings.depositor_list.check_surname_and_keyword(params['surname'], params['keyword'], account_number.to_i)
    settings.depositor_list.refill(sum.to_i, account_number.to_i)
    redirect to('/depositor/uniq')
  else
    @errors = [1]
    erb :refill_extra
  end
end

get '/deposit/top' do
  @suitable = settings.depositor_list.top_deposit
  erb :top_deposit
end

get '/depositor/uniq' do
  @uniq_depositor = settings.depositor_list.uniq_depositor
  erb :uniq_depositor
end

get '/deposit/accrual' do
  erb :accrual
end

post '/deposit/accrual' do
  a = params['accrual_date']
  @errors = Checker.check_date_info(a)
  if @errors.empty?
    arr = settings.depositor_list.accrual(a)
    arr.each do |ar|
      settings.depositor_list.each do |dep|
        if ar.to_i == dep.account_number
          dep.nachislenie(settings.deposit_list.get_percent(settings.depositor_list.name_number(ar.to_i)), a)
          dep.change_last_date(a)
        end
      end
    end
    redirect to('/depositor/uniq')
  else
    erb :accrual
  end
end
