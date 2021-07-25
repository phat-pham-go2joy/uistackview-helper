
import UIKit

public enum StackViewConfig {
    case spacing(_ value: CGFloat)
    case alignment(_ value: UIStackView.Alignment)
    case distribution(_ value: UIStackView.Distribution)
}

open class StackView: UIStackView {
    public init(axis: NSLayoutConstraint.Axis, configs: [StackViewConfig], views: [UIView]) {
        super.init(frame: .zero)
        self.axis = axis
        
        if #available(iOS 11.0, *) {
            insetsLayoutMarginsFromSafeArea = false
        } else {
            // Fallback on earlier versions
        }
        configs.forEach { config in
            switch config {
            case .alignment(let value): self.alignment = value
            case .spacing(let value): self.spacing = value
            case .distribution(let value): self.distribution = value
            }
        }
        for index in (0..<views.count) {
            let view = views[index]
            self.addArrangedSubview(view)
            if let space = view.spaceAfterInStackView {
                if #available(iOS 11, *) {
                    self.setCustomSpacing(space, after: view)
                } else {
                    if space == self.spacing {
                        continue
                    }
                    let differentSpacing = space - 2 * self.spacing
                    if differentSpacing >= 0 {
                        let v = UIView()
                        v.backgroundColor = .clear
                        v.heightAnchor.constraint(equalToConstant: differentSpacing).isActive = true
                        self.addArrangedSubview(v)
                    } else {
                        print("Can't set custom spacing")
                    }
                }
            }
        }
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class VStackView: StackView {
    public convenience init(_ views: UIView..., configs: [StackViewConfig] = []) {
        self.init(views: views, configs: configs)
    }
    public init(views: [UIView], configs: [StackViewConfig] = []) {
        super.init(axis: .vertical, configs: configs, views: views)
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class HStackView: StackView {
    public convenience init(_ views: UIView..., configs: [StackViewConfig] = []) {
        self.init(views: views, configs: configs)
    }
    public init(views: [UIView], configs: [StackViewConfig] = []) {
        super.init(axis: .horizontal, configs: configs, views: views)
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Helper for stack view with appearance
open class WrapView: UIView {
    /// Wrap a view with padding
    public init(_ view: UIView, padding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
        super.init(frame: .zero)
        self.addSubview(view)
        view.fillSuperview()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}