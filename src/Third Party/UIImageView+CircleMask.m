//
//  UIImageView+CircleMask.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 8/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "UIImageView+CircleMask.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (CircleMask)

- (void)maskWithCircle
{
    CALayer *imageLayer = self.layer;
    CGFloat cornerRadius = self.frame.size.width/2;
    [imageLayer setCornerRadius:cornerRadius];
    [imageLayer setMasksToBounds:YES];
}

- (void)removeMask
{
    CALayer *imageLayer = self.layer;
    [imageLayer setCornerRadius:0.0];
}

@end
