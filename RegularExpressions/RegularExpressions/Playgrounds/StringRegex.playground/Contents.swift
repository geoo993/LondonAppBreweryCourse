//: Playground - noun: a place where people can play

import UIKit

var str = """
A great write-up of the really groundbreaking work Wooga's hidden object games do with their live ops work over on PocketGamer.biz.  
Annelie Biernat and Andrew Harmon from the Pearl's Peril team discuss the work they do in keeping the game fresh, fun and enjoyable for the game's fans, many of whom have been playing for years.
"""

/*
 http://www.regular-expressions.info/lookaround.html
 https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial
 http://www.regular-expressions.info/backref.html
 https://code.tutsplus.com/tutorials/swift-and-regular-expressions-syntax--cms-26387
 https://code.tutsplus.com/tutorials/swift-and-regular-expressions-swift--cms-26626
 https://stackoverflow.com/questions/42019240/regex-to-match-words-with-punctuation-but-not-punctuation-alone
 https://regexr.com/
 https://regex101.com/
 
 
Just like a programming language, there are some reserved characters in regular expression syntax, as follows:
It’s easy to get carried away with regular expressions!

 [
 ( and )
 \
 *
 +
 ?
 { and }
 ^
 $
 .
 | (pipe)
 /
 
 1) - backslach
 These characters are used for advanced pattern matching. 
 If you want to search for one of these characters, you need to escape it with a backslash. 
 For example, to search for all periods in a block of text, the pattern is not . but rather \..
 
 The standard regular expression \. will appear as \\. in your Swift (or Objective-C) code
 The literal "\\." defines a string that looks like this: \.
 The regular expression \. will then match a single period (.) character.

 2) - capturing
 Capturing parentheses are used to group part of a pattern. 
 For example, 3 (pm|am) would match the text “3 pm” as well as the text “3 am”. 
 The pipe character here (|) acts like an OR operator.
 You can include as many pipe characters in your regular expression as you would like.
 
 Say you are looking for “November” in some text, 
 but it’s possible the user abbreviated the month as “Nov”. 
 You can define the pattern as Nov(ember)? where the question mark after the capturing parentheses means that whatever is inside the parentheses is optional.
 
 3) - replace
 assume you have the string “Say hi to Harry”. 
 If you created a search-and-replace regular expression to replace any occurrences of 
 (Tom|Dick|Harry) with that guy $1, the result would be “Say hi to that guy Harry”. 
 The $1 allows you to reference the first captured group of the preceding rule.
 
 4a)- character classes
 Character classes represent a set of possible single-character matches. 
 Character classes appear between square brackets ([ and ]).
 
 As an example, the regular expression t[aeiou] will match “ta”, “te”, “ti”, “to”, or “tu”. 
 You can have as many character possibilities inside the square brackets as you like, 
 but remember that any single character in the set will match. 
 [aeiou] looks like five characters, but it actually means “a” or “e” or “i” or “o” or “u”.
 
 You can also define a range in a character class if the characters appear consecutively. 
 For example, to search for a number between 100 to 109, the pattern would be 10[0-9]. 
 This returns the same results as 10[0123456789], 
 but using ranges makes your regular expressions much cleaner and easier to understand.
 
 4b) - character classes
 But character classes aren’t limited to numbers — you can do the same thing with characters. 
 For instance, [a-f] will match “a”, “b”, “c”, “d”, “e”, or “f”.
 
4c) - character classes
 Character classes usually contain the characters you want to match, but what if you want to explicitly not match a character? 
 You can also define negated character classes, which start with the ^ character. 
 For example, the pattern t[^o] will match any combination of “t” and one other character except for the single instance of “to”.
 
 
 
 NSRegularExpressions Cheat Sheet

 here’s an abbreviated form of the cheat sheet below with some additional explanations to get you started:
 
    . matches any character. p.p matches pop, pup, pmp, p@p, and so on.
 
    \w matches any “word-like” character which includes the set of numbers, letters, and underscore, but does not match punctuation or other symbols. hello\w will match “hello_” and “hello9” and “helloo” but not “hello!”
 
    \d matches a numeric digit, which in most cases means [0-9]. \d\d?:\d\d will match strings in time format, such as “9:30” and “12:45”.
 
    \b matches word boundary characters such as spaces and punctuation. to\b will match the “to” in “to the moon” and “to!”, but it will not match “tomorrow”. \b is handy for “whole word” type matching.
 
    \s matches whitespace characters such as spaces, tabs, and newlines. hello\s will match “hello ” in “Well, hello there!”.
 
    ^ matches at the beginning of a line. Note that this particular ^ is different from ^ inside of the square brackets! For example, ^Hello will match against the string “Hello there”, but not “He said Hello”.
 
    $ matches at the end of a line. For example, the end$ will match against “It was the end” but not “the end was near”
 
    * matches the previous element 0 or more times. 12*3 will match 13, 123, 1223, 122223, and 1222222223
 
    + matches the previous element 1 or more times. 12+3 will match 123, 1223, 122223, 1222222223, but not 13.
 
    Curly braces {} contain the minimum and maximum number of matches. For example, 10{1,2}1 will match both “101” and “1001” but not “10001” as the minimum number of matches is one and the maximum number of matches is two. He[Ll]{2,}o will match “HeLLo” and “HellLLLllo” and any such silly variation of “hello” with lots of L’s, since the minimum number of matches is 2 but the maximum number of matches is not set — and therefore unlimited!
 
*/
