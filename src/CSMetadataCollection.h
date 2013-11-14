//
//  CSMetadataCollection.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 24/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMetadata.h"

/**
 *  An abstract class for metadata collections.
 *
 *  These collections can be used to represent the metadata that a row presents to the 
 *  user to make one or more selections from. It can also be used to represent the 
 *  collection of metadata objects that the user selects from those rows.
 *  
 *  This class can output a multidimensional array representation for when it needs to be
 *  transmitted to a server. Conversely, it can also be created from an array 
 *  representation that is received from the server.
 */
@interface CSMetadataCollection : NSObject

///---------------------------------------------------------------------------------------
/// @name Creating Metadata Collections
///---------------------------------------------------------------------------------------

/**  Creates and returns a metadata collection using the provided array representation.
 This method call is essentially the same as calling 
 `metadataCollectionWithArrays:` with a single array.
 
 @param array A valid array representing the metadata collection.
 @return A new metadata collection created from the provided array, or `nil` if the array 
         is invalid.
 @see metadataCollectionWithArrays:
 @see CSMetadata
*/
+ (instancetype)metadataCollectionWithArray:(NSArray *)array;

/**  Creates and returns a metadata collection using the provided arrays.
 
 Each array should contain dictionaries representing `CSMetadata` objects (as described
 in its class). The following is a sample JSON representation indicating what is expected
 of each array:
 <pre><code>[
    {
        "id": "1",
        "name": "Drink Promotion"
    },
    {
        "id": "6",
        "name": "Entry Giveaway"
    },
    {
        "id": "5",
        "name": "Entry Promotion"
    }
 ]</pre></code>
 
 Note that to be considered valid, each of these arrays should have `CSMetadata`s with
 unique server IDs. If there were two dictionaries with the same *id* value within one of
 these arrays, the latter would be considered invalid regardless of the names being
 different—thus resulting in this method returning `nil` for those parameters.
 
 @param array A comma-separated list of valid arrays ending with nil.
 @return A new metadata collection created from the provided arrays, or `nil` if any of 
         the arrays are invalid.
 @see metadataCollectionWithArray:
 @see CSMetadata
 */
+ (instancetype)metadataCollectionWithArrays:(NSArray *)array1, ...
    NS_REQUIRES_NIL_TERMINATION;

///---------------------------------------------------------------------------------------
/// @name Querying a Collection
///---------------------------------------------------------------------------------------

/**
 *  Returns a Boolean value that indicates whether a given metadata is present in the
 *  first component of the collection.
 *
 *  @param aMetadata A metadata object.
 *
 *  @return `YES` if 'aMetadata' is present in the first component of the collection, 
 *          otherwise `NO`.
 */
- (BOOL)containsMetadata:(CSMetadata *)aMetadata;

/**
 *  Returns a Boolean value that indicates whether a given metadata is present in the
 *  specified component of the collection.
 *
 *  @param aMetadata A metadata object.
 *
 *  @return `YES` if 'aMetadata' is present in the specified component of the collection,
 *          otherwise `NO`.
 */
- (BOOL)containsMetadata:(CSMetadata *)aMetadata inComponent:(NSUInteger)component;

/**
 *  Returns a Boolean value that indicates whether the collection is singular (has only
 *  one component)
 *
 *  @return `YES` if the collection only has one component, otherwise `NO`.
 */
- (BOOL)isSingular;

/**
 *  Returns a Boolean value that indicates whether the collection is dual (only has two
 *  component)
 *
 *  @return `YES` if the collection only has two components, otherwise `NO`.
 */
- (BOOL)isDual;

/**
 *  Returns the number of components in the receiver.
 *
 *  @return The number of components in the receiving collection.
 */
- (NSUInteger)numberOfComponents;

/**
 *  Returns the number of metadata in the first component of the collection.
 *
 *  @return The number of metadata in the first component of the collection, or 
 *          `NSNotFound` if the collection is empty.
 */
- (NSUInteger)numberOfMetadata;

/**
 *  Returns the number of metadata in the specified component of the collection.
 *
 *  @param component A component number within the bounds of the collection.
 *  @return The number of metadata in the specified component of the collection, or
 *          `NSNotFound` if an invalid component is provided.
 */
- (NSUInteger)numberOfMetadataForComponent:(NSUInteger)component;

/**
 *  Returns the metadata located at index in the first component.
 *
 *  @param index An index within the bounds of the first component.
 *  @return The metadata located at index in the first component, or `nil` if an invalid
 *          index is specified.
 */
- (CSMetadata *)metadataAtIndex:(NSUInteger)index;

/**
 *  Returns the metadata located at index in the first component.
 *
 *  @param index An index within the bounds of the first component.
 *  @return The metadata located at index in the first component, or `nil` if an invalid
 *          index is specified.
 */

/**
 *  Returns the metadata located at index in the specified component.
 *
 *  @param index An index within the bounds of the specified component.
 *  @param component A component within the bounds of the collection.
 *
 *  @return The metadata located at index in the specified component, or `nil` if an 
 *          invalid index is specified.
 */
- (CSMetadata *)metadataAtIndex:(NSUInteger)index inComponent:(NSUInteger)component;

/**
 *  Returns a random metadata from the first component.
 *
 *  @return A random metadata or `nil` if the collection is empty.
 */
- (CSMetadata *)randomMetadata;

/**
 *  Returns a random metadata from the specified component.
 *
 *  @param component A component within the bounds of the collection.
 *
 *  @return A random metadata or `nil` if the specified component is invalid.
 */
- (CSMetadata *)randomMetadataInComponent:(NSUInteger)component;

///---------------------------------------------------------------------------------------
/// @name Finding Metadata in a Collection
///---------------------------------------------------------------------------------------

/**
 *  Returns the index whose corresponding metadata in the first component is equal to a 
 *  given metadata.
 *
 *  @param aMetadata A metadata.
 *
 *  @return The index whose corresponding metadata in the first component is equal to 
 *          `aMetadata`. If none of the metadata in the first component is equal to 
 *          `aMetadata`, returns `NSNotFound`.
 */
- (NSUInteger)indexOfMetadata:(CSMetadata *)aMetadata;

/**
 *  Returns the index whose corresponding metadata in the specified component is equal to a
 *  given metadata.
 *
 *  @param aMetadata A metadata
 *  @param component A component within the bounds of the collection.
 *
 *  @return The index whose corresponding metadata in the specified component is equal to
 *          `aMetadata`. If none of the metadata in the specified component is equal to
 *          `aMetadata`, returns `NSNotFound`. Also returns `NSNotFound` if the specified
 *          component is invalid.
 */
- (NSUInteger)indexOfMetadata:(CSMetadata *)aMetadata inComponent:(NSUInteger)component;

///---------------------------------------------------------------------------------------
/// @name Adding Metadata
///---------------------------------------------------------------------------------------

//remember to mention 'valid metadata' and that its defined by a valid CSMetadata object
// that doesn't have a server ID that already exists in the array

/**
 *  Inserts a given metadata at the end of the first component. If an invalid metadata is
 *  specified, this method does nothing to affect the receiving collection.
 *
 *  If the collection is empty, this method will create with a single component with the
 *  given metadata.
 *
 *  @param aMetadata The metadata to add to the end of the first component. This value 
 *                   must not be nil, or must not already exist in the first component (by
 *                   having the same server ID as another metadata within it).
 *  @see CSMetadata
 */
- (void)addMetadata:(CSMetadata *)aMetadata;

/**
 *  Inserts a given metadata at the end of the specified component. If an invalid metadata
 *  or component is specified, this method does nothing to affect the receiving collection.
 *
 *  If the collection is empty, this method will create with a single component with the
 *  given metadata.
*
 *  If the specified component number is out of bounds of the collection, this method will
 *  expand the collection as needed, placing empty components to fill the gaps.
 *
 *  @param aMetadata The metadata to add to the end of the specified component. This value
 *                   must not be nil, or must not already exist in the specified component
 *                   (by having the same server ID as another metadata within it).
 *  @param component A non-negative, zero-indexed component number.
 */
- (void)addMetadata:(CSMetadata *)aMetadata inComponent:(NSInteger)component;

/**
 *  Inserts a given metadata into the collection's contents at a given component.
 *
 *  If the collection is empty, this method will create with a single component with the
 *  given metadata.
 *
 *  If the specified component number is out of bounds of the collection, this method will
 *  expand the collection as needed, placing empty components to fill the gaps.
 *
 *  @param aMetadata The metadata to add to the end of the specified component. This value
 *                   must not be nil.
 *  @param component A non-negative, zero-indexed component number.
 */
- (void)insertMetadata:(CSMetadata *)aMetadata atComponent:(NSInteger)component;

///---------------------------------------------------------------------------------------
/// @name Removing Metadata
///---------------------------------------------------------------------------------------

/**
 *  Removes the given metadata from the first component.
 *
 *  If aMetadata is present in the first component, it decrements its count. If the count 
 *  is decremented to 0, the component is removed from the collection. To fill the gap, 
 *  all components beyond *component* are moved by subtracting 1 from their index.
 *
 *  `removeObject:` does nothing if aMetadata is not present in the first component.
 *
 *  @param aMetadata The metadata to remove from the specified component.
 */
- (void)removeMetadata:(CSMetadata *)aMetadata;

/**
 *  Removes the given metadata from the specified component.
 *
 *  If aMetadata is present in the specified component, it decrements its count. If the 
 *  count is decremented to 0, the component is removed from the collection. To fill the 
 *  gap, all components beyond *component* are moved by subtracting 1 from their index.
 *
 *  `removeObject:` does nothing if aMetadata is not present in the specified component 
 *  or if an invalid component is specified.
 *
 *  @param aMetadata The metadata to remove from the specified component.
 *  @param component A component within the bounds of the collection.
 */
- (void)removeMetadata:(CSMetadata *)aMetadata inComponent:(NSUInteger)component;

///---------------------------------------------------------------------------------------
/// @name Replacing Metadata
///---------------------------------------------------------------------------------------

/**
 *  Sets the receiving collection's first component to the given metadata.
 *
 *  If the collection is empty, this method will create with a single component with the
 *  given metadata.
 *
 *  @param aMetadata The metadata with which to replace the receiving collection's
 *                   component.
 */
- (void)setMetadata:(CSMetadata *)aMetadata;

/**
 *  Sets the receiving collection's specified component to the given metadata.
 *
 *  If the collection is empty, this method will create with a single component with the
 *  given metadata.
 *
 *  If the specified component number is out of bounds of the collection, this method will
 *  expand the collection as needed, placing empty components to fill the gaps.
 *
 *  @param aMetadata The metadata with which to replace the receiving collection's 
 *                   component.
 *  @param component A non-negative, zero-indexed component number.
 */
- (void)setMetadata:(CSMetadata *)aMetadata inComponent:(NSInteger)component;

///---------------------------------------------------------------------------------------
/// @name Comparing Metadata Collections
///---------------------------------------------------------------------------------------

/**
 *  Compares the receiving metadata collection to another metadata collection.
 *
 *  Two metadata collections have equal contents if they both have the same arrays with
 *  the same metadatas.
 *
 *  @param otherMetadataCollection A metadata collection.
 *
 *  @return `YES` if the contents of _otherMetadataCollection_ are equal to the contents
 *          of the receiving metadata collection, otherwise `NO`.
 */
- (BOOL)isEqualToMetadataCollection:(CSMetadataCollection *)otherMetadataCollection;

///---------------------------------------------------------------------------------------
/// @name Retrieving Array Representations
///---------------------------------------------------------------------------------------

/**
 *  Returns the receiver's value as an array. This is usually used when this collection
 *  is to be used as a parameter to a network call. It is simply a two dimensional array
 *  with the lowest objects being the dictionary values of the metadatas.
 *
 *  This may not be the exact array that this collection was created with, as it strips
 *  out any unnecessary information when it is created.
 *
 *  @return The receiver's value as an array, or an empty array if the collection is 
 *          empty.
 */
- (NSArray *)arrayValue;

///---------------------------------------------------------------------------------------
/// @name Retrieving String Representations
///---------------------------------------------------------------------------------------

/**
 *  Returns the array of the names of the metadata objects in the first component.
 *
 *  @return The array of the names of the metadata objects in the first component, or an
 *          empty array if the collection is empty.
 */
- (NSArray *)arrayOfMetadataNames;

/**
 *  Returns the array of the names of the metadata objects in the given component.
 *
 *  @param component A component within the bounds of the collection.
 *  @return The array of the names of the metadata objects in the given component, or an
 *          empty array if an invalid component is specified.
 */
- (NSArray *)arrayOfMetadataNamesForComponent:(NSInteger)component;

@end
