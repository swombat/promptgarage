require "controllers/api/v1/test"

class Api::V1::InputItemsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @project = create(:project, team: @team)
  @input_item = build(:input_item, project: @project)
  @other_input_items = create_list(:input_item, 3)

  @another_input_item = create(:input_item, project: @project)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @input_item.save
  @another_input_item.save

  @original_hide_things = ENV["HIDE_THINGS"]
  ENV["HIDE_THINGS"] = "false"
  Rails.application.reload_routes!
end

def teardown
  super
  ENV["HIDE_THINGS"] = @original_hide_things
  Rails.application.reload_routes!
end

# This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
# data we were previously providing to users _will_ break the test suite.
def assert_proper_object_serialization(input_item_data)
  # Fetch the input_item in question and prepare to compare it's attributes.
  input_item = InputItem.find(input_item_data["id"])

  assert_equal_or_nil input_item_data['name'], input_item.name
  assert_equal_or_nil input_item_data['type_id'], input_item.type_id
  assert_equal_or_nil input_item_data['contents'], input_item.contents
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal input_item_data["project_id"], input_item.project_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/projects/#{@project.id}/input_items", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  input_item_ids_returned = response.parsed_body.map { |input_item| input_item["id"] }
  assert_includes(input_item_ids_returned, @input_item.id)

  # But not returning other people's resources.
  assert_not_includes(input_item_ids_returned, @other_input_items[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/input_items/#{@input_item.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/input_items/#{@input_item.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  input_item_data = JSON.parse(build(:input_item, project: nil).api_attributes.to_json)
  input_item_data.except!("id", "project_id", "created_at", "updated_at")
  params[:input_item] = input_item_data

  post "/api/v1/projects/#{@project.id}/input_items", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/projects/#{@project.id}/input_items",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/input_items/#{@input_item.id}", params: {
    access_token: access_token,
    input_item: {
      name: 'Alternative String Value',
      contents: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @input_item.reload
  assert_equal @input_item.name, 'Alternative String Value'
  assert_equal @input_item.contents, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/input_items/#{@input_item.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("InputItem.count", -1) do
    delete "/api/v1/input_items/#{@input_item.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/input_items/#{@another_input_item.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
