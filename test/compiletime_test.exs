defmodule CompiletimeTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureLog

  def fetch!(app_id, config_key, default_val) do
    Compiletime.fetch_app_env!(app_id, config_key, default_val)
  end

  def fetch!(app_id, config_key, default_val, options) do
    Compiletime.fetch_app_env!(app_id, config_key, default_val, options)
  end

  setup_all do
    app_id      = :my_app
    config_key  = :my_config_key
    default_val = MyDefaultVal
    Application.put_env(app_id, config_key, default_val)
    on_exit fn -> Application.delete_env(app_id, config_key) end
    {:ok, [app_id: app_id, config_key: config_key, default_val: default_val]}
  end

  test "fetching default val", xx do
    assert xx.default_val == fetch!(xx.app_id, xx.config_key, xx.default_val)
  end
  
  test "fetching override_val val", xx do
    override_val = MyOverrideVal
    options = [{Mix.env, override_val}]
    assert override_val == fetch!(xx.app_id, xx.config_key, xx.default_val, options)
  end

  test "raising error if no config val", xx do
    Application.delete_env(xx.app_id, xx.config_key)
    assert_raise ArgumentError,
                 fn -> fetch!(xx.app_id, xx.config_key, xx.default_val) end
  end

  test "logging warning if config val not equal to default val", xx do
    Application.put_env(xx.app_id, xx.config_key, MyTestVal)
    funktion = fn -> fetch!(xx.app_id, xx.config_key, xx.default_val) end
    assert capture_log([], funktion) =~ "Unexpected application environment"
  end
end
