# Collection of HTML element tags
# Describes a basic, self-closing HTML tag.
class Tag
  attr_reader :type, :attributes
  attr_accessor :newline

  # type is a string, such as 'div' or 'p'.

  # attributes are a hash, with symobls as keys and an array of values. Will
  # render out to key="value1 value2 value3"

  # newline determines whether or not to insert a line break after the
  # element.

  def initialize(type, attributes: {}, newline: true)
    @type = type
    reset_attributes
    add_attributes attributes
    @newline = newline
  end

  def reset_attributes
    @attributes = {}
    @attributes.default = []
  end

  def render_attributes
    # Turns attributes into a string we can inject
    attribute_string = ''
    @attributes.each_pair do |k, v|
      attribute_string << "#{k}=\"#{v.join ' '}\" "
    end
  end

  def to_s
    # Renders our HTML.
    output =  '<' + @type
    output << ' ' + render_attributes unless @attributes.empty?
    output << '>'
    output << yield if block_given?
    output << "\n" if newline
  end

  def write_attributes(new)
    # Accepts a hash, overwrites existing attribues.
    reset_attributes
    add_attributes(new)
  end

  def add_attributes(new)
    # Appends values to existing attributes
    new.each_pair do |k, v|
      @attributes[k.to_sym].concat v.split ' '
    end
    self
  end

  def add_parent(parent)
    parent.add_child(self)
  end
end

