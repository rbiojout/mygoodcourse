require "rails_helper"

RSpec.describe AttachmentsController, type: :routing do
  describe "routing" do

    it "routes to #download" do
      expect(:get => "/attachments/1/download").to route_to("attachments#download", :id => "1", "path"=>"attachments/1/download")
    end
  end
end
