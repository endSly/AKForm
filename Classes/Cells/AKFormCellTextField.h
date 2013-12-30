//
//  AKFormCellTextField.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCell.h"

#define CELL_IDENTIFIER_TEXTFIELD       @"textFieldCell"

typedef NS_ENUM(NSInteger, AKFormCellTextFieldStyle) {
    AKFormCellTextFieldStyleNoLabel,
    AKFormCellTextFieldStyleLabelWithStaticWidth1,
    AKFormCellTextFieldStyleLabelWithStaticWidth2,
    AKFormCellTextFieldStyleLabelWithStaticWidth3,
    AKFormCellTextFieldStyleLabelWithDynamicWidth
};

typedef NS_ENUM(NSInteger, AKFormCellTextFieldMode) {
    AKFormCellTextFieldModeEmpty,
    AKFormCellTextFieldModeEditing,
    AKFormCellTextFieldModeFilled,
    AKFormCellTextFieldModeInvalid,
    AKFormCellTextFieldModeReadOnly
};

@class AKFormCellTextField;

@protocol AKFormCellTextFieldStyleProvider <NSObject>
@optional
- (AKFormCellTextFieldStyle)styleForTextFieldCell;
- (CGFloat)labelWidthForTextFieldCell;
- (CGFloat)heightForTextFieldCell;
- (UIFont *)labelFontForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style;
- (UIFont *)textFieldFontForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style;
- (UIColor *)labelTextColorForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style;
- (UIColor *)textFieldTextColorForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style;
@end

@protocol AKFormCellTextFieldDelegate <AKFormCellDelegate>
- (void)didBeginEditingOnTextFieldCell:(AKFormCellTextField *)cell;
- (BOOL)shouldReturnOnTextFieldCell:(AKFormCellTextField *)cell;
@end

@interface AKFormCellTextField : AKFormCell <UITextFieldDelegate>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, weak) id<AKFormCellTextFieldDelegate> delegate;

- (instancetype)initWithStyleProvider:(id<AKFormCellTextFieldStyleProvider>)styleProvider;

@end
