defmodule ConfigureItOutTest do
  use ExUnit.Case, async: false

  def error_message_regex(value) do
    ~r/No application environment variable for.+#{inspect(value)}/s
  end

  def fetch!(app_id, config_key, default_val) do
    ConfigureItOut.fetch_env!(app_id, config_key, default_val)
  end

  def fetch!(app_id, config_key, default_val, options) do
    ConfigureItOut.fetch_env!(app_id, config_key, default_val, options)
  end

  def fn_fetch!(app_id, config_key, default_val) do
    fn -> fetch!(app_id, config_key, default_val) end
  end

  def fn_fetch!(app_id, config_key, default_val, options) do
    fn -> fetch!(app_id, config_key, default_val, options) end
  end

  setup do
    app_id        = :my_app
    config_key    = :my_config_key
    config_val    = :my_config_val
    default_val   = MyDefaultVal
    suggested_val = MySuggestedVal
    options       = [{Mix.env, suggested_val}]

    on_exit fn -> Application.delete_env(app_id, config_key) end

    setup_options = [
      app_id:        app_id,
      config_key:    config_key,
      config_val:    config_val,
      default_val:   default_val,
      options:       options,
      suggested_val: suggested_val
    ]

    {:ok, setup_options}
  end

  test "fetches the config value w/o options", xx do
    Application.put_env(xx.app_id, xx.config_key, xx.config_val)
    assert xx.config_val == fetch!(xx.app_id, xx.config_key, xx.default_val)
  end

  test "fetches the config value w/ options", xx do
    Application.put_env(xx.app_id, xx.config_key, xx.config_val)
    assert xx.config_val == fetch!(xx.app_id,
                                   xx.config_key,
                                   xx.default_val,
                                   xx.options)
  end

  test "raises error on missing config val w/ default value", xx do
    assert_raise(
      ConfigureItOut.EnvFetcher.Error,
      error_message_regex(xx.default_val),
      fn_fetch!(xx.app_id, xx.config_key, xx.default_val)
    )
  end

  test "raises error on missing config val w/ suggested value", xx do
    assert_raise(
      ConfigureItOut.EnvFetcher.Error,
      error_message_regex(xx.suggested_val),
      fn_fetch!(xx.app_id, xx.config_key, xx.default_val, xx.options)
    )
  end
end
