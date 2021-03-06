{-# LANGUAGE NoImplicitPrelude #-}

module DDF.Show (module DDF.Show) where

import DDF.Lang
import qualified Prelude as M
import qualified DDF.Map as Map

data AST = Leaf M.String | App M.String AST [AST] | Lam M.String [M.String] AST

appAST (Leaf f) x = App f x []
appAST (App f x l) r = App f x (l ++ [r])
appAST l r = appAST (Leaf $ show l) r

lamAST str (Lam st l t) = Lam str (st:l) t
lamAST str r = Lam str [] r

instance M.Show AST where
  show (Leaf f) = f
  show (App f x l) = "(" ++ f ++ " " ++ show x ++ M.concatMap ((" " ++) . show) l ++ ")"
  show (Lam str l t) = "(\\" ++ str ++ M.concatMap (" " ++) l ++ " -> " ++ show t ++ ")"

newtype Show h a = Show {runShow :: [M.String] -> M.Int -> AST}
name = Show . M.const . M.const . Leaf

instance DBI Show where
  z = Show $ M.const $ Leaf . show . M.flip (-) 1
  s (Show v) = Show $ \vars -> v vars . M.flip (-) 1
  abs (Show f) = Show $ \vars x -> lamAST (show x) (f vars (x + 1))
  app (Show f) (Show x) = Show $ \vars h -> appAST (f vars h) (x vars h)
  hoas f = Show $ \(v:vars) h ->
    lamAST v (runShow (f $ Show $ M.const $ M.const $ Leaf v) vars (h + 1))

instance Bool Show where
  bool = name . show
  ite = name "ite"

instance Char Show where
  char = name . show

instance Prod Show where
  mkProd = name "mkProd"
  zro = name "zro"
  fst = name "fst"

instance Double Show where
  double = name . show
  doublePlus = name "plus"
  doubleMinus = name "minus"
  doubleMult = name "mult"
  doubleDivide = name "divide"
  doubleExp = name "exp"

instance Float Show where
  float = name . show
  floatPlus = name "plus"
  floatMinus = name "minus"
  floatMult = name "mult"
  floatDivide = name "divide"
  floatExp = name "exp"

instance Option Show where
  nothing = name "nothing"
  just = name "just"
  optionMatch = name "optionMatch"

instance Map.Map Show where
  empty = name "empty"
  singleton = name "singleton"
  lookup = name "lookup"
  alter = name "alter"
  mapMap = name "mapMap"

instance Bimap Show where

instance Dual Show where
  dual = name "dual"
  runDual = name "runDual"

instance Lang Show where
  fix = name "fix"
  left = name "left"
  right = name "right"
  sumMatch = name "sumMatch"
  unit = name "unit"
  exfalso = name "exfalso"
  ioRet = name "ioRet"
  ioBind = name "ioBind"
  nil = name "nil"
  cons = name "cons"
  listMatch = name "listMatch"
  ioMap = name "ioMap"
  writer = name "writer"
  runWriter = name "runWriter"
  float2Double = name "float2Double"
  double2Float = name "double2Float"
  state = name "state"
  runState = name "runState"
  putStrLn = name "putStrLn"