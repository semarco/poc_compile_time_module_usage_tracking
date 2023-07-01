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

  def modules do
    {:consolidated, modules} = Trackable.__protocol__(:impls)
    modules
  end
end
