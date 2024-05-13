class AsyncAiProcessJob < ApplicationJob
  queue_as :default
  discard_on StandardError

  def perform(execution_id, output_id)
    PromptExecution.find(execution_id).execute_async(Output.find(output_id))
  end

  # Hack because background jobs don't seem to be executing right...
  if Rails.env.test?
    def self.perform_later(args)
      super
      AsyncAiProcessJob.new.perform(args) if Rails.env.test?
    end
  end
end
