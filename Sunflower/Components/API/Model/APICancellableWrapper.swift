import Foundation
import Moya

extension API {
    
    class CancellableWrapper: Cancellable {
        
        let target: TargetType
        var value: Cancellable = SimpleCancellable()
        
        var isCancelled: Bool { value.isCancelled }
        
        init(_ target: TargetType) {
            self.target = target
        }
        
        func cancel() {
            value.cancel()
        }
    }
    
    class MultipartCancellable: Cancellable {
        let cancels: [Cancellable]
        
        var isCancelled: Bool { cancels.allSatisfy { $0.isCancelled } }
        
        init(_ cancels: [Cancellable]) {
            self.cancels = cancels
        }
        
        func cancel() {
            cancels.forEach { $0.cancel() }
        }
    }
    
    class SimpleCancellable: Cancellable {
        var isCancelled = false
        func cancel() {
            isCancelled = true
        }
    }
}
