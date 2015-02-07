module Problem007 where

--
-- Sieves
-- Contains implementations of several sieves
--

import Data.List

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

erastothenes3 limit = eSieve3 [5,7..limit] [3,2]

eSieve3 [] primes = primes
eSieve3 (x:xs) primes = eSieve3
			([y | y <- xs, y `mod` x /= 0])
			(x:primes)

{------------------------------------------------

Now that was unexpetected. I was expecting that by doing operations only on half of the original numbers, the total running time would decrease to at least half..

Running time for erastothenes3 100000 --> 77.94 secs

So maybe this is due to running the code from ghci instead of compiling it. And indeed, after compilation:

erastothenes2 100000 ---> 11.9 s
erastothenes3 100000 ---> 11.4 s

Only 500 miliseconds faster. On the other hand, it's a speed gain of almost 6 times versus executing it on GHCI!! So let's try with a bigger number:

erastothenes2 1000000 ---> 31m53s
erastothenes3 1000000 ---> 21m37s

So my hypothesis was correct then! It did not improve by half but by one third.

-------------------------------------------------}

{------------------------------------------------

Ok, so now let's try the same thing with the Sundaram Sieve. This one is prone to more optimization but let's start with the first version

-------------------------------------------------}

sundaram1 limit = let limit' = (limit `div` 2) in
	  	      2 : (map (\n -> 2*n+1)
	       	     	  ([1..limit'] \\ [i + j + 2*i*j | i <- [1..limit'], j <- [i..limit']]))

{------------------------------------------------

sundaram1 1000 ---> 9.59 secs and it is absurdly slow.

So, there's a few things I don't like in this version, chief amongst them the fact that I used \\ to do something like a set operation on the sieve but instead of that, I think I can use list comprehensions which should decrease the amount of operations. 

-------------------------------------------------}

sundaram2 limit = let limit' = (limit `div` 2) in
	  	      2:[2*n+1 | n <- [1..limit'],
		      	       	 not (n `elem` [i + j + 2*i*j | i <- [1..limit'],
				     	       	      	      	j <- [i..limit']])]

{------------------------------------------------

sundaram2 1000 ---> 31.81 secs.

So, it turns out that this solution made it even worse. So, what if we create a lexical scope around the actual sieve?

-------------------------------------------------}

sundaram3 limit = let limit' = (limit `div` 2) in
	  	      let sieve = [i + j + 2*i*j | i <- [1..limit'],
				     	       	   j <- [i..limit']] in
	  	      2:[2*n+1 | n <- [1..limit'],
		      	       	 not (n `elem` sieve)]

{------------------------------------------------

sundaram3 1000 ---> 0.56 secs.
sundaram3 10000 ---> 258.91 secs.

It is a lot better for 1000 but still very very bad for 10000. So let's use some math to optimize the limits we should go to, to avoid calculating too many numbers in the sieve. This optimization was taken from [stackoverflow](http://stackoverflow.com/a/16246829).

-------------------------------------------------}

sundaram4 :: Int -> [Int]
sundaram4 limit = let limit' = (limit `div` 2) in
	  	  let sieve = [i + j + 2*i*j | let n' = fromIntegral limit',
                           	       	       i <- [1..floor (sqrt (n' / 2))],
                           		       let i' = fromIntegral i,
                           		       j <- [i..floor( (n'-i')/(2*i'+1))]] in
	  	  2:[2*n+1 | n <- [1..limit'],
		      	     not (n `elem` sieve)]



{--------------------------------------------------

So now we get 0.40 secs for sundaram4 10000 and 38.16 seconds for sundaram4 100000.

After compilation and running with 1000000 we get:



----------------------------------------------------}