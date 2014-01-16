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
- (AKFormCellTextBoxLabelStyle)labelStyleForTextBoxCell:(AKFormCellTextBox *)cell;
- (AKFormCellTextBoxHeightStyle)heightStyleForTextBoxCell:(AKFormCellTextBox *)cell;
- (CGFloat)labelWidthForTextBoxCell:(AKFormCellTextBox *)cell;
- (CGFloat)heightForTextBoxCell:(AKFormCellTextBox *)cell;
- (UIFont *)labelFontForTextBoxMode:(AKFormCellTextBoxMode)mode forTextBoxCell:(AKFormCellTextBox *)cell;
- (UIFont *)textBoxFontForTextBoxMode:(AKFormCellTextBoxMode)mode forTextBoxCell:(AKFormCellTextBox *)cell;
- (UIColor *)labelTextColorForTextBoxMode:(AKFormCellTextBoxMode)mode forTextBoxCell:(AKFormCellTextBox *)cell;
- (UIColor *)textBoxTextColorForTextBoxMode:(AKFormCellTextBoxMode)mode forTextBoxCell:(AKFormCellTextBox *)cell;
@end

@protocol AKFormCellTextBoxDelegate <AKFormCellDelegate>
- (void)didBeginEditingOnTextBoxCell:(AKFormCellTextBox *)cell;
- (void)didEndEditingOnTextBoxCell:(AKFormCellTextBox *)cell;
- (void)textViewDidChangeOnTextBoxCell:(AKFormCellTextBox *)cell;
@end

@interface AKFormCellTextBox : AKFormCell <UITextViewDelegate>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, weak) id<AKFormCellTextBoxDelegate> delegate;
@property(nonatomic, weak) id<AKFormCellTextBoxStyleProvider> styleProvider;
@property(nonatomic, strong) NSString *placeholderString;
@property(nonatomic, assign) BOOL clearsOnInsertion;

- (instancetype)initWithStyleProvider:(id<AKFormCellTextBoxStyleProvider>)styleProvider;

@end
