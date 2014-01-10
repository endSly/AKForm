//
//  AKFormController.h
//  AKForm
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HexColors/HexColor.h>

#import "AKFormSection.h"

#import "AKFormField.h"

#import "AKFormFieldTextField.h"
#import "AKFormFieldImage.h"
#import "AKFormFieldExpandable.h"
#import "AKFormFieldDate.h"
#import "AKFormFieldExpandablePicker.h"
#import "AKFormFieldModalPicker.h"
#import "AKFormFieldTextBox.h"
#import "AKFormFieldSwitch.h"

#define HEIGHT_STANDARD_PICKER  216.f
#define CELL_HEIGHT_DEFAULT             44.f
#define CELL_HEIGHT_DEFAULT_TEXTVIEW    60.f
#define CELL_HEIGHT_PICKER              HEIGHT_STANDARD_PICKER

@interface AKFormController : UITableViewController <AKFormCellTextFieldDelegate, AKFormFieldSwitchDelegate, AKFormCellImageStyleProvider, AKFormCellTextBoxDelegate>

- (void)pressedCancelOnModalField:(id)sender;
- (void)pressedDoneOnModalField:(id)sender;

- (BOOL)validateForm;

- (void)addSection:(AKFormSection *)section;

- (AKFormValidator *)failedValidator;
- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo;
- (NSIndexPath *)indexPathForField:(AKFormField *)aField;
- (NSIndexPath *)indexPathForField:(AKFormField *)aField inSection:(AKFormSection *)section;

@end
