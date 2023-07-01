defmodule TrackerTest do
  use ExUnit.Case

  test "keeps a list of all modules using Tracker" do
    assert Tracker.modules() == [A, B, C]
  end
end
