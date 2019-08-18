import Foundation

class AsyncOperation: Operation {
    private var _executing = false
    private var _finished = false
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
        
        get {
            return _executing
        }
    }
    
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
        
        get {
            return _finished
        }
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        willChangeValue(forKey: "isExecuting")
        _executing = true
        didChangeValue(forKey: "isExecuting")
        main()
        
    }
    
    override func main() {
        fatalError("Should be overriden")
    }
    
    func finish() {
        willChangeValue(forKey: "isFinished")
        _finished = true
        didChangeValue(forKey: "isFinished")
    }
}
