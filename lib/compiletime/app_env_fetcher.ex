defmodule Compiletime.AppEnvFetcher do
  def fetch!(_app, :error=_key, _options) do
    raise "Invalid key=> :error"
  end

  def fetch!(app, key, options) do
    case Application.fetch_env(app, key) do
      value when value != :error -> value
      :error                     -> raise_error(app, key, options)
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
        config #{inspect(app)}, #{inspect(app_key)}, #{inspect(opt_value)}
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
