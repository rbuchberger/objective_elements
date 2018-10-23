# Collection of HTML element tags
# Describes a basic, self-closing HTML tag.
class SingleTag
  attr_accessor :element
  attr_reader :attributes

  # element is a string, such as 'div' or 'p'.

  # Attributes are a hash. Keys are symbols, values are arrays. Will render as
  # key="value1 value2 value3"

  def initialize(element, attributes: nil)
    @element = element
    self.attributes = attributes
  end

  def attributes=(new)
    @attributes = HTMLAttributes.new(new)
  end

  # Deletes all current attributes, overwrites them with supplied hash.
  def reset_attributes
    @attributes = HTMLAttributes.new
  end

  # Returns parent, with self added as a child
  def add_parent(parent)
    parent.add_content(self)
  end

  def to_a
    [opening_tag]
  end

  # Renders our HTML.
  def to_s
    opening_tag + "\n"
  end

  # Allows us to work with attributes as methods:
  def method_missing(method, arg = nil)
    if @attributes.respond_to?(method)
      @attributes.send(method, arg)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    @attributes.respond_to?(method) || super
  end

  private

  def opening_tag
    output =  '<' + @element
    output << ' ' + @attributes.to_s unless @attributes.empty?
    output << '>'
  end
end
