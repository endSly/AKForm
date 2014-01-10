//
//  AKFormFieldModalPicker.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldModalPicker.h"

@interface AKFormFieldModalPicker ()
@end

@implementation AKFormFieldModalPicker

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
          metadataCollection:(AKFormMetadataCollection *)metadataCollection
               multiplePicks:(BOOL)multiplePicks
               styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider
{
    return [[AKFormFieldModalPicker alloc] initWithKey:key
                                                 title:title
                                           placeholder:placeholder
                                    metadataCollection:metadataCollection
                                         multiplePicks:multiplePicks
                                         styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
              multiplePicks:(BOOL)multiplePicks
              styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider;
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.metadataCollection = metadataCollection;
        self.styleProvider = styleProvider;
        self.placeholder = placeholder;
        self.multiplePicks = multiplePicks;
    }
    
    return self;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    AKFormCellLabel *cell = (AKFormCellLabel *)[super cellForTableView:tableView];
    [self updateLabelCell:cell];
    [self styleLabelCell:cell];
    return cell;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.metadataCollection numberOfMetadata];
}

#define COLOR_TEXT_UNSELECTED [UIColor darkGrayColor]

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	}
    
    AKFormMetadata *metadata = [self.metadataCollection metadataAtIndex:indexPath.row];
    cell.textLabel.text = metadata.name;
    cell.tintColor = self.checkmarkTintColor;
    
    BOOL selected = [[self.value metadataCollectionValue] containsMetadata:metadata];
    cell.textLabel.textColor = selected ? self.checkmarkTintColor : COLOR_TEXT_UNSELECTED;
    cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AKFormMetadata *metadata = [self.metadataCollection metadataAtIndex:indexPath.row];

    //create the value if it's blank
//    if (!self.value || ![self.value isMetadataCollection]) {
    if (!self.dirtyMetadataCollection) {
        //if we don't already have a value, create a metadata collection with this selected value
        self.dirtyMetadataCollection = [[AKFormMetadataCollection alloc] init];
        self.dirtyMetadataCollection.descriptionSeparator = self.metadataCollection.descriptionSeparator;
        self.dirtyMetadataCollection.descriptionPrefix = self.metadataCollection.descriptionPrefix;
        self.dirtyMetadataCollection.descriptionSuffix = self.metadataCollection.descriptionSuffix;
    }
    
    //update the metadata collection in the value
    if (self.multiplePicks) {
        if ([self.dirtyMetadataCollection containsMetadata:metadata]) {
            [self.dirtyMetadataCollection removeMetadata:metadata];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = COLOR_TEXT_UNSELECTED;
        } else {
            [self.dirtyMetadataCollection addMetadata:metadata];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = self.checkmarkTintColor;
        }
    } else {
        NSUInteger n = [self.dirtyMetadataCollection numberOfMetadata];
        if (n != NSNotFound && n != 0) {
            AKFormMetadata *currentMetadata = [self.dirtyMetadataCollection metadataAtIndex:0];
            
            //undo the last checkmark
            NSUInteger r = [self.metadataCollection indexOfMetadata:currentMetadata];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = COLOR_TEXT_UNSELECTED;
            
            //also remove it
            [self.dirtyMetadataCollection removeMetadata:currentMetadata];
        }
        [self.dirtyMetadataCollection addMetadata:metadata];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = self.checkmarkTintColor;
        
        // we also need to send a message to dismiss us
        [[NSNotificationCenter defaultCenter] postNotificationName:AKNOTIFICATION_MODAL_PRESSED_DONE object:nil];
    }
    
//    [self updateLabelCell];
}

- (void)updateLabelCell
{
    AKFormCellLabel *labelCell = [self labelCell];
    [self updateLabelCell:labelCell];
}

- (void)updateLabelCell:(AKFormCellLabel *)labelCell
{
    if (labelCell) {
        AKFormMetadataCollection *collection = [self.value metadataCollectionValue];
        if ([collection numberOfMetadata] > 0) {
            labelCell.valueLabel.text = [collection description];
        } else {
            labelCell.valueLabel.text = self.placeholder;
        }
    }
    
    [self styleLabelCell:labelCell];
}

- (void)styleLabelCell:(AKFormCellLabel *)cell
{
    NSUInteger n = [[self.value metadataCollectionValue] numberOfMetadata];
    BOOL hasValue = self.value && [self.value isMetadataCollection] && n > 0 && n != NSNotFound;
    //set the value
    if (hasValue) {
        AKFormMetadataCollection *metadataCollection = [self.value metadataCollectionValue];
        cell.valueLabel.text = [metadataCollection description];
    } else {
        cell.valueLabel.text = self.placeholder;
    }
    
    //set the mode
    if (hasValue) {
        [cell setMode:AKFormCellLabelModeFilled];
    } else {
        [cell setMode:AKFormCellLabelModeEmpty];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell layoutSubviews];
}

@end
