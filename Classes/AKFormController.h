//
//  AKFormController.h
//  AKForm
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKFormSection.h"

#import "AKFormField.h"

#import "AKFormFieldText.h"
#import "AKFormFieldImage.h"
#import "AKFormFieldExpandable.h"
#import "CSFormFieldModalPicker.h"
#import "CSFormFieldTextView.h"
#import "CSFormFieldSwitch.h"
#import "CSFormFieldSegmented.h"

@protocol CSFormDelegate
@optional
- (void)pressedNext;
@end

@interface AKFormController : UITableViewController <CSFormDelegate, CSFormCellTextFieldDelegate, CSFormFieldModalPickerDelegate, CSFormFieldSwitchDelegate, CSFormFieldSegmentedDelegate, CSFormCellImageStyleProvider>

- (void)addSection:(AKFormSection *)section;

- (AKFormValueValidator *)failedValidator;
- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo;
- (NSIndexPath *)indexPathForField:(AKFormField *)aField;

@end
