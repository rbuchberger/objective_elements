# Collection of HTML element tags
# Describes a basic, self-closing HTML tag.
class SingleTag
  attr_reader :attributes
  attr_accessor :element

  # element is a string, such as 'div' or 'p'.

  # Attributes are a hash. Keys are symbols, values are arrays. Will render as
  # key="value1 value2 value3"

  def initialize(element, attributes: nil)
    @element = element
    reset_attributes(attributes)
  end

  # Deletes all current attributes, overwrites them with supplied hash.
  def reset_attributes(new = nil)
    @attributes = {}
    add_attributes(new) if new
  end

  # This is the only way we add new attributes. Flexible about what you give
  # it-- accepts both strings and symbols for the keys, and both strings and
  # arrays for the values.
  def add_attributes(new)
    formatted_new = {}
    new.each_pair do |k, v|
      v = v.split ' ' if v.is_a? String
      formatted_new[k.to_sym] = v
    end

    @attributes.merge! formatted_new do |_key, oldval, newval|
      oldval.concat newval
    end
    self
  end
  alias_method :add_attribute, :add_attributes

  # Turns attributes into a string we can insert.
  def render_attributes
    attribute_string = ''
    @attributes.each_pair do |k, v|
      attribute_string << "#{k}=\"#{v.join ' '}\" "
    end
    attribute_string.strip
  end

  # Returns parent, with self added as a child
  def add_parent(parent)
    parent.add_content(self)
  end

  def opening_tag
    output =  '<' + @element
    output << ' ' + render_attributes unless @attributes.empty?
    output << '>'
  end

  def to_a
    [opening_tag]
  end

  # Renders our HTML.
  def to_s
    opening_tag + "\n"
  end
end
