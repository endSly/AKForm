//
//  CSFormFieldExpandable.h
//  
//
//  Created by Ahmed Khalaf on 30/10/2013.
//
//

#import "CSFormFieldDescriptive.h"
#import "CSFormCellPickerView.h"
#import "CSFormCellLabel.h"

@class CSFormFieldExpandable;

@interface CSFormFieldExpandable : CSFormFieldDescriptive

@property(nonatomic) BOOL isExpanded;
@property(nonatomic, weak) id<CSFormCellLabelStyleProvider> styleProvider;

@property(nonatomic, weak) UITableViewCell *expandedCell;

- (CSFormCellLabel *)labelCell;

- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView;

@end
