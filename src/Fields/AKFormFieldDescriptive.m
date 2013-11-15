//
//  AKFormFieldDescriptive.m
//  
//
//  Created by Ahmed Khalaf on 31/10/2013.
//
//

#import "AKFormFieldDescriptive.h"

@implementation AKFormFieldDescriptive

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.placeholder = placeholder;
    }
    return self;
}
@end
