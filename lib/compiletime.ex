defmodule Compiletime do
  def fetch_app_env!(app_id, config_key, default_val) do
    Compiletime.AppEnvFetcher.new(app_id, config_key, default_val)
    |> Compiletime.AppEnvFetcher.fetch!()
  end
end
