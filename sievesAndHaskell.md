Sieves in Haskell

Ever since Project Euler's [problem 3](https://projecteuler.net/problem=3) that I wanted to try calculating prime numbers using a [sieve](https://en.wikipedia.org/wiki/Generating_primes#Prime_sieves). It's really not a complicated task but I guess sometimes the problems in Project Euler are so easily solvable with a one liner that I just kept postponing it.

Well, problem 7, which asks what is the 10001st prime number, really makes it very clear that it is not a good solution to keep relying on trial division to find prime numbers. So this is two day story on prime numbers, sieves and haskel.

## Trial division

We should still try to solve this with trial division, at least to have the baseline for all the other algorithms:

        isPrime :: Integral a => a -> Bool
        isPrime n | n == 2		 = True
        	  | n < 2 || even n    	 = False
        	  | otherwise 	  	 = not (any (\i -> n `mod` i == 0) [3..n-1])

        trialAndDivision limit = [n | n <- [2..limit], isPrime n]

This primality test is very basic (it's the one I used for [problem 3](https://projecteuler.net/problem=3)) and the amount of optimizations is very low - I never try division by 2 and even numbers return false immediatelly.

So, so how will these tests be done?

I'm running this on my laptop (a 2,66 GHz Intel Core i7 Macbook Pro from 2010, with 8 gigs of RAM) and apart from the command line only Firefox and emacs are running.

All test cases are compiled with `-O1` and they never print anything to the screen. The app is always something like:

import Problem007

main = print . length $	trialAndDivision 1000

So, back to the unoptimized version:

trialAndDivision 1000 = 0.01s user 0.00s system 42% cpu 0.031 total
trialAndDivision 10000 = 0.36s user 0.01s system 94% cpu 0.388 total
trialAndDivision 100000 = 24.78s user 0.27s system 99% cpu 25.093 total

25 seconds for primes up to 100000 is already way too much but there's a couple small optimizations we can do: instead of testing for <2 and for even inside isPrime (which happens for all numbers) we can make the lazy list go only over odd numbers:


isPrime2 :: Integral a => a -> Bool
isPrime2 n | n == 2		 = True
	   | otherwise 	  	 = not (any (\i -> n `mod` i == 0) [3..n-1])

trialAndDivision2 limit = 2:3:5:[n | n <- [7,9..limit], isPrime2 n]

And now:

trialAndDivision 1000 = 0.01s user 0.00s system 42% cpu 0.030 total
trialAndDivision 10000 = 0.35s user 0.01s system 94% cpu 0.381 total
trialAndDivision 100000 = 25.49s user 0.30s system 99% cpu 25.903 total

So there is a difference indeed -- it now takes us 1 second more! So, let's leave trial and division behind and let's go over to the Sieves.


## Aristothenes

Aristothenes of Cyrene has an amazing CV, capable of making anyone feel pretty useless. However we'll be focusing on the calculation of Prime numbers using the Aristothenes Sieve. Here's my first implementation:

        erastothenes1 limit = eSieve1 [2..limit] []

        eSieve1 [] primes = primes
        eSieve1 (x:xs) primes = eSieve1
        			([y | y <- xs, not (y `isMultiple` x)])
        			(primes++[x])

        isMultiple :: Int -> Int -> Bool
        isMultiple n = \x -> elem n [x,x+x..n]


The first implementation was very naive, and only meant to see how long would a typical calculation take. It also was direct copy of what the definition on wikipedia says:

"...enumerate its multiples by counting to n in increments of p, and mark them in the list..." So, even though this enumeration is just a test for a number being a multiple of another, I went with an implementation which really created a list with all those multiples.

erastothenes1 1000 = 0.01s user 0.00s system 51% cpu 0.034 total
erastothenes1 10000 = 1.08s user 0.02s system 98% cpu 1.112 total
erastothenes1 100000 = 111.72s user 1.86s system 99% cpu 1:54.04 total

So, one could say that the sieves aren't really living up to their promises but it's just my implementation that sucks really.

So now we start with optimizations. It is obvious that the function isMultiple is not really needed - instead I can simply verify that the remainder of the division is 0 and if so, the number is a multiple.

        erastothenes2 limit = eSieve2 [2..limit] []

        eSieve2 [] primes = primes
        eSieve2 (x:xs) primes = eSieve2
        			([y | y <- xs, y `mod` x /= 0])
        			(primes++[x])

erastothenes2 1000 = 0.00s user 0.00s system 30% cpu 0.024 total
erastothenes2 10000 = 0.07s user 0.00s system 80% cpu 0.092 total
erastothenes2 100000 = 9.77s user 0.09s system 99% cpu 9.909 total


Now that is a lot better, and more than twice as fast than trial and division for the same number, and mainly by avoiding the creation of so many lists. Which was rather obvious.

So let's try to beat that then and do some final improvements:

- I have understood that cons on lists is faster than list concatenation, so let's do that replacement
- We don't really need to consider even numbers in the original list since we know they'll never be prime except for 2


        erastothenes3 limit = eSieve3 [3,5..limit] [2]

        eSieve3 [] primes = primes
        eSieve3 (x:xs) primes = eSieve3
        			([y | y <- xs, y `mod` x /= 0])
        			(x:primes)

erastothenes3 1000 = 0.00s user 0.00s system 21% cpu 0.022 total
erastothenes3 10000 = 0.05s user 0.00s system 75% cpu 0.071 total
erastothenes3 100000 = 7.64s user 0.06s system 99% cpu 7.732 total

Only 2 seconds faster. So I think this is enough optimizations so let's try a final execution for 1 million

erastothenes3 1000000 ---> 1050.20s user 8.14s system 99% cpu 17:39.44 total

17 minutes!!! I would hope to get to something below 1 minute to be honest... but let's try that with the next sieves then.

...................

## Sundaram

Sundaram also created a Sieve which is said to be better than Erastothenes' sieve so let's see if that's true:

        import Data.List

        sundaram1 limit = let limit' = (limit `div` 2) in
        	  	      2 : (map (\n -> 2*n+1)
        	       	     	  ([1..limit'] \\ [i + j + 2*i*j | i <- [1..limit'], j <- [i..limit']]))

sundaram1 1000 = 5.62s user 0.07s system 99% cpu 5.741 total
sundaram1 10000 = 598.78s user 5.22s system 99% cpu 10:04.71 total and was still going...
sundaram1 100000 = 


sundaram1 1000 runs in 9.59 secs and it is absurdly slow, even worse than Erastothenes. So I must be doing something wrong.

Let's see now, there's a few things I don't like in this version, chief amongst them the fact that I used \\ to do something like a set operation on the sieve when instead of that, I think I can use list comprehensions which should decrease the amount of operations. 

        sundaram2 limit = let limit' = (limit `div` 2) in
        	  	      2:[2*n+1 | n <- [1..limit'],
        		      	       	 not (n `elem` [i + j + 2*i*j | i <- [1..limit'],
        				     	       	      	      	j <- [i..limit']])]

sundaram1 1000 = 0.34s user 0.01s system 95% cpu 0.371 total
sundaram1 10000 = 175.05s user 1.27s system 99% cpu 2:56.51 total and going...
sundaram1 100000 = 


Still not good. So, what if we create a lexical scope around the actual sieve?

sundaram3 limit = let limit' = (limit `div` 2) 
	  	      sieve = [i + j + 2*i*j | i <- [1..limit'],
				     	       j <- [i..limit']] in
	  	  2:[2*n+1 | n <- [1..limit'],
		      	     not (n `elem` sieve)]

sundaram3 1000 ---> 0.34s user 0.01s system 95% cpu 0.367 total
sundaram3 10000 ---> 195.16s user 1.40s system 99% cpu 3:16.81 total and going....

So the answer has to be in mathematics. Let's look at the domain of i+j+2*i*j. i will clearly never go above sqrt(n/2) and since j starts in i, it will never go above (n-i)/(2i+1). So let's do those changes and try to limit the amount of numbers we generate in the sieve.

        sundaram4 :: Int -> [Int]
        sundaram4 limit = let limit' = (limit `div` 2) in
        	  	  let sieve = [i + j + 2*i*j | let n' = fromIntegral limit',
                                   	       	       i <- [1..floor (sqrt (n' / 2))],
                                   		       let i' = fromIntegral i,
                                   		       j <- [i..floor( (n'-i')/(2*i'+1))]] in
        	  	  2:[2*n+1 | n <- [1..limit'],
        		      	     not (n `elem` sieve)]

sundaram4 1000 ---> 0.01s user 0.00s system 32% cpu 0.027 total
sundaram4 10000 ---> 0.26s user 0.00s system 94% cpu 0.281 total
sundaram4 100000 ---> 31.39s user 0.14s system 99% cpu 31.596 total

So it's still lousy to be honest, since that is slower than the sieve of Aristothenes and supposedly it should have been faster. So let's try one more optimization: let's get rid of the `elem` call since that forces Haskell to go through the whole list, and let's rely on recursion instead:

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

sundaram5 1000 ---> 0.00s user 0.00s system 17% cpu 0.022 total
sundaram5 10000 ---> 0.01s user 0.00s system 41% cpu 0.030 total
sundaram5 100000 ---> 0.10s user 0.01s system 34% cpu 0.338 total

That's unbelievably faster!!!! So let's see what happens with 1 million:

sundaram5 1000000 ---> 1.56s user 0.11s system 98% cpu 1.690 total

and this gives me 78498 primes under 1 million, which is correct according to Wolfram Alpha. So that was cool! Let's see if the Sieve of Atkin can beat that:


## Atkin

The Sieve of Atkin has a lot more steps and follows a somewhat different logic. There are 3 mandatory passages over the original sieve, each of which may flip a certain composite number to prime and vice versa more than once.

So I created a few more helper functions and this is the result:

initialAtkinSieve limit = sort $ zip
				  [n | n <- [60 * w + x | w <- [0..limit `div` 60],
				      	                  x <- [1,7,11,13,17,19,23,29,31,37,41,43,47,49,53,59]],
					    n <= limit]							
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


unmarkMultiples n sieve =
    let limit = (fst $ last sieve) in
        unmarkAll [n | n <-[n,n+n..limit]] sieve


unmarkAll _        []         = []
unmarkAll []       sieve      = sieve
unmarkAll (np:nps) ((s,b):ss) = if np == s
	  	   	      	then (unmarkAll nps ((s,0):ss))
				else if   np < s
				     then unmarkAll nps ((s,b):ss)
				     else (s,b) : (unmarkAll (np:nps) ss)


atkin1 limit = aSieve1 (thirdStep . secondStep . firstStep $ initialAtkinSieve limit) [(5,1),(3,1),(2,1)]

aSieve1 []         primes = primes
aSieve1 ((x,b):xs) primes = if   b == 1
		   	    then aSieve1 (unmarkMultiples (x^2) xs) ((x,b): primes)
			    else aSieve1 xs                             primes

So let's see:

atkin1 1000 = 0.00s user 0.00s system 25% cpu 0.021 total
atkin1 10000 = 0.01s user 0.00s system 48% cpu 0.034 total
atkin1 100000 = 0.58s user 0.01s system 96% cpu 0.605 total

And for the big one:

atkin1 1000000 = 42.98s user 0.32s system 99% cpu 43.455 total

So that performance, although it's really nice overall, it sucks when compared to the sieve of Sundaram. So let's try to do some improvements.

One thing I don't like is the fact that I have to compose three functions to flip the prime status of the inital list of primes. I would prefer to do this operation in one go by concatenating the lists into one, sorting it once and in one passage flip all the primes.

So let's try that then.


