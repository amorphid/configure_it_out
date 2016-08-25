defmodule Compiletime.AppEnvFetcher do
  def fetch!(app, key, options) do
    :ok = fetch_environments!(options)

    case Application.fetch_env(app, key) do
      value when value != :error -> value
      :error                     -> raise_error(app, key, options)
    end
  end

  defp config_environments do
    case Application.get_env(:compiletime, :environments) do
      environments when is_list(environments) -> environments
      _                                       -> []
    end
  end

  defp fetch_environments!(options) do
    sorted_arg    = Keyword.keys(options) |> Enum.sort
    sorted_config = Enum.sort(config_environments)

    if sorted_arg != sorted_config do
      raise_error(:compiletime, :environments, global: sorted_arg)
    else
      :ok
    end
  end

  defp main_message(app, key) do
    """


    Missing config!
      Ran this...
        Application.fetch_env(#{inspect(app)}, #{inspect(key)})
      Which returned this...
        :error
      Expected anything but this...
        :error
    """
  end

  defp option_message(app, app_key, {opt_key, opt_value}=_option) do
    """
      add this to #{opt_key} config
        config #{inspect(app)}, #{app_key}: #{inspect(opt_value)}
    """
  end

  defp options_message(app, key, options) do
    case options do
      []      -> ""
      options -> """

      To fix
      #{for option <- options, do: option_message(app, key, option)}
      """
    end
  end

  defp raise_error(app, key, options) do
    raise Enum.join([
      IO.ANSI.red,
      main_message(app, key),
      options_message(app, key, options),
      IO.ANSI.default_color
    ])
  end
end
