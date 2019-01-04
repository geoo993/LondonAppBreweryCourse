import RxCocoa
import RxSwift

// MARK: - Reactive ext on UIView

extension Reactive where Base: UIView {
    /// adds animated bindings to view classes under `rx.animated`
    var animated: AnimatedSink<Base> {
        return AnimatedSink<Base>(base: base)
    }
    /// default animated sink on `UIView`
    func animated(_ duration: TimeInterval) -> AnimatedSink<Base> {
        let type = AnimationType<Base>(type: RxAnimationType.animation, duration: duration, animations: nil)
        return AnimatedSink<Base>(base: self.base, type: type)
    }
}

// MARK: - UIView
extension AnimatedSink where Base: UIView {
    var isHidden: Binder<Bool> {
        return Binder(base) { view, hidden in
            self.type.animate(view: view, binding: {
                view.isHidden = hidden
            })
        }
    }
}

extension AnimatedSink where Base: UIView {
    var alpha: Binder<CGFloat> {
        return Binder(base) { view, alpha in
            self.type.animate(view: view, binding: {
                view.alpha = alpha
            })
        }
    }
}

extension AnimatedSink where Base: UIView {
    var frame: Binder<CGRect> {
        return Binder(base) { view, frame in
            self.type.animate(view: view, binding: {
                view.frame = frame
            })
        }
    }
}

// MARK: - UILabel

extension AnimatedSink where Base: UILabel {
    var text: Binder<String> {
        return Binder(base) { label, text in
            self.type.animate(view: label, binding: {
                guard let label = label as? UILabel else { return }
                label.text = text
            })
        }
    }

    var attributedText: Binder<NSAttributedString> {
        return Binder(base) { label, text in
            self.type.animate(view: label, binding: {
                guard let label = label as? UILabel else { return }
                label.attributedText = text
            })
        }
    }
}

// MARK: - UIControl

extension AnimatedSink where Base: UIControl {
    var isEnabled: Binder<Bool> {
        return Binder(base) { control, enabled in
            self.type.animate(view: control, binding: {
                guard let control = control as? UIControl else { return }
                control.isEnabled = enabled
            })
        }
    }

    var isSelected: Binder<Bool> {
        return Binder(base) { control, selected in
            self.type.animate(view: control, binding: {
                guard let control = control as? UIControl else { return }
                control.isSelected = selected
            })
        }
    }
}

// MARK: - UIButton

extension AnimatedSink where Base: UIButton {
    var title: Binder<String> {
        return Binder(base) { button, title in
            self.type.animate(view: button, binding: {
                guard let button = button as? UIButton else { return }
                button.setTitle(title, for: button.state)
            })
        }
    }

    var image: Binder<UIImage?> {
        return Binder(base) { button, image in
            self.type.animate(view: button, binding: {
                guard let button = button as? UIButton else { return }
                button.setImage(image, for: button.state)
            })
        }
    }

    var backgroundImage: Binder<UIImage?> {
        return Binder(base) { button, image in
            self.type.animate(view: button, binding: {
                guard let button = button as? UIButton else { return }
                button.setBackgroundImage(image, for: button.state)
            })
        }
    }
}

// MARK: - UIImageView

extension AnimatedSink where Base: UIImageView {
    var image: Binder<UIImage?> {
        return Binder(base) { imageView, image in
            self.type.animate(view: imageView, binding: {
                guard let imageView = imageView as? UIImageView else { return }
                imageView.image = image
            })
        }
    }
}

// MARK: - Reactive ext on NSLayoutConstraint

extension Reactive where Base: NSLayoutConstraint {
    /// adds animated bindings to view classes under `rx.animated`
    var animated: AnimatedSink<Base> {
        return AnimatedSink<Base>(base: base)
    }
}

// MARK: - NSLayoutConstraint

extension AnimatedSink where Base: NSLayoutConstraint {
    var constant: Binder<CGFloat> {
        return Binder(base) { constraint, constant in
            guard let view = constraint.firstItem as? UIView,
                let superview = view.superview else { return }

            self.type.animate(view: superview, binding: {
                constraint.constant = constant
            })
        }
    }

    var isActive: Binder<Bool> {
        return Binder(base) { constraint, active in
            guard let view = constraint.firstItem as? UIView,
                let superview = view.superview else { return }

            self.type.animate(view: superview, binding: {
                constraint.isActive = active
            })
        }
    }
}
