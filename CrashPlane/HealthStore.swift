//this is the part act as an controller
//this part will fetch steps in a date range and get step of today's current

import Foundation
import HealthKit

extension Date {
	static func mondayAt12AM() -> Date {
		return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
	}
}
//
class HealthStore {
	
	//instantiate a healthstore
	var healthStore: HKHealthStore?
	// two querys for the collection and the step
	var query: HKStatisticsCollectionQuery?
	var todayQuery: HKStatisticsQuery?
	
	init() {
		if HKHealthStore.isHealthDataAvailable() {
			healthStore = HKHealthStore()
		}
	}
	
	//this is the part to fetch step in a time period fashion
	func fetchSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
		
		
		let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
		
		//get start date as the 12 am of that date of the method called
		let date = Date()
		let cal = Calendar(identifier: .gregorian)
		let newDate = cal.startOfDay(for: date)
		
		let timeInterval = DateComponents(hour: 1)
		//the end time is the current time
		let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
		//this is the query
		/*
		 QuantityType: we want get step data
		 quantitySamplePredicate: the start time and end time
		 anchordate: when to start
		 intervalComponent: the frequency
		 */
		query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: newDate, intervalComponents: timeInterval)
		//set the completion status
		query!.initialResultsHandler = { query, statisticsCollection, error in
			completion(statisticsCollection)
		}
		
		if let healthStore = healthStore, let query = self.query {
			healthStore.execute(query)
		}
		
	}
	//similiar structure of fetchsing step except this method will return a double of current step of the day
	func getSteps(completion: @escaping (Double) -> Void) {
		let now = Date()
		let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
		
		let startDate = Calendar.current.startOfDay(for: now)
		
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
		
		todayQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum){ _, result, _ in
			guard let result = result, let sum = result.sumQuantity() else {
				completion(0.0)
				return
			}
			completion(sum.doubleValue(for: HKUnit.count()))
		}
		
		if let healthStore = healthStore, let todayQuery = self.todayQuery {
			healthStore.execute(todayQuery)
		}
		
	}
	//this will prompt to the user and ask for authroization
	func requestAuthorization(completion: @escaping (Bool) -> Void) {
		print("inside HS")
		let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
		
		guard let healthStore = self.healthStore else { return completion(false) }
		
		healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
			completion(success)
		}
		
	}
	
}
