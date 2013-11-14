//
//  CSFormCellLabel.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormCell.h"

#define CELL_IDENTIFIER_LABEL           @"labelCell"

///---------------------------------------------------------------------------------------
/// @name Enums
///---------------------------------------------------------------------------------------

/**
 * The styles of a `CSFormCellLabel`.
 */
typedef NS_ENUM(NSInteger, CSFormCellLabelStyle) {
    /**
     *  Left aligned value label on left taking up the entire available width.
     */
    CSFormCellLabelStyleNoTitle,
    
    /**
     * Left aligned title label on left and left aligned value label on right with a 
     * static width for the title label (provided by the style delegate, or set to a 
     * default).
     */
    CSFormCellLabelStyleTitleWithStaticWidth1,
    
    /**
     *  Right aligned title label on left and left aligned value label on right with a 
     *  static width for the title label (provided by the style delegate, or set to a 
     *  default).
     */
    CSFormCellLabelStyleTitleWithStaticWidth2,
    
    /**
     *  Left aligned title label on left and right aligned value label on right with a 
     *  static width for the title label (provided by the style delegate, or set to a 
     *  default).
     */
    CSFormCellLabelStyleTitleWithStaticWidth3,
    
    /**
     *  Left aligned title label on left and right aligned value label on right with the 
     *  width for the label deteremined by the size needed for the title label text 
     *  (constrained to allow a minimum width for the value label).
     */
    CSFormCellLabelStyleTitleWithDynamicWidth,
    
    /**
     *  Left aligned title label on top and left aligned value label on the bottom taking
     *  all the available width of the content view. The portion of the available height
     *  for each cell is assigned based on the portion of the heights needed by the fonts.
     */
    CSFormCellLabelStyleTwoLines
};

/**
 *  The modes of a `CSFormCellLabel`.
 */
typedef NS_ENUM(NSInteger, CSFormCellLabelMode) {
    
    /**
     *  Value is empty (possibly displaying a placeholder string).
     */
    CSFormCellLabelModeEmpty,
    
    /**
     *  Value label is being modified.
     */
    CSFormCellLabelModeEditing,
    
    /**
     *  Value in value label has been filled with some text (but isn't being edited).
     */
    CSFormCellLabelModeFilled,
    
    /**
     *  Value in value label is invalid. This isn't supported yet.
     */
    CSFormCellLabelModeInvalid,
    
    /**
     *  Value label is read only, just to display data. This isn't supported yet.
     */
    CSFormCellLabelModeReadOnly
};

@class  CSFormCellLabel;

@protocol CSFormCellLabelStyleProvider <NSObject>
@optional

///---------------------------------------------------------------------------------------
/// @name Cell Style
///---------------------------------------------------------------------------------------

- (CSFormCellLabelStyle)styleForLabelCell:(CSFormCellLabel *)cell;

///---------------------------------------------------------------------------------------
/// @name Dimensions
///---------------------------------------------------------------------------------------

- (CGFloat)titleLabelWidthForLabelCell:(CSFormCellLabel *)cell;
- (CGFloat)heightForLabelCell:(CSFormCellLabel *)cell;

///---------------------------------------------------------------------------------------
/// @name Fonts
///---------------------------------------------------------------------------------------

- (UIFont *)labelCell:(CSFormCellLabel *)cell titleLabelFontForMode:(CSFormCellLabelMode)mode;
- (UIFont *)labelCell:(CSFormCellLabel *)cell valueLabelFontForMode:(CSFormCellLabelMode)mode;

///---------------------------------------------------------------------------------------
/// @name Text Colors
///---------------------------------------------------------------------------------------

- (UIColor *)labelCell:(CSFormCellLabel *)cell titleLabelTextColorForMode:(CSFormCellLabelMode)mode;
- (UIColor *)labelCell:(CSFormCellLabel *)cell valueLabelTextColorForMode:(CSFormCellLabelMode)mode;

@end

@interface CSFormCellLabel : CSFormCell

///---------------------------------------------------------------------------------------
/// @name Creating a Label Cell
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithStyleProvider:(id<CSFormCellLabelStyleProvider>)styleProvider;

///---------------------------------------------------------------------------------------
/// @name Changing the Mode
///---------------------------------------------------------------------------------------

- (void)setMode:(CSFormCellLabelMode)mode;

@end
