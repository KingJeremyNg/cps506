module Test where

    -- Pattern matching
    has [] _ = False
    has (x: xs) item
        | x == item = True
        | otherwise = has xs item
    
    -- Matching item with list
    occurrences list item = [x | x <- list, x == item]

    -- create a list from another list but mod the items by certain value
    -- [list/modifications, generator, filter]
    listMod list value = [x `mod` value | x <- list]

    listEven list = [x | x <- list, x `mod` 2 == 0]

    addList list1 list2 = zipWith (+) list1 list2