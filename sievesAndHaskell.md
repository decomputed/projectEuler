Sieves in Haskell

Ever since Project Euler's [problem 3](https://projecteuler.net/problem=3) that I wanted to experiment with calculating prime numbers using [sieves](https://en.wikipedia.org/wiki/Generating_primes#Prime_sieves). It's really not a complicated task but I guess sometimes the problems in Project Euler are so easily solvable with a one liner that I just kept postponing it.

With problem 7, which asks what is the 10001st prime number, it becomes clear that it is not sustainable to keep relying on trial division to find prime numbers so the time has come for implementing and playing around with Sieves.

So this is five day story on prime numbers and sieves and how optimizing programs can become so addictive.

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

All test cases are compiled with `-O2` and they never print anything to the screen except for the size of the generated primes list. The app is always something like:

        import Problem007
        
        main = print . length $	trialAndDivision 1000

So, back to the unoptimized version:

* `trialAndDivision 1000` = 0.01s user 0.00s system 42% cpu 0.031 total
* `trialAndDivision 10000` = 0.36s user 0.01s system 94% cpu 0.388 total
* `trialAndDivision 100000` = 24.78s user 0.27s system 99% cpu 25.093 total

25 seconds for primes up to 100000 is already way too much but there's a couple small optimizations we can do: instead of testing for `<2` and for `even` inside `isPrime` (which happens for all numbers out of the list compprehension) we can make the lazy list go only over odd numbers:


        isPrime2 :: Integral a => a -> Bool
        isPrime2 n | n == 2		 = True
        	   | otherwise 	  	 = not (any (\i -> n `mod` i == 0) [3..n-1])
        
        trialAndDivision2 limit = 2:3:5:[n | n <- [7,9..limit], isPrime2 n]

And now:

* `trialAndDivision2 1000` = 0.01s user 0.00s system 42% cpu 0.030 total
* `trialAndDivision2 10000` = 0.35s user 0.01s system 94% cpu 0.381 total
* `trialAndDivision2 100000` = 25.49s user 0.30s system 99% cpu 25.903 total

So there is a difference indeed -- it now takes us 1 second more! So, let's leave trial and division behind and let's go over to the Sieves.


## Eratosthenes

Ok, so here's my first implementation of the Sieve of Eratosthenes:

        eratosthenes1 limit = eSieve1 [2..limit] []
        
        eSieve1 [] primes = primes
        eSieve1 (x:xs) primes = eSieve1
        			([y | y <- xs, not (y `isMultiple` x)])
        			(primes++[x])
        
        isMultiple :: Int -> Int -> Bool
        isMultiple n = \x -> elem n [x,x+x..n]


The first implementation was very naive, and only meant to see how long would a typical calculation take. It also was direct copy of what the definition on wikipedia says:

"...enumerate its multiples by counting to n in increments of p, and mark them in the list..." So, even though this enumeration is just a test for a number being a multiple of another, I went with an implementation which really created a list with all those multiples.

* `erastothenes1 1000` = 0.01s user 0.00s system 51% cpu 0.034 total
* `erastothenes1 10000` = 1.08s user 0.02s system 98% cpu 1.112 total
* `erastothenes1 100000` = 111.72s user 1.86s system 99% cpu 1:54.04 total

So, one could say that the sieves aren't really living up to their promises right? But no, it's just my implementation that sucks really.

Let's start with optimizations. It is obvious that the function isMultiple is not really needed - instead I can simply verify that the remainder of the division is 0 and if so, the number is a multiple. Even though this requires doing multiple divisions, it's easy to see that the amount of operations will be largelly inferior to the first implementation.

        erastothenes2 limit = eSieve2 [2..limit] []
        
        eSieve2 [] primes = primes
        eSieve2 (x:xs) primes = eSieve2
        			([y | y <- xs, y `mod` x /= 0])
        			(primes++[x])

* `erastothenes2 1000` = 0.00s user 0.00s system 30% cpu 0.024 total
* `erastothenes2 10000` = 0.07s user 0.00s system 80% cpu 0.092 total
* `erastothenes2 100000` = 9.77s user 0.09s system 99% cpu 9.909 total

Now that is a lot better, and more than twice as fast than trial and division for the same number, and mainly by avoiding the creation of so many lists. So let's try to beat that then and do some final improvements:

- I have understood that cons on lists is faster than list concatenation, so let's do that replacement
- We don't really need to consider even numbers in the original list since we know they'll never be prime except for 2

        erastothenes3 limit = eSieve3 [3,5..limit] [2]
        
        eSieve3 [] primes = primes
        eSieve3 (x:xs) primes = eSieve3
        			([y | y <- xs, y `mod` x /= 0])
        			(x:primes)

* `erastothenes3 1000` = 0.00s user 0.00s system 21% cpu 0.022 total
* `erastothenes3 10000` = 0.05s user 0.00s system 75% cpu 0.071 total
* `erastothenes3 100000` = 7.64s user 0.06s system 99% cpu 7.732 total

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

* `sundaram1 1000` = 5.62s user 0.07s system 99% cpu 5.741 total
* `sundaram1 10000` = 598.78s user 5.22s system 99% cpu 10:04.71 total and was still going...
* `sundaram1 100000` = 

`sundaram1 1000` runs in 9.59 secs and it is absurdly slow, even worse than Erastothenes. So I must be doing something wrong.

Let's see now, there's a few things I don't like in this version, chief amongst them the fact that I used `\\` to do something like a set operation on the sieve when instead of that, I think I can use list comprehensions which should decrease the amount of operations. 

        sundaram2 limit = let limit' = (limit `div` 2) in
        	  	      2:[2*n+1 | n <- [1..limit'],
        		      	       	 not (n `elem` [i + j + 2*i*j | i <- [1..limit'],
        				     	       	      	      	j <- [i..limit']])]

* `sundaram1 1000` = 0.34s user 0.01s system 95% cpu 0.371 total
* `sundaram1 10000` = 175.05s user 1.27s system 99% cpu 2:56.51 total and going...
* `sundaram1 100000` = 

Still not good. I could also extract the initial sieve creation outside of the calculations:

        sundaram3 limit = let limit' = (limit `div` 2) 
        	  	      sieve = [i + j + 2*i*j | i <- [1..limit'],
        				     	       j <- [i..limit']] in
        	  	  2:[2*n+1 | n <- [1..limit'],
        		      	     not (n `elem` sieve)]

* `sundaram3 1000` ---> 0.34s user 0.01s system 95% cpu 0.367 total
* `sundaram3 10000` ---> 195.16s user 1.40s system 99% cpu 3:16.81 total and going....

So the answer has to be in mathematics. Let's look at the domain of i+j+2*i*j. It will clearly never go above sqrt(n/2) and since j starts in i, it will never go above (n-i)/(2i+1). So let's do those changes and try to limit the amount of numbers we generate in the sieve.

        sundaram4 :: Int -> [Int]
        sundaram4 limit = let limit' = (limit `div` 2) in
        	  	  let sieve = [i + j + 2*i*j | let n' = fromIntegral limit',
                                   	       	       i <- [1..floor (sqrt (n' / 2))],
                                   		       let i' = fromIntegral i,
                                   		       j <- [i..floor( (n'-i')/(2*i'+1))]] in
        	  	  2:[2*n+1 | n <- [1..limit'],
        		      	     not (n `elem` sieve)]

* `sundaram4 1000` ---> 0.01s user 0.00s system 32% cpu 0.027 total
* `sundaram4 10000` ---> 0.26s user 0.00s system 94% cpu 0.281 total
* `sundaram4 100000` ---> 31.39s user 0.14s system 99% cpu 31.596 total

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

* `sundaram5 1000` ---> 0.00s user 0.00s system 17% cpu 0.022 total
* `sundaram5 10000` ---> 0.01s user 0.00s system 41% cpu 0.030 total
* `sundaram5 100000` ---> 0.10s user 0.01s system 34% cpu 0.338 total

Now that's unbelievably faster!!!! So let's see what happens with 1 million:

* `sundaram5 1000000` ---> 1.56s user 0.11s system 98% cpu 1.690 total

And this gives me 78498 primes under 1 million, which is correct according to Wolfram Alpha. So that was cool! Let's see if the Sieve of Atkin can beat that:

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

* `atkin1 1000` = 0.00s user 0.00s system 25% cpu 0.021 total
* `atkin1 10000` = 0.01s user 0.00s system 48% cpu 0.034 total
* `atkin1 100000` = 0.58s user 0.01s system 96% cpu 0.605 total

And for the big one:

`atkin1 1000000` = 42.98s user 0.32s system 99% cpu 43.455 total

So that performance, although it's really nice overall, it sucks when compared to the sieve of Sundaram. So let's try to do some improvements.

One thing I don't like is the fact that I have to compose three functions to flip the prime status of the inital list of primes. I would prefer to do this operation in one go by concatenating the lists into one, sorting it once and in one passage flip all the primes.

I think that would make the whole thing go faster. However, maybe this is a good opportunity to actually use a profiler and see if that is really the bottleneck of my code. So those tools come out of the box with GHC, we just need to change the compilation and execution commands a little bit:

        luis at Curry in ~/dev/euler (master●●)
        $ ghc --make -O2 Try.hs -prof -auto-all && time ./Try +RTS -p
        [1 of 2] Compiling Problem007       ( Problem007.hs, Problem007.o )
        [2 of 2] Compiling Main             ( Try.hs, Try.o )
        Linking Try ...
        78498
        ./Try +RTS -p  75.80s user 1.31s system 99% cpu 1:17.47 total
        
        luis at Curry in ~/dev/euler (master●●)
        $ more Try.prof
                Tue Feb 10 09:00 2015 Time and Allocation Profiling Report  (Final)
        
                   Try +RTS -p -RTS
        
                total time  =       74.58 secs   (74577 ticks @ 1000 us, 1 processor)
                total alloc = 2,906,769,880 bytes  (excludes profiling overheads)
        
        COST CENTRE           MODULE     %time %alloc
        
        unmarkMultiples.limit Problem007  96.7    0.0
        unmarkAll             Problem007   2.7   85.6
        firstStep             Problem007   0.2    3.8
        thirdStep             Problem007   0.1    2.5
        secondStep            Problem007   0.1    2.4
        flipAll               Problem007   0.1    2.0
        initialAtkinSieve     Problem007   0.0    3.1
        
        
                                                                              individual     inherited
        COST CENTRE                 MODULE                  no.     entries  %time %alloc   %time %alloc
        
        MAIN                        MAIN                     47           0    0.0    0.0   100.0  100.0
         main                       Main                     95           0    0.0    0.0     0.0    0.0
         CAF                        Problem007               93           0    0.0    0.0     0.0    0.7
          initialAtkinSieve         Problem007              105           0    0.0    0.7     0.0    0.7
         CAF                        Main                     92           0    0.0    0.0   100.0   99.3
          main                      Main                     94           1    0.0    0.0   100.0   99.3
           atkin1                   Problem007               96           1    0.0    0.0   100.0   99.3
            initialAtkinSieve       Problem007              104           1    0.0    2.4     0.0    2.4
            firstStep               Problem007              102           1    0.2    3.8     0.2    4.6
             firstStep.topy         Problem007              108           1    0.0    0.0     0.0    0.0
             firstStep.topx         Problem007              107           1    0.0    0.0     0.0    0.0
             firstStep.size         Problem007              106           1    0.0    0.0     0.0    0.0
             flipAll                Problem007              103      378225    0.0    0.7     0.0    0.8
              aFlip                 Problem007              110      111558    0.0    0.1     0.0    0.1
            secondStep              Problem007              100           1    0.1    2.4     0.1    3.1
             secondStep.topy        Problem007              112           1    0.0    0.0     0.0    0.0
             secondStep.topx        Problem007              111           1    0.0    0.0     0.0    0.0
             secondStep.size        Problem007              109           1    0.0    0.0     0.0    0.0
             flipAll                Problem007              101      339220    0.0    0.7     0.0    0.7
              aFlip                 Problem007              115       72553    0.0    0.1     0.0    0.1
            thirdStep               Problem007               98           1    0.1    2.5     0.1    3.2
             thirdStep.size         Problem007              114           1    0.0    0.0     0.0    0.0
             thirdStep.topx         Problem007              113           1    0.0    0.0     0.0    0.0
             flipAll                Problem007               99      327488    0.0    0.7     0.0    0.7
              aFlip                 Problem007              118       60821    0.0    0.1     0.0    0.1
            aSieve1                 Problem007               97      266667    0.2    0.2    99.6   86.0
             unmarkMultiples        Problem007              116       78495    0.1    0.2    99.4   85.8
              unmarkMultiples.limit Problem007              119       78495   96.7    0.0    96.7    0.0
              unmarkAll             Problem007              117    38976999    2.7   85.6     2.7   85.6
         CAF                        GHC.Conc.Signal          87           0    0.0    0.0     0.0    0.0
         CAF                        GHC.IO.Encoding          80           0    0.0    0.0     0.0    0.0
         CAF                        GHC.IO.Encoding.Iconv    78           0    0.0    0.0     0.0    0.0
         CAF                        GHC.IO.Handle.FD         71           0    0.0    0.0     0.0    0.0

So the verdict is very clear then: firstStep, secondStep and thirdStep are responsible only for 0.4 % of the whole time while unmarkMultiples has ~ 97% of the time. In particular the limit calculation, which makes sense since it relies on `last` and finding the last element on a linked list of size `n` has `O(n)`.

So let's just pass the size around from the very first function, including into the three steps:

        firstStep size sieve =
        	  let topx = floor(sqrt(fromIntegral (size `div` 4)))
        	      topy = floor(sqrt(fromIntegral size)) in
        	  flipAll (sort [n | n <- [4*x^2 + y^2| x <- [1..topx],
        		  	  	       	  	y <- [1,3..topy]],
        			     n `mod` 60 `elem` [1,13,17,29,37,41,49,53]])
                           sieve

        secondStep size sieve =
        	   let topx = floor(sqrt(fromIntegral (size `div` 3)))
        	       topy = floor(sqrt(fromIntegral size)) in
                   flipAll (sort [n | n <- [3*x^2 + y^2 | x <- [1,3..topx],
                                                          y <- [2,4..topy]],
        		              n `mod` 60 `elem` [7,19,31,43]])
                            sieve

        thirdStep size sieve =
        	  let topx = floor(sqrt(fromIntegral size)) in
                  flipAll (sort [n | n <- [3*x^2 - y^2 | x <- [1..topx],
                                                         y <- [(x-1),(x-3)..1],
        						 x > y],
        			     n `mod` 60 `elem` [11,23,47,59]])
                          sieve

        unmarkMultiples limit n sieve =
            		let nonPrimes = [y | y <-[n,n+n..limit]] in
            		unmarkAll nonPrimes sieve

        unmarkAll _        []         = []
        unmarkAll []       sieve      = sieve
        unmarkAll (np:nps) ((s,b):ss) 
        	  | np == s	     = unmarkAll nps ss
        	  | np < s	     = unmarkAll nps ((s,b):ss)
        	  | otherwise	     = (s,b) : (unmarkAll (np:nps) ss)

        atkin1 limit =
               aSieve1 limit
               	       ((thirdStep limit) .
        	        (secondStep limit) .
        		(firstStep limit) $
        		initialAtkinSieve limit)
        	       [(5,1),(3,1),(2,1)]

        aSieve1 _     []         primes = primes
        aSieve1 limit ((x,b):xs) primes
        	       | b == 1		= aSieve1 limit (unmarkMultiples limit (x^2) xs) ((x,b): primes)
        	       | otherwise	= aSieve1 limit xs primes

So, let's see again what does the profiler say for `atkin1 1000000`:

        luis at Curry in ~/dev/euler (master●●)
        $ ghc --make -O2 Try.hs -prof -auto-all && time ./Try +RTS -p && more Try.prof
        [1 of 2] Compiling Problem007       ( Problem007.hs, Problem007.o )
        [2 of 2] Compiling Main             ( Try.hs, Try.o )
        Linking Try ...
        78498
        ./Try +RTS -p  1.96s user 0.11s system 98% cpu 2.098 total
                Fri Feb 13 08:04 2015 Time and Allocation Profiling Report  (Final)
        
                   Try +RTS -p -RTS
        
                total time  =        1.43 secs   (1433 ticks @ 1000 us, 1 processor)
                total alloc = 2,785,514,448 bytes  (excludes profiling overheads)
        
        COST CENTRE       MODULE     %time %alloc
        
        unmarkAll         Problem007  72.6   85.0
        firstStep         Problem007   8.7    3.9
        secondStep        Problem007   5.7    2.5
        flipAll           Problem007   4.5    2.1
        thirdStep         Problem007   4.3    2.6
        initialAtkinSieve Problem007   2.4    3.3
        aSieve1           Problem007   1.0    0.2
        
        
                                                                                  individual     inherited
        COST CENTRE                     MODULE                  no.     entries  %time %alloc   %time %alloc
        
        MAIN                            MAIN                     46           0    0.0    0.0   100.0  100.0
         main                           Main                     93           0    0.0    0.0     0.0    0.0
         CAF                            Problem007               91           0    0.0    0.0     0.4    0.8
          initialAtkinSieve             Problem007               96           0    0.4    0.8     0.4    0.8
         CAF                            Main                     90           0    0.0    0.0    99.6   99.2
          main                          Main                     92           1    0.1    0.0    99.6   99.2
           atkin1                       Problem007               94           1    0.0    0.0    99.4   99.2
            aSieve1                     Problem007              108      253303    1.0    0.2    74.0   85.4
             unmarkMultiples            Problem007              110       78495    0.2    0.1    73.0   85.2
              unmarkMultiples.nonPrimes Problem007              113       78495    0.2    0.1     0.2    0.1
              unmarkAll                 Problem007              111    37087451   72.6   85.0    72.6   85.0
            thirdStep                   Problem007              105           1    4.3    2.6     5.0    3.4
             thirdStep.topx             Problem007              107           1    0.0    0.0     0.0    0.0
             flipAll                    Problem007              106      327488    0.7    0.7     0.8    0.7
              aFlip                     Problem007              112       60821    0.1    0.1     0.1    0.1
            secondStep                  Problem007              101           1    5.7    2.5     6.2    3.2
             secondStep.topy            Problem007              104           1    0.0    0.0     0.0    0.0
             secondStep.topx            Problem007              103           1    0.0    0.0     0.0    0.0
             flipAll                    Problem007              102      339220    0.6    0.7     0.6    0.8
              aFlip                     Problem007              109       72553    0.0    0.1     0.0    0.1
            firstStep                   Problem007               97           1    8.7    3.9    12.2    4.8
             firstStep.topy             Problem007              100           1    0.0    0.0     0.0    0.0
             firstStep.topx             Problem007               99           1    0.0    0.0     0.0    0.0
             flipAll                    Problem007               98      378225    3.3    0.7     3.5    0.8
              aFlip                     Problem007              114      111558    0.2    0.1     0.2    0.1
            initialAtkinSieve           Problem007               95           1    2.0    2.5     2.0    2.5
         CAF                            GHC.Conc.Signal          85           0    0.0    0.0     0.0    0.0
         CAF                            GHC.IO.Encoding          78           0    0.0    0.0     0.0    0.0
         CAF                            GHC.IO.Encoding.Iconv    76           0    0.0    0.0     0.0    0.0
         CAF                            GHC.IO.Handle.FD         69           0    0.0    0.0     0.0    0.0

1 second!!!!! And actually, 1.43 seconds, which is less than what it took for sundaram5.

Now, collectivelly, the three steps take 18,7% of the total time so maybe this could also be an opportunity to do some performance improvement. However, I think this is a good moment to stop with the improvements. Let's just see how the two best versions of the algorithm behave with 1 million, 10 million and 100 million:

atkin1 1000000 ---> 1.14s user 0.06s system 98% cpu 1.224 total
sundaram5 1000000 ---> 1.67s user 0.11s system 98% cpu 1.806 total

atkin1 10000000 ---> 31.68s user 0.97s system 99% cpu 32.778 total
sundaram5 10000000 ---> 26.02s user 1.36s system 99% cpu 27.458 total

I tried both with 100 million and it still hadn't finished after 42 seconds, so maybe we can leave that for future work.
:-)

## Future work

* Since I'm still continuing with project Euler, I guess creating a package out of these prime functions is in order, and pushing it into [hackage](http://hackage.haskell.org/);
* The Atkin sieve can still have three improvements: the original one I thought of for making the three passages into 1 passage, using [wheel factorization](https://en.wikipedia.org/wiki/Wheel_factorization) to reduce the amount of number generated even further and paralelization. This is the place where I expect the biggest win really -- since we have referential transparency in Haskell, paralelization can be applied deterministically and since this is one of the big claims of the language, I intend to test that
* And bigger numbers! It would be nice to get all the primes under 1 billion though I might have to switch to Linux on a more recent computer.

Stay tuned, next week I might have version 2 of this post.
:-)

