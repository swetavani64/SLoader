# SLoader
Custom Loader with animation
This is an attempt with text animation and view animation.<br>
Looking at the attached image will give you better idea about what this project covers.

# Requirements
Xcode 9.0 +<br>
Swift 4.0 +<br>
iOS 9 +<br>

# Basic Usage
drag and drop the Loader.swift into your project.<br>

To show loader call following method:

Loader.sharedInstance.showLoader()

For hiding loader call following method:

Loader.sharedInstance.stopLoader()

# Customization
you can also customize the properties of loader by following code:

 Loader.sharedInstance.animatedColor = UIColor.red<br>
 Loader.sharedInstance.loadingTextColor = UIColor.yellow<br>
 Loader.sharedInstance.circleColor = UIColor.blue<br>
 Loader.sharedInstance.movingCircleColor = UIColor.cyan<br>
 Loader.sharedInstance.backgroundColor = UIColor.black<br>
 
![alt tag](http://domain.com/path/to/Loader.png
