//
//  CSFormFieldModalPicker.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldModalPicker.h"

@implementation CSFormFieldModalPicker

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
                   delegate:(id<CSFormFieldModalPickerDelegate>)delegate
{
    self = [super initWithKey:key title:title];
    if (self) {
        self.metadataCollection = metadataCollection;
        self.delegate = delegate;
        self.placeholder = placeholder;
    }
    
    return self;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    AKFormCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_LABEL];
    if (!cell) {
        cell = [[AKFormCellLabel alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CELL_IDENTIFIER_LABEL];
    }
    
//    [cell setLabelString:self.title];
    
//    cell.rightLabel.text = [self.value stringValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.cell = cell;
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
    
    [self.delegate didSelectItemOnModalPicker];
}

@end
