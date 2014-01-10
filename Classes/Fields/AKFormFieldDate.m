//
//  AKFormFieldDate.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldDate.h"
#import "AKFormCellDatePicker.h"
#import <NSDate+Helper.h>
#import <NSString+CJStringValidator.h>

#import <MHPrettyDate/MHPrettyDate.h>

@implementation AKFormFieldDate

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
              datePickerMode:(UIDatePickerMode)datePickerMode
                 displayType:(AKFormFieldDateDisplayType)displayType
               displayFormat:(NSString *)displayFormat
               styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider
{
    return [[AKFormFieldDate alloc] initWithKey:key
                                          title:title
                                    placeholder:placeholder
                                 datePickerMode:datePickerMode
                                    displayType:displayType
                                  displayFormat:displayFormat
                                  styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
             datePickerMode:(UIDatePickerMode)datePickerMode
                displayType:(AKFormFieldDateDisplayType)displayType
              displayFormat:(NSString *)displayFormat
              styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.datePickerMode = datePickerMode;
        self.displayType = displayType;
        self.dateDisplayFormat = displayFormat;
        self.styleProvider = styleProvider;
        self.placeholder = placeholder;
        
        if (!self.dateDisplayFormat || [self.dateDisplayFormat isEmpty]) {
            [self setDefaultDateDisplayFormat];
        }
    }
    
    return self;
}

- (void)setDefaultDateDisplayFormat
{
    switch (self.datePickerMode) {
        case UIDatePickerModeDate:
            self.dateDisplayFormat = @"MMM dd, yyyy";
            break;
        case UIDatePickerModeTime:
            self.dateDisplayFormat = @"h:mm a";
            break;
        case UIDatePickerModeDateAndTime:
            self.dateDisplayFormat = @"MMM dd, yyyy (h:mm a)";
            break;
        case UIDatePickerModeCountDownTimer:
            self.dateDisplayFormat = @"h:mm a";
            break;
        default:
            break;
    }
}

- (NSString *)dateString
{
    if (!self.value || ![self.value isDate]) {
        if (self.placeholder) {
            return self.placeholder;
        } else {
            return @"";
        }
    }
    
    NSDate *date = [self.value dateValue];
    switch (self.displayType) {
        case AKFormFieldDateDisplayNoTime:
            return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateFormatNoTime];
            break;
        case AKFormFieldDateDisplayWithTime:
            return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateFormatWithTime];
            break;
        case AKFormFieldDateDisplayTodayTimeOnly:
            return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateFormatTodayTimeOnly];
            break;
        case AKFormFieldDateDisplayRelative:
            return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateLongRelativeTime];
            break;
        case AKFormFieldDateDisplayRelativeShort:
            return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateShortRelativeTime];
            break;
        case AKFormFieldDateDisplayCustom:
            return [date stringWithFormat:self.dateDisplayFormat];
            break;
    }
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    AKFormCellLabel *cell = (AKFormCellLabel *)[super cellForTableView:tableView];
    
    cell.valueLabel.text = [self dateString];
    
    //set the mode
    if (self.isExpanded) {
        [cell setMode:AKFormCellLabelModeEditing];
    } else if (self.value && [self.value isDate]) {
        [cell setMode:AKFormCellLabelModeFilled];
    } else {
        [cell setMode:AKFormCellLabelModeEmpty];
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
    AKFormCellDatePicker *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_DATE_PICKER];
    
    if (!cell) {
        cell = [[AKFormCellDatePicker alloc] init];
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

- (void)preselectValueOnDatePickerCell:(AKFormCellDatePicker *)cell
{
    if (![self isFilled]) {
        self.value = [AKFormValue value:[NSDate date] withType:AKFormValueDate];
    }
    [cell.datePickerView setDate:[self.value dateValue] animated:NO];
    [self didChangeValueForDatePickerCell:cell];
}

#pragma mark - AKFormCellDatePickerDelegate

- (void)didChangeValueForDatePickerCell:(AKFormCellDatePicker *)cell
{
    AKFormCellLabel *labelCell = [self labelCell];
    if (labelCell) {
        if ([self.value isDate]) {
            labelCell.valueLabel.text = [self dateString];
        }
        [labelCell setMode:AKFormCellLabelModeEditing];
    }
    
    //if we're attached to a 'period end' field
    if (self.periodEndDateField) {
        
        //set the picked date as the minimum for it
        self.periodEndDateField.minimumDate = cell.datePickerView.date;

        //push back the 'period end' field's date if it's before the new minimum
        NSDate *endDate = [self.periodEndDateField.value dateValue] ? [self.periodEndDateField.value dateValue] : [NSDate date];
        NSDate *laterDate = [endDate compare:cell.datePickerView.date] == NSOrderedAscending ? cell.datePickerView.date : endDate;
        self.periodEndDateField.value = [AKFormValue value:laterDate withType:AKFormValueDate];
        
        //update the label cell
        AKFormCellLabel *endDateLabelCell = [self.periodEndDateField labelCell];
        if (endDateLabelCell) {
            endDateLabelCell.valueLabel.text = [self.periodEndDateField dateString];
            [endDateLabelCell setMode:AKFormCellLabelModeFilled];
        }
    }
}

- (BOOL)isFilled
{
    return [super isFilled] && [self.value isDate];
}

@end
