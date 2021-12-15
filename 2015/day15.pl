ingredient_desc(sprinkles, 2, 0, -2, 0,  3).
ingredient_desc(butterscotch, 0, 5, -3, 0,  3).
ingredient_desc(chocolate, 0, 0, 5, -1,  8).
ingredient_desc(candy, 0, -1, 0, 5,  8).

cookie(Sprinkles, Butterscotch, Chocolate, Candy, Score, Calories) :-
    ingredient_desc(sprinkles, SprinklesCapacity, SprinklesDurability, SprinklesFlavor, SprinklesTexture, SprinklesCalories),
    ingredient_desc(butterscotch, ButterscotchCapacity, ButterscotchDurability, ButterscotchFlavor, ButterscotchTexture, ButterscotchCalories),
    ingredient_desc(chocolate, ChocolateCapacity, ChocolateDurability, ChocolateFlavor, ChocolateTexture, ChocolateCalories),
    ingredient_desc(candy, CandyCapacity, CandyDurability, CandyFlavor, CandyTexture, CandyCalories),
    Capacity is max(0, Sprinkles * SprinklesCapacity + Butterscotch * ButterscotchCapacity + Chocolate * ChocolateCapacity + Candy * CandyCapacity),
    Durability is max(0, Sprinkles * SprinklesDurability + Butterscotch * ButterscotchDurability + Chocolate * ChocolateDurability + Candy * CandyDurability),
    Flavor is max(0, Sprinkles * SprinklesFlavor + Butterscotch * ButterscotchFlavor + Chocolate * ChocolateFlavor + Candy * CandyFlavor),
    Texture is max(0, Sprinkles * SprinklesTexture + Butterscotch * ButterscotchTexture + Chocolate * ChocolateTexture + Candy * CandyTexture),
    Calories is Sprinkles * SprinklesCalories + Butterscotch * ButterscotchCalories + Chocolate * ChocolateCalories + Candy * CandyCalories,
    Score is Capacity * Durability * Flavor * Texture.

score(Sprinkles, Butterscotch, Chocolate, Candy, Score, Calories) :-
    between(0, 100, Sprinkles),
    ButterscotchLimit is 100 - Sprinkles,
    between(0, ButterscotchLimit, Butterscotch),
    ChocolateLimit is 100 - Sprinkles - Butterscotch,
    between(0, ChocolateLimit, Chocolate),
    Candy is 100 - Sprinkles - Butterscotch - Chocolate,
    cookie(Sprinkles, Butterscotch, Chocolate, Candy, Score, Calories).

part1_answer(N) :-
    aggregate_all(max(Score), score(_,_,_,_,Score, _), N).

part2_answer(N) :-
    aggregate_all(max(Score), score(_,_,_,_,Score, 500), N).