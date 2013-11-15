//
//  AKFormFieldDescriptive.h
//  
//
//  Created by Ahmed Khalaf on 31/10/2013.
//
//

#import "AKFormField.h"

/**
 *  Abstract class that is may have placeholder strings (for the right label, for instance), 
 *  describing the (set of) data selected as feedback
 */
@interface AKFormFieldDescriptive : AKFormField

@property(nonatomic, strong) NSString *placeholder;

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder;

@end
