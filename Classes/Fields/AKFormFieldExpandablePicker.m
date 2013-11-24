//
//  AKFormFieldExpandablePicker.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldExpandablePicker.h"

@implementation AKFormFieldExpandablePicker

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
          metadataCollection:(AKFormMetadataCollection *)metadataCollection
               styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider
{
    return [[AKFormFieldExpandablePicker alloc] initWithKey:key
                                                      title:title
                                                placeholder:placeholder
                                         metadataCollection:metadataCollection
                                              styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
              styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider
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
    AKFormCellLabel *cell = (AKFormCellLabel *)[super cellForTableView:tableView];
    
    //set the value
    if (self.value && [self.value isMetadata]) {
        AKFormMetadata *metadata = [self.value metadataValue];
        cell.valueLabel.text = [metadata description];
    } else if (self.value && [self.value isMetadataCollection]) {
        AKFormMetadataCollection *metadataCollection = [self.value metadataCollectionValue];
        cell.valueLabel.text = [metadataCollection description];
    } else {
        cell.valueLabel.text = self.placeholder;
    }
    
    //set the mode
    if (self.isExpanded) {
        [cell setMode:AKFormCellLabelModeEditing];
    } else if (self.value && ([self.value isMetadata] || [self.value isMetadataCollection])) {
        [cell setMode:AKFormCellLabelModeFilled];
    } else {
        [cell setMode:AKFormCellLabelModeEmpty];
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
    AKFormCellPickerView *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_PICKER];
    if (!cell) {
        cell = [[AKFormCellPickerView alloc] init];
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
        self.value = [AKFormValue value:[self.metadataCollection randomMetadata]
                               withType:AKFormValueMetadata];
    } else {
        AKFormMetadataCollection *newCollection = [[AKFormMetadataCollection alloc] init];
        newCollection.descriptionSeparator = self.metadataCollection.descriptionSeparator;
        newCollection.descriptionPrefix = self.metadataCollection.descriptionPrefix;
        newCollection.descriptionSuffix = self.metadataCollection.descriptionSuffix;
        
        for (int component=0; component < [self.metadataCollection numberOfComponents]; component++) {
            AKFormMetadata *randomMetadata = [self.metadataCollection randomMetadataInComponent:component];
            [newCollection setMetadata:randomMetadata inComponent:component];
        }
        self.value = [AKFormValue value:newCollection withType:AKFormValueMetadataCollection];
    }
}

- (void)preselectValueOnPickerViewCell:(AKFormCellPickerView *)cell
{
    //select the value for each component
    if ([self.metadataCollection isSingular]) {
        NSInteger valueRow = [self.metadataCollection indexOfMetadata:[self.value metadataValue]];
        [cell.pickerView selectRow:valueRow inComponent:0 animated:NO];
    } else {
        for (int component=0; component<[[self.value metadataCollectionValue] numberOfComponents]; component++) {
            AKFormMetadata *metadata = [[self.value metadataCollectionValue] metadataAtIndex:0 inComponent:component];
            NSInteger valueRow = [self.metadataCollection indexOfMetadata:metadata inComponent:component];
            
            [cell.pickerView selectRow:valueRow inComponent:component animated:NO];
        }
    }
    
    [self didChangeValueForPickerViewCell:cell];
}

- (void)didChangeValueForPickerViewCell:(AKFormCellPickerView *)cell
{
    AKFormCellLabel *labelCell = [self labelCell];
    if (labelCell) {
        if ([self.value isMetadata]) {
            AKFormMetadata *metadata = [self.value metadataValue];
            labelCell.valueLabel.text = [metadata description];
        } else if ([self.value isMetadataCollection]) {
            AKFormMetadataCollection *collection = [self.value metadataCollectionValue];
            labelCell.valueLabel.text = [collection description];
        }
        [labelCell setMode:AKFormCellLabelModeEditing];
    }
}

- (BOOL)isFilled
{
    return [super isFilled] && ([self.value isMetadata] || [self.value isMetadataCollection]);
}

@end
