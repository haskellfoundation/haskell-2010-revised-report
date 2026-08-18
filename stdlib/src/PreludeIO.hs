{-# OPTIONS_HADDOCK hide #-}
module PreludeIO
  ( FilePath,
    IOError,
    ioError,
    userError,
    catch,
    putChar,
    putStr,
    putStrLn,
    print,
    getChar,
    getLine,
    getContents,
    interact,
    readFile,
    writeFile,
    appendFile,
    readIO,
    readLn,
  )
where

import System.IO
import System.IO.Error
