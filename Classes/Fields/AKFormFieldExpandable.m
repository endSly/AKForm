//
//  AKFormFieldExpandable.m
//  
//
//  Created by Ahmed Khalaf on 30/10/2013.
//
//

#import "AKFormFieldExpandable.h"

@implementation AKFormFieldExpandable

- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView
{
    return nil;
}

- (void)setIsExpanded:(BOOL)isExpanded
{
    _isExpanded = isExpanded;

    AKFormCellLabel *labelCell = [self labelCell];
    if (labelCell) {
        if (isExpanded) {
            [labelCell setMode:AKFormCellLabelModeEditing];
        } else if ([self isFilled]) {
            [labelCell setMode:AKFormCellLabelModeFilled];
        } else {
            [labelCell setMode:AKFormCellLabelModeEmpty];
        }
    }
}

@end
