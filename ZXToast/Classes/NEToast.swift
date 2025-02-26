//
//  ZXTipView.swift
//  Agriculture_Saas
//
//  Created by zxcl on 2022/1/5.
//

import Foundation
import UIKit


open class NEToast: Equatable {
    let id = UUID()
    let message: String?
    public let config: ToastConfig
    
    private weak var container: UIView?
    private weak var coverView: UIView?
    private var hideCompletion: (() -> Void)?
    private var progress: Double = 0
    
    public init(message: String? = nil, config: ToastConfig?=nil) {
        self.message = message
        self.config = config ?? .default
    }
    
    public static func == (lhs: NEToast, rhs: NEToast) -> Bool {
        lhs.id == rhs.id
    }
    
    public func show(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.hideCompletion = completion
            self.setupContainer()
            self.animateIn()
            self.scheduleAutoHide()
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            self.animateOut()
        }
    }
}

private extension NEToast {
    
    func setupContainer() {
        guard let window = getWindow() else { return }
        
        if case .loading = config.type {
            let mask = UIView(frame: window.bounds)
            mask.backgroundColor = .clear
            window.addSubview(mask)
            coverView = mask
        }
        
        let container = UIView()
        container.alpha = 0
        container.layer.cornerRadius = config.cornerRadius
        container.clipsToBounds = true
        self.container = container
        if let blurStyle = config.blurEffect {
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            blurView.frame = container.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addSubview(blurView)
        } else {
            container.backgroundColor = config.backgroundColor
        }
        
        container.layer.shadowColor = config.shadow.color.cgColor
        container.layer.shadowRadius = config.shadow.radius
        container.layer.shadowOpacity = config.shadow.opacity
        container.layer.shadowOffset = .zero
        
        let contentStack = createContentStack()
        container.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: container.topAnchor, constant: config.padding.top),
            contentStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: config.padding.left),
            contentStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -config.padding.right),
            contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -config.padding.bottom)
        ])
        layoutContainer(container, in: window)
    }
    
    func createContentStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        switch config.type {
        case .iconText(let icon):
            addIcon(icon, to: stack)
        case .loading:
            stack.spacing = 0
            addLoader(to: stack)
        default: break
        }
        if message?.isEmpty == false {
            addLabel(to: stack)
        }
        return stack
    }
    
    
    func addLabel(to stack: UIStackView) {
        let label = UILabel()
        label.text = message
        label.textColor = config.textColor
        label.font = config.font
        label.numberOfLines = 0
        stack.addArrangedSubview(label)
    }
    
    func addIcon(_ icon: UIImage, to stack: UIStackView) {
        let imageView = UIImageView(image: icon)
        imageView.tintColor = config.textColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: config.imageSize.height),
            imageView.widthAnchor.constraint(equalToConstant: config.imageSize.width)
        ])
        stack.addArrangedSubview(imageView)
    }
    
    func addLoader(to stack: UIStackView) {
        var loader: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            loader = UIActivityIndicatorView(style: .large)
        } else {
            loader = UIActivityIndicatorView(style: .whiteLarge)
        }
        loader.color = config.textColor
        loader.startAnimating()
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.heightAnchor.constraint(equalToConstant: 75),
            loader.widthAnchor.constraint(equalToConstant: message?.isEmpty == false ? 95 : 75)
        ])
        stack.addArrangedSubview(loader)
    }
    
    func getWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

private extension NEToast {
    func layoutContainer(_ container: UIView, in window: UIWindow) {
        window.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            container.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -20),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: config.maxWidth)
        ])
        
        switch config.position {
        case .top:
            container.topAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.topAnchor,
                constant: config.verticalOffset
            ).isActive = true
        case .center:
            container.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        case .bottom:
            container.bottomAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.bottomAnchor,
                constant: -config.verticalOffset
            ).isActive = true
        }
    }
    
    func animateIn() {
        guard let container = container else { return }
        
        let initialTransform: CGAffineTransform
        switch config.showAnimation {
        case .fade:
            initialTransform = .identity
        case .slide:
            initialTransform = CGAffineTransform(translationX: 0, y: -50)
        case .scale:
            initialTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        case .custom(let show, _):
            return show(container) { self.scheduleAutoHide() }
        }
        
        container.transform = initialTransform
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            container.alpha = 1
            container.transform = .identity
        }
    }
    
    func animateOut() {
        guard let container = container else { return }
        
        let finalTransform: CGAffineTransform
        switch config.hideAnimation {
        case .fade:
            finalTransform = .identity
        case .slide:
            finalTransform = CGAffineTransform(translationX: 0, y: 50)
        case .scale:
            finalTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        case .custom(_, let hide):
            return hide(container) { self.completeHide() }
        }
        
        UIView.animate(withDuration: 0.3) {
            container.alpha = 0
            container.transform = finalTransform
        } completion: { _ in
            self.completeHide()
        }
    }
    
    func completeHide() {
        container?.removeFromSuperview()
        coverView?.removeFromSuperview()
        hideCompletion?()
    }
    
    func scheduleAutoHide() {
        guard case .loading = config.type else {
            let duration = min(config.maxDisplayDuration,
                             max(config.minDisplayDuration,
                                 Double(message?.count ?? 0) * config.charDurationRatio))
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { self.hide() }
            return
        }
    }
}

public extension NEToast {
    
    static func showLoading(_ text: String? = nil) {
        let loadingToast = NEToast(message: text, config: ToastConfig(type: .loading))
        ToastManager.shared.show(loadingToast)
    }
    
    static func showMessage(_ text: String) {
        let messageToast = NEToast(message: text, config: .init(type: .text))
        ToastManager.shared.show(messageToast)
    }
    
    static func showSuccess(_ text: String?=nil) {
        showImage(loadBundleImage("success"), text: text)
    }
    
    static func showError(_ text: String?=nil) {
        showImage(loadBundleImage("fail"), text: text)
    }
    
    static func showImage(_ image: UIImage, text: String?=nil) {
        let successToast = NEToast(message: text, config: ToastConfig(type: .iconText(icon: image)))
        ToastManager.shared.show(successToast)
    }
    
    static func hideAll() {
        ToastManager.shared.hideAll()
    }
    
   
}


func loadBundleImage(_ name: String) -> UIImage {
    let currentBundle = Bundle(for: NEToast.self)
    return UIImage(named: name, in: Bundle(path: currentBundle.path(forResource: "ZXToast", ofType: "bundle") ?? ""), compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
}
