//
//  CSFormFieldSwitch.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldSwitch.h"

@implementation CSFormFieldSwitch

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                   delegate:(id<CSFormFieldSwitchDelegate>)delegate
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

/**
 *  Returns a switch cell by first attempting to dequeue it from the provided tableView, or creating
 *  one if necessary.
 *
 *  @param tableView The tableView from which to try and dequeue the cell.
 *  @return The switch cell casted as a UITableViewcell.
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    CSFormSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_SWITCH];
    if (!cell) {
        cell = [[CSFormSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CELL_IDENTIFIER_SWITCH];
    }
    
    [cell setLabelString:self.title];
    [cell.switchControl addTarget:self
                           action:@selector(switchValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    
    cell.switchControl.on = [self.value boolValue];
    
    self.cell = cell;
    return cell;
}

#pragma mark - Value Changed

- (void)switchValueChanged:(UISwitch *)switchControl
{
    self.value = [AKFormValue value:@(switchControl.on) withType:AKFormValueBool];
    [self.delegate didChangeValueOfSwitchOnField:self toOn:switchControl.on];
}

@end
