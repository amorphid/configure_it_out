defmodule Compiletime do
  def fetch_app_env!(app_id, config_key, default_val) do
    fetch_app_env!(app_id, config_key, default_val, [])
  end

  def fetch_app_env!(app_id, config_key, default_val, options) do
    Compiletime.AppEnvFetcher.new(app_id, config_key, default_val, options)
    |> Compiletime.AppEnvFetcher.fetch!()
  end
end
