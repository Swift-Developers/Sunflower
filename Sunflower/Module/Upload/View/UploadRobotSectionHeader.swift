//
//  UploadRobotSectionHeader.swift
//  Sunflower
//
//  Created by Lee on 2020/9/2.
//

import Cocoa
import SnapKit

class UploadRobotSectionHeader: NSView {

    private lazy var image: NSImageView = .init()
    private lazy var label: NSTextField = .init(labelWithString: "")
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setup()
        setupLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        layer?.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1).cgColor
    }
    
    private func setup() {
        image.customCornerRadius = 4
        addSubview(image)
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        addSubview(label)
    }
       
    private func setupLayout() {
        image.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
}

extension UploadRobotSectionHeader {
    
    /// 设置
    /// - Parameters:
    ///   - icon: 图标
    ///   - name: 名称
    func set(_ icon: NSImage, with name: String) {
        self.image.image = icon
        self.label.stringValue = name
    }
}
