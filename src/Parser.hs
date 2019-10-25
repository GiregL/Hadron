module Parser where

import AST

import Text.Parsec
import Text.Parsec.String (Parser)

-- Parsec reminder
-- ParsecT s u m a
--   s = flux type, instance of Stream
--   u = /
--   m = /
--   a = return type

commentary :: Parser String
commentary = char '#' >> (many $ noneOf "\n")
-- the char # followed by many chars different than `\n`

-- Returns a stack declaration instruction
varDeclaration :: Parser Instruction
varDeclaration = do
    string "var"
    char ' '
    name <- many $ noneOf (" []:" ++ ['\0' .. '\31'])
    char ':'
    many $ oneOf " \t"
    typename <- (string "Integer") <|> (string "Char") <|> (string "Bool") <|> (string "Double") <|> (many alphaNum)

    let analyseType "Integer" = HInteger
        analyseType "Double" = HDouble
        analyseType "Char" = HChar
        analyseType "Bool" = HBool
        analyseType s = UserDefined s

    return $ StackDeclaration name (analyseType typename)