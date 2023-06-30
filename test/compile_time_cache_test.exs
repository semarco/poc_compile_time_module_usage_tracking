defmodule CompileTimeCacheTest do
  use ExUnit.Case

  test "builds Tracker.Cache" do
    assert Tracker.Cache.modules() == [A, B, C]
  end
end
