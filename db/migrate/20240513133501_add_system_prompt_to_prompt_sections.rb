class AddSystemPromptToPromptSections < ActiveRecord::Migration[7.1]
  def change
    add_column :prompt_sections, :system_prompt, :boolean, default: false
  end
end
