defmodule Poker do
  def deal(), do: deal(shuffle())

  def deal(list) do
    if length(list) >= 10 do
      list = Enum.drop(list, -(length(list) - 10))

      IO.inspect(list)

      {hand1, hand2} = createHands(list, 1, [], [])

      hand1 = Enum.sort(hand1)
      hand2 = Enum.sort(hand2)

      IO.inspect(hand1)
      IO.inspect(hand2)

      suit1 = assignSuit(hand1, [])
      suit2 = assignSuit(hand2, [])

      {suitKeys1, cardKeys1} = keywordList(hand1, [], [])
      {suitKeys2, cardKeys2} = keywordList(hand2, [], [])

      hand1 = assignCard(hand1, [])
      hand2 = assignCard(hand2, [])

      IO.puts("*******************************")
      IO.inspect(hand1)
      IO.inspect(suit1)
      IO.inspect(suitKeys1)
      IO.inspect(cardKeys1)
      IO.puts("*******************************")
      IO.inspect(hand2)
      IO.inspect(suit2)
      IO.inspect(suitKeys2)
      IO.inspect(cardKeys2)
      IO.puts("*******************************")

      value1 = evaluate(hand1)
      value2 = evaluate(hand2)
    else
      IO.puts("Not enough cards")
    end
  end

  # ******************************************

  def shuffle(), do: shuffle(Enum.to_list(1..52))

  def shuffle(list) do
    list = Enum.shuffle(list)
  end

  # ******************************************

  def createHands([], n, hand1, hand2), do: {hand1, hand2}

  def createHands(list, n, hand1, hand2) do
    if rem(n, 2) == 1 do
      hand1 = hand1 ++ [hd(list)]
      createHands(tl(list), n + 1, hand1, hand2)
    else
      hand2 = hand2 ++ [hd(list)]
      createHands(tl(list), n + 1, hand1, hand2)
    end
  end

  # ******************************************

  def assignSuit([], suit), do: suit

  def assignSuit(hand, suit) do
    suit = suit ++ [getSuit(hd(hand))]
    assignSuit(tl(hand), suit)
  end

  def getSuit(value) do
    value = div(value - 1, 13)

    cond do
      value == 0 -> "clubs"
      value == 1 -> "diamonds"
      value == 2 -> "hearts"
      value == 3 -> "spades"
    end
  end

  # ******************************************

  def assignCard([], cards), do: cards

  def assignCard(hand, cards) do
    cards = cards ++ [getCard(hd(hand))]
    assignCard(tl(hand), cards)
  end

  def getCard(value), do: rem(value - 1, 13) + 1

  # ******************************************

  def keywordList([], suitKeys, cardKeys), do: {suitKeys, cardKeys}

  def keywordList(hand, suitKeys, cardKeys) do
    suitKeys = suitKeys ++ getSuitPair(hd(hand))
    cardKeys = cardKeys ++ getCardPair(hd(hand))
    keywordList(tl(hand), suitKeys, cardKeys)
  end

  def getSuitPair(value) do
    suit = getSuit(value)
    cond do
      suit == "clubs" -> [clubs: getCard(value)]
      suit == "diamonds" -> [diamonds: getCard(value)]
      suit == "hearts" -> [hearts: getCard(value)]
      suit == "spades" -> [spades: getCard(value)]
    end
  end

  def getCardPair(value) do
    card = getCard(value)
    cond do
      card == 1 -> ['1': getSuit(value)]
      card == 2 -> ['2': getSuit(value)]
      card == 3 -> ['3': getSuit(value)]
      card == 4 -> ['4': getSuit(value)]
      card == 5 -> ['5': getSuit(value)]
      card == 6 -> ['6': getSuit(value)]
      card == 7 -> ['7': getSuit(value)]
      card == 8 -> ['8': getSuit(value)]
      card == 9 -> ['9': getSuit(value)]
      card == 10 -> ['10': getSuit(value)]
      card == 11 -> ['11': getSuit(value)]
      card == 12 -> ['12': getSuit(value)]
      card == 13 -> ['13': getSuit(value)]
    end
  end

  # ******************************************

  def evaluate(hand) do
    value = [
      highCard: highCard(hand),
      pair: pair(hand),
      twoPair: twoPair(hand),
      triplet: triplet(hand),
      straight: straight(hand),
      flush: flush(hand),
      fullHouse: fullHouse(hand),
      quadruplet: quadruplet(hand),
      straightFlush: straightFlush(hand),
      royalFlush: royalFlush(hand)
    ]
  end

  # ******************************************

  def highCard(hand) do
    true
  end

  # ******************************************

  def pair(hand) do
  end

  # ******************************************

  def twoPair(hand) do
  end

  # ******************************************

  def triplet(hand) do
  end

  # ******************************************

  def straight(hand) do
  end

  # ******************************************
  # Keyword.take(keywords, keys)
  def flush(hand) do
  end

  # ******************************************

  def fullHouse(hand) do
  end

  # ******************************************

  def quadruplet(hand) do
  end

  # ******************************************

  def straightFlush(hand) do
  end

  # ******************************************

  def royalFlush(hand) do
  end
end
