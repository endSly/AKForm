//
//  AKFormFieldTextBox.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormField.h"
#import "CSFormTextViewCell.h"

@interface AKFormFieldTextBox : AKFormField <UITextViewDelegate>

@property(nonatomic, assign) CGFloat textViewHeight;

- (instancetype)initWithKey:(NSString *)key
                placeholder:(NSString *)placeholder;
@end
