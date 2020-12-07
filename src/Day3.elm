module Day3 exposing (part1, part2)


part1 : Int
part1 =
    countTrees (parse data) 3 1


part2 : Int
part2 =
    let
        map =
            parse data

        slope1 =
            countTrees map 1 1

        slope2 =
            countTrees map 3 1

        slope3 =
            countTrees map 5 1

        slope4 =
            countTrees map 7 1

        slope5 =
            countTrees map 1 2
    in
    slope1 * slope2 * slope3 * slope4 * slope5


countTrees : Map -> Int -> Int -> Int
countTrees map xOffset yOffset =
    slide map 0 0 xOffset yOffset
        |> List.filter ((==) Tree)
        |> List.length


slide : Map -> Int -> Int -> Int -> Int -> List Square
slide map x y xOffset yOffset =
    let
        nextX =
            x + xOffset

        nextY =
            y + yOffset
    in
    case getSquareAt nextX nextY map of
        Just square ->
            -- keep going!
            square :: slide map nextX nextY xOffset yOffset

        Nothing ->
            -- at the bottom
            []


type Square
    = Tree
    | Space


type alias Grid =
    List (List Square)


type alias Map =
    { grid : Grid
    , maxX : Int
    , maxY : Int
    }


{-| Will return Nothing when y out of bounds.
x is always in bounds as the map wraps around infinitely on the x axis
-}
getSquareAt : Int -> Int -> Map -> Maybe Square
getSquareAt x y map =
    let
        colIndex =
            x |> modBy map.maxX

        rowIndex =
            y

        row =
            getAt rowIndex map.grid |> Maybe.withDefault []
    in
    getAt colIndex row


getAt : Int -> List a -> Maybe a
getAt position list =
    list |> List.drop position |> List.head


parse : String -> Map
parse str =
    let
        lines =
            str |> String.trim |> String.lines |> List.map String.trim

        maxY =
            List.length lines

        maxX =
            List.head lines |> Maybe.withDefault "" |> String.toList |> List.length

        grid =
            lines |> List.map parseLine
    in
    Map grid maxX maxY


parseLine : String -> List Square
parseLine str =
    str
        |> String.toList
        |> List.map
            (\s ->
                case s of
                    -- more YOLO parsing
                    '#' ->
                        Tree

                    _ ->
                        Space
            )


data =
    """
    ........#....#..##..#...#.....#
    ...............#....##........#
    .#....##...##..#...............
    .#.......#......#.##..##...#...
    .....#.#....#..##...#.....#....
    ...#.#..##...###......#..#..#.#
    .....#..##........#.##......#..
    ..##.....###.........##........
    ..............##..#.#.#.#......
    .#....##..#.##.#....#..#.#..#..
    .#.#....#.##.#...#....#.....#..
    ..#...#.#.....#....#.......##..
    .#.#..##.....#...........#.....
    .#.##...#.....#......#.##......
    ..#..#..........#.....#..###.#.
    ##....##....#.#...........#..#.
    .....#.#.......#.#.#..#.##....#
    ...##.#....#..#.....#.........#
    .....#........#.##...#.........
    .....#................#.#...#..
    ...#....##.....##....#.......#.
    ....##.#.....#.#.......#.......
    #...............#..#...........
    .......###.#.......#.##....#.#.
    ..#........###........#......#.
    .#.......#...##.....####....##.
    ..##.#....#.....#..#....#......
    ..#...#..#.#..##...#.....#.....
    .#.......###.......#....#......
    ...#...#.......#........#...#.#
    ..#....#...#.......#.#..##.....
    ##............#.#..#..........#
    .......###...##..#.....#....#..
    ##..######.#..#.......###....##
    ###..#...#.##......##....#...#.
    ..............##.###..........#
    .....#........##.#.###....#....
    ..#...#.....##.#......#.#..#.#.
    #....#.............#.#.........
    .........##.#........#...#.....
    ..........#..##.#.#.....#..##..
    ........##......#..#..#...#.#..
    .##.......#..#.#...#.####..#...
    ##...#........#.###...##....#..
    ....###.####...#..#..#......###
    #....#....#.#.....##.........#.
    #.......#....#....##...........
    ##...##.#.......#....#...#....#
    ....#....#........##..#.#..#.#.
    ..##.....##...#..........#...#.
    .#.#.#...#.....##..#........#..
    #....#.....#..........#....#...
    ...##.#.......#.#.........#....
    ##.##.........##.....##.....##.
    ##.#..##..#...##........##.....
    .........##.......#....#...#...
    .#.....#........####.#.#.....#.
    ...........##..#.###...........
    ..#....##....#...#.............
    #.#............#.......#.......
    .##........#...#..##.....#.#...
    #.##..............##..##.......
    ##.........#......#......#..#..
    ##.#....#...#....##....#..#.##.
    ......#...#..#.#...#.#....#.##.
    ##.......#.....#.........#.....
    ...##...#................#.#...
    ....#.####...#.#.....##....##.#
    #...#..#.#.##................##
    .........##.....##...#..#......
    ......####....#.##.#.....#.....
    ...#..#.#....#.#.#..#..........
    .....#........##...#.##....#.#.
    ..##......#...................#
    .....#..#...............#..#...
    ....#........#..#.#...##...#.##
    ..#.#.......#.##.........#...#.
    ...##......#.#.................
    .#....#...#.............##.#...
    ........#.##...#..#...###.....#
    #....#.#........##....#......##
    .###.......#..#..........#..#..
    #....#..#....#........#...#...#
    ##.#.###.##.#...##.#......#.#.#
    #..#..#..##........#..###.#...#
    ....#..#..#.....#...##....#...#
    .......##.......#..#.##...##..#
    .##....#..###................##
    #...#.##.##...#.##......##.....
    ...##.....##..##...#..#........
    ...............##.....##.......
    .#..#.#..#....#.....#..#...#...
    .#....#..#........#.#...#.....#
    ##.....####..#......#..........
    ........#.........#.........#..
    #...####....#.##...#....#...##.
    .#....####..#...##..#......####
    ...........##.##..#.##...##....
    ..#..#.......#.##....#.#...#.##
    #...........#..#...............
    .......#.##..#.....##......#...
    ....##.#.##.....#...........#.#
    .............#.##..#...#......#
    #......#...........#........#..
    #.#..#.............#...#.......
    #.........##...#....#...##.....
    ##...#..#..#..#....#...........
    .#.....#........#.....#.##..#.#
    ...#..............##.####.#..#.
    ##.....#..#.#..#..##...........
    ...#...#.......#...............
    ..#..................###..#..##
    ....###..........#.#..#...#.#.#
    ..#..#..#.#..........#.#......#
    ....#....#.#...#.###...##..#...
    ....#.......#...#....##........
    .#.....#.......###....#........
    ....#..#..#.....#......#.......
    ......#...#..#....#.#.......#..
    .##.#..#...#.#.#...........#...
    ..#....##.#....#.#....#...#.#.#
    ...##..#.......#....#.#.....##.
    ##.#......#.#.......##...#.....
    ......#...#.##..............#..
    .##.........#......##.#..#....#
    #.......#.....#...##...#..#...#
    ..#..##.......#......#......##.
    #..##...###.#.#...........#....
    ##......#.....####..#..#....#.#
    .......##...##.#...#...........
    ....#..#.##.#.....#.#....#.#...
    ....#.....#.....####...#..#.##.
    .##..#..#..###...#....#.##.#.#.
    ..#.#.##..........##...........
    #.##.#.#....#.##....#..#...##.#
    #...#....#...###....#.......#..
    .......#..#............#.......
    ................##.#.#.....#..#
    ..........................#....
    .##....##...#.#....####..#....#
    ......#...#....#...#.##..###.#.
    .........#............#.......#
    .#.#..#........#..#.........#..
    #..#...#......#.#....#..#.#....
    ...........#.................#.
    .#.#..#...##..###......##....##
    .#.#.##......####.........##...
    ..#....#.#..#................#.
    ##.......#....#.........##.#.#.
    ##..#.###...........#..#.#..#.#
    ...#............##.#....#......
    ...#................##.#..#....
    ....#..##.#...#.#.....#.......#
    ......#......#.#........#..##..
    ...##...#.....#.##.......#.....
    ##...#...#.............#..#....
    ..#...##.....#..........#..#.##
    #.##...#..................#.###
    .........#..........#.###...#.#
    #..#.....#.#.#....#......#...#.
    .............#.##..###.....#.##
    ..#..#.....#..#.............#..
    .#.....##.#.#..#.........#.....
    ..#.......#....#.....##.#......
    .#.........#..#....##...#.##...
    .##..##................###....#
    .#..##..............#...#......
    .#..............#.##....##.....
    .#......#..#..##..#...###.....#
    ................##...#.#..#...#
    ##.#.......#...................
    ....#.#.......#..#.##..........
    ....###............##...#......
    .......#....#.#.....##.#.....#.
    ....#...............#.#........
    ..#.##....#.#.#......##..#.....
    .##......#...#.#..#..#.......#.
    ....#...#........#.#..##.......
    .##...###.#....#..........##..#
    ..#.......##..#.....###......#.
    ...#.#..##.#.#...........#.....
    ##........#.#..##.........#..#.
    .....###.......#..#.#.....##.#.
    ..#...##.#..............#......
    ......#...#...............##.#.
    ##...#..#....#...#.####.##.....
    ...#............#.##...........
    ...#........##.#.##.......#....
    ...#..#..##....#...#......#..#.
    #.....#..#......#.#.....##.#.#.
    .....#.##......#...#..#..###..#
    ...........##..##.#.#..........
    ...#........##........##..##.#.
    ......###...#.....#..###.#..#..
    #.....#.#....#...##....##.....#
    .##....#......#.....#.#..##.##.
    ##....###.......#...##.......##
    ...##......#....###............
    ..#...#...#.#..#..........##.#.
    #.#.###...#..#.....#....#.###..
    ..##.....#.#.#.......#.........
    ...####..#....#..#.........#...
    .##...........#.##.#...#.#.##..
    ...#.#....#.##......#........#.
    ##....##....#..#...#..#.#......
    #......#..#...#...#.#.#.#.####.
    ....##.#.#.....#.###........#..
    ....##..#.#.#.#....#....#.#..#.
    ..#.###..#............##..#.#..
    ...#...#..#...#.#.#.....#.....#
    ..........#.....#..#.......##.#
    ..............##...........#...
    .......#.....#...#.....#.....#.
    .#.###.....##......##....#...#.
    .....#.........#.#....#........
    ..#.#....#.##...#.##....##...#.
    ...#......#.#.....#.......###..
    #.##....##.....#.#.#...#......#
    #..#...#..........#.........##.
    ....#.#.#.#.....#...###........
    #.#..#...#......#...#.##...####
    .#...#......#....##...#........
    ..#.........#............#...#.
    ##......#..#...#....#.##....#..
    .#...##..#..##.#.#.#........#.#
    .##.........###...#......#..###
    ...##.....##..#.#.........#....
    ...........##........#...#.....
    ..##..#...#..#..#.....#......#.
    ..#..#.#....#.....#..#.##...#..
    #....#........##..........#.###
    ......#...#...#....#...##.#....
    ...#......#.#.....##......##...
    #....#..##............#....#.#.
    ...#...##.#..........##........
    ......#.###......#...#.#.......
    ..................#.##..#..#..#
    ....#.....#...#.....#...#....#.
    .#....##.#..#..#.....###.##...#
    #.......#..#....##.##.#.....##.
    ..##........##...#.....#....##.
    #.........#...........##.#.....
    .#....#.#...##..###..........#.
    ....##..##....####...#......#..
    ##.##..#..#....#....####...#...
    ..#...............#.##.........
    ...#.#....#..#....#......#.....
    .#..#...#........#...#.....##..
    #.....###.......#.....#........
    ...#.##..#.......#....#........
    ....##..###.##...#.#....#.#....
    #.####...#.......#.....#.#....#
    #.......#......#.......#.#.#...
    ##....#......#..#...#..#..####.
    .##.....#........#..#...#......
    #.#.#....#....#...#.##..##.....
    ....#..#.........###.##.##.....
    ...##...##.###..#..##.....#.###
    ..###.......................#..
    ......##..#.#.........#......#.
    .###......##....#.....#.......#
    .....#..#..##........#......##.
    ..##.....#....#.#.............#
    ..##.........##.#..#.........##
    ......#......#.#......#........
    .#...#..#......##...#..#....#..
    ...............###............#
    #.####.#....#...#...........#.#
    ............................#.#
    .#..#...#.#.#.###..##.....##...
    ....##...#.................##..
    ......##....#...............##.
    .#......#.##.#..#.....##...##..
    .............#........#......#.
    #..........#.#....#####.#...#.#
    .#.#...##..#.#...#.#..#.#..#...
    #.##.......##......#.#.#....#..
    ##.....##.#.#.##..........##..#
    ....##..#.#.......#....#.##....
    ..#.#.#...#.....#.......#......
    .#....#..#...........###.......
    #.#...#.....#......#...#.....#.
    #........#.#..........#...#.#..
    ...#...#....#.........#........
    .....................#..##.....
    ...#......##........#.##.#.#.##
    .............###...#.#...#..#..
    .#..##........##....#...###..##
    .#..#.#...............#.....##.
    ...........##.#....#..##.#....#
    .##.#.#..#.#..#...#.#.#..#.#.##
    .......#.#..#..#..#..#...#.....
    .#......##............#.#..#...
    ..#...#..##..#..#...##......#..
    ...##......##....#............#
    .......#.....##...##.#...#..#..
    ......#.......#..##.........#..
    ..#...#.#.....#.#.......#.#...#
    .#......##.##.#.#.#.##..#....##
    #.....#.........#.#....#....##.
    .......#.........#....#..#.#.##
    .....##....#..#.#.#...#.....##.
    #####.#.......######......#....
    ..##.#.......#.#..............#
    ..#.##....#.....#...#.#...##...
    .....#...#..#....#.#..#........
    .#....#.#..#.#.#.##..#.......#.
    ....#..#..#..........##...#....
    .......#.#......#........#.....
    ##.#.#.###....##.#..#..#....#..
    #.##......#..#.......#.#...#...
    ..##...#.......#.......#...#...
    ........##.........#.#....#.#..
    ..#...#..##.#.#.#...#....#.....
    .###......#........#....#...#..
    .#.......##......###..##.......
    #....#.#....#.##.........####..
    ......#..........#..##.....#...
    .............#......#..##.#....
    ...................#....#...#..
    .#..........#...#.#..##...#....
    .....#...#..........##.##......
    #...#..#.##........#...#.......
    
    """