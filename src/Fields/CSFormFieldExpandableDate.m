//
//  CSFormFieldExpandableDate.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldExpandableDate.h"
#import "CSFormCellDatePicker.h"
#import <NSDate+Helper.h>

@implementation CSFormFieldExpandableDate

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
             datePickerMode:(UIDatePickerMode)datePickerMode
              displayFormat:(NSString *)displayFormat
              styleProvider:(id<CSFormCellLabelStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.dateDisplayFormat = displayFormat;
        self.datePickerMode = datePickerMode;
        self.styleProvider = styleProvider;
        self.placeholder = placeholder;
    }
    
    return self;
}


- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    CSFormCellLabel *cell = (CSFormCellLabel *)[super cellForTableView:tableView];
    
    //set the value
    if (self.value && [self.value isDate]) {
        NSDate *date = [self.value dateValue];
        cell.valueLabel.text = [date stringWithFormat:self.dateDisplayFormat];
    } else {
        cell.valueLabel.text = self.placeholder;
    }
    
    //set the mode
    if (self.isExpanded) {
        [cell setMode:CSFormCellLabelModeEditing];
    } else if (self.value && [self.value isDate]) {
        [cell setMode:CSFormCellLabelModeFilled];
    } else {
        [cell setMode:CSFormCellLabelModeEmpty];
    }
    
    [cell layoutSubviews];
    return cell;
}

/**
 *  Returns a picker cell by first attempting to dequeue it from the provided tableView, or creating
 *  one if necessary.
 *
 *  @param tableView The tableView from which to try and dequeue the cell.
 *  @return The picker cell casted as a UITableViewcell.
 */
- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView
{
    CSFormCellDatePicker *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_DATE_PICKER];
    
    if (!cell) {
        cell = [[CSFormCellDatePicker alloc] init];
    }
    
    cell.delegate = self;
    cell.valueDelegate = self;
    
    cell.datePickerView.datePickerMode = self.datePickerMode;
    cell.datePickerView.minimumDate = self.minimumDate;
    cell.datePickerView.maximumDate = self.maximumDate;
    
    [self preselectValueOnDatePickerCell:cell];
    
    self.expandedCell = cell;
    return cell;
}

- (void)preselectValueOnDatePickerCell:(CSFormCellDatePicker *)cell
{
    if (![self isFilled]) {
        self.value = [CSFormValue value:[NSDate date] withType:CSFormValueDate];
    }
    [cell.datePickerView setDate:[self.value dateValue] animated:NO];
    [self didChangeValueForDatePickerCell:cell];
}

#pragma mark - CSFormCellDatePickerDelegate

- (void)didChangeValueForDatePickerCell:(CSFormCellDatePicker *)cell
{
    CSFormCellLabel *labelCell = [self labelCell];
    if (labelCell) {
        if ([self.value isDate]) {
            NSDate *date = [self.value dateValue];
            labelCell.valueLabel.text = [date stringWithFormat:self.dateDisplayFormat];
        }
        [labelCell setMode:CSFormCellLabelModeEditing];
    }
    
    //if this is the starting date in a time period
    if (self.periodEndDateField) {
        //set the picked date as the minimum for the end date
        self.periodEndDateField.minimumDate = cell.datePickerView.date;

        //pick the end date or choose today if none is available
        NSDate *endDate = [self.periodEndDateField.value dateValue] ? [self.periodEndDateField.value dateValue] : [NSDate date];

        //now we choose the later date of that and the picked date
        //(to make sure we still honor it being the minimum)
        NSDate *laterDate = [endDate compare:cell.datePickerView.date] == NSOrderedAscending ? cell.datePickerView.date : endDate;

        //now we SET that date in the periodEndDateField
        self.periodEndDateField.value = [CSFormValue value:laterDate withType:CSFormValueDate];
        CSFormCellLabel *endDateLabelCell = [self.periodEndDateField labelCell];
        if (endDateLabelCell) {
            if ([self.periodEndDateField.value isDate]) {
                NSDate *date = [self.periodEndDateField.value dateValue];
                endDateLabelCell.valueLabel.text = [date stringWithFormat:self.periodEndDateField.dateDisplayFormat];
            }
            [endDateLabelCell setMode:CSFormCellLabelModeFilled];
        }

        //and update that fields label
//        CSFormCellLabel *label = [self.delegate labelCellForField:self.periodEndDateField];
//        label.valueLabel.text = [laterDate stringWithFormat:self.periodEndDateField.dateDisplayFormat];
//        [label setMode:CSFormCellLabelModeFilled];
    }
}

- (BOOL)isFilled
{
    return [super isFilled] && [self.value isDate];
}

@end
