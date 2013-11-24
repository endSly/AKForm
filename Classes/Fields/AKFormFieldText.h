//
//  AKFormFieldText.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormField.h"
#import "AKFormCellTextField.h"

@interface AKFormFieldText : AKFormField

@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UITextSpellCheckingType spellCheckingType;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property(nonatomic) BOOL secureTextEntry;
@property(nonatomic) UITextFieldViewMode clearButtonMode;

@property(nonatomic, weak) id<CSFormCellTextFieldDelegate> delegate;
@property(nonatomic, weak) id<CSFormCellTextFieldStyleProvider> styleProvider;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
                    delegate:(id<CSFormCellTextFieldDelegate>)delegate
               styleProvider:(id<CSFormCellTextFieldStyleProvider>)styleProvider;

@end
