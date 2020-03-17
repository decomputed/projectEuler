module Problem002
    ( perfect
    , fibonacci
    , sumEvenFibonaccis
    ) where


perfect :: Double -> Bool
perfect n = (sqrt n) == fromIntegral (floor (sqrt n))

fibonacci :: Double -> Bool
fibonacci n = perfect (5*n^2+4) || 
	      perfect (5*n^2-4)

sumEvenFibonaccis :: Double -> Double
sumEvenFibonaccis limit = sum [x | x <- [1..limit], 
		  	      	   even (floor x), 
				   fibonacci x]
