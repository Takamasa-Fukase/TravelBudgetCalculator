//
//  UserDefaults+Extension.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 31/8/24.
//

import Foundation

extension UserDefaults {
    static let defaults = UserDefaults.standard

    private enum Keys {
        static let registeredCurrencies = "registeredCurrencies"
        static let travels = "travels"
    }
    
    static var registeredCurrencies: [RegisteredCurrency] {
        get {
            do {
                guard let data = defaults.data(forKey: Keys.registeredCurrencies) else {
                    return []
                }
                let decodedValue = try JSONDecoder().decode([RegisteredCurrency].self, from: data)
                return decodedValue
            } catch {
                print("registeredCurrenciesのget catchしたエラー: \(error)")
                return []
            }
        }
        set {
            do {
                let encodedValue = try JSONEncoder().encode(newValue)
                defaults.set(encodedValue, forKey: Keys.registeredCurrencies)
            } catch {
                print("registeredCurrenciesのset catchしたエラー: \(error)")
            }
        }
    }
    
    static var travels: [Travel] {
        get {
            do {
                guard let data = defaults.data(forKey: Keys.travels) else {
                    return []
                }
                let decodedValue = try JSONDecoder().decode([Travel].self, from: data)
                return decodedValue
            } catch {
                print("travelsのget catchしたエラー: \(error)")
                return []
            }
        }
        set {
            do {
                let encodedValue = try JSONEncoder().encode(newValue)
                defaults.set(encodedValue, forKey: Keys.travels)
            } catch {
                print("travelsのset catchしたエラー: \(error)")
            }
        }
    }
}
