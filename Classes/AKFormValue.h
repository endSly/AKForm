//
//  AKFormValue.h
//  AKForm
//
//  Created by Ahmed Khalaf on 24/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKFormMetadata.h"
#import "AKFormMetadataCollection.h"

typedef NS_ENUM(NSInteger, AKFormValueType) {
    AKFormValueString,
    AKFormValueBool,
    AKFormValueDate,
    AKFormValueImage,
    AKFormValueMetadata,
    AKFormValueMetadataCollection,
    AKFormValueUnknown
};

/**
 *  This class is a container used to hold the value associated with a field in a form.
 *  It stores any supported type of value, and identifies the type by a set, readonly 
 *  property.
 */
@interface AKFormValue : NSObject

/**
 *  The type of the value, to which the classes methods behave accordingly. This property
 *  is readonly as it can only be set upon creation of the value.
 */
@property(readonly, nonatomic, assign) AKFormValueType type;

///---------------------------------------------------------------------------------------
/// @name Creating Form Values
///---------------------------------------------------------------------------------------

/**
 *  Creates and returns a `AKFormValue` object containing the provided value, identified
 *  by the provided type. Only values with supported types will successfully create an
 *  object – the rest will simply return nil.
 *
 *  It's important to note that when creating AKFormValueBool types, either a string or a
 *  number is expected as the parameter (since it doesn't allow primitives). It's up to
 *  the caller to ensure that the string or number explicitly indicates the bool value.
 *  So, for instance, values such as @"Y", @"1", @(1) would be explicitly identified as
 *  YES, while so would @"hello" or @(134).
 *
 *  @param aValue A value to be contained by this `AKFormValue` object.
 *  @param type   The type of the value.
 *
 *  @return A new `AKFormValue` object with the provided value. `nil` is returned if the
 *          provided value doesn't match the type, or if an invalid type is provided.
 */
+ (instancetype)value:(id)aValue withType:(AKFormValueType)type;

+ (instancetype)valueWithValue:(AKFormValue *)value;

///---------------------------------------------------------------------------------------
/// @name Accessing Form Values
///---------------------------------------------------------------------------------------

/**
 *  Returns the string value for this `AKFormValue` if it's of that type, or `nil`
 *  otherwise.
 *
 *  @return The string value for this `AKFormValue` if it's of that type or `nil` 
 *          otherwise.
 */
- (NSString *)stringValue;

/**
 *  Returns the bool value for this `AKFormValue` if it's of that type, or NO otherwise.
 *
 *  @return The bool value for this `AKFormValue` if it's of that type or NO otherwise.
 */
- (BOOL)boolValue;

/**
 *  Returns the date value for this `AKFormValue` if it's of that type, or `nil`
 *  otherwise.
 *
 *  @return The date value for this `AKFormValue` if it's of that type or `nil`
 *          otherwise.
 */
- (NSDate *)dateValue;

/**
 *  Returns the image value for this `AKFormValue` if it's of that type, or `nil`
 *  otherwise.
 *
 *  @return The image value for this `AKFormValue` if it's of that type or `nil`
 *          otherwise.
 */
- (UIImage *)imageValue;

/**
 *  Returns the metadata value for this `AKFormValue` if it's of that type, or `nil`
 *  otherwise.
 *
 *  @return The metadata value for this `AKFormValue` if it's of that type or `nil`
 *          otherwise.
 */
- (AKFormMetadata *)metadataValue;

/**
 *  Returns the metadata collection value for this `AKFormValue` if it's of that type,
 *  or `nil` otherwise.
 *
 *  @return The metadata collection  value for this `AKFormValue` if it's of that 
 *          type or `nil` otherwise.
 */
- (AKFormMetadataCollection *)metadataCollectionValue;

/**
 *  This will return the appropriate server representation for the stored value. The
 *  representation returned will have to be in a JSON parseable form (so strings, numbers,
 *  arrays and dicts are allowed, but custom objects such as metadata and their 
 *  collections will have to be converted to a representation combining those basic 
 *  types).
 *
 *  @return A JSON-parseable representation of the stored value.
 */
- (id)serverValue;

///---------------------------------------------------------------------------------------
/// @name Type Checking Form Values
///---------------------------------------------------------------------------------------

/**
 *  Returns YES if the stored value is a string, NO otherwise.
 *
 *  @return YES if the stored value is a string, NO otherwise.
 */
- (BOOL)isString;

/**
 *  Returns YES if the stored value is a bool, NO otherwise.
 *
 *  @return YES if the stored value is a bool, NO otherwise.
 */
- (BOOL)isBool;

/**
 *  Returns YES if the stored value is a date, NO otherwise.
 *
 *  @return YES if the stored value is a date, NO otherwise.
 */
- (BOOL)isDate;

/**
 *  Returns YES if the stored value is an image, NO otherwise.
 *
 *  @return YES if the stored value is an image, NO otherwise.
 */
- (BOOL)isImage;

/**
 *  Returns YES if the stored value is a metadata, NO otherwise.
 *
 *  @return YES if the stored value is a metadata, NO otherwise.
 */
- (BOOL)isMetadata;

/**
 *  Returns YES if the stored value is a metadata collection, NO otherwise.
 *
 *  @return YES if the stored value is a metadata collection, NO otherwise.
 */
- (BOOL)isMetadataCollection;

@end
