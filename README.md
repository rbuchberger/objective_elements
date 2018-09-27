** This library is very much a Work In Progress. It's not actually meant to be used yet.**

# Elements

This is a small library (nano-framework?) that builds nicely formatted HTML using sane, clean, readable Ruby. I use it for writing jekyll plugins, but you can use it anywhere. It's all plain Ruby; it has no dependencies.

Have you ever tried to build HTML with string concatenation and interpolation? At first it seems simple, but once you start adding and removing spaces and newlines for possibly present attributes, children, and closing tags, it turns into an ugly mess. If you have a lot of code which looks like this:
```ruby
picture_tag = "<picture>\n"\
                      "#{source_tags}"\
                      "#{markdown_escape * 4}<img src=\"#{url}#{instance['source_default'][:generated_src]}\" #{html_attr_string}>\n"\
"#{markdown_escape * 2}</picture>\n"
```

or this: 
```ruby
    def build_li(this_item_data, icon_location, label)
      li = "  <li#{@attributes['li']}>"
      if this_item_data && this_item_data['url']
        li << "<a href=\"#{this_item_data['url']}\"#{@attributes['a']}>"
      end
      li << build_image_tag(icon_location)
      li << label
      li << '</a>' if this_item_data['url']
      li << "</li>\n"
    end
```

This library is for you.

Example:

```ruby
p = ParentTag.new 'p'
puts p.to_s
# <p></p>

p.add_attributes {class: 'stumpy mopey grumpy', id: 'the-ugly-one'}
puts p.to_s
# <p class="stumpy mopey grumpy", id="the-ugly-one"></p>

p.add_attributes {class: 'slimy'}
puts p.to_s
# <p class="stumpy mopey grumpy slimy", id="the-ugly-one"></p>

p.add_children 'Bippity Boppity Boo!'
puts p.to_s
# <p class="stumpy mopey grumpy slimy", id="the-ugly-one">Bippity Boppity Boo!</p>

p.add_children ParentTag.new 'a', children: 'Link!', attributes: {href: 'awesome-possum.com'}
puts p.to_s
# <p class="stumpy mopey grumpy slimy", id="the-ugly-one">Bippity Boppity Boo!<a href="awesome-possum.com">Link!</a></p>

div = p.add_parent ParentTag.new 'div'
puts div.to_s
# <div>
#   <p class="stumpy mopey grumpy slimy", id="the-ugly-one">Bippity Boppity Boo!<a href="awesome-possum.com">Link!</a></p>
# </div>

div.add_children Tag.new 'img', attributes: {src: 'happy-puppy.jpg'}
puts div.to_s
# <div>
#   <p class="stumpy mopey grumpy slimy", id="the-ugly-one">Bippity Boppity Boo!<a href="awesome-possum.com">Link!</a></p>
#   <img src="happy-puppy.jpg>
# </div>

```

## Installation

 - coming eventually.
 
## Usage

 There are presets for different tags coming eventually. For now, all I have are 2 classes: `Tag`, and its subclass `ParentTag`. `Tag` is a basic, self-closing tag. It has the following properties:
 - type: mandatory string. What kind of tag it is; such as 'img' or 'hr'
 - attributes: optional hash, keys are symbols and values are arrays of strings. `{class: 'myclass'}`
 - newline: boolean. Whether to include a line break after the element. Defaults to true.

 `ParentTag` Inherits all of `Tag`'s properties and behavior, but adds children and a closing tag. Other possible names were PotentialParentTag, or NonSelfClosingTag. 
 - children: optional array of anything that answers `.to_s`, including other elements. Child elements are not rendered until calling `.to_s` on the parent, meaning you can access and modify them after defining a parent.
 
It tries to be smart about splitting tags across lines and indenting, but there's room for improvement in this logic.

## Contributing
Would really love some help on this one. The basic functionality is there, there are surely loads of bugs, I haven't written any tests and it needs a bunch of presets.

Bug reports and pull requests are welcome: https://github.com/rbuchberger/elements.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
