//
//  CSFormValueValidator.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 21/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSFormValue.h"

typedef NS_ENUM(NSInteger, CSFormValueValidatorType) {
    CSFormValueValidatorTypeDestructive,
    CSFormValueValidatorTypeWarning,
    CSFormValueValidatorTypeInformative
};

#define FAILED_TITLE_MISSING_FIELD      @"Missing field"
#define FAILED_TITLE_DEFAULT            @"Validation Error"
#define FAILED_MESSAGE_DEFAULT          @"There was a validation error. Please try again."
#define DEFAULT_VALIDATOR_TYPE          CSFormValueValidatorTypeDestructive

/**
 *  This typedef decsribes a block that processes the input value and validates it.
 *
 *  @param value A value to be validated.
 *  @return A BOOL indicating whether the validation passed or failed.
 */
typedef BOOL (^ValidationBlock)(CSFormValue *value);

/**
 *  This class holds a block of code that validates an input `CSFormValue` along with an 
 *  associated fail message in case the validation doesn't pass.
 */
@interface CSFormValueValidator : NSObject

///---------------------------------------------------------------------------------------
/// @name Main Initializer
///---------------------------------------------------------------------------------------

/**
 *  The message to the user explaining why the validation failed
 */
@property(nonatomic, strong) NSString *failMessage;

/**
 *  The title for the message explaining why the validation failed
 */
@property(nonatomic, strong) NSString *failMessageTitle;

@property(nonatomic, assign) CSFormValueValidatorType type;
/**
 *  The readonly validation block that is to be run on the provided value. This block
 *  returns a BOOL indicating whether the validation passed or not.
 */
@property(nonatomic, strong) ValidationBlock validationBlock;

/**
 *  An initializer for this validation block
 *
 *  @param validationBlock A ValidationBlock that is to be run on the provided value and 
                           output a BOOL
 *  @param failMessage The message explaining why the validation failed (it may be
 *                     presented to the user)
 *  @param failMessageTitle The title for the message explaining why the validation failed
 *
 *  @return A `CSFormValueValidator` object with the provided parameters
 */
- (instancetype)initWithValidationBlock:(ValidationBlock)validationBlock
                            failMessage:(NSString *)failMessage
                       failMessageTitle:(NSString *)failMessageTitle;

///---------------------------------------------------------------------------------------
/// @name Standard Blocks - Required Fields
///---------------------------------------------------------------------------------------

/**
 *  Creates and returns a validation block that checks whether the value is a string and
 *  exists (is not empty).
 *
 *  @param message The message for the user when the validation fails.
 *  @return A validation block that checks whether the value is a string and exists.
 */
+ (instancetype)blockForRequiredStringWithMessage:(NSString *)message;

/**
 *  Creates and returns a validation block that checks whether the value is a bool.
 *
 *  @param message The message for the user when the validation fails.
 *  @return A validation block that checks whether the value is a bool.
 */
+ (instancetype)blockForRequiredBoolWithMessage:(NSString *)message;

/**
 *  Creates and returns a validation block that checks whether the value is an image and
 *  has some data in it.
 *
 *  @param message The message for the user when the validation fails.
 *  @return A validation block that checks whether the value is an image and has some data
 *          in it.
 */
+ (instancetype)blockForRequiredImageWithMessage:(NSString *)message;

/**
 *  Creates and returns a validation block that checks whether the value is a date.
 *
 *  @param message The message for the user when the validation fails.
 *  @return A validation block that checks whether the value is a date.
 */
+ (instancetype)blockForRequiredDateWithMessage:(NSString *)message;

/**
 *  Creates and returns a validation block that checks whether the value is a metadata and
 *  exists.
 *
 *  @param message The message for the user when the validation fails.
 *  @return A validation block that checks whether the value is a metadata and exists.
 */
+ (instancetype)blockForRequiredMetadataWithMessage:(NSString *)message;

/**
 *  Creates and returns a validation block that checks whether the value is a metadata
 *  collection that exists and contains metadata in the specified number of components.
 *
 *  @param message The message for the user when the validation fails.
 *  @return A validation block that checks whether the value is a metadata collection that
 *          exists and contains at least one metadata in each of the specified number of
 *          components.
 */
+ (instancetype)blockForRequiredMetadataCollectionHavingComponents:(NSInteger)numberOfComponents
                                                       withMessage:(NSString *)message;

@end
