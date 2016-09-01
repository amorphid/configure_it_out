defmodule CompiletimeTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureLog

  def fetch!(app_id, config_key, default_val) do
    Compiletime.fetch_app_env!(app_id, config_key, default_val)
  end

  setup do
    app_id      = :my_app
    config_key  = :my_config_key
    default_val = MyDefaultVal
    Application.put_env(app_id, config_key, default_val)
    on_exit fn -> Application.delete_env(app_id, config_key) end
    {:ok, [app_id: app_id, config_key: config_key, default_val: default_val]}
  end

  test "fetching config val",
       %{app_id:      app_id,
         config_key:  config_key,
         default_val: default_val} do
    assert default_val == fetch!(app_id, config_key, default_val)
  end

  test "raising error if no config val",
       %{app_id: app_id, config_key: config_key, default_val: default_val} do
    Application.delete_env(app_id, config_key)
    assert_raise ArgumentError,
                 fn -> fetch!(app_id, config_key, default_val) end
  end

  test "logging warning if config val not equal to default val",
       %{app_id: app_id, config_key: config_key, default_val: default_val} do
    assert capture_log([], fn -> fetch!(app_id, config_key, default_val) end)
  end
end
