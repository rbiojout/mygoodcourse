# app/services/cloudfront_constraint.rb
# deny anything but /assets
# cf http://ricostacruz.com/til/rails-and-cloudfront
class CloudfrontConstraint
  def matches?(request)
    request.env['HTTP_USER_AGENT'] == 'Amazon CloudFront'
  end
end
