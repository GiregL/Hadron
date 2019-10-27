module Main where

import System.IO
import System.Environment
import Control.Monad
import Text.Parsec

import Lib
import Parser

main :: IO ()
main = do
    args <- getArgs
    mapM_ parseFile args

parseFile :: String -> IO ()
parseFile path = do
    handler <- openFile path ReadMode
    fileContent <- hGetContents handler
    print $ parse file path fileContent
    hClose handler