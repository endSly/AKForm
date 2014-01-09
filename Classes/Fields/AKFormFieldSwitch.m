//
//  AKFormFieldSwitch.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldSwitch.h"

@implementation AKFormFieldSwitch

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                    delegate:(id<AKFormFieldSwitchDelegate>)delegate
               styleProvider:(id<AKFormCellSwitchStyleProvider>)styleProvider
{
    return [[AKFormFieldSwitch alloc] initWithKey:key
                                            title:title
                                         delegate:delegate
                                    styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                   delegate:(id<AKFormFieldSwitchDelegate>)delegate
               styleProvider:(id<AKFormCellSwitchStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.delegate = delegate;
        self.styleProvider = styleProvider;
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
    AKFormCellSwitch *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_SWITCH];
    if (!cell) {
        cell = [[AKFormCellSwitch alloc] initWithStyleProvider:self.styleProvider];
    }
    
    cell.delegate = self.delegate;
    cell.valueDelegate = self;
    
    cell.label.text = self.title;
    [cell.switchControl addTarget:self
                           action:@selector(switchValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    
    cell.switchControl.on = [self.value boolValue];
    
    [cell layoutSubviews];
    self.cell = cell;
    return cell;
}

#pragma mark - Value Changed

- (void)switchValueChanged:(UISwitch *)switchControl
{
    NSLog(@"*** switchValueChanged ***");
    switchControl.userInteractionEnabled = NO;
    
    self.value = [AKFormValue value:@(switchControl.on) withType:AKFormValueBool];
    [self.delegate didChangeValueOfSwitchOnField:self toOn:switchControl.on];
}

@end
