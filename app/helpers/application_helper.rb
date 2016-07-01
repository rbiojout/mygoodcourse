module ApplicationHelper



  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "MyGoodCourse"
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

  # helper to format date
  # consider the config locales for the names that appear
  def nice_date(date)
    nice_date = (date||Time.now).strftime("%D")
    how_many_days = (Time.now - date)/1.day
    if (how_many_days < 1)
      nice_date += ' '+ content_tag("span", :new, class: 'badge alert-success')
    elsif (how_many_days < 10)
      nice_date += ' ' + content_tag("span", :recent, class: 'badge alert-info')
    end
    content_tag("span", nice_date.html_safe, class: 'date')
  end

  # helper to have a common way to present price
  def nice_price(price)
    nice_date = number_to_currency(price, precision: 2, unit: "EUR", format: "%n %u")||I18n.translate('dialog.free')
  end


end
