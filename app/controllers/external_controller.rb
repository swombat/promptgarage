class ExternalController < ApplicationController
  layout "external"

  def all_outputs
    @prompt = Prompt.find(params[:prompt_id])
    @execution = @prompt.prompt_executions.find(params[:prompt_execution_id])
    @executions = @execution.linked_executions
    @outputs = @executions.collect(&:outputs).flatten

    render "account/outputs/all_outputs"
  end
end
