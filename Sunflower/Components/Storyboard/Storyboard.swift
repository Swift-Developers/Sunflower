import Foundation
import Cocoa

enum StoryBoard: String {
    case picker              = "Picker"
    case receive             = "Receive"
    case pgyer               = "Pgyer"
    case firim               = "Firim"
    case settings            = "Settings"
    
    var storyboard: NSStoryboard {
        return NSStoryboard(name: rawValue, bundle: nil)
    }
    
    func instance<T>() -> T {
        return storyboard.instantiateController(withIdentifier: String(describing: T.self)) as! T
    }
}
