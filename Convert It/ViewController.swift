//
//  ViewController.swift
//  Convert It
//
//  Created by Kenyan Houck on 2/23/19.
//  Copyright © 2019 Kenyan Houck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    
    
    var formulaArray = ["Miles to Kilometers", "Kilometers to Miles", "Feet to Meters", "Meters to Feet", "Yards to Meters", "Meters to Yards", "Inches to Centimeters", "Centimeters to Inches", "Fahrenheit to Celsius", "Celsius to Fahrenheit", "Quarts to Liters", "Liters to Quarts"]
    
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    
    
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        conversionString = formulaArray[formulaPicker.selectedRow(inComponent: 0)]
        userInput.becomeFirstResponder()
    }


    func calculateConversion(){
        guard let inputValue = Double (userInput.text!) else {
            if userInput.text != ""{
               showAlert(title: "Cannot Convert Value", message: "\"\(userInput.text!)\" is not a valid number.")
            }
            return
        }
    
            var outputValue = 0.0
            switch conversionString{
            case "Miles to Kilometers":
                outputValue = inputValue / 0.62137
            case "Kilometers to Miles":
                outputValue = inputValue * 0.62137
            case "Feet to Meters":
                outputValue = inputValue / 3.2808
            case "Meters to Feet":
                outputValue = inputValue * 3.2808
            case "Yards to Meters":
                outputValue = inputValue / 1.0936
            case "Meters to Yards":
                outputValue = inputValue * 1.0936
            case "Inches to Centimeters":
                outputValue = inputValue / 0.3937
            case "Centimeters to Inches":
                outputValue = inputValue * 0.3937
            case "Fahrenheit to Celsius":
                outputValue = (inputValue - 32 ) * (5/9)
            case "Celsius to Fahrenheit":
                outputValue = (inputValue * (9/5) ) + 32
            case "Quarts to Liters":
                outputValue = inputValue / 1.05669
            case "Liters to Quarts":
                outputValue = inputValue * 1.05669
            default:
                showAlert(title: "Unexpected Error", message: "Contact the developer and share that \"\(conversionString)\" could not be identified")
            }
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
        return formulaArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return formulaArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionString = formulaArray[row]
        
        
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
        
        
        
        let unitsArray = formulaArray[row].components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        //resultsLabel.text = toUnits
        calculateConversion()
        
    }
}

