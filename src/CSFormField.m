//
//  CSFormField.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormField.h"

@implementation CSFormField

///---------------------------------------------------------------------------------------
#pragma mark - Creating a Form Field
///---------------------------------------------------------------------------------------

- (instancetype)initWithKey:(NSString *)key title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.key = key;
        self.title = title;
    }
    return self;
}

///---------------------------------------------------------------------------------------
#pragma mark - Generating a Table View Cell from a Form Field
///---------------------------------------------------------------------------------------

- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"defaultCellIdentifier"];
    cell.textLabel.text = @"Default Label";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cell = cell;
    return cell;
}

- (void)willBeDisplayed
{
    
}

///---------------------------------------------------------------------------------------
#pragma mark - Cell Value Delegate
///---------------------------------------------------------------------------------------

- (CSFormValue *)inputValue
{
    return self.value;
}

- (void)didInputValue:(CSFormValue *)value
{
    self.value = value;
}

- (void)didSelectMetadata:(CSMetadata *)metadata inComponent:(NSUInteger)component
{
    if (!self.value || ![self.value isMetadataCollection]) {
        //if we don't already have a value, create a metadata collection with this selected value
        CSMetadataCollection *newCollection = [[CSMetadataCollection alloc] init];
        [newCollection setMetadata:metadata inComponent:component];
        self.value = [CSFormValue value:newCollection withType:CSFormValueMetadataCollection];
    } else {
        //if we already a metadata collection, update the component
        [[self.value metadataCollectionValue] setMetadata:metadata inComponent:component];
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - Validating a Field
///---------------------------------------------------------------------------------------

- (CSFormValueValidator *)failedValidator
{
    for (CSFormValueValidator *validator in self.validators) {
        if (!validator.validationBlock(self.value)) {
            return validator;
        }
    }
    return nil;
}

- (BOOL)isFilled
{
    return self.value != nil;
}

///---------------------------------------------------------------------------------------
#pragma mark - Description of a Field
///---------------------------------------------------------------------------------------

- (NSString *)debugDescription
{
    //Field: {
    //  Key: Something
    //  Title: Something else
    //  Value: Something
    //  Cell: {
    //
    //  }
    //}
    NSMutableString *description = [NSMutableString stringWithFormat:@"\nField <%p>: {", self];
    [description appendFormat:@"\n\tKey: %@", self.key];
    [description appendFormat:@"\n\tTitle: %@", self.key];
    [description appendFormat:@"\n\tValue: %@", self.value];
    [description appendFormat:@"\n\tCell: %@", self.cell];
    [description appendString:@"\n}"];
    return description;
}

@end
