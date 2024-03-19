class Account < ApplicationRecord
  include Syncable
  include Monetizable

  validates :family, presence: true

  broadcasts_refreshes
  belongs_to :family
  has_many :balances
  has_many :valuations
  has_many :transactions

  monetize :balance

  enum :status, { ok: "ok", syncing: "syncing", error: "error" }, validate: true

  scope :active, -> { where(is_active: true) }
  scope :assets, -> { where(classification: "asset") }
  scope :liabilities, -> { where(classification: "liability") }

  delegated_type :accountable, types: Accountable::TYPES, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def balance_on(date)
    balances.where("date <= ?", date).order(date: :desc).first&.balance
  end

  # e.g. Wise, Revolut accounts that have transactions in multiple currencies
  def multi_currency?
    currencies = [ valuations.pluck(:currency), transactions.pluck(:currency) ].flatten.uniq
    currencies.count > 1
  end

  # e.g. Accounts denominated in currency other than family currency
  def foreign_currency?
    currency != family.currency
  end

  def self.by_provider
    # TODO: When 3rd party providers are supported, dynamically load all providers and their accounts
    [ { name: "Manual accounts", accounts: all.order(balance: :desc).group_by(&:accountable_type) } ]
  end

  def self.some_syncing?
    exists?(status: "syncing")
  end

  def series(period = Period.all)
    TimeSeries.from_collection(balances.in_period(period), :balance_money)
  end

  def self.by_group(period = Period.all)
    grouped_accounts = { assets: ValueGroup.new("Assets"), liabilities: ValueGroup.new("Liabilities") }

    Accountable.by_classification.each do |classification, types|
      types.each do |type|
        group = grouped_accounts[classification.to_sym].add_child_node(type)
        Accountable.from_type(type).includes(:account).each do |accountable|
          account = accountable.account
          value_node = group.add_value_node(account)
          value_node.attach_series(account.series(period))
        end
      end
    end

    grouped_accounts
  end
end
