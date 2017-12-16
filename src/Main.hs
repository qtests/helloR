{-# LANGUAGE QuasiQuotes #-}
module Main where

import qualified Foreign.R as R
import Language.R.Instance as R
import Language.R.Literal (fromSomeSEXP, dynSEXP)
import Language.R.QQ

-- 
import H.Prelude (io)


downloadCrypto :: String -> R s ()
downloadCrypto cname = do
    res <- [r| source("R/Crypto.R"); f_getCrypto(cname_hs) |]
    let x = dynSEXP res :: [String]
    io $ print ( x )
    return ()

main :: IO ()
main = do
    putStrLn "Crypto Name: bitcoin"
    R.withEmbeddedR R.defaultConfig $ R.runRegion $ downloadCrypto "bitcoin"