//
//  Something.m
//  AKForm
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "Something.h"
#import <NSDate+Helper.h>
#import <NSString+Hashes.h>
#import <PhoneNumberFormatter.h>

@implementation Something

+ (NSString *)something
{
    return [NSDate stringForDisplayFromDate:[NSDate date]];
}

+ (NSString *)somethingElse
{
    return [@"hi" md5];
}

+ (NSString *)somethingEvenElse
{
    PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
    NSString *formattedNumber = [formatter stringForObjectValue:@"2345677890"];
    return formattedNumber;
}

@end
