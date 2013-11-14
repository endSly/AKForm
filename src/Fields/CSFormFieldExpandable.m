//
//  CSFormFieldExpandable.m
//  
//
//  Created by Ahmed Khalaf on 30/10/2013.
//
//

#import "CSFormFieldExpandable.h"

@implementation CSFormFieldExpandable

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    CSFormCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_LABEL];
    if (!cell) {
        cell = [[CSFormCellLabel alloc] initWithStyleProvider:self.styleProvider];
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

- (CSFormCellLabel *)labelCell
{
    if (self.cell && [self.cell isKindOfClass:[CSFormCellLabel class]]) {
        return (CSFormCellLabel *)self.cell;
    } else {
        return nil;
    }
}

- (void)setIsExpanded:(BOOL)isExpanded
{
    _isExpanded = isExpanded;

    CSFormCellLabel *labelCell = [self labelCell];
    if (labelCell) {
        if (isExpanded) {
            [labelCell setMode:CSFormCellLabelModeEditing];
        } else if ([self isFilled]) {
            [labelCell setMode:CSFormCellLabelModeFilled];
        } else {
            [labelCell setMode:CSFormCellLabelModeEmpty];
        }
    }
}

@end
