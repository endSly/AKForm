//
//  AKFormFieldSegmented.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldSegmented.h"

@implementation AKFormFieldSegmented

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
                   delegate:(id<AKFormFieldSegmentedDelegate>)delegate
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.metadataCollection = metadataCollection;
        self.delegate = delegate;
    }
    return self;
}

/**
 *  Returns a toggle cell by first attempting to dequeue it from the provided tableView, or creating
 *  one if necessary.
 *
 *  @param tableView The tableView from which to try and dequeue the cell.
 *  @return The toggle cell casted as a UITableViewcell.
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    CSFormToggleCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_TOGGLE];
    if (!cell) {
        cell = [[CSFormToggleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CELL_IDENTIFIER_TOGGLE];
    }
    
    [cell setLabelString:self.title];
    [cell recreateSegmentedControlWithItems:[self.metadataCollection arrayOfMetadataNames]];
    [cell.segmentedControl addTarget:self
                              action:@selector(segmentedValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    
    NSInteger segmentIndex;
    if ([self.value metadataValue]) {
        segmentIndex = [self.metadataCollection indexOfMetadata:[self.value metadataValue]];
    } else {
        segmentIndex = UISegmentedControlNoSegment;
    }
    cell.segmentedControl.selectedSegmentIndex = segmentIndex;
        
    self.cell = cell;
    return cell;
}

#pragma mark - Actions

- (void)segmentedValueChanged:(UISegmentedControl *)segmentedControl
{
    AKFormMetadata *metadata = [self.metadataCollection metadataAtIndex:segmentedControl.selectedSegmentIndex];
    self.value = [AKFormValue value:metadata withType:AKFormValueBool];
    [self.delegate didSelectSegmentIndex:segmentedControl.selectedSegmentIndex onField:self];
}

@end
