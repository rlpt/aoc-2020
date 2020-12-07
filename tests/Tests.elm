module Tests exposing (..)

import Day1
import Day2
import Day3
import Day4
import Expect
import Test exposing (..)


all : Test
all =
    describe "AOC"
        [ test "Day 1 part 1" <|
            \_ ->
                Expect.equal Day1.part1 270144
        , test "Day 2 part 1" <|
            \_ ->
                Expect.equal Day2.part1 460
        , test "Day 2 part 2" <|
            \_ ->
                Expect.equal Day2.part2 251
        , test "Day 3 part 1" <|
            \_ ->
                Expect.equal Day3.part1 153
        , test "Day 3 part 2" <|
            \_ ->
                Expect.equal Day3.part2 2421944712
        , test "Day 4 part 1" <|
            \_ ->
                Expect.equal Day4.part1 256
        , test "Day 4 part 2" <|
            \_ ->
                Expect.equal Day4.part2 198
        ]
