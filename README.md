# Hadron

Hadron is a Stack based language.

It provides on ly basic types and operation to act on the value like stacks with two operators

The language's syntax is really easy: one line equals to one instruction.

## Basic stacks

`inputStream` and `outputStream` are the only two global stacks.

+ `inputStream`
    + Provides an input stream, it reads the standard input
    + The only action possible is to `pop` something out of this stack

+ `outputStream` 
    + Provides an output stream, it prints into the standard output
    + The only action possible is to `push` something into this stack

## Operators

The two following are equivalents so that you'll be able to use what you want. Just be coherent.

`a +> b` pushes `a` into `b`
`a <+ b` pushes `b` into `a`

The next two too

`a -> b` pops `a` from `b`
`a <- b` pops `b` from `a`

## Predefined behaviours

On classic types like Integers, Doubles, String, ... push and pops have a predifined behaviour.

Later, you'll be able to define your own types and behaviours

## Examples

```
var someInteger: Integer = 0
var anOtherInteger: Integer = 15

someInteger +> anOtherInteger
someInteger +> anOtherInteger

anOtherInteger +> ' ' +> "\nString literal\n" +> outputStream
```

The code above declares two stacks : `someInteger` and `anOtherInteger`. Then it pushes two times `someInteger` into `anOtherInteger`, which result for Integer stacks of an addition. Finally it prints:

```
30 
String literal
```