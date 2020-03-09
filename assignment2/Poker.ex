defmodule Poker do
  def deal(), do: deal(shuffle())

  def deal(list) do
    if length(list) >= 10 do
      list = Enum.drop(list, -(length(list) - 10))

      {raw1, raw2} = createHands(list, 1, [], [])

      raw1 = Enum.sort(raw1)
      raw2 = Enum.sort(raw2)

      suit1 = assignSuit(raw1, [])
      suit2 = assignSuit(raw2, [])

      {suitKeys1, cardKeys1} = keywordList(raw1, [], [])
      {suitKeys2, cardKeys2} = keywordList(raw2, [], [])

      hand1 = assignCard(raw1, [])
      hand2 = assignCard(raw2, [])

      data1 = [
        raw: raw1,
        hand: hand1,
        suit: suit1,
        suitKeys: suitKeys1,
        cardKeys: cardKeys1
      ]

      data2 = [
        raw: raw2,
        hand: hand2,
        suit: suit2,
        suitKeys: suitKeys2,
        cardKeys: cardKeys2
      ]

      IO.inspect(list, charlists: :as_lists)
      IO.inspect(data1, charlists: :as_lists)
      IO.inspect(data2, charlists: :as_lists)
      evaluation = evaluate(data1, data2)
      IO.inspect(evaluation, charlists: :as_lists)
      nil
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
      card == 1 -> ["1": getSuit(value)]
      card == 2 -> ["2": getSuit(value)]
      card == 3 -> ["3": getSuit(value)]
      card == 4 -> ["4": getSuit(value)]
      card == 5 -> ["5": getSuit(value)]
      card == 6 -> ["6": getSuit(value)]
      card == 7 -> ["7": getSuit(value)]
      card == 8 -> ["8": getSuit(value)]
      card == 9 -> ["9": getSuit(value)]
      card == 10 -> ["10": getSuit(value)]
      card == 11 -> ["11": getSuit(value)]
      card == 12 -> ["12": getSuit(value)]
      card == 13 -> ["13": getSuit(value)]
    end
  end

  # ******************************************

  # Here is an assignment example that clearly indicates how to tie-break using the suit of the card. Suppose we have the following hands:

  # HandA: Ace of spades, Queen of hearts, 9 of spades, 4 of spades, 2 of diamonds
  # HandB: Ace of diamonds , Queen of clubs, 9 of hearts, 4 of hearts, 2 of hearts

  # Both of these hands are the "High Card" hand type, with Ace being the high card for both.
  # Because they have the same high card, we check the second highest. If the second highest is the same, we check third highest, and so on.
  # In the above hands, all the card ranks are the same (Ace, Queen, 9, 4, 2). Thus, we move on to tie-breaking by suit.
  # Spades is considered a higher suit than diamonds, so the Ace of spades will beat the Ace of diamonds. Thus, HandA is the winner.

  # *** We only tie-break using suit when it is impossible to tie-break using rank ***

  # If we change the hands slightly to the following:

  # HandA: Ace of spades, Queen of hearts, 9 of spades, 4 of spades, 2 of diamonds
  # HandB: Ace of diamonds , Queen of clubs, 9 of hearts, 4 of hearts, 3 of hearts

  # HandB now beats HandA based on rank, because the 5th highest card is a 3 of hearts, which beats the 2 of diamonds in HandA.

  def evaluate(data1, data2) do
    value = [
      highCard: highCard(data1, data2),
      pair: pair(data1, data2),
      twoPair: twoPair(data1, data2),
      triplet: triplet(data1, data2),
      straight: straight(data1, data2),
      flush: flush(data1, data2),
      fullHouse: fullHouse(data1, data2),
      quadruplet: quadruplet(data1, data2),
      straightFlush: straightFlush(data1, data2),
      royalFlush: royalFlush(data1, data2)
    ]
  end

  # ******************************************

  def highCard(data1, data2) do
    {value1, suit1} = getHighCard(Enum.sort(data1[:raw]), 0, 0)
    {value2, suit2} = getHighCard(Enum.sort(data2[:raw]), 0, 0)

    cond do
      value1 == 99 && value2 == 99 -> [hand1: 1, hand2: 1, winner: "tie"]
      value1 == 99 && value1 > value2 -> [hand1: 1, hand2: value2, winner: "hand1"]
      value2 == 99 && value1 < value2 -> [hand1: value1, hand2: 1, winner: "hand2"]
      value1 == value2 -> [hand1: value1, hand2: value2, winner: "tie"]
      value1 > value2 -> [hand1: value1, hand2: value2, winner: "hand1"]
      value1 < value2 -> [hand1: value1, hand2: value2, winner: "hand2"]
    end
  end

  def getHighCard([], target, rawValue) do
    cond do
      target == 99 -> {99, getSuit(rawValue)}
      true -> {getCard(rawValue), getSuit(rawValue)}
    end
  end

  def getHighCard(hand, target, rawValue) do
    card = getCard(hd(hand))

    cond do
      card == 1 -> getHighCard(tl(hand), 99, hd(hand))
      card > target -> getHighCard(tl(hand), card, hd(hand))
      card < target -> getHighCard(tl(hand), target, rawValue)
      true -> getHighCard(tl(hand), target, rawValue)
    end
  end

  # ******************************************

  def pair(data1, data2) do
    pair1 = data1[:hand] -- Enum.dedup(Enum.sort(data1[:hand]))
    pair2 = data2[:hand] -- Enum.dedup(Enum.sort(data2[:hand]))

    highestPair1 = Enum.at(pair1, -1)
    highestPair2 = Enum.at(pair2, -1)

    cond do
      pair1 == [] && pair2 == [] -> [hand1: pair1, hand2: pair2, winner: "tie"]
      pair1 === pair2 -> [hand1: pair1, hand2: pair2, winner: "tie"]
      pair1 != [] && pair2 == [] -> [hand1: pair1, hand2: pair2, winner: "hand1"]
      pair1 == [] && pair2 != [] -> [hand1: pair1, hand2: pair2, winner: "hand2"]
      highestPair1 == 1 && highestPair2 != 1 -> [hand1: pair1, hand2: pair2, winner: "hand1"]
      highestPair1 != 1 && highestPair2 == 1 -> [hand1: pair1, hand2: pair2, winner: "hand2"]
      highestPair1 > highestPair2 -> [hand1: pair1, hand2: pair2, winner: "hand1"]
      highestPair1 < highestPair2 -> [hand1: pair1, hand2: pair2, winner: "hand2"]
    end
  end

  # ******************************************

  def twoPair(data1, data2) do
    pair1 = data1[:hand] -- Enum.dedup(Enum.sort(data1[:hand]))
    pair2 = data2[:hand] -- Enum.dedup(Enum.sort(data2[:hand]))

    lowestPair1 = Enum.at(pair1, 0)
    lowestPair2 = Enum.at(pair2, 0)
    highestPair1 = Enum.at(pair1, -1)
    highestPair2 = Enum.at(pair2, -1)

    check1 = checkPair(lowestPair1, highestPair1)
    check2 = checkPair(lowestPair2, highestPair2)

    cond do
      pair1 == [] && pair2 == [] ->
        [hand1: pair1, hand2: pair2, winner: "tie"]

      pair1 === pair2 ->
        [hand1: pair1, hand2: pair2, winner: "tie"]

      check1 == false && check2 == false ->
        [hand1: pair1, hand2: pair2, winner: "tie"]

      check1 == true && check2 == false ->
        [hand1: pair1, hand2: pair2, winner: "hand1"]

      check1 == false && check2 == true ->
        [hand1: pair1, hand2: pair2, winner: "hand2"]

      check1 == true && check2 == true && lowestPair1 == 1 && lowestPair2 != 1 ->
        [hand1: pair1, hand2: pair2, winner: "hand1"]

      check1 == true && check2 == true && lowestPair1 != 1 && lowestPair2 == 1 ->
        [hand1: pair1, hand2: pair2, winner: "hand2"]

      check1 == true && check2 == false ->
        [hand1: pair1, hand2: pair2, winner: "hand1"]

      check1 == false && check2 == true ->
        [hand1: pair1, hand2: pair2, winner: "hand2"]

      check1 == true && check2 == true && highestPair1 > highestPair2 ->
        [hand1: pair1, hand2: pair2, winner: "hand1"]

      check1 == true && check2 == true && highestPair1 < highestPair2 ->
        [hand1: pair1, hand2: pair2, winner: "hand2"]
    end
  end

  def checkPair(lowestPair, highestPair) do
    if lowestPair == highestPair do
      false
    else
      true
    end
  end

  # ******************************************

  def triplet(data1, data2) do
    duplicates1 = data1[:hand] -- Enum.dedup(Enum.sort(data1[:hand]))
    duplicates2 = data2[:hand] -- Enum.dedup(Enum.sort(data2[:hand]))

    triplet1 = duplicates1 -- Enum.dedup(duplicates1)
    triplet2 = duplicates2 -- Enum.dedup(duplicates2)

    if triplet1 != [] && triplet2 != [] do
      cond do
        hd(triplet1) == 1 -> [hand1: triplet1, hand2: triplet2, winner: "hand1"]
        hd(triplet2) == 1 -> [hand1: triplet1, hand2: triplet2, winner: "hand2"]
        triplet1 > triplet2 -> [hand1: triplet1, hand2: triplet2, winner: "hand1"]
        triplet1 < triplet2 -> [hand1: triplet1, hand2: triplet2, winner: "hand2"]
        true -> [hand1: triplet1, hand2: triplet2, winner: "tie"]
      end
    else
      [hand1: [], hand2: [], winner: "tie"]
    end
  end

  def checkTriplet(duplicates), do: duplicates -- Enum.dedup(duplicates)

  # ******************************************

  def straight(data1, data2) do
    {straight1, highCard1} = checkStraight(hd(data1[:hand]), tl(data1[:hand]))
    {straight2, highCard2} = checkStraight(hd(data2[:hand]), tl(data2[:hand]))

    cond do
      straight1 == true && straight2 == true ->
        [hand1: straight1, hand2: straight2, winner: "tie"]

      straight1 == true && straight2 == false ->
        [hand1: straight1, hand2: straight2, winner: "hand1"]

      straight1 == false && straight2 == true ->
        [hand1: straight1, hand2: straight2, winner: "hand2"]

      straight1 == false && straight2 == false ->
        [hand1: straight1, hand2: straight2, winner: "tie"]
    end
  end

  def checkStraight(head, []), do: {true, head}

  def checkStraight(head, tail) do
    cond do
      head == hd(tail) - 1 -> checkStraight(hd(tail), tl(tail))
      head == 1 && hd(tail) == 10 -> checkStraight(10, tl(tail) ++ [14])
      true -> {false, 0}
    end
  end

  # ******************************************

  def flush(data1, data2) do
    {check1, suit1} = checkFlush(hd(data1[:suit]), tl(data1[:suit]))
    {check2, suit2} = checkFlush(hd(data2[:suit]), tl(data2[:suit]))

    cond do
      check1 == true && check2 == true && suit1 > suit2 -> [hand1: check1, hand2: check2, winner: "hand1"]
      check1 == true && check2 == true && suit1 < suit2 -> [hand1: check1, hand2: check2, winner: "hand2"]
      check1 == true && check2 == true && suit1 == suit2 -> [hand1: check1, hand2: check2, winner: "tie"]
      check1 == true && check2 == false -> [hand1: check1, hand2: check2, winner: "hand1"]
      check1 == false && check2 == true -> [hand1: check1, hand2: check2, winner: "hand2"]
      check1 == false && check2 == false -> [hand1: check1, hand2: check2, winner: "tie"]
    end
  end

  def checkFlush(suit, []) do
    cond do
      suit == "clubs" -> {true, 0}
      suit == "diamonds" -> {true, 1}
      suit == "hearts" -> {true, 2}
      suit == "spades" -> {true, 3}
    end
  end

  def checkFlush(suit, tail) do
    if suit == hd(tail) do
      checkFlush(suit, tl(tail))
    else
      {false, -1}
    end
  end

  # ******************************************

  def fullHouse(data1, data2) do
  end

  # ******************************************

  def quadruplet(data1, data2) do
  end

  # ******************************************

  def straightFlush(data1, data2) do
  end

  # ******************************************

  def royalFlush(data1, data2) do
  end
end
