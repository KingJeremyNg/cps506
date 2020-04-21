module Poker where

    import Data.Ord
    import Data.List
    import System.Random

    -- Deal cards into 2 hands
    separate list = ([x | x <- list, x `mod` 2 == 0], [x | x <- list, x `mod` 2 == 1])

    -- Get the card values of hand
    cardValue list = sort [(x - 1) `mod` 13 | x <- list]

    -- Get the suit values of hand
    suitValue list = sort [(x - 1) `div` 13 | x <- list]

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
        | suitH == 0 = stringify handT suitT (concat [list, [show handH ++ "C"]])
        | suitH == 1 = stringify handT suitT (concat [list, [show handH ++ "D"]])
        | suitH == 2 = stringify handT suitT (concat [list, [show handH ++ "H"]])
        | suitH == 3 = stringify handT suitT (concat [list, [show handH ++ "S"]])

    -- THIS NEEDS WORK
    -- evaluate (hand1, suit1) (hand2, suit2)
    --     | royalFlush hand1 == True && royalFlush hand2 == False = stringify hand1 suit1 []
    --     | royalFlush hand1 == False && royalFlush hand2 == True = stringify hand2 suit2 []
    --     | straightFlush hand1 == True && straightFlush hand2 == False = stringify hand1 suit1 []
    --     | straightFlush hand1 == False && straightFlush hand2 == True = stringify hand1 suit1 []
    --     | otherwise = "TIE"

    royalFlush hand =
        case hand of
            [0, 9, 10, 11, 12] -> True
            [_, _, _, _, _] -> False
    
    -- deal list = evaluate (sort list)

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