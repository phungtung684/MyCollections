//
//  PVTPlaceholderTextView.swift
//  MyCollections
//
//  Created by noka-devlab on 8/25/21.
//

import UIKit

@IBDesignable class PVTPlaceholderTextView: UITextView {
    
    @IBInspectable var placeHolder: String = ""
    @IBInspectable var placeHolderColor: UIColor = .lightGray
    
    private var placeHolderLayer: CATextLayer?
    
    private func createPlaceHolderLayerIfNeed() {
        if placeHolderLayer == nil {
            let layer = CATextLayer()
            layer.fontSize = self.font?.pointSize ?? UIFont.systemFontSize
            layer.frame = CGRect(x: self.textContainerInset.left + self.textContainer.lineFragmentPadding,
                                 y: self.textContainerInset.top,
                                 width: self.frame.width - self.textContainer.lineFragmentPadding * 2 - self.textContainerInset.right - textContainerInset.left,
                                 height: frame.height)
            layer.string = self.placeHolder
            layer.foregroundColor = placeHolderColor.cgColor
            layer.contentsScale = UIScreen.main.scale
            layer.alignmentMode = CATextLayerAlignmentMode.left
            layer.isWrapped = true
            
            self.layer.addSublayer(layer)
            placeHolderLayer = layer
        }
    }
    
    private func removePlaceHolderLayerIfNeed() {
        placeHolderLayer?.removeFromSuperlayer()
        placeHolderLayer = nil
    }
    
    private func updateLayer() {
        // Observerから呼ばれるとmainじゃないかも？
        DispatchQueue.main.async {
            if self.text == nil || self.text.isEmpty {
                self.createPlaceHolderLayerIfNeed()
            } else {
                self.removePlaceHolderLayerIfNeed()
            }
        }
    }
    
    @objc func onChangedText(_ notification: NSNotification?) {
        updateLayer()
    }
    
    // MARK: Observer関連
    
    private func addObserver() {
        updateLayer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onChangedText(_:)), name: UITextView.textDidChangeNotification, object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObserver()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

