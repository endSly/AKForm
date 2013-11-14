//
//  Something.m
//  AKForm
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "Something.h"
#import <NSDate+Helper.h>

@implementation Something

+ (NSString *)something
{
    return [NSDate stringForDisplayFromDate:[NSDate date]];
}

@end
