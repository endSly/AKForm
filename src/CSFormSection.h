//
//  CSFormSection.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSFormField.h"
#import "CSFormFieldExpandable.h"

@interface CSFormSection : NSObject <NSCopying>

///---------------------------------------------------------------------------------------
/// @name Creating a Section
///---------------------------------------------------------------------------------------

/**
 *  A unique key identifying this section within the form.
 */
@property(nonatomic, strong) NSString *key;

/**
 *  A header title that is displayed at the top of the section.
 */
@property(nonatomic, strong) NSString *headerTitle;

/**
 *  A footer title that is displayed at the bottom of the section.
 */
@property(nonatomic, strong) NSString *footerTitle;

- (instancetype)initWithFields:(NSArray *)fields;

///---------------------------------------------------------------------------------------
/// @name Querying a Section
///---------------------------------------------------------------------------------------

- (BOOL)containsField:(CSFormField *)field;
- (CSFormFieldExpandable *)expandedField;
- (CSFormField *)fieldAtIndex:(NSInteger)index;
- (CSFormField *)fieldAtRowNumber:(NSInteger)rowNumber;
- (NSInteger)numberOfFields;
- (NSInteger)numberOfRows;

///---------------------------------------------------------------------------------------
/// @name Finding Fields in a Section
///---------------------------------------------------------------------------------------

- (NSInteger)indexOfField:(CSFormField *)field;

///---------------------------------------------------------------------------------------
/// @name Adding Fields
///---------------------------------------------------------------------------------------

- (void)addField:(CSFormField *)field;
- (void)addFields:(NSArray *)fields;

///---------------------------------------------------------------------------------------
/// @name Removing Fields
///---------------------------------------------------------------------------------------

- (void)removeField:(CSFormField *)field;

///---------------------------------------------------------------------------------------
/// @name Managing Expandable Fields
///---------------------------------------------------------------------------------------

- (BOOL)expandFieldAtRowNumber:(NSInteger)rowNumber;
- (BOOL)collapseFieldAtRowNumber:(NSInteger)rowNumber;

///---------------------------------------------------------------------------------------
/// @name Validating a Section
///---------------------------------------------------------------------------------------

- (CSFormField *)fieldFailedWithValidator:(CSFormValueValidator **)validator;

///---------------------------------------------------------------------------------------
/// @name Generating table view cells
///---------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtRowNumber:(NSInteger)rowNumber;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

///---------------------------------------------------------------------------------------
/// @name Populating a dictionary of form values
///---------------------------------------------------------------------------------------

- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo;

@end
