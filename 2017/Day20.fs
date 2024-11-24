module Day20

open Xunit

type Particle = {
    position : int * int * int
    velocity : int * int * int
    acceleration : int * int * int
}

let addVec (x1, y1, z1) (x2, y2, z2) = (x1 + x2, y1 + y2, z1 + z2)

let manhattanMagnitude (x, y, z) =
    abs x + abs y + abs z

let stepParticle particle =
    let newVelocity = addVec particle.velocity particle.acceleration
    let newPosition = addVec particle.position newVelocity
    {
        position = newPosition
        velocity = newVelocity
        acceleration = particle.acceleration
    }

let stepSimulation particles =
    let newParticles = Array.map stepParticle particles
    let collisionPositions =
        newParticles
        |> Array.countBy (fun p -> p.position)
        |> Array.filter (fun (pos, count) -> count > 1)
        |> Array.map fst
        |> Set.ofArray

    Array.filter (fun p -> not (Set.contains p.position collisionPositions)) newParticles    

let parseParticle (line : string) =
    let p =
        line.Split(", ")
        |> Array.map (fun coordWithPrefix ->
            let sp = coordWithPrefix.Split("=")
            let coordWithBrackets = sp[1]
            let coords = coordWithBrackets[1..coordWithBrackets.Length-2].Split(",") |> Array.map int 
            (coords[0], coords[1], coords[2])
        )
    {
        position = p[0]
        velocity = p[1]
        acceleration = p[2]
    }

let parseParticles (puzzleInput : string) =
    Util.splitIntoLines puzzleInput |> Array.map parseParticle

let closestParticle particles =
    Array.map ((fun p -> p.acceleration) >> manhattanMagnitude) particles
    |> Array.indexed
    |> Array.minBy snd
    |> fst
    
let numRemaining initial =   
    let mutable particles = initial
    // TODO: Would be nice to be more principled about how long we run
    for i = 1 to 100 do
        particles <- stepSimulation particles

    Array.length particles

let run puzzleInput =
    let parsed = parseParticles puzzleInput
    (closestParticle parsed, numRemaining parsed)

[<Fact>]
let testExamples () =
    let example1 = """
p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
"""
    
    let particleIdx = closestParticle (parseParticles example1)

    Assert.Equal(0, particleIdx)

    let example2 = """
p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
"""
    
    let particlesRemaining = numRemaining (parseParticles example2)

    Assert.Equal(1, particlesRemaining)
[<Fact>]
let testPuzzleInput () = Util.testDay 20 run