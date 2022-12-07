//
//  GameStep.swift
//  CrashPlane
//
//  Created by 马浩轩 on 12/6/22.
//

import Foundation
////import Firebase
//import FirebaseFirestore
//import FirebaseFirestoreSwift


class GameStep {
	
	var healthStore: HealthStore?
	var currentStep: Double
	var theCoin: Int
	
	init(){
		self.healthStore = HealthStore();
		self.currentStep = 0;
		self.theCoin = 0;
		self.updateSteps {
			self.theCoin = self.convertCoins()
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
		return theCoin
		
	}
	
	func consumeCoin(coin: Int) -> Int {
		theCoin -= coin
		return theCoin
	}

}
