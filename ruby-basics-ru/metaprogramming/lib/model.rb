# frozen_string_literal: true

# BEGIN
# model.rb

module Model
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Хранение информации об атрибутах
    def attribute(name, options = {})
      @attributes ||= {}
      @attributes[name] = options

      # Определение геттера
      define_method(name) do
        if instance_variable_defined?("@#{name}")
          value = instance_variable_get("@#{name}")
        else
          value = options[:default]
        end
        convert_value(value, options[:type])
      end

      # Определение сеттера
      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
      end
    end

    # Метод для получения информации об атрибутах
    def attributes_info
      @attributes || {}
    end
  end

  # Метод initialize
  def initialize(attributes = {})
    attributes.each do |name, value|
      if self.class.attributes_info.key?(name)
        send("#{name}=", value)
      end
    end
  end

  # Метод attributes
  def attributes
    self.class.attributes_info.keys.each_with_object({}) do |name, result|
      value = send(name)
      result[name] = value
    end
  end

  private

  # Метод для преобразования значений в указанный тип
  def convert_value(value, type)
    return value if value.nil? || type.nil?

    begin
      case type
      when :integer
        Integer(value)
      when :string
        value.to_s
      when :boolean
        !!value && value.to_s != 'false'
      when :float
        Float(value)
      when :datetime
        require 'date'
        DateTime.parse(value.to_s)
      else
        value
      end
    rescue ArgumentError, TypeError
      nil
    end
  end
end

# END
 