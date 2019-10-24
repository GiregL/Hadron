
# Hadron

Hadron is a **Stack based** language which provides on ly basic types and operations to act on the value like stacks with two operators.

Its syntax is really easy: one line equals to one instruction.

## Basic stacks

`inputStream` and `outputStream` are the only two global stacks.

+ `inputStream`
    + Provides an input stream, it reads the standard input
    + The only action possible is to `pop` something out of this stack

+ `outputStream` 
    + Provides an output stream, it prints into the standard output
    + The only action possible is to `push` something into this stack

## Operators

The two following are equivalent, so that you'll be able to use these with whatever you want.
Just be coherent.

`a +> b` pushes `a` into `b`

`a <+ b` pushes `b` into `a`

The same principle applies below.

`a -> b` pops `a` from `b`
`a <- b` pops `b` from `a`

## Predefined behaviours

On classic types like Integer, Double, String, ..., `push` and `pop` have a predefined behaviour.
Later, you'll be able to define your own types and behaviours

## Examples

```
var someInteger: Integer = 0
var anOtherInteger: Integer = 15

someInteger +> anOtherInteger
someInteger +> anOtherInteger

anOtherInteger +> ' ' +> "\nString literal\n" +> outputStream
```

The code above has three main instructions.

 - It declares two stacks : `someInteger` and `anOtherInteger`.
 - Then it pushes two times `someInteger` into `anOtherInteger`, which results
   in Integer stacks of an addition.
 - Finally it prints out the result below

```
30 
String literal
```
