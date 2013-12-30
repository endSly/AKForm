//
//  AKFormFieldDate.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldExpandable.h"
#import "AKFormCellDatePicker.h"

typedef NS_ENUM(NSUInteger, AKFormFieldDateDisplayType) {
    AKFormFieldDateDisplayRelative,
    AKFormFieldDateDisplayRelativeShort,
    AKFormFieldDateDisplayWithTime,
    AKFormFieldDateDisplayNoTime,
    AKFormFieldDateDisplayTodayTimeOnly,
    AKFormFieldDateDisplayCustom
};

@interface AKFormFieldDate : AKFormFieldExpandable <AKFormCellDatePickerDelegate>

@property(nonatomic) UIDatePickerMode datePickerMode;
@property(nonatomic) AKFormFieldDateDisplayType displayType;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSDate *maximumDate;
@property(nonatomic, strong) NSString *dateDisplayFormat;

@property(nonatomic, weak) AKFormFieldDate *periodEndDateField;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
              datePickerMode:(UIDatePickerMode)datePickerMode
                 displayType:(AKFormFieldDateDisplayType)displayType
               displayFormat:(NSString *)displayFormat
              	styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider;

- (NSString *)dateString;

@end
