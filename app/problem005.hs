
isDivisible :: Int -> [Int] -> Bool
isDivisible y [x] = y `mod` x == 0
isDivisible y (x:xs) = y `mod` x == 0 && isDivisible y xs

firstDivisible = head [x | x <- [20,40..],
	       	      	   isDivisible x [20,19..5]]