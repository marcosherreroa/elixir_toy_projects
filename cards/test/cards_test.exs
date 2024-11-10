defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    assert length(Cards.create_deck) == 20
  end
end
