# PromptCraft

## Getting Started

1. You must have the following dependencies installed:

     - Ruby 3
          - See [`.ruby-version`](.ruby-version) for the specific version.
     - Node 19
          - See [`.nvmrc`](.nvmrc) for the specific version.
     - PostgreSQL 14
     - Redis 6.2
     - [Chrome](https://www.google.com/search?q=chrome) (for headless browser tests)

    If you don't have these installed, you can use [rails.new](https://rails.new) to help with the process.

2. Run the `bin/setup` script.
3. Start the application with `bin/dev`.
4. Visit http://localhost:3000.

Note: PromptCraft will by default use `redis://localhost:6379/10` for Sidekiq, which should coexist just fine with other Sidekiq apps running alongside it. If that's no good for you, change it in `config/initializers/sidekiq.rb`.

## Rationale

When crafting large and complicated prompts with non-trivial imputs and outputs, using the chat box is inefficient and annoying. Most tooling for this is focused on refining short prompts with short outputs, automating evaluations, etc.

This doesn't work for me. I want to be able to evolve and tweak large prompts involving substantial amounts of source data, without having to copy and paste between chat boxes and text documents on my computer.

Enter PromptCraft.

Here's a general process that it might support:

You decide you want to make a prompt for... making structured technical reports from a call log.

You set up a project, and put in some sample call logs as input items.

Then you create a prompt with various parts (both system and user), using `{{arguments}}` to set up placeholders. `{{Arguments}}` can support multiple items (in which case they get concatenated together). There can be multiple `{{Arguments}}` of different types.

Then, having crafted a possible prompt, you assign the sample call logs (or anything else), in some combination, as arguments, you select a model and parameters (temperature, etc), maybe a number of times you want to run it to get a more varied sample, and then you click "Go" and...

...not too long later you have N sample outputs from your chosen LLM, which you can go through and rate manually. From that point, the prompt is read-only so that your results are easier to track (otherwise we'd need prompts to be versioned and that gets complicated).

You can keep running that prompt with the same parameters any number of times with different settings (model, temperature, tweak the inputs), without creating a new prompt.

If you decide actually it's the prompt that needs changing, you "fork" it, and create a new prompt based on the old one, that is editable again. It is linked to the old prompt, so inherits whatever settings it had, and perhaps, later, the evolution of a prompt's output can be tracked in some neat way. If you go down a dead end, you can instead go back to an earlier prompt that worked better, and fork that.

Have a look at [the proposed scaffolding](SCAFFOLDING.md) for more details about the data model. Input welcome, find me on the [Ruby AI Builders Discord](https://discord.gg/jewqJN6wck) if you'd like to chat about this. 

## Information about Bullet Train
If this is your first time working on a Bullet Train application, be sure to review the [Bullet Train Basic Techniques](https://bullettrain.co/docs/getting-started) and the [Bullet Train Developer Documentation](https://bullettrain.co/docs).

### Render

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/bullet-train-co/bullet_train)

Clicking this button will take you to the first step of a process that, when completed, will provision production-grade infrastructure for your Bullet Train application which will cost about **$30/month**.

When you're done deploying to Render, you need to go into "Dashboard" > "web", copy the server URL, and then go into "Env Groups" > "settings" and paste the URL into the value for `BASE_URL`.
