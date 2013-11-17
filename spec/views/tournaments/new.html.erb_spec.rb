require 'spec_helper'

describe "tournaments/new" do
  before(:each) do
    assign(:tournament, stub_model(Tournament,
      :name => "MyString",
      :matches => nil
    ).as_new_record)
  end

  it "renders new tournament form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tournaments_path, "post" do
      assert_select "input#tournament_name[name=?]", "tournament[name]"
      assert_select "input#tournament_matches[name=?]", "tournament[matches]"
    end
  end
end
