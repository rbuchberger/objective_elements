# Represents standard HTML attributes, such as class="myclass"
class HTMLAttributes
  attr_reader :content
  def initialize(new = nil)
    @content = {}
    self << new
  end

  def [](key)
    @content[key.to_sym]
  end

  def to_s
    return_string = ''
    @content.each_pair do |k, v|
      # If an attribute has no values, we need to introduce an empty string to
      # the array in order to get the correct format (alt="", for example):
      v << '' if v.empty?

      return_string << "#{k}=\"#{v.join ' '}\" "
    end

    return_string.strip
  end

  # This is the only way we add new attributes. Flexible about what you give
  # it-- accepts both strings and symbols for the keys, and both strings and
  # arrays for the values.
  def <<(new)
    # Don't break everything if this is passed an empty value:
    return self unless new

    if new.is_a? Hash
      add_hash(new)
    else
      add_string(new)
    end

    self
  end

  def delete(trash)
    # accepts an array or a single element
    [trash].flatten
           .map(&:to_sym)
           .each { |k| @content.delete k }

    self
  end

  def replace(new)
    formatted_new = if new.is_a? String
                      hashify_input(new)
                    else
                      new.transform_keys(&:to_sym)
                    end

    delete formatted_new.keys

    add_hash formatted_new

    self
  end

  def empty?
    @content.empty?
  end

  def method_missing(method, arg = nil)
    if method[-1] == '='
      raise 'must supply new value' unless arg

      replace(method[0..-2] => arg)
    elsif @content.key? method
      @content[method].join(' ')
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    (method[-1] == '=') ||
      (@content.key? method) ||
      super
  end

  private

  def add_string(new_string)
    add_hash hashify_input new_string
  end

  # Input: Keys are attribute names (either strings or symbols), values are
  # attribute values (either a string or an array of strings)
  def add_hash(new_hash)
    formatted_new = {}

    new_hash.each_pair do |k, v|
      v = v.split(' ') if v.is_a? String

      formatted_new[k.to_sym] = v
    end

    @content.merge!(formatted_new) do |_key, oldval, newval|
      oldval.concat(newval)
    end

    self
  end

  def hashify_input(new_string)
    # looking for something like:
    # 'class="something something-else" id="my-id" alt=""'
    new_hash = {}
    new_string.scan(/ ?([^="]+)="([^"]*)"/).each do |match|
      # Returns something like:
      # [['class','something something-else'],['id','my-id'],['alt', '']]

      key, val = *match

      if new_hash[key]
        new_hash[key] << ' ' + val
      else
        new_hash[key] = val
      end
    end
    new_hash
  end
end
