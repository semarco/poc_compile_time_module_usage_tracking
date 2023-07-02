defmodule Tracker do
  @moduledoc """
  PoC for tracking which modules using a specific module (here Tracker) at compile time.

  We just add a protocol and use protocol introspection at the end.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      defimpl Trackable do
        def track(struct) do
          struct
        end
      end
    end
  end

  # ignore dialyzer assumes Trackable is always consolidated
  @dialyzer {:nowarn_function, modules: 0}
  @spec modules :: [module]
  def modules do
    case Trackable.__protocol__(:impls) do
      {:consolidated, modules} ->
        modules

      :not_consolidated ->
        Protocol.extract_impls(Trackable, :code.get_path())
    end
  end
end
