# SuperScaffolds

Being a bullet-train app, this makes use of super-scaffolds to get started. Those are much
more powerful than the default scaffolds.

![data model in figma](https://github.com/swombat/promptcraft/blob/main/docs/data_model.png?raw=true)


## Implemented Scaffolds

```bash
# Core stuff
rails generate super_scaffold IntelligenceCredential Team api_key:text_field class_name:super_select

# Set up invitation key management
rails generate super_scaffold InvitationKey Team key:text_field

# Prompts are organised inside projects
rails generate super_scaffold Project Team name:text_field description:trix_editor
rails generate super_scaffold InputType Project,Team name:text_field description:trix_editor
rails generate super_scaffold InputItem Project,Team name:text_field type_id:super_select{class_name=InputType} contents:text_area
```

## Planned Scaffolds

Scaffolds in this list have not yet been executed.

```bash
# Prompts are organised inside projects
rails generate super_scaffold InputType Project,Team name:text_field description:trix_editor
rails generate super_scaffold InputItem Project,Team name:text_field type_id:super_select{class_name=InputType} contents:text_area

# Prompts
rails generate super_scaffold Prompt Team name:text_field description:trix_editor
rails generate super_scaffold:field Prompt parent_id:super_select{class_name=Prompt} # self-reference
rails generate super_scaffold PromptSection Prompt,Team name:text_field description:trix_editor contents:text_area

rails generate super_scaffold PromptExecution Prompt,Team compiled_parameters:text_area parameters_summary:text_area model_id:super_select{class_name=IntelligenceModel}

rails generate super_scaffold Output Prompt,Team label:text_field results:text_area input_tokens:number_field output_tokens:number_field message_id:text_field user_rating:number_field
```