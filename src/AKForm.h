//
//  AKForm.h
//  CitySwagga
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

@interface AKForm : NSObject <UITableViewDataSource, UITableViewDelegate, CSFormCellTextFieldDelegate, CSFormFieldImageDelegate, CSFormFieldModalPickerDelegate, CSFormFieldSwitchDelegate, CSFormFieldSegmentedDelegate>

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) UIViewController<CSFormDelegate> *viewController;

+ (instancetype)formWithSections:(NSArray *)sections;
- (instancetype)initWithSections:(NSArray *)sections;

- (void)addSection:(AKFormSection *)section;

- (AKFormValueValidator *)failedValidator;
- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo;
- (NSIndexPath *)indexPathForField:(AKFormField *)aField;

@end
