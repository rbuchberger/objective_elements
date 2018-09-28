# Collection of HTML element tags
# Describes a basic, self-closing HTML tag.
class Tag
  attr_reader :attributes
  attr_accessor :newline, :element

  # element is a string, such as 'div' or 'p'.

  # attributes are a hash. The keys are symbols, and the values are arrays. Will
  # render as key="value1 value2 value3"

  # newline determines whether or not to insert a line break after the
  # element.

  def initialize(element, attributes: nil, newline: true)
    @element = element
    reset_attributes(attributes)
    @newline = newline
  end

  # Deletes current attributes, overwrites them with supplied hash.
  def reset_attributes(new = nil)
    @attributes = {}
    add_attributes(new) if new
  end

  # The only way we add new attributes. Flexible about what you give it--
  # accepts both strings and symbols for the keys, and both strings and arrays
  # for the values.
  def add_attributes(new)
    formatted_new = {}
    new.each_pair do |k, v|
      v = v.split ' ' if v.is_a? String
      formatted_new[k.to_sym] = v
    end

    @attributes.merge! formatted_new do |_key, oldval, newval|
      oldval.concat newval
    end
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

  # Renders our HTML.
  def to_s
    output =  '<' + @element
    output << ' ' + render_attributes unless @attributes.empty?
    output << '>'
    output << yield if block_given?
    output << "\n" if newline
  end
end
