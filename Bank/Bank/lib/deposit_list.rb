# frozen_string_literal: true

require_relative 'deposit'

# list classes
class DepositList
  def initialize
    @depositlist = []
  end

  def add_deposit(deposit)
    @depositlist.push(deposit)
  end

  def delete_deposit(name)
    @depositlist.each do |dep|
      @depositlist.delete(dep) if dep.name == name
    end
  end

  def chance_refill(name)
    @depositlist.each do |dep|
      if dep.name == name
        return true if dep.popolnenie
      end
    end
    false
  end

  def get_percent(name)
    @depositlist.each do |dep|
      return dep.percent if dep.name == name
    end
  end

  def each
    @depositlist.each do |dep|
      yield dep
    end
  end
end
