# Author: Robert Buchberger <robert@buchberger.cc>
#
# This module provides a few helpful classes for generating HTML using simple
# Ruby. Its goal is to be lightweight, and more focused than the general-purpose
# nature of nokogiri.
module ObjectiveElements
  require_relative 'objective_elements/single_tag'
  require_relative 'objective_elements/double_tag'
  require_relative 'objective_elements/html_attributes'
  require_relative 'objective_elements/shelf_tag'
end
