//: Playground - noun: a place where people can play

import UIKit

/*
    The body mass index (BMI) is a measure used to quantify a person’s mass as well as interpret their body composition.
    It is defined as the mass (Kg) divided by height (m) squared.
    
    On Earth, a 1 kg object weighs 9.8 Newtons, so to find the weight of an object in N simply multiply the mass by 9.8 N. Or, to find the mass in kg, divide the weight by 9.8 N
 */

func bmiResult (_ bmi : Double) -> String {
    // we want to round of everything to two decimal places
    let shorternedBMI = String(format: "%.2f", bmi) 
    let interpretation : String
    
    if bmi > 25.0 {
        interpretation = "you are overweight"
    }else if bmi < 25.0 && bmi > 18.5 {
        interpretation = "you have a normal weight"
    }else {
        interpretation = "you are underweight"
    }
    
    return "Your BMI is \(shorternedBMI) kg/m² and " + interpretation
}

// returns kilograms per meters squared (kg/m²)
func BMI(weight : Double, height : Double ) -> String {
    let mass : Double = weight /// 9.8 
    let bmi = mass / pow(height, 2)
    
    return bmiResult(bmi)
}

func imperialUnitsBMI(weight : Double, heightInFeet : Double, inches : Double) -> String {
    let weightInKG = weight * 0.45359237
    let totalInches = heightInFeet * 12 + inches
    let heightInMeters = totalInches * 0.0254
    
    let mass : Double = weightInKG /// 9.8 
    let bmi = mass / pow(heightInMeters, 2)
    return bmiResult(bmi)
}

let bmi = BMI(weight: 253, height: 2.3)
let imperialBmi = imperialUnitsBMI(weight: 230, heightInFeet: 5, inches: 10)
print(imperialBmi)
print()

func beerSong(_ beers : Int) -> String {
    var lyrics = ""
    
    for bottles in (1...beers).reversed() {
        let plural = bottles > 1 ? "s" : ""
        let takeOneDown = (bottles == 0) ? "\(bottles - 1)" : "No more" 
        let newLine : String = 
        "\(bottles) bottle\(plural) of beer on the wall, \(bottles) bottle\(plural) of beer.\n" + 
        "Take one down, pass it around, \(takeOneDown) bottles of beer on the wall.\n\n"
        
        lyrics += newLine
    }
    
    lyrics += 
    "No more bottles of beer on the wall, no more bottles of beer.\n" +
    "We've taken them down and passed them around; now we're drunk and passed out!\n\n"
    
    return lyrics
}

print(beerSong( 99))


/*
 Fibonacci Sequence
 the series of numbers: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34
 
 */

func fibonacci(until value: Int) {
    print(0)
    print(1)
    var first = 0
    var second = 1
    
    for _ in 0...value {
        
        let iterator = first + second
        print(iterator)
        
        first = second
        second = iterator
    }
}

fibonacci(until: 5)
