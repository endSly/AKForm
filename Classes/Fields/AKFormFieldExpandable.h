//
//  AKFormFieldExpandable.h
//  
//
//  Created by Ahmed Khalaf on 30/10/2013.
//
//

#import "AKFormFieldDescriptive.h"
#import "AKFormCellPickerView.h"
#import "AKFormCellLabel.h"

@class AKFormFieldExpandable;

@interface AKFormFieldExpandable : AKFormFieldDescriptive

@property(nonatomic) BOOL isExpanded;
@property(nonatomic, weak) id<AKFormCellLabelStyleProvider> styleProvider;

@property(nonatomic, weak) UITableViewCell *expandedCell;

- (AKFormCellLabel *)labelCell;

- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView;

@end
