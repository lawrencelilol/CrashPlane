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
    self.updateCoins()
  }
  
  func updateCoins() {
    self.updateSteps {
      if self.getCoins() == 0 {
        self.theCoin = self.convertCoins()
      }
      if self.getSteps() == 0 {
        self.defaults.set(self.currentStep, forKey: "steps")
      }
      if self.getSteps() < Int(self.currentStep) {
        
        let increment = (Int(self.currentStep) - self.getSteps())/100
        self.theCoin += increment
        self.defaults.set(self.getCoins() + increment, forKey: "coins")
        self.defaults.set(self.currentStep, forKey: "steps")
      }
    }
    
    
  }
  
  func getCoins() -> Int {
    return self.defaults.integer(forKey: "coins")
  }
  
  func getSteps() -> Int {
    return self.defaults.integer(forKey: "steps")
  }
  
  func updateSteps( closure: @escaping () -> Void){
    if let healthStore = healthStore{
      
      healthStore.requestAuthorization { success in
        if success {
          healthStore.getSteps { unwrapp in
            self.currentStep = unwrapp
            closure()
          }
        }
        
      }
    }
  }
  
  func convertCoins() -> Int{
    theCoin = (Int(self.currentStep))/100
    if self.getCoins() == 0 {
      self.defaults.set(self.theCoin, forKey: "coins")
    }
    
    return theCoin
    
  }
  
  func consumeCoin(coin: Int) -> Int {
    theCoin -= coin
    self.defaults.set(self.theCoin, forKey: "coins")
    return theCoin
  }

}
