{-# OPTIONS_HADDOCK hide #-}
module PreludeText
  ( ReadS,
    ShowS,
    Read (readsPrec, readList),
    Show (showsPrec, show, showList),
    reads,
    shows,
    read,
    lex,
    showChar,
    showString,
    readParen,
    showParen,
  )
where

import Text.Read
import Text.Show
