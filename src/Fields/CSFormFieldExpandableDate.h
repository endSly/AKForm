//
//  CSFormFieldExpandableDate.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldExpandable.h"
#import "CSFormCellDatePicker.h"

@interface CSFormFieldExpandableDate : CSFormFieldExpandable <CSFormCellDatePickerDelegate>

///---------------------------------------------------------------------------------------
/// @name Date Pickers
///---------------------------------------------------------------------------------------

@property(nonatomic) UIDatePickerMode datePickerMode;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSDate *maximumDate;
@property(nonatomic, strong) NSString *dateDisplayFormat;

/**
 *  This is an optional association with another CSFormField indicating a date field after
 *  this (date) row. This row will therefore set that date's maximum date as the selected
 *  value to keep the user from selecting incorrect ranges.
 */
@property(nonatomic, weak) CSFormFieldExpandableDate *periodEndDateField;

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
             datePickerMode:(UIDatePickerMode)datePickerMode
              displayFormat:(NSString *)displayFormat
              styleProvider:(id<CSFormCellLabelStyleProvider>)styleProvider;

@end
