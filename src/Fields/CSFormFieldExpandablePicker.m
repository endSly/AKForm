//
//  CSFormFieldExpandablePicker.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldExpandablePicker.h"

@implementation CSFormFieldExpandablePicker

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
         metadataCollection:(CSMetadataCollection *)metadataCollection
              styleProvider:(id<CSFormCellLabelStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title placeholder:placeholder];
    if (self) {
        self.metadataCollection = metadataCollection;
        self.styleProvider = styleProvider;
        self.placeholder = placeholder;
    }
    return self;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    CSFormCellLabel *cell = (CSFormCellLabel *)[super cellForTableView:tableView];
    
    //set the value
    if (self.value && [self.value isMetadata]) {
        CSMetadata *metadata = [self.value metadataValue];
        cell.valueLabel.text = [metadata description];
    } else if (self.value && [self.value isMetadataCollection]) {
        CSMetadataCollection *metadataCollection = [self.value metadataCollectionValue];
        cell.valueLabel.text = [metadataCollection description];
    } else {
        cell.valueLabel.text = self.placeholder;
    }
    
    //set the mode
    if (self.isExpanded) {
        [cell setMode:CSFormCellLabelModeEditing];
    } else if (self.value && ([self.value isMetadata] || [self.value isMetadataCollection])) {
        [cell setMode:CSFormCellLabelModeFilled];
    } else {
        [cell setMode:CSFormCellLabelModeEmpty];
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
    CSFormCellPickerView *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_PICKER];
    if (!cell) {
        cell = [[CSFormCellPickerView alloc] init];
    }
    
    cell.metadataCollection = self.metadataCollection;
    [cell.pickerView reloadAllComponents];
    
    cell.valueDelegate = self;
    cell.delegate = self;
    
    if (![self isFilled]) {
        [self assignRandomValue];
    }
    
    [self preselectValueOnPickerViewCell:cell];

    self.expandedCell = cell;
    return cell;
}

- (void)assignRandomValue
{
    if ([self.metadataCollection isSingular]) {
        self.value = [CSFormValue value:[self.metadataCollection randomMetadata]
                               withType:CSFormValueMetadata];
    } else {
        CSMetadataCollection *newCollection = [[CSMetadataCollection alloc] init];
        for (int component=0; component < [self.metadataCollection numberOfComponents]; component++) {
            CSMetadata *randomMetadata = [self.metadataCollection randomMetadataInComponent:component];
            [newCollection setMetadata:randomMetadata inComponent:component];
        }
        self.value = [CSFormValue value:newCollection withType:CSFormValueMetadataCollection];
    }
}

- (void)preselectValueOnPickerViewCell:(CSFormCellPickerView *)cell
{
    //select the value for each component
    if ([self.metadataCollection isSingular]) {
        NSInteger valueRow = [self.metadataCollection indexOfMetadata:[self.value metadataValue]];
        [cell.pickerView selectRow:valueRow inComponent:0 animated:NO];
    } else {
        for (int component=0; component<[[self.value metadataCollectionValue] numberOfComponents]; component++) {
            CSMetadata *metadata = [[self.value metadataCollectionValue] metadataAtIndex:0 inComponent:component];
            NSInteger valueRow = [self.metadataCollection indexOfMetadata:metadata inComponent:component];
            
            [cell.pickerView selectRow:valueRow inComponent:component animated:NO];
        }
    }
    
    [self didChangeValueForPickerViewCell:cell];
}

- (void)didChangeValueForPickerViewCell:(CSFormCellPickerView *)cell
{
    CSFormCellLabel *labelCell = [self labelCell];
    if (labelCell) {
        if ([self.value isMetadata]) {
            CSMetadata *metadata = [self.value metadataValue];
            labelCell.valueLabel.text = [metadata description];
        } else if ([self.value isMetadataCollection]) {
            CSMetadataCollection *collection = [self.value metadataCollectionValue];
            labelCell.valueLabel.text = [collection description];
        }
        [labelCell setMode:CSFormCellLabelModeEditing];
    }
}

- (BOOL)isFilled
{
    return [super isFilled] && ([self.value isMetadata] || [self.value isMetadataCollection]);
}

@end
