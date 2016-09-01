defmodule ConfigureItOut.AppEnvFetcher do
  require Logger

  @enforce_keys [:app_id, :config_key, :suggested_val]
  defstruct     @enforce_keys

  def fetch!(%__MODULE__{app_id: app_id, config_key: config_key}=state) do
    state
    |> fetch_config_val()
  end

  def new(app_id, config_key, default_val, options) do
    %__MODULE__{
      app_id:        app_id,
      config_key:    config_key,
      suggested_val: Keyword.get(options, Mix.env, default_val)
    }
  end

  defp fetch_config_val(%__MODULE__{app_id:     app_id,
                                    config_key: config_key}=state) do
    case Application.fetch_env(app_id, config_key) do
      {:ok, config_val} -> config_val
      :error            -> raise fetch_config_val_error(state)
    end
  end

  defp fetch_config_val_error(%__MODULE__{
                                app_id:        app_id,
                                config_key:    config_key,
                                suggested_val: suggested_val
                              }=state) do
    """

    #{IO.ANSI.red()}
    No application environment variable for '#{inspect(app_id)}, #{inspect(config_key)}'.  Consider adding this to your '#{Mix.env}' config:

      config #{inspect(app_id)}, #{config_key}: #{inspect(suggested_val)}
    #{IO.ANSI.default_color()}
    """
  end
end
