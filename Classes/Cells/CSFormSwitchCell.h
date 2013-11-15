//
//  CSFormSwitchCell.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormBaseCell.h"

#define CELL_IDENTIFIER_SWITCH          @"switchCell"

/**
 *  A type of cell that presents a switch along with a label.
 */
@interface CSFormSwitchCell : CSFormBaseCell

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

/**
 *  The label for the cell
 */
@property(nonatomic, strong) UILabel *label;

/**
 *  The container view for the switch (in which the switch itself is right aligned)
 */
@property(nonatomic, strong) UIView *switchContainerView;

/**
 *  The switch for the cell
 */
@property(nonatomic, strong) UISwitch *switchControl;

@end
