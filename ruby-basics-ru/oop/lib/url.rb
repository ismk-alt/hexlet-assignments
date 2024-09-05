# frozen_string_literal: true

# frozen_string_literal: true

require 'uri'
require 'forwardable'

class Url
  extend Forwardable
  include Comparable

  def initialize(url)
    @url = URI.parse(url)
  end

  def_delegators :@url, :scheme, :host, :port, :path

  # Возвращает параметры запроса в виде хеша ключ-значение, где ключи преобразованы в символы
  def query_params
    URI.decode_www_form(@url.query || '').to_h.transform_keys(&:to_sym)
  end

  # Возвращает значение параметра по ключу, если ключ не найден - возвращает default
  def query_param(key, default = nil)
    query_params.fetch(key.to_sym, default)
  end

  def sorted_query_params
    query_params.sort.to_h
  end

  def <=>(other)
    return nil unless other.is_a?(Url)
    [scheme, host, port, path, sorted_query_params] <=> [other.scheme, other.host, other.port, other.path, other.sorted_query_params]
  end
end


# END


