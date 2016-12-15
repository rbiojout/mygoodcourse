module AbusesHelper
  def abusable_name(abuse)
    name = ''
    begin
      name = abuse.abusable.model_name.human
      name += (': ' + abuse.abusable.name) if abuse.abusable.class.column_names.include? 'name'
      name += (': ' + abuse.abusable.title) if abuse.abusable.class.column_names.include? 'title'
    rescue
      name = ''
    end
    name
  end
end
