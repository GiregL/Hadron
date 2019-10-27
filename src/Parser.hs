module Parser where

import AST

import Text.Parsec
import Text.Parsec.String (Parser)

import Data.Char (isDigit)

-- Parsec reminder
-- ParsecT s u m a
--   s = flux type, instance of Stream
--   u = /
--   m = /
--   a = return type

commentary :: Parser Instruction
commentary = do
    char '#'
    comm <- many $ noneOf "\n"
    return $ Commentary comm
-- the char # followed by many chars different than `\n`

-- Returns a stack declaration instruction
varDeclaration :: Parser Instruction
varDeclaration = do
    string "var"
    char ' '
    --name <- many $ noneOf (" []:" ++ ['\0' .. '\31'])
    name <- identifier
    char ':'
    many $ oneOf " \t"
    typename <- (string "Integer") <|> (string "Char") <|> (string "Bool") <|> (string "Double") <|> (many alphaNum)

    let analyseType "Integer" = HInteger
        analyseType "Double" = HDouble
        analyseType "Char" = HChar
        analyseType "Bool" = HBool
        analyseType s = UserDefined s

    return $ StackDeclaration name (analyseType typename)

hinteger :: Parser Literal
hinteger = do
    int <- many1 $ satisfy isDigit
    return $ HIntLit (read int)

hdouble :: Parser Literal
hdouble = do
    let p = many1 $ satisfy isDigit

    i <- p
    char '.'
    dec <- p

    return $ HDoubleLit (read (i <> "." <> dec) :: Double)

hchar :: Parser Literal
hchar = do
    char '\''
    content <- anyChar
    char '\''
    return $ HCharLit content

hbool :: Parser Literal
--hbool = do
--    content <- (string "True") <|> (string "False")
--
--    let identify "True" = True
--        identify "False" = False
--        identify _ = False
--    
--    return $ HBoolLit (identify content)
--hbool = (HBoolLit <$> (True <$ string "True")) <|> (HBoolLit <$> (False <$ string "False"))
hbool = HBoolLit <$> ( (True <$ string "True") <|> (False <$ string "False") )

literal :: Parser Literal
literal = hbool <|> hchar <|> (try hdouble) <|> hinteger

identifier :: Parser String
identifier = many1 $ alphaNum

source :: Parser Source
source = (HLiteral <$> literal) <|> (StackName <$> identifier)

-- Push operation section

leftPushOperation :: Parser Instruction
leftPushOperation = do
    t <- identifier
    operator <- between (char ' ') (char ' ') $ string "<+"
    s <- source
    return $ StackPush s t

rightPushOperation :: Parser Instruction
rightPushOperation = do
    s <- source
    between (char ' ') (char ' ') $ string "+>"
    t <- identifier
    return $ StackPush s t

pushOperation :: Parser Instruction
pushOperation = try leftPushOperation <|> rightPushOperation

-- Pop operation section

leftPopOperation :: Parser Instruction
leftPopOperation = do
    t <- identifier
    operator <- between (char ' ') (char ' ') $ string "<-"
    s <- source
    return $ StackPush s t

rightPopOperation :: Parser Instruction
rightPopOperation = do
    s <- source
    between (char ' ') (char ' ') $ string "->"
    t <- identifier
    return $ StackPush s t

popOperation :: Parser Instruction
popOperation = try leftPopOperation <|> rightPopOperation

-- Parsing a single line
line :: Parser Instruction
line = do
    result <- varDeclaration <|> try pushOperation <|> popOperation
    many newline
    return result

-- Parsing a file
file :: Parser [Instruction]
file = do
    lines <- many line
    eof
    return lines