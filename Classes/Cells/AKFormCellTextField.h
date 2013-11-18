//
//  AKFormCellTextField.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCell.h"

#define CELL_IDENTIFIER_TEXTFIELD       @"textFieldCell"

typedef NS_ENUM(NSInteger, CSFormCellTextFieldStyle) {
    CSFormCellTextFieldStyleNoLabel,
    CSFormCellTextFieldStyleLabelWithStaticWidth1,
    CSFormCellTextFieldStyleLabelWithStaticWidth2,
    CSFormCellTextFieldStyleLabelWithStaticWidth3,
    CSFormCellTextFieldStyleLabelWithDynamicWidth
};

typedef NS_ENUM(NSInteger, CSFormCellTextFieldMode) {
    CSFormCellTextFieldModeEmpty,
    CSFormCellTextFieldModeEditing,
    CSFormCellTextFieldModeFilled,
    CSFormCellTextFieldModeInvalid,
    CSFormCellTextFieldModeReadOnly
};

@class AKFormCellTextField;

@protocol CSFormCellTextFieldStyleProvider <NSObject>
@optional
- (CSFormCellTextFieldStyle)styleForTextFieldCell;
- (CGFloat)labelWidthForTextFieldCell;
- (CGFloat)heightForTextFieldCell;
- (UIFont *)labelFontForMode:(CSFormCellTextFieldMode)mode style:(CSFormCellTextFieldStyle)style;
- (UIFont *)textFieldFontForMode:(CSFormCellTextFieldMode)mode style:(CSFormCellTextFieldStyle)style;
- (UIColor *)labelTextColorForMode:(CSFormCellTextFieldMode)mode style:(CSFormCellTextFieldStyle)style;
- (UIColor *)textFieldTextColorForMode:(CSFormCellTextFieldMode)mode style:(CSFormCellTextFieldStyle)style;
@end

#warning CHECK THESE DELEGATE METHODS
@protocol CSFormCellTextFieldDelegate <CSFormCellDelegate>
- (void)didBeginEditingOnTextFieldCell:(AKFormCellTextField *)cell;
- (BOOL)shouldReturnOnTextFieldCell:(AKFormCellTextField *)cell;
@end



@interface AKFormCellTextField : AKFormCell <UITextFieldDelegate>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, weak) id<CSFormCellTextFieldDelegate> delegate;

- (instancetype)initWithStyleProvider:(id<CSFormCellTextFieldStyleProvider>)styleProvider;

@end
