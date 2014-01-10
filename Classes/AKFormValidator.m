//
//  AKFormValidator.m
//  AKForm
//
//  Created by Ahmed Khalaf on 21/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormValidator.h"
#import "AKFormMetadata.h"
#import <CJStringValidator/NSString+CJStringValidator.h>

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

+ (instancetype)emailValidator:(NSString *)failMessage
{
    return [[AKFormValidator alloc] initWithValidationBlock:[AKFormValidator requiredEmailBlock]
                                                failMessage:failMessage
                                           failMessageTitle:FAILED_TITLE_INVALID_EMAIL];
}

+ (instancetype)passwordStrengthValidator:(NSString *)failMessage
                            minimumLength:(NSUInteger)minimumLength
                             alphanumeric:(BOOL)alphanumeric
                               hasSymbols:(BOOL)hasSymbols
                                bothCases:(BOOL)bothCases
{
    ValidationBlock validationBlock = [AKFormValidator passwordStrengthBlockForMinimumLength:minimumLength
                                                                                alphanumeric:alphanumeric
                                                                                  hasSymbols:hasSymbols
                                                                                   bothCases:bothCases];
    return [[AKFormValidator alloc] initWithValidationBlock:validationBlock
                                                failMessage:failMessage
                                           failMessageTitle:FAILED_TITLE_WEAK_PASSWORD];
}

+ (instancetype)requiredValidator:(NSString *)failMessage
{
    return [[AKFormValidator alloc] initWithValidationBlock:[AKFormValidator requiredBlock]
                                                failMessage:failMessage
                                           failMessageTitle:FAILED_TITLE_MISSING_FIELD];
}

+ (instancetype)requiredMetadataCollection:(NSString *)failMessage withComponents:(NSInteger)numberOfComponents
{
    return [[AKFormValidator alloc] initWithValidationBlock:[AKFormValidator requiredMetadataCollectionBlockWithComponents:numberOfComponents]
                                                failMessage:failMessage
                                           failMessageTitle:FAILED_TITLE_MISSING_FIELD];
}

#pragma mark - Standard Validation Blocks (Private)

+ (ValidationBlock)passwordStrengthBlockForMinimumLength:(NSUInteger)minimumLength
                                            alphanumeric:(BOOL)alphanumeric
                                              hasSymbols:(BOOL)hasSymbols
                                               bothCases:(BOOL)bothCases
{
    return ^BOOL(AKFormValue *value) {
        if (!value || ![value isString]) {
            return NO;
        }
        NSString *password = [value stringValue];
        
        if (![password isMinLength:minimumLength]) {
            return NO;
        }
        
        if (alphanumeric && ![self isAlphanumeric:password]) {
            return NO;
        }
        
        if (bothCases && ![self hasBothCases:password]) {
            return NO;
        }
        
        return YES;
    };
}

+ (BOOL)isAlphanumeric:(NSString *)string
{
    NSString *regex = @"^.*(?=.*?[a-zA-Z])(?=.*?[0-9]).+$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:string];
}

+ (BOOL)hasBothCases:(NSString *)string
{
    NSString *regex = @"^.*(?=.*?[a-z])(?=.*?[A-Z]).+$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:string];
}

+ (ValidationBlock)requiredEmailBlock
{
    return ^BOOL(AKFormValue *value) {
        if (!value || ![value isString]) {
            return NO;
        }
        
        return [[value stringValue] isEmail];
    };
}

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
