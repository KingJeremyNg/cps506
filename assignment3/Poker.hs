module Poker where

    import Data.Ord
    import Data.List
    import System.Random

    -- Deal cards into 2 hands
    separate list 0 (hand1, hand2) = (hand1, hand2)
    separate (listH: listT) n (hand1, hand2)
        | n `mod` 2 == 0 = separate listT (n - 1) (hand1 ++ [listH], hand2)
        | n `mod` 2 == 1 = separate listT (n - 1) (hand1, hand2 ++ [listH])

    -- Get the card values of hand
    cardValue list = sort [(x - 1) `mod` 13 | x <- list]

    -- Get the suit values of hand
    suitValue list = [(x - 1) `div` 13 | x <- list]

    -- Find all occurrences of a card in hand
    occurrences list item = length [x | x <- list, x == item]

    -- Check if item exists in list
    has [] _ = False
    has (x: xs) item
        | x == item = True
        | otherwise = has xs item

    -- Converting hand into string list
    stringify [] _ list = list
    stringify (handH: handT) (suitH: suitT) list
        | suitH == 0 = stringify handT suitT (concat [list, [show (handH + 1) ++ "C"]])
        | suitH == 1 = stringify handT suitT (concat [list, [show (handH + 1) ++ "D"]])
        | suitH == 2 = stringify handT suitT (concat [list, [show (handH + 1) ++ "H"]])
        | suitH == 3 = stringify handT suitT (concat [list, [show (handH + 1) ++ "S"]])

    -- *******************************************

    -- DETECTION FUNCTIONS
    hasFlush hand
        | occurrences (suitValue hand) 0 == 5 = True
        | occurrences (suitValue hand) 1 == 5 = True
        | occurrences (suitValue hand) 2 == 5 = True
        | occurrences (suitValue hand) 3 == 5 = True
        | otherwise = False
    
    hasStraight (handH: handT)
        | handT == [] = True
        | head (handT) == handH + 1 = hasStraight handT
        | otherwise = False

    findDuplicate [] _ dupe = dupe
    findDuplicate (handH: handT) runningList dupe
        | has runningList handH == True = findDuplicate (handT) runningList (dupe ++ [handH])
        | otherwise = findDuplicate (handT) (runningList ++ [handH]) dupe
    
    compareCards hand1 hand2 [] [] = []
    compareCards hand1 hand2 (x: xs) (y: ys)
        | x == y = compareCards hand1 hand2 xs ys
        | x > y = hand1
        | x < y = hand2

    detectHighCard hand1 hand2
        | head (sort hand1) == 1 && head(sort hand2) /= 1 = hand1
        | head (sort hand1) /= 1 && head(sort hand2) == 1 = hand2
        | otherwise = compareCards hand1 hand2 (reverse (sort hand1)) (reverse (sort hand2))
    
    -- *******************************************

    -- Main deal function
    deal list = start (separate list 10 ([], []))

    -- Start of the evaluation process
    start (hand1, hand2) = highCard hand1 hand2

    highCard hand1 hand2
        | detectHighCard hand1 hand2 == hand1 = hand1
        | detectHighCard hand1 hand2 == hand2 = hand2
        | otherwise = "tie"

    -- -- Find winner for high card scenario, then move onto pair
    -- highCard data1 data2 [] [] [] [] winner = pair data1 data2 (fst data1) (snd data2) (fst data1) (snd data2) winner
    -- highCard data1 data2 (hand1H: hand1T) (suit1H: suit1T) (hand2H: hand2T) (suit2H: suit2T) winner
    --     -- Check ace cards first
    --     | hand1H == 0 && hand2H /= 0 = pair data1 data2 (fst data1) (snd data2) (fst data1) (snd data2) "hand1"
    --     | hand1H /= 0 && hand2H == 0 = pair data1 data2 (fst data1) (snd data2) (fst data1) (snd data2) "hand2"
    --     | hand1H == 0 && hand2H == 0 && suit1H > suit2H = highCard data1 data2 hand1T suit1T hand2T suit2T "hand1"
    --     | hand1H == 0 && hand2H == 0 && suit1H < suit2H = highCard data1 data2 hand1T suit1T hand2T suit2T "hand2"
    --     -- If card is equal then check suit
    --     | hand1H == hand2H && suit1H > suit2H = highCard data1 data2 hand1T suit1T hand2T suit2T "hand1"
    --     | hand1H == hand2H && suit1H < suit2H = highCard data1 data2 hand1T suit1T hand2T suit2T "hand2"
    --     -- Compare 2 cards
    --     | hand1H > hand2H = pair data1 data2 hand1T suit1T hand2T suit2T "hand1"
    --     | hand1H < hand2H = pair data1 data2 hand1T suit1T hand2T suit2T "hand2"
    --     -- | otherwise = highCard data1 data2 hand1T suit1T hand2T suit2T winner
    
    -- Find all pairs, then move onto 3 of a kind
    -- pair data1 data2 [] [] [] [] winner = threeKind data1 data2 (fst data1) (snd data2) (fst data1) (snd data2) winner
    -- pair data1 data2 (hand1H: hand1T) (suit1H: suit1T) (hand2H: hand2T) (suit2H: suit2T) winner
    --     | occurrences (fst data1) 0 == 2 = "ok" --
    --     | otherwise = pair data1 data2 hand1T suit1T hand2T suit2T winner

    -- threeKind data1 data2 (hand1H: hand1T) (suit1H: suit1T) (hand2H: hand2T) (suit2H: suit2T) winner = winner ++ show ([x + 1 | x <- fst data1]) ++ show ([x + 1 | x <- fst data2])

    {-
    royal flush
    straight flush
    4 of a kind
    full house
    flush
    straight
    3 of a kind
    2 pair, pair, high card
    -}

{-
find occurrences for pairs etc
boolean function for checking
performing mod operation
integer division for every item
convert poker hand to string
deal should be cases and pattern matching *
-}