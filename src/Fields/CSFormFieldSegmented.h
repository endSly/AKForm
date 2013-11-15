//
//  CSFormFieldSegmented.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldToggle.h"
#import "CSFormToggleCell.h"

@protocol CSFormFieldSegmentedDelegate
- (void)didSelectSegmentIndex:(NSInteger)selectedIndex onField:(AKFormField *)row;
@end

@interface CSFormFieldSegmented : CSFormFieldToggle

//doesn't do any toggling of other fields at the moment, because we need to be
//able to define which fields get shown when a certain segment is tapped on...
// so in the case of three options:
//Delivery Method:
//
//  [  iBeacons  ] [    GPS    ] [demographics]
//       {MT}           {MT}         {MT}
//
// now each of those ^ map tables (MT) can contain 
@property(nonatomic, strong) id<CSFormFieldSegmentedDelegate>delegate;
- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
                   delegate:(id<CSFormFieldSegmentedDelegate>)delegate;

@end
