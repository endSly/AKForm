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

///---------------------------------------------------------------------------------------
/// @name Enums
///---------------------------------------------------------------------------------------

/**
 * The styles of a `AKFormCellLabel`.
 */
typedef NS_ENUM(NSInteger, AKFormCellLabelStyle) {
    /**
     *  Left aligned value label on left taking up the entire available width.
     */
    AKFormCellLabelStyleNoTitle,
    
    /**
     * Left aligned title label on left and left aligned value label on right with a 
     * static width for the title label (provided by the style delegate, or set to a 
     * default).
     */
    AKFormCellLabelStyleTitleWithStaticWidth1,
    
    /**
     *  Right aligned title label on left and left aligned value label on right with a 
     *  static width for the title label (provided by the style delegate, or set to a 
     *  default).
     */
    AKFormCellLabelStyleTitleWithStaticWidth2,
    
    /**
     *  Left aligned title label on left and right aligned value label on right with a 
     *  static width for the title label (provided by the style delegate, or set to a 
     *  default).
     */
    AKFormCellLabelStyleTitleWithStaticWidth3,
    
    /**
     *  Left aligned title label on left and right aligned value label on right with the 
     *  width for the label deteremined by the size needed for the title label text 
     *  (constrained to allow a minimum width for the value label).
     */
    AKFormCellLabelStyleTitleWithDynamicWidth,
    
    /**
     *  Left aligned title label on top and left aligned value label on the bottom taking
     *  all the available width of the content view. The portion of the available height
     *  for each cell is assigned based on the portion of the heights needed by the fonts.
     */
    AKFormCellLabelStyleTwoLines
};

/**
 *  The modes of a `AKFormCellLabel`.
 */
typedef NS_ENUM(NSInteger, AKFormCellLabelMode) {
    
    /**
     *  Value is empty (possibly displaying a placeholder string).
     */
    AKFormCellLabelModeEmpty,
    
    /**
     *  Value label is being modified.
     */
    AKFormCellLabelModeEditing,
    
    /**
     *  Value in value label has been filled with some text (but isn't being edited).
     */
    AKFormCellLabelModeFilled,
    
    /**
     *  Value in value label is invalid. This isn't supported yet.
     */
    AKFormCellLabelModeInvalid,
    
    /**
     *  Value label is read only, just to display data. This isn't supported yet.
     */
    AKFormCellLabelModeReadOnly
};

@class  AKFormCellLabel;

@protocol AKFormCellLabelStyleProvider <NSObject>
@optional

///---------------------------------------------------------------------------------------
/// @name Cell Style
///---------------------------------------------------------------------------------------

- (AKFormCellLabelStyle)styleForLabelCell:(AKFormCellLabel *)cell;

///---------------------------------------------------------------------------------------
/// @name Dimensions
///---------------------------------------------------------------------------------------

- (CGFloat)titleLabelWidthForLabelCell:(AKFormCellLabel *)cell;
- (CGFloat)heightForLabelCell:(AKFormCellLabel *)cell;

///---------------------------------------------------------------------------------------
/// @name Fonts
///---------------------------------------------------------------------------------------

- (UIFont *)labelCell:(AKFormCellLabel *)cell titleLabelFontForMode:(AKFormCellLabelMode)mode;
- (UIFont *)labelCell:(AKFormCellLabel *)cell valueLabelFontForMode:(AKFormCellLabelMode)mode;

///---------------------------------------------------------------------------------------
/// @name Text Colors
///---------------------------------------------------------------------------------------

- (UIColor *)labelCell:(AKFormCellLabel *)cell titleLabelTextColorForMode:(AKFormCellLabelMode)mode;
- (UIColor *)labelCell:(AKFormCellLabel *)cell valueLabelTextColorForMode:(AKFormCellLabelMode)mode;

@end

@interface AKFormCellLabel : AKFormCell

///---------------------------------------------------------------------------------------
/// @name Creating a Label Cell
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithStyleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider;

///---------------------------------------------------------------------------------------
/// @name Changing the Mode
///---------------------------------------------------------------------------------------

- (void)setMode:(AKFormCellLabelMode)mode;

@end
