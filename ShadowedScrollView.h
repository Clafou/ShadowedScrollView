//
//  ShadowedScrollView.h
//  ShadowedScrollView
//
//  Copyright (c) 2011 Sébastien Molines. All rights reserved.
// 
//  With thanks to Matt Galagher at Cocoa With Love for his article, which was a starting point,
//  at http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html
// 
//  This code is licensed under the BSD license that is available at: http://www.opensource.org/licenses/bsd-license.php
//
//  Please consider giving credit to the author and/or letting him know if you use this code.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShadowedScrollView : UIScrollView
{
	CALayer *contentShadowBack;
	CALayer *contentShadowTop;
	CALayer *contentShadowRight;
	CALayer *contentShadowLeft;
	CALayer *contentShadowBottom;
	CALayer *edgeShadowTop;
	CALayer *edgeShadowBottom;
    UIColor *lightColor;
    UIColor *darkColor;
}

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame;

@end
