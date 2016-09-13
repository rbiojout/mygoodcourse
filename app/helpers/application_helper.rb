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
    #css_class = column == sort_column ? "btn btn-primary sorting_#{sort_direction}" : "btn btn-default sorting"
    css_class = column == sort_column ? "sorting_#{sort_direction}" : "sorting"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  # helper to render the order in lists with bootstrap glyph
  def sortable_bootstrap(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    glyphicon = column == sort_column ? ( sort_direction == "asc" ? "-by-attributes" : "-by-attributes-alt" ) :""
    #css_class = column == sort_column ? "btn btn-primary sorting_#{sort_direction}" : "btn btn-default sorting"
    css_class = column == sort_column ? "btn btn-primary sorting_#{sort_direction}" : "btn btn-default sorting"
    css_button = column == sort_column ? 'primary' : 'default'
    #link_to content_tag(:span, '', class: "glyphicon glyphicon-sort#{glyphicon}", 'aria-hidden' => "true" )+ ' '+ title, {:sort => column, :direction => direction}, :class=>"btn btn-#{css_button}", :html_options => {:'aria-label' => "Left Align"}
    link_to content_tag(:span, '', class: "glyphicon glyphicon-sort#{glyphicon}", 'aria-hidden' => "true" )+ ' '+ title, {:sort => column, :direction => direction}, :html_options => {:'aria-label' => "Left Align"}
  end

  # helper to paginate with bootsrap presentation
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
    #nice_date = (date||Time.now).strftime("%D")
    nice_date = I18n.localize( (date||Time.now), :format => :short)
    how_many_days = (Time.now - date)/1.day
    if (how_many_days < 1)
      nice_date += ' '+ content_tag("span", I18n.translate('time.new'), class: 'badge alert-success')
    elsif (how_many_days < 10)
      nice_date += ' ' + content_tag("span", I18n.translate('time.recent'), class: 'badge alert-info')
    end
    content_tag("span", nice_date.html_safe, class: 'date')
  end

  # helper to have a common way to present price withe the right unit
  def nice_price(price)
    nice_date = number_to_currency(price, precision: 2, unit: "€", format: "%n %u")||I18n.translate('dialog.free')
  end

  # helper to have a common way to present status for orders
  # the list of status are in Order.STATUSES
  # STATUSES = %w(created confirming received accepted rejected).freeze
  # we need to have a common way to present without any i18n issue
  def nice_status(status)
    status ||= ''
    css_class = "badge"
    case status
      when "created"
        css_class = "badge badge-warning"
      when "confirming"
        css_class = "badge badge-warning"
      when "received"
        css_class = "badge badge-primary"
      when "accepted"
        css_class = "badge badge-success"
      when "rejected"
        css_class = "badge danger-danger"
    end
    content_tag("span", status.to_s.capitalize, class: "#{css_class}")
  end


end
