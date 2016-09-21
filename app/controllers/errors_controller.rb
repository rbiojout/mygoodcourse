# app/controllers/errors_controller.rb
class ErrorsController
  def not_found
    raise ActiveRecord::RecordNotFound
  end
end