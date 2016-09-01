defmodule Compiletime do
  def fetch_app_env!(app_id, config_key) do
    Compiletime.AppEnvFetcher.new(app_id, config_key)
    |> Compiletime.AppEnvFetcher.fetch!()
  end
end
