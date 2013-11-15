//
//  AKFormCellTextField.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCell.h"

#define CELL_IDENTIFIER_TEXTFIELD       @"textFieldCell"

/**
 * The styles of a `AKFormCellTextField`.
 */
typedef NS_ENUM(NSInteger, CSFormCellTextFieldStyle) {
    /**
     *  Left aligned textField on left taking up the entire available width.
     */
    CSFormCellTextFieldStyleNoLabel,

    /**
     * Left aligned label on left and left aligned textField on right with a static width 
     * for the label (provided by the style delegate, or set to a default).
     */
    CSFormCellTextFieldStyleLabelWithStaticWidth1,
    
    /**
     *  Right aligned label on left and left aligned textField on right with a static 
     *  width for the label (provided by the style delegate, or set to a default).
     */
    CSFormCellTextFieldStyleLabelWithStaticWidth2,
    
    /**
     *  Left aligned label on left and right aligned textField on right with a static 
     *  width for the label (provided by the style delegate, or set to a default).
     */
    CSFormCellTextFieldStyleLabelWithStaticWidth3,
    
    /**
     *  Left aligned label on left and right aligned textField on right with the width 
     *  for the label deteremined by the size needed for the label text (constrained to 
     *  allow a minimum width for the textField).
     */
    CSFormCellTextFieldStyleLabelWithDynamicWidth
};

/**
 *  The modes of a `AKFormCellTextField`.
 */
typedef NS_ENUM(NSInteger, CSFormCellTextFieldMode) {
    
    /**
     *  Text field is writable and is empty (possibly displaying a placeholder string).
     */
    CSFormCellTextFieldModeEmpty,
    
    /**
     *  Text field is writable and is currenly being edited.
     */
    CSFormCellTextFieldModeEditing,
    
    /**
     *  Text field is writable and has been filled with some text (but isn't being edited).
     */
    CSFormCellTextFieldModeFilled,
    
    /**
     *  Text field is invalid.
     */
    CSFormCellTextFieldModeInvalid,
    
    /**
     *  Text field is read only, just to display data. This isn't supported yet.
     */
    CSFormCellTextFieldModeReadOnly
};

@class AKFormCellTextField;

/**
 *  An object conforming to the `CSFormCellTextFieldStyleProvider` protocol may provide
 *  custom styling for a `AKFormCellTextField` by implementing some or all of it's 
 *  methods.
 */
@protocol CSFormCellTextFieldStyleProvider <NSObject>
@optional

///---------------------------------------------------------------------------------------
/// @name Cell Style
///---------------------------------------------------------------------------------------

/**
 *  Provides a `CSFormCellTextFieldStyle` for the cell.
 *
 *  @param cell The text field cell that the style is being asked for.
 *
 *  @return A `CSFormCellTextFieldStyle` to be used for the cell.
 *  @see CSFormCellTextFieldStyle
 */
- (CSFormCellTextFieldStyle)styleForTextFieldCell:(AKFormCellTextField *)cell;

///---------------------------------------------------------------------------------------
/// @name Dimensions
///---------------------------------------------------------------------------------------

/**
 *  Provides a static width for the label.
 *
 *  @param cell The text field cell that the static label width is being asked for.
 *
 *  @return A static width to be used for the label.
 */
- (CGFloat)labelWidthForTextFieldCell:(AKFormCellTextField *)cell;

/**
 *  Provides a height for the entire cell.
 *
 *  @param cell The text field cell that the height is being asked for.
 *
 *  @return A height to be used for this cell.
 */
- (CGFloat)heightForTextFieldCell:(AKFormCellTextField *)cell;

///---------------------------------------------------------------------------------------
/// @name Fonts
///---------------------------------------------------------------------------------------

/**
 *  Provides a font for the label.
 *
 *  @param cell The text field cell that the label font is being asked for.
 *  @param mode The mode that the label font is being asked for.
 *
 *  @return A font to be used for the label.
 */
- (UIFont *)textFieldCell:(AKFormCellTextField *)cell
         labelFontForMode:(CSFormCellTextFieldMode)mode;

/**
 *  Provides a font for the text field.
 *
 *  @param cell The text field cell that the text field font is being asked for.
 *  @param mode The mode that the text field font is being asked for.
 *
 *  @return A font to be used for the text field.
 */
- (UIFont *)textFieldCell:(AKFormCellTextField *)cell
     textFieldFontForMode:(CSFormCellTextFieldMode)mode;

///---------------------------------------------------------------------------------------
/// @name Text Colors
///---------------------------------------------------------------------------------------

/**
 *  Provides a text color for the label.
 *
 *  @param cell The text field cell that the label text color is being asked for.
 *  @param mode The mode that the label text color is being asked for.
 *
 *  @return A color to be used for the label.
 */
- (UIColor *)textFieldCell:(AKFormCellTextField *)cell
     labelTextColorForMode:(CSFormCellTextFieldMode)mode;

/**
 *  Provides a text color for the text field.
 *
 *  @param cell The text field cell that the text field text color is being asked for.
 *  @param mode The mode that the text field text color is being asked for.
 *
 *  @return A color to be used for the text field.
 */
- (UIColor *)textFieldCell:(AKFormCellTextField *)cell
 textFieldTextColorForMode:(CSFormCellTextFieldMode)mode;

@end

/**
 *  An object conforming to the `CSFormCellTextFieldDelegate` protocol will be informed
 *  and queried regarding relevant actions regarding the input of text into the textfield.
 */
@protocol CSFormCellTextFieldDelegate <CSFormCellDelegate>

/**
 *  Tells the delegate that editing began in the textfield cell.
 *
 *  @param cell The textfield cell that editing began in.
 */
- (void)didBeginEditingOnTextFieldCell:(AKFormCellTextField *)cell;

/**
 *  Asks the delegate if the textfield on the cell should process the pressing of the 
 *  return button.
 *
 *  @param cell The textfield cell whose return button pressed.
 *
 *  @return YES if the text field should implement its default behavior for the return 
 *          button; otherwise, NO.
 */
- (BOOL)shouldReturnOnTextFieldCell:(AKFormCellTextField *)cell;
@end










/**
 *  A type of cell that has a text field for accepting user input.
 */
@interface AKFormCellTextField : AKFormCell <UITextFieldDelegate>

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

/**
 *  The label for the cell, which is placed on the left side.
 */
@property(nonatomic, strong) UILabel *label;

/**
 *  The text field, placed on the right side.
 */
@property(nonatomic, strong) UITextField *textField;

/**
 *  The delegate for this cell.
 */
@property(nonatomic, weak) id<CSFormCellTextFieldDelegate> delegate;

///---------------------------------------------------------------------------------------
/// @name Creating a Text Field Cell
///---------------------------------------------------------------------------------------

/**
 *  Creates a text field cell with the provided style provider. The preset reuse 
 *  identifier is used in case the table view needs to reuse the cells.
 *
 *  @param styleProvider The object that provides the styles for the various modes of the
 *                       text field cell.
 *
 *  @return A newly created text field cell that has been initialized as an empty field 
 *          using the provided style provider.
 *  @see CSFormCellTextFieldStyleProvider
 */
- (instancetype)initWithStyleProvider:(id<CSFormCellTextFieldStyleProvider>)styleProvider;

@end
