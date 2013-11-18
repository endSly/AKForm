//
//  AKFormCellLabel.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFormCell.h"

#define CELL_IDENTIFIER_LABEL           @"labelCell"

typedef NS_ENUM(NSInteger, AKFormCellLabelStyle) {
    AKFormCellLabelStyleNoTitle,
    AKFormCellLabelStyleTitleWithStaticWidth1,
    AKFormCellLabelStyleTitleWithStaticWidth2,
    AKFormCellLabelStyleTitleWithStaticWidth3,
    AKFormCellLabelStyleTitleWithDynamicWidth,
    AKFormCellLabelStyleTwoLines
};

typedef NS_ENUM(NSInteger, AKFormCellLabelMode) {
    AKFormCellLabelModeEmpty,
    AKFormCellLabelModeEditing,
    AKFormCellLabelModeFilled,
    AKFormCellLabelModeInvalid,
    AKFormCellLabelModeReadOnly
};



@class  AKFormCellLabel;

@protocol AKFormCellLabelStyleProvider <NSObject>
@optional

- (AKFormCellLabelStyle)styleForLabelCell;
- (CGFloat)titleLabelWidthForLabelCell;
- (CGFloat)heightForLabelCell;
- (UIFont *)titleLabelFontForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style;
- (UIFont *)valueLabelFontForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style;
- (UIColor *)titleLabelTextColorForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style;
- (UIColor *)valueLabelTextColorForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style;

@end



@interface AKFormCellLabel : AKFormCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithStyleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider;
- (void)setMode:(AKFormCellLabelMode)mode;

@end
