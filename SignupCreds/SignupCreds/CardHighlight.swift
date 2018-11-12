//
//  CardHighlight.swift
//  SignupCreds
//
//  Created by Robin Dupret on 12/11/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

@IBDesignable open class CardHighlight: Card {

    /**
     Text of the title label.
     */
    @IBInspectable public var title: String = "welcome \nto \ncards !" {
        didSet{
            titleLbl.text = title.uppercased()
            titleLbl.lineHeight(0.70)
        }
    }
    /**
     Max font size the title label.
     */
    @IBInspectable public var titleSize:CGFloat = 26

    /**
     Image displayed in the icon ImageView.
     */
    @IBInspectable public var icon: UIImage? {
        didSet{
            iconIV.image = icon
            bgIconIV.image = icon
        }
    }
    /**
     Corner radius for the icon ImageView
     */
    @IBInspectable public var iconRadius: CGFloat = 16 {
        didSet{
            iconIV.layer.cornerRadius = iconRadius
            bgIconIV.layer.cornerRadius = iconRadius*2
        }
    }
    /**
     Text for the card's button.
     */
    @IBInspectable public var buttonText: String = "view" {
        didSet{
            self.setNeedsDisplay()
        }
    }

    //Priv Vars
    private var iconIV = UIImageView()
    private var actionBtn = UIButton()
    private var titleLbl = UILabel ()
    private var lightColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    private var bgIconIV = UIImageView()

    fileprivate var btnWidth = CGFloat()

    // View Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override open func initialize() {
        super.initialize()

        actionBtn.addTarget(self, action: #selector(buttonTapped), for: UIControl.Event.touchUpInside)

        backgroundIV.addSubview(iconIV)
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(actionBtn)

        if backgroundImage == nil {  backgroundIV.addSubview(bgIconIV); }
        else { bgIconIV.alpha = 0 }
    }


    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        //Draw
        bgIconIV.image = icon
        bgIconIV.alpha = backgroundImage != nil ? 0 : 0.6
        bgIconIV.clipsToBounds = true

        iconIV.image = icon
        iconIV.clipsToBounds = true

        titleLbl.text = title.uppercased()
        titleLbl.textColor = textColor
        titleLbl.font = UIFont.systemFont(ofSize: titleSize, weight: .heavy)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.lineHeight(0.70)
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byTruncatingTail
        titleLbl.numberOfLines = 3
        backgroundIV.bringSubviewToFront(titleLbl)

        actionBtn.backgroundColor = UIColor.clear
        actionBtn.layer.backgroundColor = lightColor.cgColor
        actionBtn.clipsToBounds = true
        let btnTitle = NSAttributedString(string: buttonText.uppercased(), attributes: [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .black), NSAttributedString.Key.foregroundColor : self.tintColor])
        actionBtn.setAttributedTitle(btnTitle, for: .normal)

        btnWidth = CGFloat((buttonText.count + 2) * 10)

        layout()

    }

    override open func layout(animating: Bool = true) {
        super.layout(animating: animating)

        let gimme = LayoutHelper(rect: backgroundIV.frame)

        iconIV.frame = CGRect(x: insets,
                              y: insets,
                              width: gimme.Y(25),
                              height: gimme.Y(25))

        titleLbl.frame.origin = CGPoint(x: insets, y: gimme.Y(5, from: iconIV))
        titleLbl.frame.size.width = (originalFrame.width * 0.65) + ((backgroundIV.bounds.width - originalFrame.width)/3)
        titleLbl.frame.size.height = gimme.Y(35)

        bgIconIV.transform = CGAffineTransform.identity


        iconIV.layer.cornerRadius = iconRadius

        bgIconIV.frame.size = CGSize(width: iconIV.bounds.width * 2, height: iconIV.bounds.width * 2)
        bgIconIV.frame.origin = CGPoint(x: gimme.RevX(0, width: bgIconIV.frame.width) + LayoutHelper.Width(40, of: bgIconIV) , y: 0)


        bgIconIV.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/6))
        bgIconIV.layer.cornerRadius = iconRadius * 2

        actionBtn.frame = CGRect(x: gimme.RevX(0, width: btnWidth) - insets,
                                 y: gimme.RevY(0, height: 32) - insets,
                                 width: btnWidth,
                                 height: 32)
        actionBtn.layer.cornerRadius = actionBtn.layer.bounds.height/2
    }

    //Actions

    @objc  func buttonTapped(){
        UIView.animate(withDuration: 0.2, animations: {
            self.actionBtn.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.actionBtn.transform = CGAffineTransform.identity
            })
        }
        delegate?.cardHighlightDidTapButton?(card: self, button: actionBtn)
    }
}
