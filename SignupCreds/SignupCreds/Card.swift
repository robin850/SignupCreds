//
//  Card.swift
//  SignupCreds
//
//  Created by Robin Dupret on 12/11/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//
import UIKit

@objc public protocol CardDelegate {

    @objc optional func cardDidTapInside(card: Card)
    @objc optional func cardWillShowDetailView(card: Card)
    @objc optional func cardDidShowDetailView(card: Card)
    @objc optional func cardWillCloseDetailView(card: Card)
    @objc optional func cardDidCloseDetailView(card: Card)
    @objc optional func cardIsShowingDetail(card: Card)
    @objc optional func cardIsHidingDetail(card: Card)
    @objc optional func cardDetailIsScrolling(card: Card)

    @objc optional func cardHighlightDidTapButton(card: CardHighlight, button: UIButton)
}

@IBDesignable open class Card: UIView, CardDelegate {

    // Storyboard Inspectable vars
    /**
     Color for the card's labels.
     */
    @IBInspectable public var textColor: UIColor = UIColor.black
    /**
     Amount of blur for the card's shadow.
     */
    @IBInspectable public var shadowBlur: CGFloat = 14 {
        didSet{
            self.layer.shadowRadius = shadowBlur
        }
    }
    /**
     Alpha of the card's shadow.
     */
    @IBInspectable public var shadowOpacity: Float = 0.6 {
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    /**
     Color of the card's shadow.
     */
    @IBInspectable public var shadowColor: UIColor = UIColor.gray {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    /**
     The image to display in the background.
     */
    @IBInspectable public var backgroundImage: UIImage? {
        didSet{
            self.backgroundIV.image = backgroundImage
        }
    }
    /**
     Corner radius of the card.
     */
    @IBInspectable public var cardRadius: CGFloat = 20{
        didSet{
            self.layer.cornerRadius = cardRadius
        }
    }
    /**
     Insets between card's content and edges ( in percentage )
     */
    @IBInspectable public var contentInset: CGFloat = 6 {
        didSet {
            insets = LayoutHelper(rect: originalFrame).X(contentInset)
        }
    }
    /**
     Color of the card's background.
     */
    override open var backgroundColor: UIColor? {
        didSet(new) {
            if let color = new { backgroundIV.backgroundColor = color }
            if backgroundColor != UIColor.clear { backgroundColor = UIColor.clear }
        }
    }

    /**
     Event handler au moment du clique sur l'élément
     */
    @IBInspectable public var onClick : (() -> Void)! = {}

    /**
     contentViewController  -> The view controller to present when the card is tapped
     from                   -> Your current ViewController (self)
     */
    public func shouldPresent( _ contentViewController: UIViewController?, from superVC: UIViewController?, fullscreen: Bool = false) {
        if let content = contentViewController {
            self.superVC = superVC
            detailVC.addChild(content)
            detailVC.detailView = content.view
            detailVC.card = self
            detailVC.delegate = self.delegate
            detailVC.isFullscreen = fullscreen
        }
    }

    /**
     Delegate for the card. Should extend your VC with CardDelegate.
     */
    public var delegate: CardDelegate?

    //Private Vars
    fileprivate var tap = UITapGestureRecognizer()
    fileprivate var detailVC = DetailViewController()
    weak var superVC: UIViewController?
    var originalFrame = CGRect.zero
    public var backgroundIV = UIImageView()
    public var insets = CGFloat()
    var isPresenting = false

    //MARK: - View Life Cycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {

        // Tap gesture init
        self.addGestureRecognizer(tap)
        tap.delegate = self
        tap.cancelsTouchesInView = false

        //detailVC.transitioningDelegate = self

        // Adding Subviews
        self.addSubview(backgroundIV)

        backgroundIV.isUserInteractionEnabled = true

        if backgroundIV.backgroundColor == nil {
            backgroundIV.backgroundColor = UIColor.white
            super.backgroundColor = UIColor.clear
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        originalFrame = rect

        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowBlur
        self.layer.cornerRadius = cardRadius

        backgroundIV.image = backgroundImage
        backgroundIV.layer.cornerRadius = self.layer.cornerRadius
        backgroundIV.clipsToBounds = true
        backgroundIV.contentMode = .scaleAspectFill

        backgroundIV.frame.origin = bounds.origin
        backgroundIV.frame.size = CGSize(width: bounds.width, height: bounds.height)
        contentInset = 6
    }


    //MARK: - Layout

    open func layout(animating: Bool = true){ }


    //MARK: - Actions

    @objc func cardTapped() {
        self.onClick()
    }

}

//MARK: - Gesture Delegate

extension Card: UIGestureRecognizerDelegate {

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardTapped()
    }
}


//MARK: - Helpers

extension UILabel {

    func lineHeight(_ height: CGFloat) {

        let attributedString = NSMutableAttributedString(string: self.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = height
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
