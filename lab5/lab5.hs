module Lab5 where

thirdLast :: [a] -> a
thirdLast lst = head(drop (length(lst) - 3) lst)

everyOther :: [a] -> [a]
everyOther lst = [snd x | x <- (zip [0..] lst), even(fst x)]

-- sumPosList :: (Num p, Ord p) => [p] -> p