//
//  AKFormFieldTextBox.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldTextBox.h"

@implementation AKFormFieldTextBox

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
                    delegate:(id<AKFormCellTextBoxDelegate>)delegate
               styleProvider:(id<AKFormCellTextBoxStyleProvider>)styleProvider
{
    return [[AKFormFieldTextBox alloc] initWithKey:key title:title placeholder:placeholder delegate:delegate styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
                   delegate:(id<AKFormCellTextBoxDelegate>)delegate
              styleProvider:(id<AKFormCellTextBoxStyleProvider>)styleProvider
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
    AKFormCellTextBox *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_TEXTBOX];
    if (!cell) {
        cell = [[AKFormCellTextBox alloc] initWithStyleProvider:self.styleProvider];
    }
    
    cell.delegate = self.delegate;
    cell.valueDelegate = self;
    
    cell.textView.keyboardType = self.keyboardType;
    cell.textView.autocapitalizationType = self.autocapitalizationType;
    cell.textView.autocorrectionType = self.autocorrectionType;
    cell.textView.spellCheckingType = self.spellCheckingType;
    cell.textView.returnKeyType = self.returnKeyType;
    cell.textView.secureTextEntry = self.secureTextEntry;
    
    if ([self.value stringValue] && [self.value stringValue].length > 0) {
        cell.textView.text = [self.value stringValue];
    } else {
        cell.textView.text = self.placeholder;
    }
    
    cell.label.text = self.title;
    
    //now rearrange the layout!
    [cell layoutSubviews];
    
    self.cell = cell;
    return cell;
}

@end
