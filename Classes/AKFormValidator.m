//
//  AKFormValidator.m
//  AKForm
//
//  Created by Ahmed Khalaf on 21/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormValidator.h"
#import "AKFormMetadata.h"

@implementation AKFormValidator

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

+ (instancetype)requiredBlockWithFailMessage:(NSString *)message
{
    return [AKFormValidator requiredValidatorWithMessage:message block:[AKFormValidator requiredBlock]];
}

+ (instancetype)requiredMetadataCollectionWithComponents:(NSInteger)numberOfComponents withMessage:(NSString *)message
{
    return [AKFormValidator requiredValidatorWithMessage:message block:[AKFormValidator requiredMetadataCollectionBlockWithComponents:numberOfComponents]];
}

#pragma mark - Required Field Validators (Private)

+ (instancetype)requiredValidatorWithMessage:(NSString *)message block:(ValidationBlock)block
{
    return [[AKFormValidator alloc] initWithValidationBlock:block
                                                     failMessage:message
                                                failMessageTitle:FAILED_TITLE_MISSING_FIELD];
}

#pragma mark - Standard Validation Blocks (Private)

+ (ValidationBlock)requiredBlock
{
    return ^BOOL(AKFormValue *value) {
        if (!value) {
            return NO;
        }
        
        switch (value.type) {
            case AKFormValueBool:
                return [value isBool];
                break;
            case AKFormValueString:
                return [value isString] && [[value stringValue] length] > 0;
                break;
            case AKFormValueDate:
                return [value isDate];
                break;
            case AKFormValueImage:
                return [value isImage] && [value imageValue] != nil;
                break;
            case AKFormValueMetadata:
                return [value isMetadata] &&
                [value metadataValue].serverID && [value metadataValue].serverID.length != 0 &&
                [value metadataValue].name && [value metadataValue].name.length != 0;
                break;
            case AKFormValueMetadataCollection:
                if ([value isMetadataCollection]) {
                    BOOL hasAtLeastOneMetadataInEachComponent = YES;
                    for (int i=0; i<[[value metadataCollectionValue] numberOfComponents]; i++) {
                        hasAtLeastOneMetadataInEachComponent &= [[value metadataCollectionValue] numberOfMetadataForComponent:i] > 0;
                    }
                    return hasAtLeastOneMetadataInEachComponent;
                }
                return NO;
                break;
            case AKFormValueUnknown:
                return NO;
                break;
        }
    };
}

+ (ValidationBlock)requiredMetadataCollectionBlockWithComponents:(NSInteger)numberOfComponents
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