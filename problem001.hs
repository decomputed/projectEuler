--
-- Multiples of 3 and 5
--

multiple :: Int -> Int -> Bool
multiple number factor = (number `mod` factor) == 0

multipleOf :: Int -> [Int] -> Bool
multipleOf number factors = any (multiple number) factors

sumNaturals :: Int -> [Int] -> Int
sumNaturals limit divisors = sum [num | num <- [1..limit-1], 
	    	  	     	      	multipleOf num divisors]

