//
//  CSFormSection.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormSection.h"
#import "CSFormFieldExpandablePicker.h"
#import "CSFormValueValidator.h"

@interface CSFormSection()
@property(nonatomic, strong) NSMutableArray *fields;
@end

@implementation CSFormSection

#pragma mark - Convenience Helpers

//adds a field to the array
- (void)addField:(CSFormField *)field
{
    [self.fields addObject:field];
}

//for each provided field in the array, adds it
- (void)addFields:(NSArray *)fields
{
    for (CSFormField *field in fields) {
        if (field) {
            [self addField:field];
        }
    }
}

//removes a field from the array
- (void)removeField:(CSFormField *)field
{
    [self.fields removeObject:field];
}

#pragma mark - Initializers & Constructors

- (instancetype)initWithFields:(NSArray *)fields
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.fields = [NSMutableArray arrayWithArray:fields];
    return self;
}

#pragma mark - UITableViewDataSource Helpers

- (NSInteger)indexOfField:(CSFormField *)field
{
    if (self.fields) {
        return [self.fields indexOfObject:field];
    } else {
        return NSNotFound;
    }
}

//DELETE THIS
////row number (ie. that which the tableview calls the row in an index path)
//// this should consider expandable fields and whether they are expanded.
//// should return NSNotFound if not found
////*** put simply, this is the row number (that the tableview is concerned) with.
////*** it depends on whether there is an expanded cell within this section, unlike
////*** the index method
//- (NSInteger)rowNumberOfField:(CSFormField *)aField
//{
//    int n=0;
//    for (int r=0; r<self.fields.count; r++) {
//        CSFormField *field = self.fields[r];
//        if ([field isEqual:aField]) {
//            return n;
//        }
//        
//        //if this is one, add 1 to the row number
//        if ([field isKindOfClass:[CSFormFieldExpandable class]]
//            && [(CSFormFieldExpandable *)field isExpanded]) {
//            n++;
//        }
//        n++;
//    }
//    return NSNotFound;
//}

- (CSFormField *)fieldAtIndex:(NSInteger)index
{
    if (self.fields && index < self.fields.count) {
        return self.fields[index];
    } else {
        return nil;
    }
}

- (CSFormField *)fieldAtRowNumber:(NSInteger)row
{
    int n=0;
    for (int r=0; r<self.fields.count; r++) {
        CSFormField *field = self.fields[r];
        if (n == row) {
            return field;
        }
        // make sure we increment the count for expanded cells
        if ([field isKindOfClass:[CSFormFieldExpandable class]]
            && [(CSFormFieldExpandable *)field isExpanded]) {
            n++;
            if (n == row) {
                return field;
            }
        }
        n++;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSFormField *field = self.fields[indexPath.row];
    if (field) {
        [field willBeDisplayed];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtRowNumber:(NSInteger)row
{
    int n=0;
    for (int r=0; r<self.fields.count; r++) {
        CSFormField *field = self.fields[r];
        if (n == row) {
            return [field cellForTableView:tableView];
        }
        
        //if this is an expanded picker, increment the count and
        // then check if this the row we're looking for
        if ([field isKindOfClass:[CSFormFieldExpandable class]]
            && [(CSFormFieldExpandable *)field isExpanded]) {
            n++;
            //if it is, we will return the expanded cell
            if (n == row) {
                CSFormFieldExpandable *expandableField = (CSFormFieldExpandable *)field;
                return [expandableField expandedCellForTableView:tableView];
            }
        }
        n++;
    }
    //maybe return nil here?
    return [[[CSFormField alloc] init] cellForTableView:tableView];
}

#pragma mark - UITableViewDelegate Helpers

//used by the tableview to determine the number of 'rows' to display, we will need to
// account for the expanded companions, if any.
- (NSInteger)numberOfRows
{
    if (self.fields) {
        NSInteger expandedFieldsCount = 0;
        for (CSFormField *field in self.fields) {
            if ([field isKindOfClass:[CSFormFieldExpandable class]]
                && [(CSFormFieldExpandable *)field isExpanded]) {
                expandedFieldsCount++;
            }
        }
        return self.fields.count + expandedFieldsCount;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfFields
{
    if (self.fields) {
        return self.fields.count;
    } else {
        return 0;
    }
}

#pragma mark - Just Added?

- (CSFormFieldExpandable *)expandedField
{
    for (CSFormField *field in self.fields) {
        if ([field isKindOfClass:[CSFormFieldExpandable class]]) {
            CSFormFieldExpandable *expandableField = (CSFormFieldExpandable *)field;
            if ([expandableField isExpanded]) {
                return expandableField;
            }
        }
    }
    return nil;
}

- (BOOL)setExpandedStateOfFieldAtRowNumber:(NSInteger)rowNumber toExpanded:(BOOL)expanded
{
    if (self.fields
        && self.fields.count > rowNumber
        && [self.fields[rowNumber] isKindOfClass:[CSFormFieldExpandable class]]) {
        [self.fields[rowNumber] setIsExpanded:expanded];
        return YES;
    } else {
        return NO;
    }
}

//TODO; with unit tests — make sure that we don't already have an expanded field,
// and decide if we want to collapse it first?
- (BOOL)expandFieldAtRowNumber:(NSInteger)rowNumber
{
    return [self setExpandedStateOfFieldAtRowNumber:rowNumber toExpanded:YES];
}

- (BOOL)collapseFieldAtRowNumber:(NSInteger)rowNumber
{
    return [self setExpandedStateOfFieldAtRowNumber:rowNumber toExpanded:NO];
}

- (CSFormField *)fieldFailedWithValidator:(CSFormValueValidator **)validator
{
    for (CSFormField *field in self.fields) {
        CSFormValueValidator *failedValidator = [field failedValidator];
        if (failedValidator) {
            *validator = failedValidator;
            return field;
        }
    }
    return nil;
}

//perhaps populate server info? (since it's server value :P)
- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo
{
    for (CSFormField *field in self.fields) {
        if (field.value != nil) {
            userInfo[field.key] = [field.value serverValue];
        }
    }
    return userInfo;
}

- (BOOL)containsField:(CSFormField *)field
{
    if (self.fields) {
        return [self.fields containsObject:field];
    } else {
        return NO;
    }
}

//used for NSMapTable stuff?
#pragma mark - NSCoding Protocol

- (id)copyWithZone:(NSZone *)zone
{
    CSFormSection *objectCopy = [[CSFormSection allocWithZone:zone] init];
    objectCopy.headerTitle = self.headerTitle;
    objectCopy.footerTitle = self.footerTitle;
    objectCopy.fields = [NSMutableArray arrayWithArray:self.fields];
    return objectCopy;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[CSFormSection class]]) {
        return NO;
    }
    
    CSFormSection *section = (CSFormSection *)object;
    return [self.key isEqualToString:section.key];
}

@end