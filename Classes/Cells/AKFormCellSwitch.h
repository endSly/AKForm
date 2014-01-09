//
//  AKFormCellSwitch.h
//  AKForm
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCell.h"

#define CELL_IDENTIFIER_SWITCH          @"switchCell"

typedef NS_ENUM(NSInteger, AKFormCellSwitchStyle) {
    AKFormCellSwitchStyleLabelWithStaticWidth1,
    AKFormCellSwitchStyleLabelWithStaticWidth2,
    AKFormCellSwitchStyleLabelWithStaticWidth3,
    AKFormCellSwitchStyleLabelWithDynamicWidth
};

typedef NS_ENUM(NSInteger, AKFormCellSwitchMode) {
    AKFormCellSwitchModeEditable,
    AKFormCellSwitchModeReadOnly
};

@class AKFormCellSwitch;

@protocol AKFormCellSwitchStyleProvider <NSObject>
@optional
- (AKFormCellSwitchStyle)styleForSwitchCell;
- (CGFloat)labelWidthForSwitchCell;
- (CGFloat)heightForSwitchCell;
- (UIColor *)switchTintColor;
- (UIFont *)labelFontForMode:(AKFormCellSwitchMode)mode style:(AKFormCellSwitchStyle)style;
- (UIColor *)labelTextColorForMode:(AKFormCellSwitchMode)mode style:(AKFormCellSwitchStyle)style;
- (UITableViewRowAnimation)rowAnimationDeleteForSwitchCell;
- (UITableViewRowAnimation)rowAnimationInsertForSwitchCell;
- (UITableViewRowAnimation)sectionAnimationDeleteForSwitchCell;
- (UITableViewRowAnimation)sectionAnimationInsertForSwitchCell;
@end

@protocol AKFormFieldSwitchDelegate;

@interface AKFormCellSwitch : AKFormCell

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIView *switchContainerView;
@property(nonatomic, strong) UISwitch *switchControl;

@property(nonatomic, weak) id<AKFormFieldSwitchDelegate> delegate;
@property(nonatomic, weak) id<AKFormCellSwitchStyleProvider> styleProvider;

- (instancetype)initWithStyleProvider:(id<AKFormCellSwitchStyleProvider>)styleProvider;
- (void)refreshSwitchControl;

@end
