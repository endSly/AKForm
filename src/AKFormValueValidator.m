//
//  AKFormValueValidator.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 21/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormValueValidator.h"
#import "AKFormMetadata.h"

@implementation AKFormValueValidator

- (instancetype)initWithValidationBlock:(ValidationBlock)validationBlock
                            failMessage:(NSString *)failMessage
                       failMessageTitle:(NSString *)failMessageTitle
{
    if (!validationBlock) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.validationBlock = validationBlock;
        
        if (failMessage && [failMessage isKindOfClass:[NSString class]]) {
            self.failMessage = failMessage;
        } else {
            self.failMessage = FAILED_MESSAGE_DEFAULT;
        }

        if (failMessageTitle && [failMessageTitle isKindOfClass:[NSString class]]) {
            self.failMessageTitle = failMessageTitle;
        } else {
            self.failMessageTitle = FAILED_TITLE_DEFAULT;
        }
        
        self.type = DEFAULT_VALIDATOR_TYPE;
    }
    return self;
}

#pragma mark - Required Field Validators

+ (instancetype)blockForRequiredStringWithMessage:(NSString *)message
{
    return [AKFormValueValidator requiredValidatorWithMessage:message
                                                      block:[AKFormValueValidator validationBlock_stringExists]];
}

+ (instancetype)blockForRequiredBoolWithMessage:(NSString *)message
{
    return [AKFormValueValidator requiredValidatorWithMessage:message
                                                              block:[AKFormValueValidator validationBlock_boolExists]];
}

+ (instancetype)blockForRequiredImageWithMessage:(NSString *)message
{
    return [AKFormValueValidator requiredValidatorWithMessage:message
                                                      block:[AKFormValueValidator validationBlock_imageExists]];
}

+ (instancetype)blockForRequiredDateWithMessage:(NSString *)message
{
    return [AKFormValueValidator requiredValidatorWithMessage:message
                                                      block:[AKFormValueValidator validationBlock_dateExists]];
}

+ (instancetype)blockForRequiredMetadataWithMessage:(NSString *)message
{
    return [AKFormValueValidator requiredValidatorWithMessage:message
                                                      block:[AKFormValueValidator validationBlock_metadataExists]];
}

+ (instancetype)blockForRequiredMetadataCollectionHavingComponents:(NSInteger)numberOfComponents withMessage:(NSString *)message
{
    return [AKFormValueValidator requiredValidatorWithMessage:message
                                                      block:
            [AKFormValueValidator validationBlock_metadataCollectionExistsWithNumberOfComponents:numberOfComponents]];
}

#pragma mark - Helper Initializers (Private)

+ (instancetype)requiredValidatorWithMessage:(NSString *)message block:(ValidationBlock)block
{
    return [[AKFormValueValidator alloc] initWithValidationBlock:block
                                                   failMessage:message
                                              failMessageTitle:FAILED_TITLE_MISSING_FIELD];
}

#pragma mark - Standard Validation Blocks (Private)

+ (ValidationBlock)validationBlock_stringExists
{
    return ^BOOL(AKFormValue *value) {
        if (!value) {
            return NO;
        }
        
        return [value isString] && [[value stringValue] length] > 0;
    };
}

+ (ValidationBlock)validationBlock_boolExists
{
    return ^BOOL(AKFormValue *value) {
        if (!value) {
            return NO;
        }
        
        return [value isBool];
    };
}

+ (ValidationBlock)validationBlock_dateExists
{
    return ^BOOL(AKFormValue *value) {
        if (!value) {
            return NO;
        }
        
        return [value isDate];
    };
}

+ (ValidationBlock)validationBlock_imageExists
{
    return ^BOOL(AKFormValue *value) {
        if (!value) {
            return NO;
        }

        return [value isImage] && [value imageValue] != nil;
//        return [value isImage] && [UIImagePNGRepresentation([value imageValue]) length] > 0;
    };
}

+ (ValidationBlock)validationBlock_metadataExists
{
    return ^BOOL(AKFormValue *value) {
        if (!value) {
            return NO;
        }

        return [value isMetadata] &&
                [value metadataValue].serverID && [value metadataValue].serverID.length != 0 &&
                [value metadataValue].name && [value metadataValue].name.length != 0;
    };
}

+ (ValidationBlock)validationBlock_metadataCollectionExistsWithNumberOfComponents:(NSInteger)numberOfComponents
{
    return ^BOOL(AKFormValue *value) {
        if (!value) {
            return NO;
        }

        if ([value isMetadataCollection]) {
            if ([[value metadataCollectionValue] numberOfComponents] >= numberOfComponents) {
                BOOL hasAtLeastOneMetadataInEachComponent = YES;
                for (int i=0; i<numberOfComponents; i++) {
                    hasAtLeastOneMetadataInEachComponent &= [[value metadataCollectionValue] numberOfMetadataForComponent:i] > 0;
                }
                return hasAtLeastOneMetadataInEachComponent;
            }
        }
        return NO;
    };
}

@end
