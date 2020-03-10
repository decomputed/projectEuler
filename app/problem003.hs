--
-- Largest prime factor
--

isPrime :: Integral a => a -> Bool
isPrime n | n == 2		 = True
	  | n < 2 || even n    	 = False
	  | otherwise 	  	 = not (any (\i -> n `mod` i == 0) [3..n-1])

factors x = factorsAux x [] [n | n <- [2..x], isPrime n]

factorsAux 1 fs _  = fs
factorsAux x fs ps = if (x `mod` (head ps)) == 0
	     	     then factorsAux (x `div` (head ps)) ((head ps):fs) ps
		     else factorsAux x fs (tail ps)

largestPrimeFactor x = maximum (factors x)
