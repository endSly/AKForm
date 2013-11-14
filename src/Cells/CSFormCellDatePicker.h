//
//  CSFormCellDatePicker.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 8/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormCell.h"

#define CELL_IDENTIFIER_DATE_PICKER     @"datePickerCell"

@class CSFormCellDatePicker;

@protocol CSFormCellDatePickerDelegate <CSFormCellDelegate>
- (void)didChangeValueForDatePickerCell:(CSFormCellDatePicker *)cell;
@end

@interface CSFormCellDatePicker : CSFormCell

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UIDatePicker *datePickerView;
@property(nonatomic, weak) id<CSFormCellDatePickerDelegate> delegate;

@end
