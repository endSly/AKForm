//
//  AKFormFieldLabelled.m
//  
//
//  Created by Ahmed Khalaf on 24/11/2013.
//
//

#import "AKFormFieldLabelled.h"

@implementation AKFormFieldLabelled

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

- (AKFormCellLabel *)labelCell
{
    if (self.cell && [self.cell isKindOfClass:[AKFormCellLabel class]]) {
        return (AKFormCellLabel *)self.cell;
    } else {
        return nil;
    }
}

@end
