//
//  CSFormBaseCell.h
//  AKForm
//
//  Created by Ahmed Khalaf on 11/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HexColors/HexColor.h>

#define CELL_PADDING_HORIZONTAL 15.f
#define CELL_PADDING_VERTICAL   7.f

#define HEIGHT_STANDARD_PICKER  216.f
#define CELL_HEIGHT_DEFAULT     44.f
#define CELL_HEIGHT_PICKER      HEIGHT_STANDARD_PICKER
#define CELL_HEIGHT_TEXTVIEW    150.f

/**
 *  This is a class that all other form cells are subclasses of.
 */
@interface CSFormBaseCell : UITableViewCell

///---------------------------------------------------------------------------------------
/// @name Managing the cell's label
///---------------------------------------------------------------------------------------

/**
 *  A label for the cell.
 */
@property(readonly, nonatomic, strong) NSString *labelString;

/**
 *  This setter override is also expected to be overriden by any subclasses. Its main
 *  purpose (in addition to setting the labelString), is to readjust the properties of the
 *  UIElements contained in this cell accordingly (based on whether a string for the label
 *  was actually received and how long it was).
 *
 *  @param labelString The string to be used for the label. This can be nil or empty.
 */
- (void)setLabelString:(NSString *)labelString;

/**
 *  A helper method that checks whether the `labelString` property has a string of at 
 *  least one character.
 *
 *  @return A boolean value indicating whether `labelString` has a string or not.
 */
- (BOOL)hasLabelString;











///---------------------------------------------------------------------------------------
/// @name Subview Frames
///---------------------------------------------------------------------------------------

/**
 *  The frame for the left element placed on the cell.
 */
@property(nonatomic, assign) CGSize leftViewSize;

- (void)setLeftViewHeight:(CGFloat)leftElementHeight;
- (CGSize)sizeForLabel;

- (CGRect)leftViewFrame;
- (CGRect)rightViewFrame;

- (CGRect)contentFrame;

@end
