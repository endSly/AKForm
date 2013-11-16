//
//  AKFormMetadata.m
//  AKForm
//
//  Created by Ahmed Khalaf on 24/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormMetadata.h"

@interface AKFormMetadata()
//extensions for setters
@property(nonatomic, strong) NSString *serverID;
@property(nonatomic, strong) NSString *name;
@end

@implementation AKFormMetadata

///---------------------------------------------------------------------------------------
#pragma mark - Creating Metadata
///---------------------------------------------------------------------------------------

+ (instancetype)metadataWithDictionary:(NSDictionary *)dictionary
{
    AKFormMetadata *metadata = [[AKFormMetadata alloc] init];
    if ([dictionary isKindOfClass:[NSDictionary class]]
        && [self validateDictionary:dictionary]) {
        metadata.serverID = dictionary[KEY_METADATA_ID];
        metadata.name = dictionary[KEY_METADATA_NAME];
        return metadata;
    }
    return nil;
}

///---------------------------------------------------------------------------------------
#pragma mark Validating Metadata Dictionaries
///---------------------------------------------------------------------------------------

+ (BOOL)validateDictionary:(NSDictionary *)d
{
    if (![d objectForKey:KEY_METADATA_ID]
        || !([[d objectForKey:KEY_METADATA_ID] isKindOfClass:[NSNumber class]]
             || [[d objectForKey:KEY_METADATA_ID] isKindOfClass:[NSString class]])) {
        NSLog(@"A valid value for key %@ wasn't provided", KEY_METADATA_ID);
        return NO;
    }
    
    if (![d objectForKey:KEY_METADATA_NAME]
        || ![[d objectForKey:KEY_METADATA_NAME] isKindOfClass:[NSString class]]) {
        NSLog(@"A valid value for key %@ wasn't provided", KEY_METADATA_NAME);
        return NO;
    }
    
    return YES;
}

///---------------------------------------------------------------------------------------
#pragma mark - Comparing Metadata
///---------------------------------------------------------------------------------------

- (BOOL)isEqualToMetadata:(AKFormMetadata *)otherMetadata
{
    if (!otherMetadata) {
        return NO;
    }

    BOOL haveEqualServerIDs = (!self.serverID && !otherMetadata.serverID) || [self.serverID isEqual:otherMetadata.serverID];
    BOOL haveEqualNames = (!self.name && !otherMetadata.name) || [self.name isEqualToString:otherMetadata.name];
    
    return haveEqualServerIDs && haveEqualNames;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[AKFormMetadata class]]) {
        return NO;
    }
    
    return [self isEqualToMetadata:(AKFormMetadata *)object];
}

- (NSUInteger)hash
{
    return [self.serverID hash] ^ [self.name hash];
}

///---------------------------------------------------------------------------------------
#pragma mark - Retrieving a Dictionary Representation
///---------------------------------------------------------------------------------------

- (NSDictionary *)dictionaryValue
{
    if (!self.name || !self.serverID) {
        return [NSDictionary dictionary];
    } else {
        return @{KEY_METADATA_ID: self.serverID,
                 KEY_METADATA_NAME: self.name};
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - Creating a Description
///---------------------------------------------------------------------------------------

- (NSString *)description
{
    if (self.name && self.serverID &&
        [self.name isKindOfClass:[NSString class]] &&
        [self.serverID isKindOfClass:[NSString class]]) {
        return self.name;
    } else {
        return @"";
    }
}

- (NSString *)debugDescription
{
    if (self.name && self.serverID) {
        NSString *debugDescription = [NSString stringWithFormat:@"<AKFormMetadata: server-id=\"%@\", name=\"%@\">",
                                      self.serverID, self.name];
        return debugDescription;
    } else {
        return @"<AKFormMetadata: empty>";
    }
}

@end
