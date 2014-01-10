//
//  AKFormCellTextBox.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCell.h"

#define CELL_IDENTIFIER_TEXTBOX       @"textBoxCell"

typedef NS_ENUM(NSInteger, AKFormCellTextBoxLabelStyle) {
    AKFormCellTextBoxLabelStyleOnLeftLeftAligned,
    AKFormCellTextBoxLabelStyleOnLeftRightAligned,
    AKFormCellTextBoxLabelStyleOnTop
};

typedef NS_ENUM(NSInteger, AKFormCellTextBoxHeightStyle) {
    AKFormCellTextBoxHeightStyleAutomatic,
    AKFormCellTextBoxHeightStyleManual
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
- (AKFormCellTextBoxLabelStyle)labelStyleForTextBoxCell;
- (AKFormCellTextBoxHeightStyle)heightStyleForTextBoxCell;
- (CGFloat)labelWidthForTextBoxCell;
- (CGFloat)heightForTextBoxCell;
- (UIFont *)labelFontForTextBoxMode:(AKFormCellTextBoxMode)mode;
- (UIFont *)textBoxFontForTextBoxMode:(AKFormCellTextBoxMode)mode;
- (UIColor *)labelTextColorForTextBoxMode:(AKFormCellTextBoxMode)mode;
- (UIColor *)textBoxTextColorForTextBoxMode:(AKFormCellTextBoxMode)mode;
@end

@protocol AKFormCellTextBoxDelegate <AKFormCellDelegate>
- (void)didBeginEditingOnTextBoxCell:(AKFormCellTextBox *)cell;
- (BOOL)shouldReturnOnTextBoxCell:(AKFormCellTextBox *)cell;
@end

@interface AKFormCellTextBox : AKFormCell <UITextViewDelegate>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, weak) id<AKFormCellTextBoxDelegate> delegate;

- (instancetype)initWithStyleProvider:(id<AKFormCellTextBoxStyleProvider>)styleProvider;

@end
