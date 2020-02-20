defmodule Poker do
  def deal(), do: deal(shuffle())

  def deal(list) do
    if (length(list) >= 10) do
      list = Enum.drop(list, -(length(list) - 10))

      {hand1, hand2} = createHands(list, 1, [], [])

      # evaluate(hand1)
      # evaluate(hand2)
    else
      IO.puts("Not enough cards")
    end
  end

  def shuffle(), do: shuffle(Enum.to_list(1..52))

  def shuffle(list) do
    list = Enum.shuffle(list)
    list = Enum.drop(list, -(length(list) - 10))
  end

  def createHands([], n, hand1, hand2), do: {hand1, hand2}
  def createHands(list, n, hand1, hand2) do
    if (rem(n, 2) == 1) do
      hand1 = hand1 ++ [hd(list)]
      createHands(tl(list), n + 1, hand1, hand2)
    else
      hand2 = hand2 ++ [hd(list)]
      createHands(tl(list), n + 1, hand1, hand2)
    end
  end

  # ******************************************

  def evaluate(hand) do
    value = [
      highCard:       highCard(hand),
      pair:           pair(hand),
      twoPair:        twoPair(hand),
      triplet:        triplet(hand),
      straight:       straight(hand),
      flush:          flush(hand),
      fullHouse:      fullHouse(hand),
      quadruplet:     quadruplet(hand),
      straightFlush:  straightFlush(hand),
      royalFlush:     royalFlush(hand),
    ]
  end

  def sort(hand) do
  end

  # ******************************************

  def highCard(hand) do
  end

  def pair(hand) do
  end

  def twoPair(hand) do
  end

  def triplet(hand) do
  end

  def straight(hand) do
  end

  def flush(hand) do
  end

  def fullHouse(hand) do
  end

  def quadruplet(hand) do
  end

  def straightFlush(hand) do
  end

  def royalFlush(hand) do
  end
end
