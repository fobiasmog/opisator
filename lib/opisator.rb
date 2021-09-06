require "opisator/defaults"
require "active_support/concern"

module Opisator
  extend ActiveSupport::Concern

  attr_accessor :contract

  included do
    before_action :call
  end

  class_methods do
    def opisator_for(*actions)
      actions.each { |action| define_method_for action }
    end

    private def method_by(action)
      "call_#{action}"
    end

    private def define_method_for(action)
      define_method method_by(action) do

        @contract = Opisator::Defaults::Contract
        @interactor = Opisator::Defaults::Interactor
        @presenter = Opisator::Defaults::Presenter

        self.send(action)

        contract_params = @contract.new.call(params)

        result = @interactor.new.call(contract_params)

        render @presenter.new.call(result)
      end
    end
  end

  def call
    return self.send(action_name) unless has_call_method?

    self.send(call_method)
  end

  private

  def call_method
    instance_method_by(action_name)
  end

  def has_call_method?
    self.class.method_defined? call_method
  end

  def instance_method_by(action)
    self.class.send(:method_by, action)
  end
end
