//
//  GameStep.swift
//  CrashPlane
//
//  Created by 马浩轩 on 12/6/22.
//
import CoreData
import Foundation



class GameStep {
  
  var healthStore: HealthStore?
  var currentStep: Double
  var theCoin: Int
  var defaults: UserDefaults
  
  init(){
    self.healthStore = HealthStore();
    self.currentStep = 0;
    self.defaults = UserDefaults.standard
    self.theCoin = self.defaults.integer(forKey: "coins")
    self.updateSteps {
      if self.defaults.integer(forKey: "coins") == 0 {
        self.theCoin = self.convertCoins()
      }
      if self.defaults.integer(forKey: "steps") == 0 {
        self.defaults.set(self.currentStep, forKey: "steps")
      }
      print("old step is \(self.defaults.integer(forKey: "steps")), new step is \(Int(self.currentStep))\n")
      if self.defaults.integer(forKey: "steps") < Int(self.currentStep) {
        
        let increment = (Int(self.currentStep) - self.defaults.integer(forKey: "steps"))/100
        self.theCoin += increment
        print("new coins is \(self.defaults.integer(forKey: "coins") + increment)")
        self.defaults.set(self.defaults.integer(forKey: "coins") + increment, forKey: "coins")
        self.defaults.set(self.currentStep, forKey: "steps")
        print("set default to \(self.defaults.integer(forKey: "coins"))\n")
      }
    }
    
  }
  
  func updateSteps( closure: @escaping () -> Void){
    if let healthStore = healthStore{
      
      healthStore.requestAuthorization { success in
        if success {
          healthStore.getSteps { unwrapp in
            self.currentStep = unwrapp
            print("inside " + String(self.currentStep))
            closure()
          }
          print("outside " + String(self.currentStep))
        }
        
      }
    }
  }
  
  func convertCoins() -> Int{
    theCoin = (Int(self.currentStep))/100
    //self.user.coins = self.user.coins + thisCoin
    if self.defaults.integer(forKey: "coins") == 0 {
      self.defaults.set(self.theCoin, forKey: "coins")
      print("set coins to \(self.theCoin)\n")
    }
    
    return theCoin
    
  }
  
  func consumeCoin(coin: Int) -> Int {
    theCoin -= coin
    self.defaults.set(self.theCoin, forKey: "coins")
    print("set coins to \(self.theCoin)\n")
    return theCoin
  }

}
