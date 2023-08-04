module Data.List.Extra
  ( dropRight,
    takeRight,
    elementAt,
    findWithIndex,
    mapWithIndex,
    none,
    findFirstAndReplace,
    endsWith,
    startsWith,
    concatMapM,
    module Data.List,
    module Data.List.Split,
  )
where

import Data.List
import Data.List.Split (chunk, chunksOf, splitOn, splitWhen)
import Data.Maybe (fromMaybe)
import Data.Tuple.Extra (mapSnd)
import Prelude

dropRight :: Int -> [a] -> [a]
dropRight n xs = take (length xs - n) xs

takeRight :: Int -> [a] -> [a]
takeRight n xs = drop (length xs - n) xs

elementAt :: Int -> [a] -> Maybe a
elementAt pos xs = if pos > length xs then Nothing else Just (xs !! pos)

concatMapM :: (Monad m) => (a -> m [b]) -> [a] -> m [b]
concatMapM f = (concat <$>) . mapM f

findWithIndex :: (a -> Bool) -> [a] -> Maybe (a, Int)
findWithIndex = go 0
  where
    go _ _ [] = Nothing
    go i f (x : xs) = if f x then return (x, i) else go (i + 1) f xs

mapWithIndex :: (a -> Int -> b) -> [a] -> [b]
mapWithIndex = go 0
  where
    go _ _ [] = []
    go i f (x : xs) = f x i : go (i + 1) f xs

none :: (a -> Bool) -> [a] -> Bool
none f = not . all f

findFirstAndReplace :: (a -> Bool) -> (a -> [a]) -> [a] -> [a]
findFirstAndReplace comparator f xs = fromMaybe xs $ do
  (a, idx) <- findWithIndex comparator xs
  let (left, right) = mapSnd tail . splitAt idx $ xs
  return $ left ++ f a ++ right

startsWith :: (Eq a) => [a] -> [a] -> Bool
startsWith = flip isPrefixOf

endsWith :: (Eq a) => [a] -> [a] -> Bool
endsWith = flip isSuffixOf