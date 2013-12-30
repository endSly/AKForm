//
//  AKFormValue.m
//  AKForm
//
//  Created by Ahmed Khalaf on 24/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormValue.h"
#import "AKFormMetadataCollection.h"
#import <NSDate+Helper/NSDate+Helper.h>

@interface AKFormValue()
//internal, because we format it when returned as needed
@property(nonatomic, strong) id value;
@property(nonatomic, assign) AKFormValueType type;
@end

@implementation AKFormValue

///---------------------------------------------------------------------------------------
#pragma mark - Creating Form Values
///---------------------------------------------------------------------------------------

+ (instancetype)valueWithValue:(AKFormValue *)value
{
    return [AKFormValue value:[value.value copy] withType:value.type];
}

+ (instancetype)value:(id)aValue withType:(AKFormValueType)type
{
    switch (type) {
        case AKFormValueString:
            if (![aValue isKindOfClass:[NSString class]]) {
                return nil;
            }
            break;
        case AKFormValueBool:
            if (!([aValue isKindOfClass:[NSString class]] || [aValue isKindOfClass:[NSNumber class]])) {
                return nil;
            }
            break;
        case AKFormValueDate:
            if (![aValue isKindOfClass:[NSDate class]]) {
                return nil;
            }
            break;
        case AKFormValueImage:
            if (![aValue isKindOfClass:[UIImage class]]) {
                return nil;
            }
            break;
        case AKFormValueMetadata:
            if (![aValue isKindOfClass:[AKFormMetadata class]]) {
                return nil;
            }
            break;
        case AKFormValueMetadataCollection:
            if (![aValue isKindOfClass:[AKFormMetadataCollection class]]) {
                return nil;
            }
            break;
        default:
            break;
    }
    
    AKFormValue *value = [[AKFormValue alloc] init];
    if (type == AKFormValueBool) {
        BOOL boolValue = [aValue boolValue];
        value.value = [NSNumber numberWithBool:boolValue];
    } else {
        value.value = aValue;
    }
    value.type = type;
    return value;
}

///---------------------------------------------------------------------------------------
#pragma mark - Accessing Form Values
///---------------------------------------------------------------------------------------

- (id)serverValue
{
    switch (self.type) {
        case AKFormValueString:
            return [self stringValue];
            break;
        case AKFormValueBool:
            return [NSString stringWithFormat:@"%d", [self boolValue]];
            break;
        case AKFormValueDate:
            return [NSString stringWithFormat:@"%d", (int)[[self dateValue] timeIntervalSince1970]];
            break;
        case AKFormValueImage:
            return [self imageValue];
            break;
        case AKFormValueMetadata:
            return [[self metadataValue] dictionaryValue];
            break;
        case AKFormValueMetadataCollection:
            return [[self metadataCollectionValue] arrayValue];
            break;
        default:
            return nil;
            break;
    }
}

- (BOOL)boolValue
{
    if (self.type == AKFormValueBool && ([self.value isKindOfClass:[NSString class]]
                                           || [self.value isKindOfClass:[NSNumber class]])) {
        return [self.value boolValue];
    } else {
        return NO;
    }
}

- (UIImage *)imageValue
{
    if ([self.value isKindOfClass:[UIImage class]]) {
        return (UIImage *)self.value;
    } else {
        return nil;
    }
}

- (NSDate *)dateValue
{
    if ([self.value isKindOfClass:[NSDate class]]) {
        return (NSDate *)self.value;
    } else {
        return nil;
    }
}

- (NSString *)stringValue
{
    if (!self.value) {
        return nil;
    }
    
    if ([self.value isKindOfClass:[NSString class]]) {
        return (NSString *)self.value;
    }
//    } else if ([self.value isKindOfClass:[AKFormMetadata class]]) {
//        return ((AKFormMetadata *)self.value).name;
        
//    } else if ([self.value isKindOfClass:[AKFormMetadataCollection class]]) {
//        AKFormMetadataCollection *metadataCollection = (AKFormMetadataCollection *)self.value;
//        if ([metadataCollection isSingular]) {
//            return [metadataCollection metadataAtIndex:0].name;
//
//        } else if ([metadataCollection isDual]) {
//#warning Instead of hardcoding, we want to save (just like dateFormatDescriptor, a metadataFormatPrefix, metadataFormatSuffix and metadataFormatDelimeter which we create the description with. Also this description may be in the metadataCollection itself?#
//
//#warning I know now, just like date format, we will have a special metadataCollectionStringValue and metadataStringValue, and we shall support FORMAT identifiers (taking the number of string placeholders as there are components and it will output the string accordingly (so we need this method in both those)
//            NSString *firstString = [metadataCollection metadataAtIndex:0 inComponent:0].name;
//            NSString *secondString = [metadataCollection metadataAtIndex:0 inComponent:1].name;
//            return [NSString stringWithFormat:@"%@ %@", firstString, secondString];
//        
//        } else if ([metadataCollection numberOfComponents] > 1) {
//            NSString *string = [metadataCollection metadataAtIndex:0].name;
//            for (int i=1; i<[metadataCollection numberOfMetadata]; i++) {
//                string = [NSString stringWithFormat:@"%@, %@",
//                          string,
//                          [metadataCollection metadataAtIndex:i].name];
//            }
//            return string;
//        }
//    }
    
//    else if ([self.value isKindOfClass:[NSDate class]]) {
//        //we return a string for the date with the level of detail relative to today, as described here:
//        //https://github.com/billymeltdown/nsdate-helper
//        //... but really the user should be formatting the date themselves for more explicit results
//        return [NSDate stringFromDate:(NSDate *)self.value];
//    }
    
    return nil;
}

- (AKFormMetadata *)metadataValue
{
    if ([self.value isKindOfClass:[AKFormMetadata class]]) {
        return (AKFormMetadata *)self.value;
    } else {
        return nil;
    }
}

- (AKFormMetadataCollection *)metadataCollectionValue
{
    if (self.type != AKFormValueMetadataCollection) {
        return nil;
    }
    
    //create an empty metadata collection if needed
    if (!self.value) {
        self.value = [[AKFormMetadataCollection alloc] init];
    }
    
    if ([self.value isKindOfClass:[AKFormMetadataCollection class]]) {
        return (AKFormMetadataCollection *)self.value;
    } else {
        return nil;
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - Type Checking Form Values
///---------------------------------------------------------------------------------------

- (BOOL)isString
{
    return self.type == AKFormValueString;
}

- (BOOL)isBool
{
    return self.type == AKFormValueBool;
}

- (BOOL)isDate
{
    return self.type == AKFormValueDate;
}

- (BOOL)isImage
{
    return self.type == AKFormValueImage;
}

- (BOOL)isMetadata
{
    return self.type == AKFormValueMetadata;
}

- (BOOL)isMetadataCollection
{
    return self.type == AKFormValueMetadataCollection;
}

- (NSString *)stringForType:(AKFormValueType)type
{
    switch (type) {
        case AKFormValueBool:
            return @"Bool";
        case AKFormValueDate:
            return @"Date";
        case AKFormValueImage:
            return @"Image";
        case AKFormValueMetadata:
            return @"Metadata";
        case AKFormValueMetadataCollection:
            return @"Metadata Collection";
        case AKFormValueString:
            return @"String";
        case AKFormValueUnknown:
            return @"Unknown";
    }
}

- (NSString *)debugDescription
{
    //Field: {
    //  Type: Something
    //  Value: Something
    //}
    NSMutableString *description = [NSMutableString stringWithFormat:@"\nField <%p>: {", self];
    [description appendFormat:@"\n\tType: %@", [self stringForType:self.type]];
    [description appendFormat:@"\n\tValue: %@", [self.value debugDescription]];
    [description appendString:@"\n}"];
    return description;
}

@end
