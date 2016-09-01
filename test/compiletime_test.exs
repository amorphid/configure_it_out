defmodule CompiletimeTest do
  use ExUnit.Case, async: false

  setup do
    app_id     = :my_app
    config_key = :my_config_key
    config_val = MyConfigVal
    Application.put_env(app_id, config_key, config_val)
    on_exit fn -> Application.delete_env(app_id, config_key) end
    {:ok, [app_id: app_id, config_key: config_key, config_val: config_val]}
  end

  test "fetching config val",
       %{app_id: app_id, config_key: config_key, config_val: config_val} do
    assert config_val == Compiletime.fetch_app_env!(app_id, config_key)
  end
end
