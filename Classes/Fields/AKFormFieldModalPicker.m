//
//  AKFormFieldModalPicker.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldModalPicker.h"

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
    
    //set the value
    if (self.value && [self.value isMetadataCollection]) {
        AKFormMetadataCollection *metadataCollection = [self.value metadataCollectionValue];
        cell.valueLabel.text = [metadataCollection description];
    } else {
        cell.valueLabel.text = self.placeholder;
    }
    
    //set the mode
    if (self.value && [self.value isMetadataCollection]) {
        [cell setMode:AKFormCellLabelModeFilled];
    } else {
        [cell setMode:AKFormCellLabelModeEmpty];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell layoutSubviews];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	}
    
    AKFormMetadata *metadata = [self.metadataCollection metadataAtIndex:indexPath.row];
    cell.textLabel.text = metadata.name;
    cell.tintColor = [[UIView appearance] tintColor];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = [[self.value metadataCollectionValue] containsMetadata:metadata] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AKFormMetadata *metadata = [self.metadataCollection metadataAtIndex:indexPath.row];

    //create the value if it's blank
    if (!self.value || ![self.value isMetadataCollection]) {
        //if we don't already have a value, create a metadata collection with this selected value
        AKFormMetadataCollection *newCollection = [[AKFormMetadataCollection alloc] init];
        newCollection.descriptionSeparator = self.metadataCollection.descriptionSeparator;
        newCollection.descriptionPrefix = self.metadataCollection.descriptionPrefix;
        newCollection.descriptionSuffix = self.metadataCollection.descriptionSuffix;
        self.value = [AKFormValue value:newCollection withType:AKFormValueMetadataCollection];
    }
    
    //update the metadata collection in the value
    if (self.multiplePicks) {
        if ([[self.value metadataCollectionValue] containsMetadata:metadata]) {
            [[self.value metadataCollectionValue] removeMetadata:metadata];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [[self.value metadataCollectionValue] addMetadata:metadata];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        int n = [[self.value metadataCollectionValue] numberOfMetadata];
        if (n != NSNotFound && n != 0) {
            AKFormMetadata *currentMetadata = [[self.value metadataCollectionValue] metadataAtIndex:0];
            
            //undo the last checkmark
            int r = [self.metadataCollection indexOfMetadata:currentMetadata];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            //also remove it
            [[self.value metadataCollectionValue] removeMetadata:currentMetadata];
        }
        [[self.value metadataCollectionValue] addMetadata:metadata];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // we also need to send a message to dismiss us
    }
    
    //update the label cell
    AKFormCellLabel *labelCell = [self labelCell];
    if (labelCell) {
        AKFormMetadataCollection *collection = [self.value metadataCollectionValue];
        labelCell.valueLabel.text = [collection description];
    }
}

@end
