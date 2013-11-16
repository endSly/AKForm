//
//  AKFormField.h
//  AKForm
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AKFormValue.h"
#import "AKFormMetadataCollection.h"
#import "AKFormValidator.h"
#import "AKFormCell.h"

/**
 *  An abstract parent class for all the other field classes. This class encapsulates the
 *  common properties for all form fields. It isn't meant to be created directly, but
 *  does provide an initializer for its subclasses to utilize.
 */
@interface AKFormField : NSObject <CSFormCellValueDelegate>

///---------------------------------------------------------------------------------------
/// @name Common Field Properties
///---------------------------------------------------------------------------------------

/**
 *  A unique string key for this field within the scope of the form. It is also the key
 *  that the value of this field will be stored under (in the form data dictionary), so it
 *  is good practice to use to one consistent with the server.
 */
@property(nonatomic, strong) NSString *key;

/**
 *  The value of this field.
 *  @see AKFormValue
 */
@property(nonatomic, strong) AKFormValue *value;

/**
 *  The title of this field, describing it.
 */
@property(nonatomic, strong) NSString *title;


/**
 *  The metadata associated with this field, if any. This applies to fields that present
 *  options from which the user can pick one or many from.
 *  @see AKFormMetadataCollection
 */
@property(nonatomic, strong) AKFormMetadataCollection *metadataCollection;

///---------------------------------------------------------------------------------------
/// @name Creating a Form Field
///---------------------------------------------------------------------------------------

- (instancetype)initWithKey:(NSString *)key title:(NSString *)title;

///---------------------------------------------------------------------------------------
/// @name Generating a Table View Cell from a Form Field
///---------------------------------------------------------------------------------------

@property(nonatomic, weak) UITableViewCell *cell;

- (UITableViewCell *)cellForTableView:(UITableView *)tableView;
- (void)willBeDisplayed;

///---------------------------------------------------------------------------------------
/// @name Validation
///---------------------------------------------------------------------------------------

/**
 *  The array of validation blocks that are used for this field when validating this form.
 *  The field's value will be passed into each of these validator blocks.
 *  @see AKFormValidator
 */
@property(nonatomic, strong) NSArray *validators;

- (AKFormValidator *)failedValidator;
- (BOOL)isFilled;


@end
