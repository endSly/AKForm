//
//  CSFormValue.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 24/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormValue.h"
#import "CSMetadataCollection.h"
#import "NSString+CJStringValidator.h"
#import <NSDate+Helper/NSDate+Helper.h>

@interface CSFormValue()
//internal, because we format it when returned as needed
@property(nonatomic, strong) id value;
@property(nonatomic, assign) CSFormValueType type;
@end

@implementation CSFormValue

///---------------------------------------------------------------------------------------
#pragma mark - Creating Form Values
///---------------------------------------------------------------------------------------

+ (instancetype)value:(id)aValue withType:(CSFormValueType)type
{
    switch (type) {
        case CSFormValueString:
            if (![aValue isKindOfClass:[NSString class]]) {
                return nil;
            }
            break;
        case CSFormValueBool:
            if (!([aValue isKindOfClass:[NSString class]] || [aValue isKindOfClass:[NSNumber class]])) {
                return nil;
            }
            break;
        case CSFormValueDate:
            if (![aValue isKindOfClass:[NSDate class]]) {
                return nil;
            }
            break;
        case CSFormValueImage:
            if (![aValue isKindOfClass:[UIImage class]]) {
                return nil;
            }
            break;
        case CSFormValueMetadata:
            if (![aValue isKindOfClass:[CSMetadata class]]) {
                return nil;
            }
            break;
        case CSFormValueMetadataCollection:
            if (![aValue isKindOfClass:[CSMetadataCollection class]]) {
                return nil;
            }
            break;
        default:
            break;
    }
    
    CSFormValue *value = [[CSFormValue alloc] init];
    if (type == CSFormValueBool) {
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
        case CSFormValueString:
            return [self stringValue];
            break;
        case CSFormValueBool:
            return [NSString stringWithFormat:@"%d", [self boolValue]];
            break;
        case CSFormValueDate:
            return [NSString stringWithFormat:@"%d", (int)[[self dateValue] timeIntervalSince1970]];
            break;
        case CSFormValueImage:
            return [self imageValue];
            break;
        case CSFormValueMetadata:
            return [[self metadataValue] dictionaryValue];
            break;
        case CSFormValueMetadataCollection:
            return [[self metadataCollectionValue] arrayValue];
            break;
        default:
            return nil;
            break;
    }
}

- (BOOL)boolValue
{
    if (self.type == CSFormValueBool && ([self.value isKindOfClass:[NSString class]]
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
//    } else if ([self.value isKindOfClass:[CSMetadata class]]) {
//        return ((CSMetadata *)self.value).name;
        
//    } else if ([self.value isKindOfClass:[CSMetadataCollection class]]) {
//        CSMetadataCollection *metadataCollection = (CSMetadataCollection *)self.value;
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

- (CSMetadata *)metadataValue
{
    if ([self.value isKindOfClass:[CSMetadata class]]) {
        return (CSMetadata *)self.value;
    } else {
        return nil;
    }
}

- (CSMetadataCollection *)metadataCollectionValue
{
    if (self.type != CSFormValueMetadataCollection) {
        return nil;
    }
    
    //create an empty metadata collection if needed
    if (!self.value) {
        self.value = [[CSMetadataCollection alloc] init];
    }
    
    if ([self.value isKindOfClass:[CSMetadataCollection class]]) {
        return (CSMetadataCollection *)self.value;
    } else {
        return nil;
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - Type Checking Form Values
///---------------------------------------------------------------------------------------

- (BOOL)isString
{
    return self.type == CSFormValueString;
}

- (BOOL)isBool
{
    return self.type == CSFormValueBool;
}

- (BOOL)isDate
{
    return self.type == CSFormValueDate;
}

- (BOOL)isImage
{
    return self.type == CSFormValueImage;
}

- (BOOL)isMetadata
{
    return self.type == CSFormValueMetadata;
}

- (BOOL)isMetadataCollection
{
    return self.type == CSFormValueMetadataCollection;
}

@end
