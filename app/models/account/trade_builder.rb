class Account::TradeBuilder
  TYPES = %w[ buy sell ].freeze

  include ActiveModel::Model

  attr_accessor :type, :qty, :price, :ticker, :date, :account

  validates :type, :qty, :price, :ticker, :date, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :type, inclusion: { in: TYPES }

  def save
    if valid?
      create_entry
    end
  end

  private

    def create_entry
      account.entries.account_trades.create! \
        date: date,
        amount: amount,
        currency: account.currency,
        entryable: Account::Trade.new(
          security: security,
          qty: signed_qty,
          price: price.to_d,
          currency: account.currency
        )
    end

    def security
      Security.find_or_create_by(ticker: ticker)
    end

    def amount
      price.to_d * signed_qty
    end

    def signed_qty
      _qty = qty.to_d
      _qty = _qty * -1 if type == "sell"
      _qty
    end
end
