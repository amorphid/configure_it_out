defmodule ConfigureItOut do
  @type app_id      :: ConfigureItOut.EnvFetcher.app_id()
  @type config_key  :: ConfigureItOut.EnvFetcher.config_key()
  @type config_val  :: ConfigureItOut.EnvFetcher.config_val()
  @type default_val :: ConfigureItOut.EnvFetcher.default_val()
  @type options     :: ConfigureItOut.EnvFetcher.options()

  @spec fetch_env!(app_id(), config_key(), default_val()) :: config_val()
  def fetch_env!(app_id, config_key, default_val) do
    fetch_env!(app_id, config_key, default_val, [])
  end

  @doc """
  Use to assign values to module attributes at compiletime.  It with either work as expected, or cause compile to fail w/ a suggestion on how to fix the problem.

  ```elixir
  # define a module w/ an attribute using ConfigureItOut.fetch_env!/4
  defmodule MyApp.MyModule do
    @my_attribute ConfigureItOut.fetch_env!(
      :my_app,         # application ID
      :my_key,         # key for application environment
      DefaultModule,   # default value for any environment
      test: TestModule # overrides default value for 'test' environment
    )

    def my_attribute do
      @my_attribute
    end
  end
  ```
  ```bash
  ## Compile fails, throwing an error
  $ mix compile

    Compiling 1 file (.ex)
    == Compilation error on file lib/my_app.ex ==
    ** (RuntimeError)

    No application environment variable for ':my_app, :my_key'.  Consider adding this to your 'dev' config:

      config :my_app, my_key: DefaultModule
  ```
  ```elixir
  # Following suggestion in error message, and setting to dev.exs
  use Mix.config

  config :my_app, my_key: DefaultModule
  ```
  ```bash
  # Compile now works!
  $ mix compile
    Compiling 1 file (.ex)
    Generated my_app app
  ```
  ```bash
  # Compile still fails for any enviornment without the config setting
  #
  # Notice TestModule is used in 'test', as 'test' overrides the default
  $ MIX_ENV=test mix compile

    == Compilation error on file lib/my_app.ex ==
    ** (RuntimeError)

    No application environment variable for ':my_app, :some_key'.  Consider adding this to your 'test' config:

      config :my_app, my_key: TestModule
  ```
  ```elixir
  # Following suggestion in error message, and setting to test.exs
  use Mix.config

  config :my_app, my_key: TestModule #
  ```
  ```bash
  # it compiles!
  $ MIX_ENV=test mix compile
    Compiling 1 file (.ex)
    Generated my_app app
  ```
  """
  @spec fetch_env!(app_id(), config_key(), default_val(), options) :: config_val()
  def fetch_env!(app_id, config_key, default_val, options) do
    ConfigureItOut.EnvFetcher.new(app_id, config_key, default_val, options)
    |> ConfigureItOut.EnvFetcher.fetch!()
  end
end
