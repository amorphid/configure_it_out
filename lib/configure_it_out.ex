defmodule ConfigureItOut do
  def fetch_env!(app_id, config_key, default_val) do
    fetch_env!(app_id, config_key, default_val, [])
  end

  def fetch_env!(app_id, config_key, default_val, options) do
    ConfigureItOut.EnvFetcher.new(app_id, config_key, default_val, options)
    |> ConfigureItOut.EnvFetcher.fetch!()
  end
end
