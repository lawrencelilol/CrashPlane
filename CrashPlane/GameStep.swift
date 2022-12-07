//
//  GameStep.swift
//  CrashPlane
//
//  Created by 马浩轩 on 12/6/22.
//
import CoreData
import Foundation

//import FirebaseFirestore
//import FirebaseFirestoreSwift


class GameStep {
  
  var healthStore: HealthStore?
  var currentStep: Double
  var theCoin: Int
  var defaults: UserDefaults
  
  init(){
    self.healthStore = HealthStore();
    self.currentStep = 0;
    self.defaults = UserDefaults.standard
    self.theCoin = self.defaults.integer(forKey: "coins");
    self.updateSteps {
      if self.defaults.integer(forKey: "coins") == 0 {
        self.theCoin = self.convertCoins()
      }
      self.defaults.set(self.currentStep, forKey: "steps")
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


