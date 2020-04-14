//
//  ReceiveDragView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/13.
//

import Cocoa

protocol ReceiveDragViewDelegate: NSObjectProtocol {
    func draggingFileAccept(file url: URL)
}

class ReceiveDragView: NSView {

    weak var delegate : ReceiveDragViewDelegate?
    /// 接受类型
    private let types: [String] = Receive.types
    /// 是否正在接收拖拽
    private var isReceivingDrag: Bool = false {
        didSet { needsDisplay = true }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 注册拖拽类型
        registerForDraggedTypes([.fileURL])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if isReceivingDrag {
            let path = NSBezierPath(
                roundedRect: dirtyRect.insetBy(dx: 2, dy: 2),
                xRadius: 20,
                yRadius: 20
            )
            path.lineWidth = 4
            path.setLineDash([7, 2], count: 1, phase: 0)
            NSColor.placeholderTextColor.setStroke()
            path.stroke()
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isReceivingDrag = true
        return sender.map().contains(extension: types) ? .copy : .init()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return sender.map().contains(extension: types)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        defer { isReceivingDrag = false }
        guard let url = sender.map(), url.contains(extension: types) else {
            return false
        }
        
        delegate?.draggingFileAccept(file: url)
        return true
    }
}

fileprivate extension NSDraggingInfo {
    
    func map() -> URL? {
        guard let file = draggingPasteboard.string(forType: .fileURL) else {
            return nil
        }
        return URL(string: file)
    }
}

fileprivate extension Optional where Wrapped == URL {
    
    func contains(extension types: [String]) -> Bool {
        switch self {
        case .some(let url):    return url.contains(extension: types)
        default:                return false
        }
    }
}

fileprivate extension URL {
    
    func contains(extension types: [String]) -> Bool {
        types.contains(pathExtension.lowercased())
    }
}

/**
 file:///.file/id=6571367.2773272/ 相关文档
 
 https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/AccessingFilesandDirectories/AccessingFilesandDirectories.html#//apple_ref/doc/uid/TP40010672-CH3-SW1
 
*/
