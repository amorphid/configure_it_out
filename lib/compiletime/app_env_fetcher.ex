defmodule Compiletime.AppEnvFetcher do
  defstruct [:app_id, :config_key]

  def fetch!(%__MODULE__{}=state) do
    state
    |> fetch_app_env!()
  end

  def new(app_id, config_key) do
    %__MODULE__{app_id: app_id, config_key: config_key}
  end

  def fetch_app_env!(%__MODULE__{app_id:     app_id,
                                 config_key: config_key}=_state) do
    Application.fetch_env!(app_id, config_key)
  end
end
