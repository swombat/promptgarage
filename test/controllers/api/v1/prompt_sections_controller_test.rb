require "controllers/api/v1/test"

class Api::V1::PromptSectionsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @project = create(:project, team: @team)
  @prompt = create(:prompt, project: @project)
  @prompt_section = build(:prompt_section, prompt: @prompt)
  @other_prompt_sections = create_list(:prompt_section, 3)

  @another_prompt_section = create(:prompt_section, prompt: @prompt)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @prompt_section.save
  @another_prompt_section.save

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
def assert_proper_object_serialization(prompt_section_data)
  # Fetch the prompt_section in question and prepare to compare it's attributes.
  prompt_section = PromptSection.find(prompt_section_data["id"])

  assert_equal_or_nil prompt_section_data['name'], prompt_section.name
  assert_equal_or_nil prompt_section_data['contents'], prompt_section.contents
  assert_equal_or_nil prompt_section_data['system_prompt'], prompt_section.system_prompt
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal prompt_section_data["prompt_id"], prompt_section.prompt_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/prompts/#{@prompt.id}/prompt_sections", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  prompt_section_ids_returned = response.parsed_body.map { |prompt_section| prompt_section["id"] }
  assert_includes(prompt_section_ids_returned, @prompt_section.id)

  # But not returning other people's resources.
  assert_not_includes(prompt_section_ids_returned, @other_prompt_sections[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/prompt_sections/#{@prompt_section.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/prompt_sections/#{@prompt_section.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  prompt_section_data = JSON.parse(build(:prompt_section, prompt: nil).api_attributes.to_json)
  prompt_section_data.except!("id", "prompt_id", "created_at", "updated_at")
  params[:prompt_section] = prompt_section_data

  post "/api/v1/prompts/#{@prompt.id}/prompt_sections", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/prompts/#{@prompt.id}/prompt_sections",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/prompt_sections/#{@prompt_section.id}", params: {
    access_token: access_token,
    prompt_section: {
      name: 'Alternative String Value',
      contents: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @prompt_section.reload
  assert_equal @prompt_section.name, 'Alternative String Value'
  assert_equal @prompt_section.contents, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/prompt_sections/#{@prompt_section.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("PromptSection.count", -1) do
    delete "/api/v1/prompt_sections/#{@prompt_section.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/prompt_sections/#{@another_prompt_section.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
