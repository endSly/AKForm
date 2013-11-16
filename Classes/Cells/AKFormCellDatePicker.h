//
//  AKFormCellDatePicker.h
//  AKForm
//
//  Created by Ahmed Khalaf on 8/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFormCell.h"

#define CELL_IDENTIFIER_DATE_PICKER     @"datePickerCell"

@class AKFormCellDatePicker;

@protocol CSFormCellDatePickerDelegate <CSFormCellDelegate>
- (void)didChangeValueForDatePickerCell:(AKFormCellDatePicker *)cell;
@end

@interface AKFormCellDatePicker : AKFormCell

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UIDatePicker *datePickerView;
@property(nonatomic, weak) id<CSFormCellDatePickerDelegate> delegate;

@end
