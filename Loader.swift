//
//  Loader.swift
//  SLoader
//
//  Created by Shweta Vani on 24/11/17.
//  Copyright © 2017 Brainvire. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics


//default colors for loader
struct LoaderColor {
    static let backgroundColor = UIColor.lightGray
    static let circleColor = UIColor.black
    static let loadingTextColor = UIColor.black
    static let movingCircleColor = UIColor.blue
    static let animatedColor = UIColor.white
}

//default frames for loader
struct viewFrame {
    //width and height of main view for loader
    static let loadingViewWidth : Int = 100
    static let loadingViewHeight : Int = 100
    
    //UIView frame of circle with co-ordinates
    static let circleX : Int = 20
    static let circleY : Int = 5
    static let circleWidth : Int = 60
    static let circleHeight : Int = 60
    
    //UIView frame of moving circle with co-ordinates
    static let squareViewX : Int = 0
    static let squareViewY : Int = 0
    static let squareViewWidth : Int = 15
    static let squareViewHeight : Int = 15
    
    //UILabel frame of text loading with co-ordinates
    static let labelLoadingX :  Int = 0
    static let labelLoadingY :  Int = 70
    static let labelLoadingWidth :  Int = 100
    static let labelLoadingHeight :  Int = 20
}

class Loader: NSObject {
    
    //notification center for foreground state
    private var notificationCenter = NotificationCenter.default
  
    //for loader background color change
    var backgroundColor = LoaderColor.backgroundColor
    
    //for loader circle color change
    var circleColor = LoaderColor.circleColor
    
    //for loading text color change
    var loadingTextColor = LoaderColor.loadingTextColor
    
    //for moving circle color change
    var movingCircleColor = LoaderColor.movingCircleColor
    
    //for label animation color change
    var animatedColor = LoaderColor.animatedColor
    
    //Main view which contains all the subviews
    private var loadingView = UIView(frame: CGRect(x: 0,y:0, width: viewFrame.loadingViewWidth, height: viewFrame.loadingViewHeight))
    
    //UIView which is main window
    private var viewParent:UIView!
    
    //UIBezierPath it draws the circle on CAShapeLayer path
    private var progressCircle = CAShapeLayer()
    private var circlePath = UIBezierPath()
    
    //for animation of moving circle
    private var animation = CAKeyframeAnimation()
    
    //UIView which is moving circle it adds on circle
    private var squareView = UIView()
    private var circle = UIView()
    
    //UILabel which contains "Loading..." text
    private var lblLoading = UILabel()
    private var strLoading = "Loading..."
    
    //Timer is used for animation
    private var timer = Timer()
    private var i = 0
    private var isFromanimation = false
    private var isCompletedFirstCycle = false
   
    
    //shared instance of class
    static let sharedInstance = Loader()
    
    //MARK:show Loader Method
    func showLoader(){
        self.drawLoaderCircle(backgroundColor: self.backgroundColor, circleColor: self.circleColor, movingCircleColor: self.movingCircleColor, loadingTextColor: self.loadingTextColor)
    }
    
    
    //MARK:- Loader method
    func drawLoaderCircle(backgroundColor:UIColor,
                          circleColor:UIColor,
                          movingCircleColor:UIColor,
                          loadingTextColor:UIColor)
    {

        let app = UIApplication.shared.delegate as? AppDelegate
        let window = app?.window?.rootViewController?.view!
        viewParent = UIView(frame: (window?.frame)!)
        viewParent.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        loadingView.layoutIfNeeded()
        loadingView.center = viewParent.center
        loadingView.backgroundColor = backgroundColor
        
        //UIVIew for Circle
        circle.frame = CGRect (x: viewFrame.circleX, y: viewFrame.circleY, width: viewFrame.circleWidth, height: viewFrame.circleHeight)
        circle.layoutIfNeeded()
       
        //adding circle on UIView
        let centerPoint = CGPoint (x: circle.bounds.width / 2, y: circle.bounds.width / 2)
        let circleRadius : CGFloat = circle.bounds.width / 2 * 0.83
    
        circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = circleColor.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 2.5
        progressCircle.strokeStart = 0
        progressCircle.strokeEnd = 1.0
        circle.layer.addSublayer(progressCircle)
        loadingView.addSubview(circle)
        //Circle
    
        //moving view on Circle
        squareView.frame = CGRect (x: viewFrame.squareViewX, y: viewFrame.squareViewY, width: viewFrame.squareViewWidth, height: viewFrame.squareViewHeight)
        squareView.backgroundColor = movingCircleColor
        squareView.alpha = 0
        squareView.layer.cornerRadius = self.squareView.frame.size.width / 2
        squareView.layer.layoutIfNeeded()
        circle.addSubview(self.squareView)
        
        //Animation on circle
        startANimating()
        
        //UIlabel in center of view
        lblLoading.frame = CGRect (x: viewFrame.labelLoadingX , y: viewFrame.labelLoadingY, width: viewFrame.labelLoadingWidth, height: viewFrame.labelLoadingHeight)
        lblLoading.text = strLoading
        lblLoading.textColor = loadingTextColor
        lblLoading.font = lblLoading.font.withSize(18)
        //lblLoading.backgroundColor = UIColor.yellow
        lblLoading.layer.shadowColor = loadingTextColor.cgColor
        lblLoading.layer.shadowOpacity = 0.5
        lblLoading.layer.shadowOffset = CGSize.zero
        lblLoading.layer.shadowRadius = 4.5
        lblLoading.layer.masksToBounds = false
        lblLoading.textAlignment = .center
        loadingView.addSubview(lblLoading)
        viewParent.addSubview(loadingView)
        window?.addSubview(viewParent)
        viewParent.bringSubview(toFront: window!)
        
        //Animation on label
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.animateChangeColor), userInfo: nil, repeats: true)
        
        //managing foreground state animation
        notificationCenter.addObserver(self,
                                       selector: #selector(applicationWillEnterForeground(_:)),
                                       name: NSNotification.Name.UIApplicationWillEnterForeground,
                                       object: nil)
        
    }
    
    //MARK:- startANimating method
    func startANimating()  {
        animation = CAKeyframeAnimation(keyPath: "position");
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.path = self.circlePath.cgPath
        animation.rotationMode = kCAAnimationRotateAuto
        squareView.alpha = 1
        squareView.layer.add(self.animation, forKey: nil)
    }

    //MARK:- Stop Loader method
    func stopLoader()  {
        viewParent.removeFromSuperview()
        timer.invalidate()
        notificationCenter.removeObserver(self)
    }
    
    
    //MARK:- Foreground Method
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.startANimating()
    }
    
    //MARK:- animateChangeColor method
   //Text color change of each character
    @objc func animateChangeColor() {
        DispatchQueue.main.async {
            self.lblLoading.text = self.strLoading
            self.lblLoading.fadeTransition(0.5)
            var mutuableString = NSMutableAttributedString()
            mutuableString = NSMutableAttributedString (string: self.lblLoading.text!)
            mutuableString.setAttributes([NSAttributedStringKey.foregroundColor : self.animatedColor], range: NSRange(location:self.i,length:1))
            self.lblLoading.attributedText = mutuableString
           
            print("\("11---:", self.isCompletedFirstCycle)")
            print("\("22---:", self.isCompletedFirstCycle)")
            print(self.i)

            
            if (self.lblLoading.text?.count)!-1 == self.i{

                if self.isFromanimation == false
                {
                    self.isFromanimation = true
                    self.isCompletedFirstCycle = false
                    self.i = self.i - 1
                }
                else{
                    self.isFromanimation = false
                    self.i = 0
                    self.isCompletedFirstCycle = false
                }
            }
            else if self.i == 7 && self.isFromanimation
            {
                self.i = self.i + 1
                self.isCompletedFirstCycle = true
            }
            else{
                if self.isFromanimation == true
                {
                    if self.isCompletedFirstCycle{
                        self.i = self.i + 1
                    }else{
                        self.i = self.i - 1
                    }
                }else{
                    self.i = self.i + 1
                }
            }
        }
    }
}


//MARK:- UIView Extension
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}

