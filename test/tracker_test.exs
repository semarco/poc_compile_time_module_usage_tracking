defmodule TrackerTest do
  use ExUnit.Case

  test "keeps a list of all modules using Tracker" do
    assert Tracker.modules() |> Enum.sort() == [A, B, C]
  end
end
