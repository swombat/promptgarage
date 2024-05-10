require "controllers/api/v1/test"

class Api::V1::InputTypesControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @project = create(:project, team: @team)
  @input_type = build(:input_type, project: @project)
  @other_input_types = create_list(:input_type, 3)

  @another_input_type = create(:input_type, project: @project)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @input_type.save
  @another_input_type.save

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
def assert_proper_object_serialization(input_type_data)
  # Fetch the input_type in question and prepare to compare it's attributes.
  input_type = InputType.find(input_type_data["id"])

  assert_equal_or_nil input_type_data['name'], input_type.name
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal input_type_data["project_id"], input_type.project_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/projects/#{@project.id}/input_types", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  input_type_ids_returned = response.parsed_body.map { |input_type| input_type["id"] }
  assert_includes(input_type_ids_returned, @input_type.id)

  # But not returning other people's resources.
  assert_not_includes(input_type_ids_returned, @other_input_types[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/input_types/#{@input_type.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/input_types/#{@input_type.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  input_type_data = JSON.parse(build(:input_type, project: nil).api_attributes.to_json)
  input_type_data.except!("id", "project_id", "created_at", "updated_at")
  params[:input_type] = input_type_data

  post "/api/v1/projects/#{@project.id}/input_types", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/projects/#{@project.id}/input_types",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/input_types/#{@input_type.id}", params: {
    access_token: access_token,
    input_type: {
      name: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @input_type.reload
  assert_equal @input_type.name, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/input_types/#{@input_type.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("InputType.count", -1) do
    delete "/api/v1/input_types/#{@input_type.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/input_types/#{@another_input_type.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
