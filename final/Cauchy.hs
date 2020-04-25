module Cauchy where

    data CauchyList = CauchyList Int [Int]

    compareList (list1H: list1T) (list2H: list2T)
        | list1H == list2H && ((list1T == []) || (list2T == [])) = True
        | list1H == list2H = compareList list1T list2T
        | otherwise = False

    addList list1 list2
        | (length list1) == (length list2) = zipWith (+) list1 list2
        | (length list1) < (length list2) = zipWith (+) (extendList list1 (length list2)) list2
        | (length list1) > (length list2) = zipWith (+) list1 (extendList list2 (length list1))

    extendList list n
        | (length list == n) = list
        | (length list < n) = extendList (list ++ [0]) n

    subtractList list1 list2
        | (length list1) == (length list2) = zipWith (-) list1 list2
        | (length list1) < (length list2) = zipWith (-) (extendList list1 (length list2)) list2
        | (length list1) > (length list2) = zipWith (-) list1 (extendList list2 (length list1))

    multiplyList list1 list2
        | (length list1) == (length list2) = multiplyListCalculate (tail list1) (tail list2) [head list1] [head list2] []
        | otherwise = multiplyList (extendList list1 ((length list1) + (length list2))) (extendList list2 ((length list1) + (length list2)))

    multiplyListCalculate (x: xs) (y: ys) list1 list2 answer
        | xs == [] && ys == [] = (answer ++ [(sum (zipWith (*) list1 (reverse list2)))])
        | otherwise = multiplyListCalculate xs ys (list1 ++ [x]) (list2 ++ [y]) (answer ++ [(sum (zipWith (*) list1 (reverse list2)))])

    -- ==
    instance Eq CauchyList where
        CauchyList num1 list1 == CauchyList num2 list2
            | num1 == num2 && compareList list1 list2 == True = True
            | otherwise = False

    -- +, -, *, abs, sigNum, fromInt
    instance Num CauchyList where
        CauchyList num1 list1 + CauchyList num2 list2 =
            CauchyList num1 [x `mod` num1 | x <- addList list1 list2]

        CauchyList num1 list1 - CauchyList num2 list2 =
            CauchyList num1 [x `mod` num1 | x <- subtractList list1 list2]

        CauchyList num1 list1 * CauchyList num2 list2 =
            CauchyList num1 [x `mod` num1 | x <- multiplyList list1 list2]

        abs (CauchyList num list) = CauchyList num [abs x | x <- list]

        signum (CauchyList num list) = CauchyList num [signum x | x <- list]

        fromInteger n = CauchyList (fromIntegral n) [fromIntegral n]

    -- Give a string that mimics the output. String representation
    instance Show CauchyList where
        show (CauchyList num list) =
            "p: " ++ show num ++ "\nlength: " ++ show (length list) ++ "\ncontent: " ++ show list
