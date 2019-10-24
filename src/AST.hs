module AST where

-- Language's types definition
data Type
    = HInteger
    | HDouble
    | HChar
    | HBool
    | HStack Type
    | UserDefined String
    deriving (Show)

-- Representing a literal
data Literal
    = HCharLit Char
    | HIntLit Integer
    | HDoubleLit Double
    | HBoolLit Bool
    deriving (Show)

-- Source part of a pop / push instruction
data Source 
    = HLiteral Literal
    | StackName String
    deriving (Show)

data Target
    = TargetName String
    | LitSource Source
    deriving (Show)

-- Instruction in the
data Instruction
    = StackDeclaration String Type
    | StackPush Source Target
    | StackPop Source Target
    deriving (Show)