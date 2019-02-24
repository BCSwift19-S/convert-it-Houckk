//
//  ViewController.swift
//  Convert It
//
//  Created by Kenyan Houck on 2/23/19.
//  Copyright © 2019 Kenyan Houck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Formula {
        var conversionString: String
        var formula: (Double) -> Double
    }
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    
    
//    var formulaArray = ["Miles to Kilometers", "Kilometers to Miles", "Feet to Meters", "Meters to Feet", "Yards to Meters", "Meters to Yards", "Inches to Centimeters", "Centimeters to Inches", "Fahrenheit to Celsius", "Celsius to Fahrenheit", "Quarts to Liters", "Liters to Quarts"]
    
    let formulasArray = [Formula(conversionString: "Miles to Kilometers", formula: {$0 / 0.62137}),
                         Formula(conversionString: "Kilometers to Miles", formula: {$0 * 0.62137}),
                         Formula(conversionString: "Feet to Meters", formula: {$0 / 3.2808}),
                         Formula(conversionString: "Meters to Feet", formula: {$0 * 3.2808}),
                         Formula(conversionString: "Yards to Meters", formula: {$0 / 1.0936}),
                         Formula(conversionString: "Meters to Yards", formula: {$0 * 1.0936}),
                         Formula(conversionString: "Inches to Centimeters", formula: {$0 / 0.3937}),
                         Formula(conversionString: "Centimeters to Inches", formula: {$0 * 0.3937}),
                         Formula(conversionString: "Fahrenheit to Celsius", formula: {($0 - 32) * (5/9)}),
                         Formula(conversionString: "Celsius to Fahrenheit", formula: {($0 * (9/5)) + 32}),
                          Formula(conversionString: "Quarts to Liters", formula: {$0 / 1.05669}),
                         Formula(conversionString: "Liters to Quarts", formula: {$0 * 1.05669})]
    

    
    
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    
    
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        conversionString = formulasArray[formulaPicker.selectedRow(inComponent: 0)].conversionString
        let unitsArray = conversionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        fromUnitsLabel.text = fromUnits
        toUnits = unitsArray[1]
        userInput.becomeFirstResponder()
        signSegment.isHidden = true
    }


    func calculateConversion(){
        guard let inputValue = Double (userInput.text!) else {
            if userInput.text != ""{
               showAlert(title: "Cannot Convert Value", message: "\"\(userInput.text!)\" is not a valid number.")
            }
            return
        }
        
    
        
          var outputValue = formulasArray[formulaPicker.selectedRow(inComponent: 0)].formula(inputValue)
          //let segmentedIndex = 3
          var formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments-1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f" : "%f")
          let outputString = String (format: formatString, outputValue)
        
          resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction (title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - IBActions
    @IBAction func userInputChanged(_ sender: UITextField) {
        resultsLabel.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
    }
    @IBAction func decimalSelected(_ sender: Any) {
        calculateConversion()
    }
    
    
    @IBAction func signSegmentSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0
        {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        if userInput.text != "-"
        {
            calculateConversion()
        }
    }
    
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConversion()
    }
}


//MARK:-PickerView Extension
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulasArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return formulasArray[row].conversionString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionString = formulasArray[row].conversionString
        
        
        if conversionString.lowercased().contains("celsius".lowercased())
        {
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
        }
        
        if conversionString.uppercased().contains("celsius".uppercased())
        {
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
        }
        
        
        
        let unitsArray = formulasArray[row].conversionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        //resultsLabel.text = toUnits
        calculateConversion()
        
    }
}

