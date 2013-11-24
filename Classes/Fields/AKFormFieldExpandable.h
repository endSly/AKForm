//
//  AKFormFieldExpandable.h
//  
//
//  Created by Ahmed Khalaf on 30/10/2013.
//
//

#import "AKFormField.h"

#import "AKFormCellPickerView.h"
#import "AKFormCellLabel.h"

@class AKFormFieldExpandable;

#import "AKFormFieldLabelled.h"

@interface AKFormFieldExpandable : AKFormFieldLabelled

@property(nonatomic) BOOL isExpanded;

@property(nonatomic, weak) UITableViewCell *expandedCell;


- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView;

@end
