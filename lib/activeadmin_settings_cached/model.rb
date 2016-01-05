module ActiveadminSettingsCached
  class Model
    include ActiveModel::Model

    attr_reader :attributes

    def initialize(args = {})
      @attributes = {}
      args[:model_name] = args[:model_name].constantize if args[:model_name].is_a? String
      args[:display] = default_attributes[:display].merge!(args[:display]) if args[:display]
      assign_attributes(merge_attributes(args))
    end

    def settings
      settings_model.public_send(meth, attributes[:scope])
    end

    def defaults
      settings_model.defaults
    end

    def display
      attributes[:display]
    end

    def [](param)
      settings_model[param]
    end

    def []=(param, value)
      settings_model[param] = value
    end

    def persisted?
      false
    end

    alias_method :to_hash, :attributes

    protected

    def assign_attributes(args = {})
      @attributes.merge!(args)
    end

    def default_attributes
      {
        scope: nil,
        model_name: ActiveadminSettingsCached.config.model_name,
        display: ActiveadminSettingsCached.config.display
      }
    end

    def merge_attributes(args)
      default_attributes.each_with_object({}) do |(k, v), h|
        h[k] = args[k] || v
      end
    end

    def settings_model
      attributes[:model_name]
    end

    def meth
      if Rails.version >= '4.1.0'
        :get_all
      else
        :all
      end
    end
  end
end
