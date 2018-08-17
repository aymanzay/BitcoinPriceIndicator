//
//  ThemeManager.swift
import UIKit
import Foundation

/// Enum Theme Manager
/// - Note: https://github.com/durul/DRL-Theme-Manager
enum Theme: Int {
    
    case Dark, Graphical
    
    /// Main Color
    var mainColor: UIColor {
        switch self {
        case .Graphical:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red:0.13, green:0.13, blue:0.17, alpha:1.0)
        }
    }
    
    /// Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .Graphical:
            return .default
        case .Dark:
            return .black
        }
    }
    
    /// BackgroundColor properties
    var backgroundColor: UIColor {
        return UIColor(red:0.13, green:0.13, blue:0.17, alpha:1.0)
    }
    
    /// MainLabelColor properties
    var mainLabelColor: UIColor {
        return UIColor(red:0.58, green:0.78, blue:0.44, alpha:1.0)
    }
    
    /// CommentColor properties
    var commentColor: UIColor {
        return UIColor(red:0.61, green:0.64, blue:0.69, alpha:1.0)
    }
    
    /// BlueColor properties
    var blueColor: UIColor {
        return UIColor(red:0.27, green:0.44, blue:0.85, alpha:1.0)
    }
    
    /// OrangeColor properties
    var orangeColor: UIColor {
        return  UIColor(red:0.82, green:0.56, blue:0.36, alpha:1.0)
    }
    
    /// FuchsiaColor
    var fuchsiaColor: UIColor {
        return  UIColor(red:0.72, green:0.22, blue:0.60, alpha:1.0)
    }
}

/// Enum declaration
let SelectedThemeKey = "SelectedTheme"

/// This will let you use a theme in the app.
struct ThemeManager {
    
    /// currentTheme: static function store current theme.
    /// Returns: Theme
    /// Parameters: None
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Graphical
        }
    }
    
    /// applyTheme: static function applyTheme.
    /// Returns: None
    /// Parameters: theme
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [kCTForegroundColorAttributeName : theme.blueColor] as [NSAttributedStringKey : Any]
        
    }
}
