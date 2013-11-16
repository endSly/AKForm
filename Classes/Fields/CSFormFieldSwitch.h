//
//  CSFormFieldSwitch.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldToggle.h"
#import "CSFormSwitchCell.h"

@class CSFormFieldSwitch;

@protocol CSFormFieldSwitchDelegate
- (void)didChangeValueOfSwitchOnField:(CSFormFieldSwitch *)row toOn:(BOOL)on;
@end

@interface CSFormFieldSwitch : CSFormFieldToggle

//placed here for now because its only switches that have on/off toggles.
//we need to have a more abstract way of dealing with these
@property(nonatomic, strong) NSMapTable *fieldsToHideOnOn;
@property(nonatomic, strong) NSMapTable *fieldsToShowOnOn;

@property(nonatomic, strong) id<CSFormFieldSwitchDelegate> delegate;

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                   delegate:(id<CSFormFieldSwitchDelegate>)delegate;

@end
