import Foundation
import Cocoa

enum StoryBoard: String {
    case receive             = "Receive"
    case pgyer               = "Pgyer"
    case firim               = "Firim"
    
    var storyboard: NSStoryboard {
        return NSStoryboard(name: rawValue, bundle: nil)
    }
    
    func instance<T>() -> T {
        return storyboard.instantiateController(withIdentifier: String(describing: T.self)) as! T
    }
}
