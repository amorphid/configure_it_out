defmodule ConfigureItOut do
  @type app_id      :: ConfigureItOut.EnvFetcher.app_id()
  @type config_key  :: ConfigureItOut.EnvFetcher.config_key()
  @type config_val  :: ConfigureItOut.EnvFetcher.config_val()
  @type default_val :: ConfigureItOut.EnvFetcher.default_val()
  @type options     :: ConfigureItOut.EnvFetcher.options()

  @spec fetch_env!(app_id(), config_key(), default_val()) :: config_val()
  def fetch_env!(app_id, config_key, default_val) do
    fetch_env!(app_id, config_key, default_val, [])
  end

  @spec fetch_env!(app_id(), config_key(), default_val(), options) :: config_val()
  def fetch_env!(app_id, config_key, default_val, options) do
    ConfigureItOut.EnvFetcher.new(app_id, config_key, default_val, options)
    |> ConfigureItOut.EnvFetcher.fetch!()
  end
end
