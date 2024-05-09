require "controllers/api/v1/test"

class Api::V1::IntelligenceCredentialsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @intelligence_credential = build(:intelligence_credential, team: @team)
  @other_intelligence_credentials = create_list(:intelligence_credential, 3)

  @another_intelligence_credential = create(:intelligence_credential, team: @team)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @intelligence_credential.save
  @another_intelligence_credential.save

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
def assert_proper_object_serialization(intelligence_credential_data)
  # Fetch the intelligence_credential in question and prepare to compare it's attributes.
  intelligence_credential = IntelligenceCredential.find(intelligence_credential_data["id"])

  assert_equal_or_nil intelligence_credential_data['api_key'], intelligence_credential.api_key
  assert_equal_or_nil intelligence_credential_data['class_name'], intelligence_credential.class_name
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal intelligence_credential_data["team_id"], intelligence_credential.team_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/teams/#{@team.id}/intelligence_credentials", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  intelligence_credential_ids_returned = response.parsed_body.map { |intelligence_credential| intelligence_credential["id"] }
  assert_includes(intelligence_credential_ids_returned, @intelligence_credential.id)

  # But not returning other people's resources.
  assert_not_includes(intelligence_credential_ids_returned, @other_intelligence_credentials[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/intelligence_credentials/#{@intelligence_credential.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/intelligence_credentials/#{@intelligence_credential.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  intelligence_credential_data = JSON.parse(build(:intelligence_credential, team: nil).api_attributes.to_json)
  intelligence_credential_data.except!("id", "team_id", "created_at", "updated_at")
  params[:intelligence_credential] = intelligence_credential_data

  post "/api/v1/teams/#{@team.id}/intelligence_credentials", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/teams/#{@team.id}/intelligence_credentials",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/intelligence_credentials/#{@intelligence_credential.id}", params: {
    access_token: access_token,
    intelligence_credential: {
      api_key: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @intelligence_credential.reload
  assert_equal @intelligence_credential.api_key, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/intelligence_credentials/#{@intelligence_credential.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("IntelligenceCredential.count", -1) do
    delete "/api/v1/intelligence_credentials/#{@intelligence_credential.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/intelligence_credentials/#{@another_intelligence_credential.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
