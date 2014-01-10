//
//  AKFormCellTextBox.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCell.h"

#define CELL_IDENTIFIER_TEXTBOX       @"textBoxCell"

typedef NS_ENUM(NSInteger, AKFormCellTextBoxStyle) {
    AKFormCellTextBoxStyleNoLabel,
    AKFormCellTextBoxStyleLabelWithStaticWidth1,
    AKFormCellTextBoxStyleLabelWithStaticWidth2,
    AKFormCellTextBoxStyleLabelWithStaticWidth3,
    AKFormCellTextBoxStyleLabelWithDynamicWidth
};

typedef NS_ENUM(NSInteger, AKFormCellTextBoxMode) {
    AKFormCellTextBoxModeEmpty,
    AKFormCellTextBoxModeEditing,
    AKFormCellTextBoxModeFilled,
    AKFormCellTextBoxModeInvalid,
    AKFormCellTextBoxModeReadOnly
};

@class AKFormCellTextBox;

@protocol AKFormCellTextBoxStyleProvider <NSObject>
@optional
- (AKFormCellTextBoxStyle)styleForTextFieldCell;
- (CGFloat)labelWidthForTextFieldCell;
- (CGFloat)heightForTextFieldCell;
- (UIFont *)labelFontForMode:(AKFormCellTextBoxMode)mode style:(AKFormCellTextBoxStyle)style;
- (UIFont *)textFieldFontForMode:(AKFormCellTextBoxMode)mode style:(AKFormCellTextBoxStyle)style;
- (UIColor *)labelTextColorForMode:(AKFormCellTextBoxMode)mode style:(AKFormCellTextBoxStyle)style;
- (UIColor *)textFieldTextColorForMode:(AKFormCellTextBoxMode)mode style:(AKFormCellTextBoxStyle)style;
@end

@protocol AKFormCellTextBoxDelegate <AKFormCellDelegate>
- (void)didBeginEditingOnTextFieldCell:(AKFormCellTextBox *)cell;
- (BOOL)shouldReturnOnTextFieldCell:(AKFormCellTextBox *)cell;
@end

@interface AKFormCellTextBox : AKFormCell <UITextFieldDelegate>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, weak) id<AKFormCellTextBoxDelegate> delegate;

- (instancetype)initWithStyleProvider:(id<AKFormCellTextBoxStyleProvider>)styleProvider;

@end
