//
//  AKFormFieldTextBox.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormField.h"
#import "AKFormCellTextBox.h"

@interface AKFormFieldTextBox : AKFormField

@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UITextSpellCheckingType spellCheckingType;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property(nonatomic) BOOL secureTextEntry;
@property(nonatomic) UITextFieldViewMode clearButtonMode;

@property(nonatomic, weak) id<AKFormCellTextBoxDelegate> delegate;
@property(nonatomic, weak) id<AKFormCellTextBoxStyleProvider> styleProvider;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
                    delegate:(id<AKFormCellTextBoxDelegate>)delegate
               styleProvider:(id<AKFormCellTextBoxStyleProvider>)styleProvider;

@end
