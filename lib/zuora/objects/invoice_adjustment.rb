module Zuora::Objects
  class InvoiceAdjustment < Base
    belongs_to :account
    belongs_to :invoice
    has_many :invoice_adjustments

    validates_presence_of :amount, :type

    validates_length_of       :accounting_code, :maximum => 100
    validates_date_of         :adjustment_date, :allow_nil => true
    validates_length_of       :adjustment_number, :maximum => 50
    validates_numericality_of :amount
    validates_length_of       :cancelled_by_id, :maximum => 32
    validates_datetime_of     :cancelled_on, :allow_nil => true
    validates_length_of       :comments, :maximum => 255
    validates_length_of       :created_by_id, :maximum => 32
    validates_datetime_of     :created_date, :allow_nil => true
    validates_length_of       :customer_name, :maximum => 50, :allow_nil => true
    validates_length_of       :customer_number, :maximum => 70, :allow_nil => true
    validates_presence_of     :invoice_id, :if => Proc.new { |ia| ia.invoice_number.nil? }
    validates_presence_of     :invoice_number, :if => Proc.new { |ia| ia.invoice_id.nil? }
    validates_length_of       :reference_id, :maximum => 60, :allow_nil => true
    validates_inclusion_of    :transferred_to_accounting, :in => %w(Processing Yes Error Ignore), :allow_nil => true
    validates_inclusion_of    :type, :in => %w(Credit Charge)
    validates_length_of       :updated_by_id, :maximum => 32, :allow_nil => true
    validates_datetime_of     :updated_date

    define_attributes do
      read_only(
        :cancelled_by_id,
        :canceled_on,
        :created_by_id,
        :created_date,
        :impact_amount,
        :updated_by_id,
        :updated_date,
        :status
      )
      defaults(
        :adjustment_date => Proc.new { Date.today }
      )
    end
  end
end
