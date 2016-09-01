defmodule Compiletime.AppEnvFetcher do
  require Logger

  defstruct [:app_id, :config_key, :config_val, :default_val, :override_val]

  def fetch!(%__MODULE__{}=state) do
    state
    |> fetch_app_env!()
    |> compare_config_and_override_vals()
    |> compare_config_and_default_vals()
    |> Map.get(:config_val)
  end

  def new(app_id, config_key, default_val, options) do
    %__MODULE__{
      app_id:       app_id,
      config_key:   config_key,
      default_val:  default_val,
      override_val: Keyword.get(options, Mix.env)
    }
  end

  defp compare_config_and_default_vals(%__MODULE__{
                                        app_id:       app_id,
                                        config_key:   config_key,
                                        config_val:   config_val,
                                        default_val:  default_val,
                                        override_val: override_val
                                      }=state) do
    if !override_default_val?(override_val) && (config_val != default_val) do
      Logger.warn("""
      Unexpected application environment value for '#{inspect(app_id)}, #{inspect(config_key)}'
      Expected this => #{inspect(config_val)}
      Got this      => #{inspect(default_val)}
      """)
    end

    state
  end

  defp compare_config_and_override_vals(%__MODULE__{
                                          config_val:   config_val,
                                          override_val: override_val
                                        }=state) do
    if override_default_val?(override_val) do
      Map.put(state, :config_val, override_val)
    else
      state
    end
  end

  defp fetch_app_env!(%__MODULE__{
                        app_id:     app_id,
                        config_key: config_key
                      }=state) do
    Map.put(state, :config_val, Application.fetch_env!(app_id, config_key))
  end

  defp override_default_val?(nil) do
    false
  end

  defp override_default_val?(_) do
    true
  end
end
