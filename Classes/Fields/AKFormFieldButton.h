//
//  AKFormFieldButton.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormField.h"
#import "AKFormCellButton.h"

@interface AKFormFieldButton : AKFormField

@property(nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property(nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, strong) UIImage *image;

@property(nonatomic, weak) id<AKFormCellButtonDelegate> delegate;
@property(nonatomic, weak) id<AKFormCellButtonStyleProvider> styleProvider;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                    subtitle:(NSString *)subtitle
                       image:(UIImage *)image
                    delegate:(id<AKFormCellButtonDelegate>)delegate
               styleProvider:(id<AKFormCellButtonStyleProvider>)styleProvider;

@end
