defmodule ConfigureItOut do
  def fetch_app_env!(app_id, config_key, default_val) do
    fetch_app_env!(app_id, config_key, default_val, [])
  end

  def fetch_app_env!(app_id, config_key, default_val, options) do
    ConfigureItOut.AppEnvFetcher.new(app_id, config_key, default_val, options)
    |> ConfigureItOut.AppEnvFetcher.fetch!()
  end
end
