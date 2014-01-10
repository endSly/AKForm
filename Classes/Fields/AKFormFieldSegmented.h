// TODO

//
//  AKFormFieldSegmented.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldToggle.h"
#import "CSFormToggleCell.h"

@protocol AKFormFieldSegmentedDelegate
- (void)didSelectSegmentIndex:(NSInteger)selectedIndex onField:(AKFormField *)row;
@end

@interface AKFormFieldSegmented : AKFormFieldToggle

//doesn't do any toggling of other fields at the moment, because we need to be
//able to define which fields get shown when a certain segment is tapped on...
// so in the case of three options:
//Delivery Method:
//
//  [  iBeacons  ] [    GPS    ] [demographics]
//       {MT}           {MT}         {MT}
//
// now each of those ^ map tables (MT) can contain 
@property(nonatomic, strong) id<AKFormFieldSegmentedDelegate>delegate;
- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
                   delegate:(id<AKFormFieldSegmentedDelegate>)delegate;

@end
