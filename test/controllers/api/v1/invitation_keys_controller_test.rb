require "controllers/api/v1/test"

class Api::V1::InvitationKeysControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @invitation_key = build(:invitation_key, team: @team)
  @other_invitation_keys = create_list(:invitation_key, 3)

  @another_invitation_key = create(:invitation_key, team: @team)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @invitation_key.save
  @another_invitation_key.save

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
def assert_proper_object_serialization(invitation_key_data)
  # Fetch the invitation_key in question and prepare to compare it's attributes.
  invitation_key = InvitationKey.find(invitation_key_data["id"])

  assert_equal_or_nil invitation_key_data['key'], invitation_key.key
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal invitation_key_data["team_id"], invitation_key.team_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/teams/#{@team.id}/invitation_keys", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  invitation_key_ids_returned = response.parsed_body.map { |invitation_key| invitation_key["id"] }
  assert_includes(invitation_key_ids_returned, @invitation_key.id)

  # But not returning other people's resources.
  assert_not_includes(invitation_key_ids_returned, @other_invitation_keys[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/invitation_keys/#{@invitation_key.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/invitation_keys/#{@invitation_key.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  invitation_key_data = JSON.parse(build(:invitation_key, team: nil).api_attributes.to_json)
  invitation_key_data.except!("id", "team_id", "created_at", "updated_at")
  params[:invitation_key] = invitation_key_data

  post "/api/v1/teams/#{@team.id}/invitation_keys", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/teams/#{@team.id}/invitation_keys",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/invitation_keys/#{@invitation_key.id}", params: {
    access_token: access_token,
    invitation_key: {
      key: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @invitation_key.reload
  assert_equal @invitation_key.key, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/invitation_keys/#{@invitation_key.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("InvitationKey.count", -1) do
    delete "/api/v1/invitation_keys/#{@invitation_key.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/invitation_keys/#{@another_invitation_key.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
