defmodule ConfigureItOutTest do
  use ExUnit.Case, async: false

  def fetch!(app_id, config_key, default_val) do
    ConfigureItOut.fetch_env!(app_id, config_key, default_val)
  end

  def fetch!(app_id, config_key, default_val, options) do
    ConfigureItOut.fetch_env!(app_id, config_key, default_val, options)
  end

  setup do
    app_id      = :my_app
    config_key  = :my_config_key
    default_val = MyDefaultVal
    Application.put_env(app_id, config_key, default_val)
    on_exit fn -> Application.delete_env(app_id, config_key) end
    {:ok, app_id: app_id, config_key: config_key, default_val: default_val}
  end

  test "fetching default val", xx do
    assert xx.default_val == fetch!(xx.app_id, xx.config_key, xx.default_val)
  end

  test "raising error if no config val", xx do
    Application.delete_env(xx.app_id, xx.config_key)
    assert_raise(
      RuntimeError,
      ~r/No application environment variable for/,
      fn -> fetch!(xx.app_id, xx.config_key, xx.default_val) end
    )
  end
end
