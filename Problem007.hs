module Problem007 where

import Data.List

--
-- Trial and division
-- yaaaaaaaaaaaaaaaaay
--


isPrime :: Integral a => a -> Bool
isPrime n | n == 2		 = True
	  | n < 2 || even n    	 = False
	  | otherwise 	  	 = not (any (\i -> n `mod` i == 0) [3..n-1])

trialAndDivision limit = [n | n <- [2..limit], isPrime n]


----------------------

isPrime2 :: Integral a => a -> Bool
isPrime2 n | n == 2		 = True
	  | otherwise 	  	 = not (any (\i -> n `mod` i == 0) [3..n-1])

trialAndDivision2 limit = 2:3:5:[n | n <- [7,9..limit], isPrime2 n]


--
-- Sieves
-- Contains implementations of several sieves
--



{------------------------------------------------

The first implementation was very naive, and only meant to see how long would a typical calculation take. It also was direct copy of what the definition on wikipedia says:

"...enumerate its multiples by counting to n in increments of p, and mark them in the list..." So, even though this enumeration is just a test for a number being a multiple of another, I went with an implementation which really got created a list with those multiples.

Total running time for erastothenes1 100000 --> 248.81 secs

-------------------------------------------------}

erastothenes1 limit = eSieve1 [2..limit] []

eSieve1 [] primes = primes
eSieve1 (x:xs) primes = eSieve1
			([y | y <- xs, not (y `isMultiple` x)])
			(primes++[x])

isMultiple :: Int -> Int -> Bool
isMultiple n = \x -> elem n [x,x+x..n]

{------------------------------------------------

Now, it is obvious that the function isMultiple is not really needed - instead I can simply verify that the remainder of the division is 0 and if so, the number is a multiple.

Total running time for erastothenes2 100000 --> 66.67 secs, which is about 4 times faster, mainly by avoiding the creation of so many lists. Which is rather obvious.

-------------------------------------------------}

erastothenes2 limit = eSieve2 [2..limit] []

eSieve2 [] primes = primes
eSieve2 (x:xs) primes = eSieve2
			([y | y <- xs, y `mod` x /= 0])
			(primes++[x])

{------------------------------------------------

Let's do some final improvements:

- I have understood that cons on lists is faster than list concatenation, so let's do that replacement
- We don't really need to consider even numbers in the original list since we know they'll never be prime except for 2

Running time for erastothenes3 100000 --> 77.94 secs

-------------------------------------------------}

erastothenes3 limit = eSieve3 [3,5..limit] [2]

eSieve3 [] primes = primes
eSieve3 (x:xs) primes = eSieve3
			([y | y <- xs, y `mod` x /= 0])
			(x:primes)

{------------------------------------------------
-------------------------------------------------}

sundaram1 limit = let limit' = (limit `div` 2) in
	  	      2 : (map (\n -> 2*n+1)
	       	     	  ([1..limit'] \\ [i + j + 2*i*j | i <- [1..limit'], j <- [i..limit']]))

{------------------------------------------------
-------------------------------------------------}

sundaram2 limit = let limit' = (limit `div` 2) in
	  	      2:[2*n+1 | n <- [1..limit'],
		      	       	 not (n `elem` [i + j + 2*i*j | i <- [1..limit'],
				     	       	      	      	j <- [i..limit']])]

{------------------------------------------------
-------------------------------------------------}

sundaram3 limit = let limit' = (limit `div` 2) 
	  	      sieve = [i + j + 2*i*j | i <- [1..limit'],
				     	       j <- [i..limit']] in
	  	  2:[2*n+1 | n <- [1..limit'],
		      	     not (n `elem` sieve)]

{------------------------------------------------
-------------------------------------------------}

sundaram4 :: Int -> [Int]
sundaram4 limit = let limit' = (limit `div` 2) in
	  	  let sieve = [i + j + 2*i*j | let n' = fromIntegral limit',
                           	       	       i <- [1..floor (sqrt (n' / 2))],
                           		       let i' = fromIntegral i,
                           		       j <- [i..floor( (n'-i')/(2*i'+1))]] in
	  	  2:[2*n+1 | n <- [1..limit'],
		      	     not (n `elem` sieve)]

{------------------------------------------------
-------------------------------------------------}

initialSundaramSieve limit = let topi = floor (sqrt ((fromIntegral limit) / 2)) in
	  	             [i + j + 2*i*j | i <- [1..topi],
                           		      j <- [i..floor((fromIntegral(limit-i)) / fromIntegral(2*i+1))]]

sundaram5 limit = let halfLimit = (limit `div` 2) in
	  	      2:removeComposites ([1..halfLimit]) (sort $ initialSundaramSieve halfLimit) 

removeComposites []     _                  = []
removeComposites sieve  []                 = sieve
removeComposites (s:ss) (c:cs) | s == c    = removeComposites ss cs
		 	       | s > c     = removeComposites (s:ss) cs
			       | otherwise = 2*s+1 : (removeComposites ss (c:cs))

{--------------------------------------------------

So now we get 0.40 secs for sundaram4 10000 and 38.16 seconds for sundaram4 100000.

So now let's try to do the Atkin Sieve, which is a bit like the Erastothenes Sieve, but with more math!

----------------------------------------------------}

--initialAtkinSieve limit = zip [2..limit] (take limit [0,0..])
initialAtkinSieve limit = sort $ zip
				  [60 * w + x | w <- [0..limit `div` 60],
				      	        x <- [1,7,11,13,17,19,23,29,31,37,41,43,47,49,53,59]]
				  (take limit [0,0..])

aFlip :: (x,Int) -> (x,Int)
aFlip (x,1) = (x,0)
aFlip (x,0) = (x,1)


flipAll :: [Int] -> [(Int, Int)] -> [(Int, Int)]
flipAll _      []     = []
flipAll []     ss     = ss
flipAll (f:fs) ((s,b):ss) = if s < f
	       	      	then (s,b): (flipAll (f:fs) ss)
			else if s == f
			     then flipAll fs ((aFlip (s,b)):ss)
			     else flipAll fs ((s,b):ss)


firstStep sieve = let size = (fst $ last sieve)
	  	      topx = floor(sqrt(fromIntegral (size `div` 4)))
		      topy = floor(sqrt(fromIntegral size)) in
	  	  flipAll (sort [n | n <- [4*x^2 + y^2| x <- [1..topx],
		  	  	       	  	   	y <- [1,3..topy]],
							n `mod` 60 `elem` [1,13,17,29,37,41,49,53]])
                          sieve


secondStep sieve = let size = (fst $ last sieve)
	   	       topx = floor(sqrt(fromIntegral (size `div` 3)))
		       topy = floor(sqrt(fromIntegral size)) in
                     flipAll (sort [n | n <- [3*x^2 + y^2
                                           | x <- [1,3..topx],
                                             y <- [2,4..topy]],
					     n `mod` 60 `elem` [7,19,31,43]])
                           sieve


thirdStep sieve = let size = (fst $ last sieve)
	  	      topx = floor(sqrt(fromIntegral size)) in
                    flipAll (sort [n | n <- [3*x^2 - y^2
		                                | x <- [1..topx],
                                                  y <- [(x-1),(x-3)..1],
						  x>y],
						  n `mod` 60 `elem` [11,23,47,59]])
                           sieve

reduceList _      []         = []
reduceList number ((x,b):xs) = if   x >= number && x `mod` number == 0
	   	  	       then (x,0) : (reduceList number xs)
			       else (x,b) : (reduceList number xs)


reduceListAndUnmark candidate sieve = let limit = (fst $ last sieve) in
		    	      	      unmarkAll [candidate * m | m <-[1,7,11,13,17,19,23,29,31,37,41,43,47,49,53,59],
                                                                candidate * m <= limit]
						sieve


unmarkAll _        []         = []
unmarkAll []       sieve      = sieve
unmarkAll (np:nps) ((s,b):ss) = if np == s
	  	   	      	then (unmarkAll nps ((s,0):ss))
				else if   np < s
				     then unmarkAll nps ((s,b):ss)
				     else (s,b) : (unmarkAll (np:nps) ss)


atkin1 limit = aSieve2 (thirdStep . secondStep . firstStep $ initialAtkinSieve limit) [(5,1),(3,1),(2,1)]

aSieve2 []         primes = primes
aSieve2 ((x,b):xs) primes = if   b == 1
		   	    then aSieve2 (reduceListAndUnmark (x^2) xs) ((x,b): primes)
			    else aSieve2 xs                             primes


aSieve1 []         primes = primes
aSieve1 ((x,b):xs) primes = if   b == 1
		   	    then aSieve1 (reduceList (x^2) xs) ((x,b): primes)
			    else aSieve1 xs                    primes

