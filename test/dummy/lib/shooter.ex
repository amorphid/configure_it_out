defmodule Shooter do
  @sound Compiletime.fetch_app_env!(
    :shooter,
    :sound,
    dev:  "bang bang",
    test: "mock bang",
    prod: "BANG BANG!!!!"
  )

  def shoot do
    @sound
  end
end
