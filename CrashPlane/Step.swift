//
//  Step.swift
//  HealthKitDemo
//
//  Created by 马浩轩 on 10/27/22.
//

//step struct used to parse out the step info from collection

import Foundation

struct Step: Identifiable {
		let id = UUID()
		let count: Int
		let date: Date
}
