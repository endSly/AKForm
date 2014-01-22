//
//  AKFormCellButton.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCell.h"

#define CELL_IDENTIFIER_BUTTON       @"buttonCell"

typedef NS_ENUM(NSInteger, AKFormCellButtonStyle) {
    AKFormCellButtonStyleLabelCentered,
    AKFormCellButtonStyleLabelLeft,
    AKFormCellButtonStyleLabelRight
};

typedef NS_ENUM(NSInteger, AKFormCellButtonMode) {
    AKFormCellButtonModeEnabled,
    AKFormCellButtonModeDisabled
};

@class AKFormCellButton;

@protocol AKFormCellButtonStyleProvider <NSObject>
@optional
- (AKFormCellButtonStyle)styleForButtonCell:(AKFormCellButton *)cell;
- (CGFloat)heightForButtonCell:(AKFormCellButton *)cell;
- (UIFont *)labelFontForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell;
- (UIFont *)detailLabelFontForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell;
- (UIColor *)labelTextColorForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell;
- (UIColor *)detailLabelTextColorForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell;
@end

@protocol AKFormCellButtonDelegate <AKFormCellDelegate>
- (void)didPressButtonCell:(AKFormCellButton *)cell;
@end

@interface AKFormCellButton : AKFormCell <UITextFieldDelegate>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, weak) id<AKFormCellButtonDelegate> delegate;

- (instancetype)initWithStyleProvider:(id<AKFormCellButtonStyleProvider>)styleProvider;
- (void)setIconImage:(UIImage *)image;

@end
