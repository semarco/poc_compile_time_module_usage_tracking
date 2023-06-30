defmodule Tracker do
  @moduledoc """
  PoC for tracking which modules using a specifific module (here Tracker) at compile time.

  We keep the state in a ETS table and Fastglobal.
  Feels hacky, but a solution using only Fastglobal and ETS was not possible, as:
  - Fastglobal was always empty in the next module register cycle, so we use ETS for tracking the modules.
  - ETS table wasn't available in the final compile step, so we additionally 'persist' via Fastglobal.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      IO.inspect(__MODULE__, label: "use Tracker")
      Tracker.register(__MODULE__)
    end
  end

  def register(module) do
    try do
      :ets.new(:modules_using_tracker, [:set, :named_table, :public])
    rescue
      _ -> :ok
    end

    update_registered_modules(module)
  end

  def update_registered_modules(module) do
    :ets.insert(:modules_using_tracker, {module, module})

    modules = :ets.match(:modules_using_tracker, {:"$1", :_}) |> List.flatten()
    FastGlobal.put(:modules_using_tracker, modules)
  end

  def registered_modules() do
    FastGlobal.get(:modules_using_tracker) || []
  end
end
