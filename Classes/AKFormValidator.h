//
//  AKFormValidator.h
//  AKForm
//
//  Created by Ahmed Khalaf on 21/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKFormValue.h"

typedef NS_ENUM(NSInteger, AKFormValidatorType) {
    AKFormValidatorTypeDestructive,
    AKFormValidatorTypeWarning,
    AKFormValidatorTypeInformative
};

#define FAILED_TITLE_MISSING_FIELD      @"Missing field"
#define FAILED_TITLE_DEFAULT            @"Validation Error"
#define FAILED_MESSAGE_DEFAULT          @"There was a validation error. Please try again."
#define DEFAULT_VALIDATOR_TYPE          AKFormValidatorTypeDestructive

/**
 *  This typedef decsribes a block that processes the input value and validates it.
 *
 *  @param value A value to be validated.
 *  @return A BOOL indicating whether the validation passed or failed.
 */
typedef BOOL (^ValidationBlock)(AKFormValue *value);

/**
 *  This class holds a block of code that validates an input `AKFormValue` along with an 
 *  associated fail message in case the validation doesn't pass.
 */
@interface AKFormValidator : NSObject

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

@property(nonatomic, assign) AKFormValidatorType type;
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
 *  @return A `AKFormValidator` object with the provided parameters
 */
- (instancetype)initWithValidationBlock:(ValidationBlock)validationBlock
                            failMessage:(NSString *)failMessage
                       failMessageTitle:(NSString *)failMessageTitle;

///---------------------------------------------------------------------------------------
/// @name Standard Blocks - Required Fields
///---------------------------------------------------------------------------------------

+ (instancetype)requiredBlockWithFailMessage:(NSString *)message;
+ (instancetype)requiredMetadataCollectionWithComponents:(NSInteger)numberOfComponents withMessage:(NSString *)message;


@end
