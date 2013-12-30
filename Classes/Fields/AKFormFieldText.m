//
//  AKFormFieldText.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldText.h"

@implementation AKFormFieldText

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
                    delegate:(id<AKFormCellTextFieldDelegate>)delegate
               styleProvider:(id<AKFormCellTextFieldStyleProvider>)styleProvider
{
    return [[AKFormFieldText alloc] initWithKey:key title:title placeholder:placeholder delegate:delegate styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
                   delegate:(id<AKFormCellTextFieldDelegate>)delegate
              styleProvider:(id<AKFormCellTextFieldStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title placeholder:placeholder];
    if (self) {
        self.delegate = delegate;
        self.styleProvider = styleProvider;
        
        self.keyboardType = UIKeyboardTypeDefault;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        self.returnKeyType = UIReturnKeyNext;
        self.clearButtonMode = UITextFieldViewModeNever;
        self.secureTextEntry = NO;
    }
    return self;
}

/**
 *  Returns a field cell by first attempting to dequeue it from the provided tableView, or creating
 *  one if necessary.
 *
 *  @param tableView The tableView from which to try and dequeue the cell.
 *  @return The field cell casted as a UITableViewcell.
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    AKFormCellTextField *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_TEXTFIELD];
    if (!cell) {
        cell = [[AKFormCellTextField alloc] initWithStyleProvider:self.styleProvider];
    }
    
    cell.delegate = self.delegate;
    cell.valueDelegate = self;
    
    cell.textField.keyboardType = self.keyboardType;
    cell.textField.autocapitalizationType = self.autocapitalizationType;
    cell.textField.autocorrectionType = self.autocorrectionType;
    cell.textField.spellCheckingType = self.spellCheckingType;
    cell.textField.returnKeyType = self.returnKeyType;
    cell.textField.clearButtonMode = self.clearButtonMode;
    cell.textField.secureTextEntry = self.secureTextEntry;

    cell.textField.placeholder = self.placeholder;

    cell.textField.text = [self.value stringValue];
    cell.label.text = self.title;
    
    //now rearrange the layout!
    [cell layoutSubviews];
    
    self.cell = cell;
    return cell;
}

@end
