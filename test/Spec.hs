import Test.Hspec
import Problem001

main :: IO ()
main = hspec $ do
  describe "Prelude.read" $ do
    it "can parse integers" $ do
      read "10" `shouldBe` (10 :: Int)

    it "can parse floating-point numbers" $ do
      read "2.5" `shouldBe` (2.5 :: Float)

    it "solves euler problems" $ do
      read "233168" `shouldBe` (sumNaturals 1000 [3,5])
