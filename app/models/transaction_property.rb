class TransactionProperty < ApplicationRecord

  belongs_to :transaction_sale, primary_key: :transaction_id
  belongs_to :transaction_purchase, primary_key: :transaction_id
  belongs_to :property

  has_one :transaction_term, foreign_key: :transaction_property_id, dependent: :destroy
  accepts_nested_attributes_for :transaction_term, :reject_if => :all_blank

  has_many :transaction_property_offers, foreign_key: :transaction_property_id, dependent: :destroy

  delegate :name, to: :property, allow_nil: true

  delegate :closing_date, to: :transaction_term, allow_nil: true
  delegate :first_deposit_date_due, to: :transaction_term, allow_nil: true
  delegate :inspection_period_days, to: :transaction_term, allow_nil: true
  delegate :psa_date, to: :transaction_term, allow_nil: true
  delegate :second_deposit_date_due, to: :transaction_term, allow_nil: true
  delegate :first_deposit_days_after_psa, to: :transaction_term, allow_nil: true
  delegate :second_deposit_days_after_inspection_period, to: :transaction_term, allow_nil: true
  delegate :closing_days_after_inspection_period, to: :transaction_term, allow_nil: true
  
  def closed?
    return !self.closing_date.nil?
  end
end
