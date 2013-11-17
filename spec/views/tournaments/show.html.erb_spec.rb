require 'spec_helper'

describe "tournaments/show" do
  before(:each) do
    @tournament = assign(:tournament, stub_model(Tournament,
      :name => "Name",
      :matches => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
  end
end
