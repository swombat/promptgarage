require "controllers/api/v1/test"

class Api::V1::OutputsControllerTest < Api::Test
def setup
  # See `test/controllers/api/test.rb` for common set up for API tests.
  super

  @project = create(:project, team: @team)
  @prompt = create(:prompt, project: @project)
  @prompt_execution = create(:prompt_execution, prompt: @prompt)
  @output = build(:output, prompt_execution: @prompt_execution)
  @other_outputs = create_list(:output, 3)

  @another_output = create(:output, prompt_execution: @prompt_execution)

  # 🚅 super scaffolding will insert file-related logic above this line.
  @output.save
  @another_output.save

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
def assert_proper_object_serialization(output_data)
  # Fetch the output in question and prepare to compare it's attributes.
  output = Output.find(output_data["id"])

  assert_equal_or_nil output_data['label'], output.label
  assert_equal_or_nil output_data['results'], output.results
  assert_equal_or_nil output_data['input_tokens'], output.input_tokens
  assert_equal_or_nil output_data['output_tokens'], output.output_tokens
  assert_equal_or_nil output_data['message_id_api'], output.message_id_api
  assert_equal_or_nil output_data['user_rating'], output.user_rating
  # 🚅 super scaffolding will insert new fields above this line.

  assert_equal output_data["prompt_execution_id"], output.prompt_execution_id
end

test "index" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/prompt_executions/#{@prompt_execution.id}/outputs", params: {access_token: access_token}
  assert_response :success

  # Make sure it's returning our resources.
  output_ids_returned = response.parsed_body.map { |output| output["id"] }
  assert_includes(output_ids_returned, @output.id)

  # But not returning other people's resources.
  assert_not_includes(output_ids_returned, @other_outputs[0].id)

  # And that the object structure is correct.
  assert_proper_object_serialization response.parsed_body.first
end

test "show" do
  # Fetch and ensure nothing is seriously broken.
  get "/api/v1/outputs/#{@output.id}", params: {access_token: access_token}
  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  get "/api/v1/outputs/#{@output.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "create" do
  # Use the serializer to generate a payload, but strip some attributes out.
  params = {access_token: access_token}
  output_data = JSON.parse(build(:output, prompt_execution: nil).api_attributes.to_json)
  output_data.except!("id", "prompt_execution_id", "created_at", "updated_at")
  params[:output] = output_data

  post "/api/v1/prompt_executions/#{@prompt_execution.id}/outputs", params: params
  assert_response :success

  # # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # Also ensure we can't do that same action as another user.
  post "/api/v1/prompt_executions/#{@prompt_execution.id}/outputs",
    params: params.merge({access_token: another_access_token})
  assert_response :not_found
end

test "update" do
  # Post an attribute update ensure nothing is seriously broken.
  put "/api/v1/outputs/#{@output.id}", params: {
    access_token: access_token,
    output: {
      label: 'Alternative String Value',
      results: 'Alternative String Value',
      message_id_api: 'Alternative String Value',
      # 🚅 super scaffolding will also insert new fields above this line.
    }
  }

  assert_response :success

  # Ensure all the required data is returned properly.
  assert_proper_object_serialization response.parsed_body

  # But we have to manually assert the value was properly updated.
  @output.reload
  assert_equal @output.label, 'Alternative String Value'
  assert_equal @output.results, 'Alternative String Value'
  assert_equal @output.message_id_api, 'Alternative String Value'
  # 🚅 super scaffolding will additionally insert new fields above this line.

  # Also ensure we can't do that same action as another user.
  put "/api/v1/outputs/#{@output.id}", params: {access_token: another_access_token}
  assert_response :not_found
end

test "destroy" do
  # Delete and ensure it actually went away.
  assert_difference("Output.count", -1) do
    delete "/api/v1/outputs/#{@output.id}", params: {access_token: access_token}
    assert_response :success
  end

  # Also ensure we can't do that same action as another user.
  delete "/api/v1/outputs/#{@another_output.id}", params: {access_token: another_access_token}
  assert_response :not_found
end
end
