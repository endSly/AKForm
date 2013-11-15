//
//  AKFormCellDatePicker.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 8/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCellDatePicker.h"

@implementation AKFormCellDatePicker

#pragma mark - Initializers

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_DATE_PICKER];
    if (self) {
        self.datePickerView = [[UIDatePicker alloc] init];
        [self.contentView addSubview:self.datePickerView];
        [self.datePickerView addTarget:self
                                action:@selector(pickedDate:)
                      forControlEvents:UIControlEventValueChanged];

    }
    return self;
}

#pragma mark - Actions

- (void)pickedDate:(id)sender
{    
    //save the value
    if (self.valueDelegate && [self.valueDelegate respondsToSelector:@selector(didInputValue:)]) {
        UIDatePicker *datePicker = (UIDatePicker *)sender;
        NSDate *pickedDate = datePicker.date;
        [self.valueDelegate didInputValue:[AKFormValue value:pickedDate withType:AKFormValueDate]];
    }
    
    //tell the delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeValueForKey:)]) {
        [self.delegate didChangeValueForDatePickerCell:self];
    }
}

@end
