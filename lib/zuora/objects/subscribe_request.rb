module Zuora::Objects
  # With a SubscribeRequest you can create one or more subscriptions, together
  # with all the needed data: account, contacts, payment methods, etc. See
  # https://knowledgecenter.zuora.com/BC_Developers/SOAP_API/F_SOAP_API_Complex_Types/SubscribeRequest
  #
  # Example:
  #
  #   payment_method = Zuora::Objects::PaymentMethod.find('PAYMENT_METHOD_ID')
  #
  #   account = Zuora::Objects::Account.new(
  #     name: 'Foo',
  #     currency: 'USD',
  #     auto_pay: true,
  #     bill_cycle_day: Time.zone.today.day,
  #   )
  #
  #   bill_to_contact = Zuora::Objects::Contact.new(
  #     first_name: 'John',
  #     last_name: 'Doe',
  #     work_email: 'johndoe@example.test'
  #   )
  #
  #   subscription = Zuora::Objects::Subscription.new(
  #     auto_renew: true,
  #     contract_effective_date: Time.zone.today,
  #     initialTerm: 1,
  #     renewal_term: 1,
  #     termType: 'TERMED'
  #   )
  #
  #   product_rate_plan_charge = Zuora::Objects::ProductRatePlanCharge.find('RATE_PLAN_CHARGE_ID')
  #
  #   rate_plan_charge = Zuora::Objects::RatePlanCharge.new(
  #     product_rate_plan_charge: product_rate_plan_charge,
  #     quantity: 10
  #   )
  #
  #   subscription_request = Zuora::Objects::SubscribeRequest.new(
  #     account: account,
  #     bill_to_contact: bill_to_contact,
  #     subscription: subscription,
  #     rate_plan_charge: rate_plan_charge,
  #     payment_method: payment_method
  #   )
  #
  #   subscription_request.create
  class SubscribeRequest < Base
    attr_accessor :account
    attr_accessor :subscription
    attr_accessor :bill_to_contact
    attr_accessor :payment_method
    attr_accessor :sold_to_contact
    attr_accessor :rate_plan_charges

    store_accessors :subscribe_options
    store_accessors :preview_options

    validate do |request|
      request.must_have_usable(:account)
      request.must_have_usable(:bill_to_contact)
      request.must_have_new(:subscription)
    end

    # used to validate nested objects
    def must_have_new(ref)
      obj = self.send(ref)
      return errors[ref] << "must be provided" if obj.nil?
      return errors[ref] << "must be new" unless obj.new_record?
      must_have_usable(ref)
    end

    # used to validate nested objects
    def must_have_usable(ref)
      obj = self.send(ref)
      return errors[ref] << "must be provided" if obj.blank?
      obj = obj.is_a?(Array) ? obj : [obj]
      obj.each do |object|
        if object.new_record? || object.changed?
          errors[ref] << "is invalid" unless object.valid?
        end
      end
    end

    # Generate a subscription request
    def create
      #return false unless valid?
      result = Zuora::Api.instance.request(:subscribe) do |xml|
        xml.__send__(zns, :subscribes) do |s|
          s.__send__(zns, :Account) do |a|
            generate_object(a, account)
          end

          s.__send__(zns, :PaymentMethod) do |pm|
            generate_object(pm, payment_method)
          end unless payment_method.nil?

          s.__send__(zns, :BillToContact) do |btc|
            generate_object(btc, bill_to_contact)
          end

          s.__send__(zns, :PreviewOptions) do |po|
            generate_preview_options(po)
          end unless preview_options.blank?

          s.__send__(zns, :SoldToContact) do |btc|
            generate_object(btc, sold_to_contact)
          end unless sold_to_contact.nil?

          s.__send__(zns, :SubscribeOptions) do |so|
            generate_subscribe_options(so)
          end unless subscribe_options.blank?

          s.__send__(zns, :SubscriptionData) do |sd|
            sd.__send__(zns, :Subscription) do |sub|
              generate_subscription(sub)
            end

            rate_plan_charges.each do |rate_plan_charge|
              sd.__send__(zns, :RatePlanData) do |rpd|
                rpd.__send__(zns, :RatePlan) do |rp|
                  rp.__send__(ons, :ProductRatePlanId, rate_plan_charge.product_rate_plan_charge.product_rate_plan_id)
                end
                rpd.__send__(zns, :RatePlanChargeData) do |rpcd|
                  rpcd.__send__(zns, :RatePlanCharge) do |rpc|
                    rpc.__send__(ons, :Name, rate_plan_charge.product_rate_plan_charge.name)
                    rpc.__send__(ons, :ProductRatePlanChargeId, rate_plan_charge.product_rate_plan_charge.id)
                    rpc.__send__(ons, :Quantity, rate_plan_charge.quantity)
                  end
                end
              end
            end
          end
        end
      end

      apply_response(result.to_hash, :subscribe_response)
    end

    # method to support backward compatibility of a single
    # rate_plan_charge
    def rate_plan_charge=(rate_plan_charge_object)
      self.rate_plan_charges = [rate_plan_charge_object]
    end

    protected

    def apply_response(response_hash, type)
      result = response_hash[type][:result]
      if result[:success]
        subscription.account_id = result[:account_id]
        subscription.id = result[:subscription_id]
        subscription.clear_changed_attributes!
        @previously_changed = changes
        @changed_attributes.clear
      else
        self.errors.add(:base, result[:errors][:message])
      end
      return result
    end

    def generate_object(builder, object)
      if object.new_record?
        object.to_hash.each do |k,v|
          builder.__send__(ons, k.to_s.zuora_camelize.to_sym, v) unless v.nil?
        end
      else
        builder.__send__(ons, :Id, object.id)
      end
    end

    def generate_subscription(builder)
      subscription.to_hash.each do |k,v|
        builder.__send__(ons, k.to_s.zuora_camelize.to_sym, v) unless v.nil?
      end
    end

    def generate_subscribe_options(builder)
      subscribe_options.each do |k,v|
        builder.__send__(zns, k.to_s.zuora_camelize.to_sym, v)
      end
    end

    def generate_preview_options(builder)
      preview_options.each do |k,v|
        builder.__send__(zns, k.to_s.zuora_camelize.to_sym, v)
      end
    end

    # TODO: Restructute an intermediate class that includes
    # persistence only within ZObject models.
    # These methods are not relevant, but defined in Base
    def find ; end
    def where ; end
    def update ; end
    def destroy ; end
    def save ; end
  end
end

