module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "ForMyCourse"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # helper to render the order in lists
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "btn btn-primary sorting_#{sort_direction}" : "btn btn-default sorting"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  # helper to render the order in lists with bootstrap glyph
  def sortable_bootstrap(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    glyphicon = column == sort_column ? ( sort_direction == "asc" ? "-by-attributes" : "-by-attributes-alt" ) :""
    css_class = column == sort_column ? "btn btn-primary sorting_#{sort_direction}" : "btn btn-default sorting"
    css_button = column == sort_column ? 'primary' : 'default'
    link_to content_tag(:span, '', class: "glyphicon glyphicon-sort#{glyphicon}", 'aria-hidden' => "true" )+ ' '+ title, {:sort => column, :direction => direction}, :class=>"btn btn-#{css_button}", :html_options => {:'aria-label' => "Left Align"}
  end

  # helper to paginate
  def pagination_links(collection, options = {})
    options[:renderer] ||= BootstrapPaginationHelper::LinkRenderer
    options[:class] ||= 'pagination pagination-centered'
    options[:inner_window] ||= 2
    options[:outer_window] ||= 1
    will_paginate(collection, options)
  end

end
