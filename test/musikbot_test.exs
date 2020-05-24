defmodule MusikbotTest do
  use ExUnit.Case
  doctest Musikbot

  test "greets the world" do
    assert Musikbot.hello() == :world
  end
end
