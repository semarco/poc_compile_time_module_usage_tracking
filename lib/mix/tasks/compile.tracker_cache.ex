defmodule Mix.Tasks.Compile.TrackerCache do
  @moduledoc "The tracker cache compile mix task: `mix compile tracker_cache`"
  use Mix.Task.Compiler

  # The recursive module attribute tells Mix that we want to get the
  # project config for the specific project even if it is called from
  # the umbrella root.  Otherwise we get the project config of the
  # umbrella project itself. Not intuitive at all!
  @recursive true

  @default_path "lib/tracker_cache.ex"

  @shortdoc "Compiles Tracker.Cache"
  @impl true
  def run(_) do
    registered_modules =
      Tracker.registered_modules()
      |> IO.inspect(label: "newly registered modules")

    tracked_modules =
      tracked_modules()
      |> IO.inspect(label: "already tracked modules")

    # merge existing modules from TrackerCache (as we only register re-compiled modules here)
    modules = (tracked_modules ++ registered_modules) |> Enum.uniq() |> Enum.sort()

    build_cache_module(
      "Tracker.Cache",
      @default_path,
      Enum.map(modules, fn m -> to_string(m) |> String.replace("Elixir.", "") end)
    )

    :ok
  end

  def tracked_modules() do
    case Code.ensure_compiled(Tracker.Cache) do
      {:module, _} ->
        Tracker.Cache.modules()
        |> Enum.filter(fn module ->
          match?({:module, _}, Code.ensure_compiled(module)) &&
            :erlang.function_exported(module, :__info__, 1)

          # TODO
          # - fix for elixir_ls (not recompling if a file is deleted)
          # - check the module is still using the tracked module
        end)

      {:error, _} ->
        []
    end
  end

  def build_cache_module(cache_module_name, path, modules) do
    with Mix.shell().info("Generating cache module #{cache_module_name}..."),
         {:ok, cache_module} <- encode(cache_module_name, modules),
         Mix.shell().info("Writing cache module file #{path}"),
         :ok <- write_cache(cache_module, path) do
      Mix.shell().info("Done")
      :ok
    else
      {:error, exception} = error ->
        Mix.shell().error("Caching failed with #{inspect(exception)}")
        error

      error ->
        Mix.shell().error("Caching failed with fatal error: #{inspect(error)}")

        raise error
    end
  end

  def encode(cache_module_name, modules) do
    code = """
    defmodule #{cache_module_name} do
      def modules do
        [
          #{Enum.join(modules, ",\n      ")}
        ]
      end
    end
    """

    {:ok, code}
  end

  defp write_cache(code, path) do
    case path |> Path.dirname() |> File.mkdir_p() do
      :ok ->
        File.rm(path)
        File.write(path, code)
    end
  end
end
