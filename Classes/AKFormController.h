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
#import "AKFormFieldDate.h"
#import "AKFormFieldExpandablePicker.h"
#import "AKFormFieldModalPicker.h"
#import "CSFormFieldTextView.h"
#import "CSFormFieldSwitch.h"
#import "CSFormFieldSegmented.h"

@interface AKFormController : UITableViewController <CSFormCellTextFieldDelegate, CSFormFieldSwitchDelegate, CSFormFieldSegmentedDelegate, CSFormCellImageStyleProvider>

- (void)pressedCancelOnModalField:(id)sender;
- (void)pressedDoneOnModalField:(id)sender;

- (BOOL)validateForm;

- (void)addSection:(AKFormSection *)section;

- (AKFormValidator *)failedValidator;
- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo;
- (NSIndexPath *)indexPathForField:(AKFormField *)aField;

@end
