//
//  AKFormFieldExpandable.m
//  
//
//  Created by Ahmed Khalaf on 30/10/2013.
//
//

#import "AKFormFieldExpandable.h"

@implementation AKFormFieldExpandable

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    AKFormCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_LABEL];
    if (!cell) {
        cell = [[AKFormCellLabel alloc] initWithStyleProvider:self.styleProvider];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.titleLabel.text = self.title;
    
    self.cell = cell;
    return cell;
}

- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView
{
    return nil;
}

- (AKFormCellLabel *)labelCell
{
    if (self.cell && [self.cell isKindOfClass:[AKFormCellLabel class]]) {
        return (AKFormCellLabel *)self.cell;
    } else {
        return nil;
    }
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
