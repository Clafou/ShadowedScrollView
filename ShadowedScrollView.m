//
//  ShadowedScrollView.m
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

#import "ShadowedScrollView.h"

#define SHADOW_WIDTH 20.0

@implementation ShadowedScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lightColor = [[UIColor alloc] initWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        darkColor = [[UIColor alloc] initWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    return self;
}

- (CAGradientLayer *)newShadowWithColor:(UIColor *)color inverse:(BOOL)inverse vertical:(BOOL)vertical
{
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    CGColorRef col1 = [color colorWithAlphaComponent:1.0].CGColor;
    CGColorRef col2 = [color colorWithAlphaComponent:0.0].CGColor;
    layer.colors = (inverse) ? [NSArray arrayWithObjects:(id)col1, (id)col2, nil]
                             : [NSArray arrayWithObjects:(id)col2, (id)col1, nil];

    if (vertical) {
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1.0, 0.5);
    }

    return layer;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

    if (!contentShadowBack)
    {
        // One-off initialization
        self.backgroundColor = lightColor;

        contentShadowBack = [[CALayer alloc] init];
        contentShadowBack.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        contentShadowBack.backgroundColor = darkColor.CGColor;

        contentShadowTop = [self newShadowWithColor:lightColor inverse:YES vertical:NO];
        contentShadowBottom = [self newShadowWithColor:lightColor inverse:NO vertical:NO];
        contentShadowLeft = [self newShadowWithColor:lightColor inverse:YES vertical:YES];
        contentShadowRight = [self newShadowWithColor:lightColor inverse:NO vertical:YES];
        edgeShadowTop = [self newShadowWithColor:darkColor inverse:YES vertical:NO];
        edgeShadowBottom = [self newShadowWithColor:darkColor inverse:NO vertical:NO];

        [self.layer insertSublayer:edgeShadowTop atIndex:0];
        [self.layer insertSublayer:edgeShadowBottom atIndex:0];
        [self.layer insertSublayer:contentShadowTop atIndex:0];
        [self.layer insertSublayer:contentShadowRight atIndex:0];
        [self.layer insertSublayer:contentShadowBottom atIndex:0];
        [self.layer insertSublayer:contentShadowLeft atIndex:0];
        [self.layer insertSublayer:contentShadowBack atIndex:0];
    }

    [CATransaction begin];
    if ((self.layer.animationKeys.count > 0)) { // Check if an animation is ongoing
        // Create a transaction to match the layer's existing animation
        CAAnimation *animation = [self.layer animationForKey:[self.layer.animationKeys lastObject]];
        [CATransaction setAnimationDuration:animation.duration];
        [CATransaction setAnimationTimingFunction:animation.timingFunction];
    }
    else {
        // No animation
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    }

    // Position each of the layers
    CGRect frameBack;
    frameBack.origin.x = -SHADOW_WIDTH;
    frameBack.origin.y = -SHADOW_WIDTH;
    frameBack.size.width = self.contentSize.width + 2 * SHADOW_WIDTH;
    frameBack.size.height = self.contentSize.height + 2 * SHADOW_WIDTH;
    contentShadowBack.frame = frameBack;

    CGRect frame = frameBack;
    frame.size.height = SHADOW_WIDTH;
    contentShadowTop.frame = frame;
    frame.origin.y = self.contentSize.height;
    contentShadowBottom.frame = frame;

    frame = frameBack;
    frame.size.width = SHADOW_WIDTH;
    contentShadowLeft.frame = frame;
    frame.origin.x = self.contentSize.width;
    contentShadowRight.frame = frame;

    frame.origin.x = self.contentOffset.x;
    frame.origin.y = self.contentOffset.y;
    frame.size.width = self.frame.size.width; // Note: changes when screen re-orients so needs to be reevaluated each time
    frame.size.height = SHADOW_WIDTH;
    edgeShadowTop.frame = frame;
    frame.origin.y += self.frame.size.height - SHADOW_WIDTH;
    edgeShadowBottom.frame = frame;    

    [CATransaction commit];
}

- (void)dealloc
{
    [contentShadowBack release];
    [contentShadowTop release];
    [contentShadowBottom release];
    [contentShadowLeft release];
    [contentShadowRight release];
    [edgeShadowTop release];
    [edgeShadowBottom release];
    [lightColor release];
    [darkColor release];
    [super dealloc];
}

@end
