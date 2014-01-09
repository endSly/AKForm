//
//  AKFormFieldSwitch.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldToggle.h"
#import "AKFormCellSwitch.h"

@class AKFormFieldSwitch;

@protocol AKFormFieldSwitchDelegate
- (void)didChangeValueOfSwitchOnField:(AKFormFieldSwitch *)row toOn:(BOOL)on;
@end


@interface AKFormFieldSwitch : AKFormFieldToggle

//placed here for now because its only switches that have on/off toggles.
//we need to have a more abstract way of dealing with these
@property(nonatomic, strong) NSMapTable *fieldsToHideOnOn;
@property(nonatomic, strong) NSMapTable *fieldsToShowOnOn;

@property(nonatomic, weak) id<AKFormFieldSwitchDelegate> delegate;
@property(nonatomic, weak) id<AKFormCellSwitchStyleProvider> styleProvider;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                    delegate:(id<AKFormFieldSwitchDelegate>)delegate
               styleProvider:(id<AKFormCellSwitchStyleProvider>)styleProvider;

@end
