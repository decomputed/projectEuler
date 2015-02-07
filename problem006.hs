
difference :: Fractional a => a -> a
difference n = (((n*(n+1))/2)^2) - ((2*n^3 + 3*n^2 + n)/6)