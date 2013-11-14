//
//  CSFormFieldTextView.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldDescriptive.h"
#import "CSFormTextViewCell.h"

@interface CSFormFieldTextView : CSFormFieldDescriptive <UITextViewDelegate>

@property(nonatomic, assign) CGFloat textViewHeight;

- (instancetype)initWithKey:(NSString *)key
                placeholder:(NSString *)placeholder;
@end