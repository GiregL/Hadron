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
    int <- many $ oneOf "0123456789"
    return $ HIntLit (read int)

hdouble :: Parser Literal
hdouble = do
    let p = many1 $ oneOf "0123456789"

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
hbool = do
    content <- (string "True") <|> (string "False")

    let identify "True" = True
        identify "False" = False
        identify _ = False
    
    return $ HBoolLit (identify content)

literal :: Parser Literal
literal = hbool <|> hchar <|> (try hdouble) <|> hinteger

identifier :: Parser String
identifier = many1 $ alphaNum

source :: Parser Source
source = (HLiteral <$> literal) <|> (StackName <$> identifier)

pushOperation :: Parser Instruction
pushOperation = do
    leftName <- identifier
    stackOperator <- between (char ' ') (char ' ') $ (string "<+") <|> (string "+>")
    rightName <- identifier

    let detectSourceTarget "<+" = StackPush (StackName leftName) rightName
        detectSourceTarget "+>" = StackPush (StackName rightName) leftName
    
    return $ detectSourceTarget stackOperator

    
-- Parsing a single line
line :: Parser Instruction
line = do
    skipMany commentary
    result <- varDeclaration
    many newline
    return result

-- Parsing a file
file :: Parser [Instruction]
file = do
    lines <- many line
    eof
    return lines