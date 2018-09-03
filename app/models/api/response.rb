require 'active_model'
module Api
  class Response
    include ActiveModel::Model

    def self.validated_response(hash_response)
      self.new(hash_response || {}).tap(&:validate)
    end

    def validate
      raise ModelError, self.error_messages unless self.valid?
    end

    def error_messages
      self.errors.full_messages.join(', ') if errors.any?
    end

    ModelError = Class.new(StandardError)
  end
end
