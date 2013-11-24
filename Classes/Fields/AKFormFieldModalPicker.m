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
               styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider
{
    return [[AKFormFieldModalPicker alloc] initWithKey:key
                                                 title:title
                                           placeholder:placeholder
                                    metadataCollection:metadataCollection
                                         styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
              styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider;
{
    self = [super initWithKey:key title:title];
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
    if (self.value && ([self.value isMetadata] || [self.value isMetadataCollection])) {
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
    cell.accessoryType = [[self.value metadataCollectionValue] containsMetadata:metadata] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AKFormMetadata *metadata = [self.metadataCollection metadataAtIndex:indexPath.row];
    
    if ([[self.value metadataCollectionValue] containsMetadata:metadata]) {
        [[self.value metadataCollectionValue] removeMetadata:metadata];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [[self.value metadataCollectionValue] addMetadata:metadata];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
//    [self.delegate didSelectItemOnModalPicker];
}

@end
