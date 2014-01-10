//
//  AKFormFieldTextField.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormField.h"
#import "AKFormCellTextField.h"

@interface AKFormFieldTextField : AKFormField

@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UITextSpellCheckingType spellCheckingType;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property(nonatomic) BOOL secureTextEntry;
@property(nonatomic) UITextFieldViewMode clearButtonMode;

@property(nonatomic, weak) id<AKFormCellTextFieldDelegate> delegate;
@property(nonatomic, weak) id<AKFormCellTextFieldStyleProvider> styleProvider;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
                    delegate:(id<AKFormCellTextFieldDelegate>)delegate
               styleProvider:(id<AKFormCellTextFieldStyleProvider>)styleProvider;

@end
