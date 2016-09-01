defmodule Compiletime.AppEnvFetcher do
  require Logger

  defstruct [:app_id, :config_key, :config_val, :default_val]

  def fetch!(%__MODULE__{}=state) do
    state
    |> fetch_app_env!()
    |> compare_config_and_default_vals()
    |> Map.get(:config_val)
  end

  def new(app_id, config_key, default_val) do
    %__MODULE__{
      app_id:      app_id,
      config_key:  config_key,
      default_val: default_val
    }
  end

  defp compare_config_and_default_vals(%__MODULE__{
                                        app_id:      app_id,
                                        config_key:  config_key,
                                        config_val:  config_val,
                                        default_val: default_val
                                      }=state) do
    if config_val != default_val do
      Logger.warn("""
      Unexpected application environment value for '#{inspect(app_id)}, #{inspect(config_key)}'
      Expected this => #{inspect(config_val)}
      Got this      => #{inspect(default_val)}
      """)
    end

    state
  end

  defp fetch_app_env!(%__MODULE__{app_id:     app_id,
                                  config_key: config_key}=state) do
    Map.put(state, :config_val, Application.fetch_env!(app_id, config_key))
  end
end
