//
//  BMICalc.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/10.
//

import Foundation

class BMICalc {
    
    enum BMI : Int {
        case invalid, thin, normal, overweight, fat, fat2, fat3
    }
    
    init() {
        // bmiValue = 0
    }
    private var bmiEvaluate: [Float] = [18.5, 25, 30, 35, 40];
    public var bmiValue: Float?
    public var bmi: BMI?
    
    func bmiString(bmi: BMI) -> String {
        let xx: String
        switch (bmi) {
        case .invalid:
            xx = "invalid"
        case .thin:
            xx = "thin"
        case .normal:
            xx = "normal"
        case .overweight:
            xx = "overweight"
        case .fat:
            xx = "fat"
        case .fat2:
            xx = "fat2"
        case .fat3:
            xx = "fat3"
        }
        
        return xx
    }
    
    func toBmi(weight: Float, height: Float) -> BMI {
        if (weight <= 0.01 || height <= 0.01) {
            bmiValue = nil
            bmi = .invalid
        } else {
            let bmiValue = weight / (height * height)
            self.bmiValue = bmiValue
            if (bmiValue < bmiEvaluate[0]) {
                bmi = .thin
            } else if (bmiValue < bmiEvaluate[1]) {
                bmi = .normal;
            } else if (bmiValue < bmiEvaluate[2]) {
                bmi = .overweight;
            } else if (bmiValue < bmiEvaluate[3]) {
                bmi = .fat;
            } else if (bmiValue < bmiEvaluate[4]) {
                bmi = .fat2;
            } else {
                bmi = .fat3;
            }
        }
        return bmi!
    }
}
