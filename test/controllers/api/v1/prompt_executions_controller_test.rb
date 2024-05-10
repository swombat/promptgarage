require "controllers/api/v1/test"

class Api::V1::PromptExecutionsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @project = create(:project, team: @team)
  @prompt = create(:prompt, project: @project)
  @prompt_execution = build(:prompt_execution, prompt: @prompt)
  @other_prompt_executions = create_list(:prompt_execution, 3)

  @another_prompt_execution = create(:prompt_execution, prompt: @prompt)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @prompt_execution.save
  @another_prompt_execution.save

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
def assert_proper_object_serialization(prompt_execution_data)
  # Fetch the prompt_execution in question and prepare to compare it's attributes.
  prompt_execution = PromptExecution.find(prompt_execution_data["id"])

  assert_equal_or_nil prompt_execution_data['label'], prompt_execution.label
  assert_equal_or_nil prompt_execution_data['compiled_parameters'], prompt_execution.compiled_parameters
  assert_equal_or_nil prompt_execution_data['parameters_summary'], prompt_execution.parameters_summary
  assert_equal_or_nil prompt_execution_data['model'], prompt_execution.model
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal prompt_execution_data["prompt_id"], prompt_execution.prompt_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/prompts/#{@prompt.id}/prompt_executions", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  prompt_execution_ids_returned = response.parsed_body.map { |prompt_execution| prompt_execution["id"] }
  assert_includes(prompt_execution_ids_returned, @prompt_execution.id)

  # But not returning other people's resources.
  assert_not_includes(prompt_execution_ids_returned, @other_prompt_executions[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/prompt_executions/#{@prompt_execution.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/prompt_executions/#{@prompt_execution.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  prompt_execution_data = JSON.parse(build(:prompt_execution, prompt: nil).api_attributes.to_json)
  prompt_execution_data.except!("id", "prompt_id", "created_at", "updated_at")
  params[:prompt_execution] = prompt_execution_data

  post "/api/v1/prompts/#{@prompt.id}/prompt_executions", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/prompts/#{@prompt.id}/prompt_executions",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/prompt_executions/#{@prompt_execution.id}", params: {
    access_token: access_token,
    prompt_execution: {
      label: 'Alternative String Value',
      compiled_parameters: 'Alternative String Value',
      parameters_summary: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @prompt_execution.reload
  assert_equal @prompt_execution.label, 'Alternative String Value'
  assert_equal @prompt_execution.compiled_parameters, 'Alternative String Value'
  assert_equal @prompt_execution.parameters_summary, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/prompt_executions/#{@prompt_execution.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("PromptExecution.count", -1) do
    delete "/api/v1/prompt_executions/#{@prompt_execution.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/prompt_executions/#{@another_prompt_execution.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
