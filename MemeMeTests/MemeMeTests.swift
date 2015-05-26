//
//  MemeMeTests.swift
//  MemeMeTests
//
//  Created by Kadar Toth Istvan on 18/05/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import UIKit
// May pizza :) bon appetit
class Pizza {
    //changed pizzaPricePerInSq from let to var for segues and delegates 7/1/14
    var pizzaPricePerInSq = ["Cheese": 0.03 , "Sausage": 0.06 , "Pepperoni": 0.05 , "Veggie": 0.04]
    let pi = 3.1415926
    
    var pizzaDiameter = 0.0
    let maxPizza = 24.0
    var pizzaType = "Cheese"
    
    var radius : Double {  //computed property
        get{   //must define a getter
            return pizzaDiameter/2.0
        }
        set(newRadius){ //optionally define a setter
            pizzaDiameter = newRadius * 2.0
        }
    }
    
    var area :  Double {
        get{
            return pizzaArea()
        }
    }
    
    func pizzaArea() -> Double{
        return radius * radius * pi
    }
    
    
    func pizzaPrice() ->Double{
        let unitPrice = pizzaPricePerInSq[pizzaType]    //optional type ?Double
        if (unitPrice != nil){                                   //optional type ?Double checking for nil
            return pizzaArea() * unitPrice!             //unwrapping the optional type
        }
        return 0.0
    }
}