
import Data.Char (intToDigit)

numberToString :: Int -> [Char]
numberToString x | x < 0	= error "Positive integers only"
	       	 | x == 0	= []
		 | otherwise	= (numberToString (x `div` 10) ++ [(intToDigit (x `mod` 10))])

isPalindrome :: Int -> Bool
isPalindrome = isPalindromeAux . numberToString

isPalindromeAux :: Eq a => [a] -> Bool
isPalindromeAux [] = True
isPalindromeAux [a] = True
isPalindromeAux xs = if (head xs) == (last xs)
		     then isPalindromeAux (init (tail xs))
		     else False

largestPalindrome :: (Int,Int,Int)
largestPalindrome =  head [(x*y,x,y) | x <- [999999,999998..100000],
   	   	      	     		  y <- [x,x-1..1000],
					  isPalindrome (x*y)]