//
//  SkillSelectViewController.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/29/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectLocationView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var countrySelected : Int = 0
    var stateSelected : Int = 0
    var citySelected : Int = 0
    
    struct StateData
    {
        var state : String
        var city : [String] = []
    }
    
    struct CountryData
    {
        var country : String
        var state : [StateData] = []
    }
    
    var pickerData : [CountryData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stateData = CountryData(country: "USA", state: [StateData(state: "NY", city: ["Buffalo", "Niagara", "Rochester"])])
        stateData.state.append(StateData(state: "NJ", city: ["City1", "City2", "City3"]))
        pickerData.append(stateData)
        
        //stateData = CountryData(country: "United Kingdom", state: [StateData(state: "Alabama", city: ["Montgomery", "Birmingham"])])
        //stateData.state.append(StateData(state: "Alaska", city: ["Juneau", "Anchorage"]))
        //stateData.state.append(StateData(state: "Arizona", city: ["Phoenix", "Another city", "City 3"]))
        //pickerData.append(stateData)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 3 // country, state, city
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch component
        {
        case 0: // country
            return pickerData.count
            
        case 1: // state
            return pickerData[countrySelected].state.count
            
        case 2: // city
            return pickerData[countrySelected].state[stateSelected].city.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch component
        {
        case 0: // country
            return pickerData[row].country
            
        case 1: // state
            return pickerData[countrySelected].state[row].state
            
        case 2: // city
            return pickerData[countrySelected].state[stateSelected].city[row]
            
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        switch component {
        case 0: // country
            countrySelected = pickerView.selectedRow(inComponent: 0)
            stateSelected = 0
            citySelected = 0
            
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
        case 1: // country
            stateSelected = pickerView.selectedRow(inComponent: 1)
            citySelected = 0
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            
        case 2: // country
            citySelected = pickerView.selectedRow(inComponent: 2)
            
        default:
            break
        }
        
        print("\(pickerData[countrySelected].country), \(pickerData[countrySelected].state[stateSelected].state), \(pickerData[countrySelected].state[stateSelected].city[citySelected])")
    }
    
}
