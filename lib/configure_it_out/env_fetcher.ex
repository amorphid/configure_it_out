defmodule ConfigureItOut.EnvFetcher do
  defmodule Error do
    defexception [:app_id, :config_key, :env, :suggested_val]

    def message(%__MODULE__{
                  app_id:        app_id,
                  config_key:    config_key,
                  env:           env,
                  suggested_val: suggested_val
                }=_state) do
      """

      #{IO.ANSI.red()}
      No application environment variable for '#{inspect(app_id)}, #{inspect(config_key)}'.  Consider adding this to your '#{env}' config:
        config #{inspect(app_id)}, #{config_key}: #{inspect(suggested_val)}
      #{IO.ANSI.default_color()}
      """
    end
  end

  require Logger

  @type app_id      :: atom()
  @type config_key  :: atom()
  @type config_val  :: any()
  @type default_val :: any()
  @type options     :: Keyword.t
  @type t           :: struct()

  @enforce_keys [:app_id, :config_key, :env, :suggested_val]
  defstruct     @enforce_keys

  @env Mix.env

  @spec fetch!(t()) :: config_val()
  def fetch!(%__MODULE__{}=state) do
    state
    |> fetch_config_val()
  end

  @spec new(app_id(), config_key(), default_val(), options()) :: t()
  def new(app_id, config_key, default_val, options) do
    %__MODULE__{
      app_id:        app_id,
      config_key:    config_key,
      env:           @env,
      suggested_val: Keyword.get(options, @env, default_val)
    }
  end

  @spec fetch_config_val(t()) :: config_val()
  defp fetch_config_val(%__MODULE__{app_id:     app_id,
                                    config_key: config_key}=state) do
    case Application.fetch_env(app_id, config_key) do
      {:ok, config_val} -> config_val
      :error            -> raise_error(state)
    end
  end

  @spec raise_error(t()) :: no_return()
  defp raise_error(%__MODULE__{
                     app_id:        app_id,
                     config_key:    config_key,
                     env:           env,
                     suggested_val: suggested_val
                   }=_state) do
    raise(%__MODULE__.Error{
      app_id:        app_id,
      config_key:    config_key,
      env:           env,
      suggested_val: suggested_val
    })
  end
end
