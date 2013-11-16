//
//  CSFormToggleCell.h
//  AKForm
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormBaseCell.h"

#define CELL_IDENTIFIER_TOGGLE          @"toggleCell"

/**
 *  A type of cell that presents a segmented control along with a label.
 */
@interface CSFormToggleCell : CSFormBaseCell

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

/**
 *  The label for the cell
 */
@property(nonatomic, strong) UILabel *label;

/**
 *  The container view for the segmentedControl (in which the control itself is right aligned)
 */
@property(nonatomic, strong) UIView *containerView;

/**
 *  The segmented control for the cell
 */
@property(nonatomic, strong) UISegmentedControl *segmentedControl;

/**
 *  Sets the items for the segmented control. It is up to the user of this framework to ensure
 *  that the items aren't too cluttered with the space available.
 *
 *  @param items An array of NSString's or UIImage's to be the items for the segmented control
 */
- (void)recreateSegmentedControlWithItems:(NSArray *)items;

@end
