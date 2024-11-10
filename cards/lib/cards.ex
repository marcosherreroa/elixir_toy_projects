defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Returns a list of strings representing a deck of playing cards
  """
  def create_deck do
    values = ["Ace","Two","Three","Four","Five"]
    suits = ["Spades","Clubs","Hearts","Diamonds"]

    List.flatten(
      for suit <- suits, value <- values do
        "#{value} of #{suit}"
      end
    )
  end

  def shuffle(deck) do
    Enum.shuffle deck
  end

  @doc """
    Checks if the card `card` is in the deck `deck`

  ## Examples

      iex> Cards.contains?(["Two of Spades","Three of Hearts"],"Two of Spades")
      true
      iex> Cards.contains?(["Two of Spades","Three of Hearts"],"Ace of Hearts")
      false
  """
  def contains?(deck, card) do
    Enum.member?(deck,card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should be in the hand.

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand,_deck} = Cards.deal(deck,1)
      iex> hand
      ["Ace of Spades"]

  """
  def deal(deck,hand_size) do
    Enum.split(deck,hand_size)
  end

  def save(deck,filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename,binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok,binary} -> :erlang.binary_to_term(binary)
      {:error,_} -> "The file #{filename} does not exist"
      #{:error,:enoent} -> "The file #{filename} does not exist"
      #{:error,:eacces} -> "You don't have permission for reading the file #{filename}"
      #{:error,:eisdir} -> "The file #{filename} is a directory"
    end
  end

  def create_hand(hand_size) do
    #deal(shuffle(create_deck()),hand_size)
    create_deck()
    |> shuffle()
    |> deal(hand_size)
  end
end
