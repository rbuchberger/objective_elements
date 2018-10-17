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

    self
  end

  # This is the only way we add new attributes. Flexible about what you give
  # it-- accepts both strings and symbols for the keys, and both strings and
  # arrays for the values.

  def add_attributes(new)
    # Don't break everything if this is passed an empty value:
    return self unless new

    if new.is_a? String
      add_string_attributes(new)
    else
      add_hash_attributes(new)
    end

    self
  end
  alias add_attribute add_attributes

  def delete_attributes(keys)
    # accepts an array or a single element
    to_delete = if keys.is_a? Array
                  keys.map(&:to_sym)
                else
                  [keys.to_sym]
                end

    to_delete.each { |k| @attributes.delete k }

    self
  end
  alias delete_attribute delete_attributes

  def rewrite_attribute(new)
    formatted_new = if new.is_a? String
                      hashify_attributes(new)
                    else
                      new.transform_keys(&:to_sym)
                    end

    delete_attributes formatted_new.keys

    add_hash_attributes formatted_new
  end

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

  private

  def add_string_attributes(new_string)
    add_hash_attributes hashify_attributes new_string
  end

  def hashify_attributes(new_string)
    # looking for something like:
    # 'class="something something-else" id="my-id"'
    new_hash = {}
    new_string.scan(/ ?([^="]+)="([^"]+)"/).each do |m|
      # [['class','something something-else'],['id','my-id']]
      new_hash[m.shift] = m.pop
    end
    new_hash
  end

  def add_hash_attributes(new)
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
end
