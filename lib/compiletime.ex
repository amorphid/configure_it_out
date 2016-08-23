defmodule Compiletime do
  def fetch_app_env!(app, key, options \\ []) do
    Compiletime.AppEnvFetcher.fetch!(app, key, options)
  end
end
