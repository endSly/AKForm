//
//  AKFormMetadataCollection.m
//  AKForm
//
//  Created by Ahmed Khalaf on 24/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormMetadataCollection.h"

#define DEFAULT_DESCRIPTION_SEPARATOR @", "
#define DEFAULT_DESCRIPTION_PREFIX @""
#define DEFAULT_DESCRIPTION_SUFFIX @""

@interface AKFormMetadataCollection()
/**
 *  The internal multidimensional mutable array that is used to manage the collection.
 *  Users of the class do not need to know about this, and should simply use the
 *  helper methods instead.
 */
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation AKFormMetadataCollection

///---------------------------------------------------------------------------------------
#pragma mark - Creating Metadata Arrays
///---------------------------------------------------------------------------------------

+ (instancetype)metadataCollectionWithArray:(NSArray *)array
{
    return [self metadataCollectionWithArrays:array, nil];
}

+ (instancetype)metadataCollectionWithArrays:(NSArray *)array1, ... NS_REQUIRES_NIL_TERMINATION
{
    //add each of the provided arguments to the array of arrays
    NSMutableArray *arrays = [NSMutableArray array];
    id eachObject;
    va_list argumentList;
    if (array1) {
        [arrays addObject:array1];
        va_start(argumentList, array1);
        while ((eachObject = va_arg(argumentList, id))) {
            [arrays addObject: eachObject];
        }
        va_end(argumentList);
    } else {
        return nil;
    }
    
    //create the collection and the array
    AKFormMetadataCollection *metadataCollection = [[AKFormMetadataCollection alloc] init];
    metadataCollection.array = [NSMutableArray arrayWithCapacity:arrays.count];
    
    //go through the provided arrays, creating arrays of metadata objects from them
    for (NSArray *array in arrays) {
        NSMutableArray *metadataArray = [NSMutableArray array];
        for (NSDictionary *dictionary in array) {
            AKFormMetadata *metadata = [AKFormMetadata metadataWithDictionary:dictionary];
            if (metadata && ![AKFormMetadataCollection metadataArray:metadataArray contains:metadata]) {
                [metadataArray addObject:metadata];
            } else {
                return nil; //fail if any of the metadata representations were invalid
            }
        }
        [metadataCollection.array addObject:metadataArray];
    }
    
    return metadataCollection;
}

///---------------------------------------------------------------------------------------
#pragma mark - Querying an Array
///---------------------------------------------------------------------------------------

- (BOOL)containsMetadata:(AKFormMetadata *)aMetadata
{
    return [self containsMetadata:aMetadata inComponent:0];
}

- (BOOL)containsMetadata:(AKFormMetadata *)aMetadata inComponent:(NSUInteger)component
{
    if (self.array.count > component) {
        return ([self.array[component] containsObject:aMetadata]);
    }
    return NO;
}

- (BOOL)isSingular
{
    return [self numberOfComponents] == 1;
}

- (BOOL)isDual
{
    return [self numberOfComponents] == 2;
}

- (NSUInteger)numberOfComponents
{
    return [self.array count];
}

- (NSUInteger)numberOfMetadata
{
    return [self numberOfMetadataForComponent:0];
}

- (NSUInteger)numberOfMetadataForComponent:(NSUInteger)component
{
    if (!self.array || component >= self.array.count) {
        return NSNotFound;
    }
    
    return [self.array[component] count];
}

- (AKFormMetadata *)metadataAtIndex:(NSUInteger)index
{
    return [self metadataAtIndex:index inComponent:0];
}

- (AKFormMetadata *)metadataAtIndex:(NSUInteger)index inComponent:(NSUInteger)component
{
    if (self.array &&
        self.array.count > component &&
        [self.array[component] count] > index) {
        return self.array[component][index];
    }
    return nil;
}

- (AKFormMetadata *)randomMetadata
{
    return [self randomMetadataInComponent:0];
}

- (AKFormMetadata *)randomMetadataInComponent:(NSUInteger)component
{
    int randomRow = arc4random() % [self numberOfMetadataForComponent:component];
    return [self metadataAtIndex:randomRow inComponent:component];
}

///---------------------------------------------------------------------------------------
#pragma mark - Finding Metadata in an Array
///---------------------------------------------------------------------------------------

- (NSUInteger)indexOfMetadata:(AKFormMetadata *)aMetadata
{
    return [self indexOfMetadata:aMetadata inComponent:0];
}

- (NSUInteger)indexOfMetadata:(AKFormMetadata *)aMetadata inComponent:(NSUInteger)component
{
    if (self.array.count > component) {
        return [self.array[component] indexOfObject:aMetadata];
    } else {
        return NSNotFound;
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - Adding Metadata
///---------------------------------------------------------------------------------------

- (void)addMetadata:(AKFormMetadata *)aMetadata
{
    [self addMetadata:aMetadata inComponent:0];
}

- (void)addMetadata:(AKFormMetadata *)aMetadata inComponent:(NSInteger)component
{
    [self addMetadata:aMetadata inComponent:component byReplacing:NO];
}

- (void)insertMetadata:(AKFormMetadata *)aMetadata atComponent:(NSInteger)component
{
    if (component < 0 || !aMetadata || ![aMetadata isKindOfClass:[AKFormMetadata class]]) {
        return;
    }
    
    if (!self.array) {
        self.array = [NSMutableArray array];
    }
    [self insertEmptyComponent:component];
    self.array[component] = [NSMutableArray arrayWithObject:aMetadata];
}

///---------------------------------------------------------------------------------------
#pragma mark - Removing Metadata
///---------------------------------------------------------------------------------------

- (void)removeMetadata:(AKFormMetadata *)aMetadata
{
    [self removeMetadata:aMetadata inComponent:0];
}

- (void)removeMetadata:(AKFormMetadata *)aMetadata inComponent:(NSUInteger)component
{
    //don't continue if unnecessary
    if (!self.array || self.array.count <= component
        || !aMetadata || ![aMetadata isKindOfClass:[AKFormMetadata class]]) {
        return;
    }
    
    //*now* remove the metadata
    [self.array[component] removeObject:aMetadata];
    
    //do the dutiful if the component is now empty
    if ([self.array[component] count] == 0) {
        [self.array removeObjectAtIndex:component];
        
        //now remove any trailing 'placeholder' arrays
        for (int i=self.array.count-1; i>0; i--) {
            if ([self.array[i] count] == 0) {
                [self.array removeObjectAtIndex:i];
            } else {
                break;
            }
        }
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - Replacing Metadata
///---------------------------------------------------------------------------------------

- (void)setMetadata:(AKFormMetadata *)aMetadata
{
    [self setMetadata:aMetadata inComponent:0];
}

- (void)setMetadata:(AKFormMetadata *)aMetadata inComponent:(NSInteger)component
{
    [self addMetadata:aMetadata inComponent:component byReplacing:YES];
}

///---------------------------------------------------------------------------------------
#pragma mark - Retrieving String Representations
///---------------------------------------------------------------------------------------

- (NSArray *)arrayOfMetadataNames
{
    return [self arrayOfMetadataNamesForComponent:0];
}

- (NSArray *)arrayOfMetadataNamesForComponent:(NSInteger)component
{
    if (component < 0 || component >= self.array.count) {
        return [NSArray array];
    }
    
    NSMutableArray *items = [NSMutableArray array];
    for (AKFormMetadata *metadata in self.array[component]) {
        [items addObject:metadata.name];
    }
    return [NSArray arrayWithArray:items];
}

///---------------------------------------------------------------------------------------
#pragma mark - Retrieving Array Representations
///---------------------------------------------------------------------------------------

- (NSArray *)arrayValue
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (int i=0; i<self.array.count; i++) {
        NSMutableArray *componentArray = self.array[i];
        NSMutableArray *metadataArray = [NSMutableArray array];
        for (int j=0; j<componentArray.count; j++) {
            AKFormMetadata *metadata = componentArray[j];
            NSDictionary *dictionaryValue = [metadata dictionaryValue];
            if (!dictionaryValue) {
                return nil;
            } else {
                [metadataArray addObject:dictionaryValue];
            }
        }
        [returnArray addObject:[NSArray arrayWithArray:metadataArray]];
    }
    
    return [NSArray arrayWithArray:returnArray];
}

///---------------------------------------------------------------------------------------
#pragma mark - Comparing Metadata
///---------------------------------------------------------------------------------------

- (BOOL)isEqualToMetadataCollection:(AKFormMetadataCollection *)otherMetadataCollection
{
    if (!otherMetadataCollection) {
        return NO;
    }
    
    BOOL haveEqualArray = (!self.array && !otherMetadataCollection.array) || [self.array isEqual:otherMetadataCollection.array];
    
    return haveEqualArray;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[AKFormMetadataCollection class]]) {
        return NO;
    }
    
    return [self isEqualToMetadataCollection:(AKFormMetadataCollection *)object];
}

- (NSUInteger)hash
{
    return [self.array hash];
}

///---------------------------------------------------------------------------------------
#pragma mark - Private Helpers
///---------------------------------------------------------------------------------------

/**
 *  Returns YES if the server ID of *metadata* is present in any of the `AKFormMetadata` objects
 *  currently in *metadataArray*, regardless of whether the names differ.
 *
 *  @param metadataArray The metadataArray that we're checking.
 *  @param metadata      The metadata that we're searching for
 *
 *  @return A BOOL value indicating whether the *metadataArray* 'contains' the provided
 *          *metadata* object, in the context of a collection (ie. have the same ID).
 */
+ (BOOL)metadataArray:(NSArray *)metadataArray contains:(AKFormMetadata *)aMetadata
{
    //only search for dupliate id's
    for (AKFormMetadata *m in metadataArray) {
        if ([m.serverID isEqualToString:aMetadata.serverID]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  This method expands the collection to fit the specified number of components. It does this
 *  by placing empty mutable arrays at all the required components to match the specified 
 *  count.
 *
 *  @param components The number of components to expand the collection to hold. This method
 *                    does nothing if the number of components isn't greater than the currently
 *                    existing component count.
 */
- (void)expandComponentsToFit:(NSUInteger)components
{
    for (int i=self.array.count; i<=components; i++) {
        self.array[i] = [NSMutableArray array];
    }
}

/**
 *  This helper method inserts an empty component at the provided index in the collection. It 
 *  does so by first expanding the collection if needed. It then moves all the components ahead
 *  of the specified component count by 1, and placing an empty mutable array in the component
 *  index specified.
 *
 *  @param component A non-negative, zero-indexed component number to insert an empty component
 *                   at.
 */
- (void)insertEmptyComponent:(NSInteger)component
{
    if (component < 0) {
        return;
    }
    //if the component isn't 'within' the array, simply expand it
    if (component >= self.array.count) {
        [self expandComponentsToFit:component];
    } else {
        //move the elements in front up one before setting it with an empty metadata
        for (int i=self.array.count-1; i>=component; i--) {
            self.array[i+1] = self.array[i];
            //OR
            //self.array[i+1] = [NSMutableArray arrayWithArray:self.array[i]];
        }
        self.array[component] = [NSMutableArray array];
    }
}

/**
 *  This helper methods either adds the given metadata to the end of the component specified, or
 *  replacing the component with an array containing the metadata alone.
 *
 *  @param aMetadata The metadata to be added or to replace the component with.
 *  @param component A non-negative, zero-indexed component number.
 *  @param replace   A boolean value indicating whether the metadata should be added to the end of
 *                   the component specified or replace it entirely.
 */
- (void)addMetadata:(AKFormMetadata *)aMetadata inComponent:(NSInteger)component byReplacing:(BOOL)replace
{
    if (!aMetadata || ![aMetadata isKindOfClass:[AKFormMetadata class]] || component < 0) {
        return;
    }
    
    //create the array if needed
    if (!self.array) {
        self.array = [NSMutableArray array];
    }
    
    //create all the missing components if needed
    if (self.array.count <= component) {
        [self expandComponentsToFit:component];
    }
    
    //*now* add or set the metadata
    if (replace) {
        self.array[component] = [NSMutableArray arrayWithObject:aMetadata];
    } else {
        if (![AKFormMetadataCollection metadataArray:self.array[component] contains:aMetadata]) {
            [self.array[component] addObject:aMetadata];
        }
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - Creating a Description
///---------------------------------------------------------------------------------------

- (NSString *)description
{
    if (self.array && self.array.count > 0) {

        NSMutableString *description = [NSMutableString string];
        NSString *separatorString = self.descriptionSeparator != nil ? self.descriptionSeparator : DEFAULT_DESCRIPTION_SEPARATOR;
        NSString *prefixString = self.descriptionPrefix != nil ? self.descriptionPrefix : DEFAULT_DESCRIPTION_PREFIX;
        NSString *suffixString = self.descriptionSuffix != nil ? self.descriptionSuffix : DEFAULT_DESCRIPTION_SUFFIX;
    
        description = [NSMutableString string];
        [description appendString:prefixString];
        
        for (int i=0; i<self.array.count; i++) {
            NSArray *metadataArray = self.array[i];
            
            for (int j=0; j<metadataArray.count; j++) {
                AKFormMetadata *metadata = (AKFormMetadata *)metadataArray[j];
                [description appendString:[metadata name]];
                if (j != metadataArray.count-1) {
                    [description appendString:separatorString];
                }
            }
            if (![self isSingular]) {
                if (i != self.array.count-1) {
                    [description appendString:separatorString];
                }
            }
        }
        [description appendString:suffixString];
        return description;
    } else {
        return @"";
    }
}

- (NSString *)debugDescription
{
    if (self.array && self.array.count > 0) {
        NSMutableString *debugDescription = [NSMutableString stringWithString:@"<AKFormMetadataCollection: ["];
        for (NSArray *metadataArray in self.array) {
            [debugDescription appendString:@"["];
            for (AKFormMetadata *metadata in metadataArray) {
                [debugDescription appendString:[metadata debugDescription]];
                if ([metadataArray indexOfObject:metadata] != metadataArray.count-1) {
                    [debugDescription appendString:@","];
                }
            }
            [debugDescription appendString:@"]"];
            if ([self.array indexOfObject:metadataArray] != self.array.count-1) {
                [debugDescription appendString:@","];
            }
        }
        [debugDescription appendString:@"]>"];
        return debugDescription;
    } else {
        return @"<AKFormMetadataCollection: empty>";
    }
}

@end
