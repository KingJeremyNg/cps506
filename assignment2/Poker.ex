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

      evaluation = evaluate(data1, data2)
      winner = getWinner(evaluation)

      cond do
        winner == "hand1" -> displayWinner(data1[:raw], [])
        winner == "hand2" -> displayWinner(data2[:raw], [])
      end
    else
      IO.puts("Not enough cards")
    end
  end

  # ******************************************

  def shuffle(), do: shuffle(Enum.to_list(1..52))

  def shuffle(list) do
    Enum.shuffle(list)
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

  def evaluate(data1, data2) do
    value = [
      # royalFlush: royalFlush(data1, data2)
      # straightFlush: straightFlush(data1, data2),
      quadruplet: quadruplet(data1, data2),
      # fullHouse: fullHouse(data1, data2),
      flush: flush(data1, data2),
      straight: straight(data1, data2),
      triplet: triplet(data1, data2),
      twoPair: twoPair(data1, data2),
      pair: pair(data1, data2),
      highCard: highCard(data1, data2)
    ]

    value = List.insert_at(value, 1, {:fullHouse, fullHouse(value)})
    value = List.insert_at(value, 0, {:straightFlush, straightFlush(value)})
    value = List.insert_at(value, 0, {:royalFlush, royalFlush(data1, data2, value)})
  end


  def getWinner(evaluation) do
    cond do
      evaluation[:royalFlush][:winner] == "hand1" -> "hand1"
      evaluation[:royalFlush][:winner] == "hand2" -> "hand2"
      evaluation[:straightFlush][:winner] == "hand1" -> "hand1"
      evaluation[:straightFlush][:winner] == "hand2" -> "hand2"
      evaluation[:quadruplet][:winner] == "hand1" -> "hand1"
      evaluation[:quadruplet][:winner] == "hand2" -> "hand2"
      evaluation[:fullHouse][:winner] == "hand1" -> "hand1"
      evaluation[:fullHouse][:winner] == "hand2" -> "hand2"
      evaluation[:flush][:winner] == "hand1" -> "hand1"
      evaluation[:flush][:winner] == "hand2" -> "hand2"
      evaluation[:straight][:winner] == "hand1" -> "hand1"
      evaluation[:straight][:winner] == "hand2" -> "hand2"
      evaluation[:triplet][:winner] == "hand1" -> "hand1"
      evaluation[:triplet][:winner] == "hand2" -> "hand2"
      evaluation[:twoPair][:winner] == "hand1" -> "hand1"
      evaluation[:twoPair][:winner] == "hand2" -> "hand2"
      evaluation[:pair][:winner] == "hand1" -> "hand1"
      evaluation[:pair][:winner] == "hand2" -> "hand2"
      evaluation[:highCard][:winner] == "hand1" -> "hand1"
      evaluation[:highCard][:winner] == "hand2" -> "hand2"
      evaluation[:highCard][:winner] == "tie" -> "tie"
    end
  end

  def displayWinner([], list), do: Enum.sort(list)

  def displayWinner(hand, list) do
    card = getCard(hd(hand))
    suit = getSuit(hd(hand))

    list = list ++ [Integer.to_string(card) <> String.capitalize(String.at(suit, 0))]

    displayWinner(tl(hand), list)
  end

  # ******************************************

  def highCard(data1, data2) do
    {value1} = getHighCard(Enum.sort(data1[:raw]), 0, 0)
    {value2} = getHighCard(Enum.sort(data2[:raw]), 0, 0)

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
      target == 99 -> {99}
      true -> {getCard(rawValue)}
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
      pair1 == [] && pair2 == [] -> [hand1: false, hand2: false, winner: "tie"]
      pair1 === pair2 -> [hand1: true, hand2: true, winner: "tie"]
      pair1 != [] && pair2 == [] -> [hand1: true, hand2: false, winner: "hand1"]
      pair1 == [] && pair2 != [] -> [hand1: false, hand2: true, winner: "hand2"]
      highestPair1 == 1 && highestPair2 != 1 -> [hand1: true, hand2: true, winner: "hand1"]
      highestPair1 != 1 && highestPair2 == 1 -> [hand1: true, hand2: true, winner: "hand2"]
      highestPair1 > highestPair2 -> [hand1: true, hand2: true, winner: "hand1"]
      highestPair1 < highestPair2 -> [hand1: true, hand2: true, winner: "hand2"]
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
        [hand1: false, hand2: false, winner: "tie"]

      pair1 === pair2 ->
        [hand1: true, hand2: true, winner: "tie"]

      check1 == false && check1 == false ->
        [hand1: check1, hand2: check1, winner: "tie"]

      check1 == true && check2 == false ->
        [hand1: check1, hand2: check1, winner: "hand1"]

      check1 == false && check2 == true ->
        [hand1: check1, hand2: check1, winner: "hand2"]

      check1 == true && check2 == true && lowestPair1 == 1 && lowestPair2 != 1 ->
        [hand1: check1, hand2: check1, winner: "hand1"]

      check1 == true && check2 == true && lowestPair1 != 1 && lowestPair2 == 1 ->
        [hand1: check1, hand2: check1, winner: "hand2"]

      check1 == true && check2 == false ->
        [hand1: check1, hand2: check1, winner: "hand1"]

      check1 == false && check2 == true ->
        [hand1: check1, hand2: check1, winner: "hand2"]

      check1 == true && check2 == true && highestPair1 > highestPair2 ->
        [hand1: check1, hand2: check1, winner: "hand1"]

      check1 == true && check2 == true && highestPair1 < highestPair2 ->
        [hand1: check1, hand2: check1, winner: "hand2"]
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

    {check1, value1} = checkTriplet(triplet1)
    {check2, value2} = checkTriplet(triplet2)

    cond do
      check1 == true && value1 == 1 ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check2 == true && value2 == 1 ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == true && check2 == true && value1 > value2 ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check1 == true && check2 == true && value1 < value2 ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == true && check2 == false ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check1 == false && check2 == true ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == false && check2 == false ->
        [hand1: check1, hand2: check2, winner: "tie"]
    end
  end

  def checkTriplet(list) do
    if list == [] do
      {false, 0}
    else
      {true, hd(list)}
    end
  end

  # ******************************************

  def straight(data1, data2) do
    {straight1, highCard1} = checkStraight(hd(data1[:hand]), tl(data1[:hand]))
    {straight2, highCard2} = checkStraight(hd(data2[:hand]), tl(data2[:hand]))

    cond do
      straight1 == true && straight2 == true && highCard1 == highCard2 ->
        [hand1: straight1, hand2: straight2, winner: "tie"]

      straight1 == true && straight2 == true && highCard1 > highCard2 ->
        [hand1: straight1, hand2: straight2, winner: "hand1"]

      straight1 == true && straight2 == true && highCard1 < highCard2 ->
        [hand1: straight1, hand2: straight2, winner: "hand2"]

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
      check1 == true && check2 == true && suit1 > suit2 ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check1 == true && check2 == true && suit1 < suit2 ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == true && check2 == true && suit1 == suit2 ->
        [hand1: check1, hand2: check2, winner: "tie"]

      check1 == true && check2 == false ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check1 == false && check2 == true ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == false && check2 == false ->
        [hand1: check1, hand2: check2, winner: "tie"]
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

  def fullHouse(evaluation) do
    fullHouse1 = evaluation[:triplet][:hand1] && evaluation[:pair][:hand1]
    fullHouse2 = evaluation[:triplet][:hand2] && evaluation[:pair][:hand1]

    tripletWinner = evaluation[:triplet][:winner]

    cond do
      fullHouse1 == true && fullHouse2 == true && tripletWinner == "hand1" ->
        [hand1: fullHouse1, hand2: fullHouse2, winner: "hand1"]

      fullHouse1 == true && fullHouse2 == true && tripletWinner == "hand2" ->
        [hand1: fullHouse1, hand2: fullHouse2, winner: "hand2"]

      fullHouse1 == true && fullHouse2 == true && tripletWinner == "tie" ->
        [hand1: fullHouse1, hand2: fullHouse2, winner: "tie"]

      fullHouse1 == true && fullHouse2 == false ->
        [hand1: fullHouse1, hand2: fullHouse2, winner: "hand1"]

      fullHouse1 == false && fullHouse2 == true ->
        [hand1: fullHouse1, hand2: fullHouse2, winner: "hand2"]

      fullHouse1 == false && fullHouse2 == false ->
        [hand1: fullHouse1, hand2: fullHouse2, winner: "tie"]
    end
  end

  # ******************************************

  def quadruplet(data1, data2) do
    duplicates1 = data1[:hand] -- Enum.dedup(Enum.sort(data1[:hand]))
    duplicates2 = data2[:hand] -- Enum.dedup(Enum.sort(data2[:hand]))

    triplet1 = duplicates1 -- Enum.dedup(duplicates1)
    triplet2 = duplicates2 -- Enum.dedup(duplicates2)

    quadruplet1 = triplet1 -- Enum.dedup(triplet1)
    quadruplet2 = triplet2 -- Enum.dedup(triplet2)

    {check1, value1} = checkQuadruplet(quadruplet1)
    {check2, value2} = checkQuadruplet(quadruplet2)

    cond do
      check1 == true && value1 == 1 ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check2 == true && value2 == 1 ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == true && check2 == true && value1 > value2 ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check1 == true && check2 == true && value1 < value2 ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == true && check2 == false ->
        [hand1: check1, hand2: check2, winner: "hand1"]

      check1 == false && check2 == true ->
        [hand1: check1, hand2: check2, winner: "hand2"]

      check1 == false && check2 == false ->
        [hand1: check1, hand2: check2, winner: "tie"]
    end
  end

  def checkQuadruplet(list) do
    if list == [] do
      {false, 0}
    else
      {true, hd(list)}
    end
  end

  # ******************************************

  def straightFlush(evaluation) do
    straightFlush1 = evaluation[:straight][:hand1] && evaluation[:flush][:hand1]
    straightFlush2 = evaluation[:straight][:hand2] && evaluation[:flush][:hand2]

    # straightWinner = evaluation[:straight][:winner]
    flushWinner = evaluation[:flush][:winner]

    cond do
      straightFlush1 == true && straightFlush2 == true && flushWinner == "hand1" ->
        [hand1: straightFlush1, hand2: straightFlush2, winner: "hand1"]

        straightFlush1 == true && straightFlush2 == true && flushWinner == "hand2" ->
        [hand1: straightFlush1, hand2: straightFlush2, winner: "hand2"]

      straightFlush1 == true && straightFlush2 == true && flushWinner == "tie" ->
        [hand1: straightFlush1, hand2: straightFlush2, winner: "tie"]

      straightFlush1 == true && straightFlush2 == false ->
        [hand1: straightFlush1, hand2: straightFlush2, winner: "hand1"]

      straightFlush1 == false && straightFlush2 == true ->
        [hand1: straightFlush1, hand2: straightFlush2, winner: "hand2"]

      straightFlush1 == false && straightFlush2 == false ->
        [hand1: straightFlush1, hand2: straightFlush2, winner: "tie"]
    end
  end

  # ******************************************

  def royalFlush(data1, data2, evaluation) do
    royalFlush1 = evaluation[:flush][:hand1] && (Enum.sort(data1[:hand]) == [1,10,11,12,13])
    royalFlush2 = evaluation[:flush][:hand2] && (Enum.sort(data2[:hand]) == [1,10,11,12,13])

    flushWinner = evaluation[:flush][:winner]

    cond do
      royalFlush1 == true && royalFlush2 == true && flushWinner == "hand1" ->
        [hand1: royalFlush1, hand2: royalFlush2, winner: "hand1"]

        royalFlush1 == true && royalFlush2 == true && flushWinner == "hand2" ->
        [hand1: royalFlush1, hand2: royalFlush2, winner: "hand2"]

      royalFlush1 == true && royalFlush2 == true && flushWinner == "tie" ->
        [hand1: royalFlush1, hand2: royalFlush2, winner: "tie"]

      royalFlush1 == true && royalFlush2 == false ->
        [hand1: royalFlush1, hand2: royalFlush2, winner: "hand1"]

      royalFlush1 == false && royalFlush2 == true ->
        [hand1: royalFlush1, hand2: royalFlush2, winner: "hand2"]

      royalFlush1 == false && royalFlush2 == false ->
        [hand1: royalFlush1, hand2: royalFlush2, winner: "tie"]
    end
  end
end
