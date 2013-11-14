//*
//  CSMetadata.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 24/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_METADATA_ID     @"id"
#define KEY_METADATA_NAME   @"name"

/**
 *  An abstract class for metadata that is represented throughout the app. Metadata can be 
 *  defined as the data that is provided to describe user generated data. For instance, 
 *  when describing a user (in terms of their profile), their metadata could include the 
 *  gender and occupation.
 *
 *  This also strongly reflects the metadata stored on the server, as it has a server ID
 *  (which is usually used when making an association) and the name of it (that will be 
 *  displayed).
 *
 *  This class is associated with a dictionary represenation on the server.
 */
@interface CSMetadata : NSObject

///---------------------------------------------------------------------------------------
/// @name Creating Metadata
///---------------------------------------------------------------------------------------

/**
 *  The server ID of the metadata which accompanies the object for consistency.
 */
@property(readonly, nonatomic, strong) NSString *serverID;

/**
 *  The name of the metadata, which is what is usually displayed.
 */
@property(readonly, nonatomic, strong) NSString *name;

/** Creates and returns a metadata using the provided dictionary representation.
 
 This dictionary representation should have the required (predefined) key-values specified
 in the class as a minimum. The following is a sample JSON representation indicating what
 is expected of the dictionary:
 <pre><code>{
    "id": "1",
    "name": "Drink Promotion"
 }</pre></code>
 
 @param dictionary A valid dictionary representation of the metadata.
 @return A new metadata based on the provided dictionary representation, or `nil` if the 
         dictionary is invalid.
 */
+ (instancetype)metadataWithDictionary:(NSDictionary *)dictionary;

///---------------------------------------------------------------------------------------
/// @name Comparing Metadata
///---------------------------------------------------------------------------------------

/**
 *  Compares the receiving metadata to another metadata.
 *
 *  Two metadata have equal contents if they both have the same _serverID_ and _name_
 *  properties.
 *
 *  @param otherMetadata A metadata
 *
 *  @return `YES` if the contents of _otherMetadata_ are equal to the contents of the
 *          receiving metadata, otherwise `NO`.
 */
- (BOOL)isEqualToMetadata:(CSMetadata *)otherMetadata;

///---------------------------------------------------------------------------------------
/// @name Retrieving a Dictionary Representation
///---------------------------------------------------------------------------------------

/**
 *  Returns the receiver's value as a dictionary. This is usually used when this metadata
 *  is to be used as a parameter to a network call.
 *
 *  If the metadata doesn't have a server ID or name, an empty dictionary is returned.
 *
 *  @return The receiver's value as a dictionary.
 */
- (NSDictionary *)dictionaryValue;

@end
