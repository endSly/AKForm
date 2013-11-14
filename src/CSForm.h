//
//  CSForm.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 9/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSFormSection.h"

#import "CSFormField.h"

#import "CSFormFieldText.h"
#import "CSFormFieldImage.h"
#import "CSFormFieldExpandable.h"
#import "CSFormFieldModalPicker.h"
#import "CSFormFieldTextView.h"
#import "CSFormFieldSwitch.h"
#import "CSFormFieldSegmented.h"

@protocol CSFormDelegate
- (void)pressedNext;
@end

@interface CSForm : NSObject <UITableViewDataSource, UITableViewDelegate, CSFormCellTextFieldDelegate, CSFormFieldImageDelegate, CSFormFieldModalPickerDelegate, CSFormFieldSwitchDelegate, CSFormFieldSegmentedDelegate>

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) UIViewController<CSFormDelegate> *viewController;

+ (instancetype)formWithSections:(NSArray *)sections;
- (instancetype)initWithSections:(NSArray *)sections;

- (void)addSection:(CSFormSection *)section;

- (CSFormValueValidator *)failedValidator;
- (NSMutableDictionary *)populateUserInfo:(NSMutableDictionary *)userInfo;
- (NSIndexPath *)indexPathForField:(CSFormField *)aField;

@end
