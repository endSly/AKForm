//
//  DatePickerFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "DatePickerFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"
#define HEX_COLOR_RED               @"#790c06"

@interface DatePickerFieldsForm () <AKFormCellLabelStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setLabelWidth:(CGFloat)labelWidth;
- (void)setLabelCellStyle:(AKFormCellLabelStyle)labelCellStyle;
@end

@implementation DatePickerFieldsForm {
    CGFloat _labelWidth;
    AKFormCellLabelStyle _labelCellStyle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createForm];
}

#pragma mark -
#pragma mark Form Creation

- (void)createForm
{
    [self addDateFormatsSection];
    [self addPeriodsSection];
    [self addLabelStringLengthsSection];
}

- (void)addPeriodsSection
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormFieldDate *startField = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Start Time"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDateAndTime
                                                    displayType:AKFormFieldDateDisplayWithTime
                                                  displayFormat:nil
                                                  styleProvider:self];
    [fields addObject:startField];
    
    AKFormFieldDate *endField = [AKFormFieldDate fieldWithKey:@"date"
                                                        title:@"End Time"
                                                  placeholder:@"optional"
                                               datePickerMode:UIDatePickerModeDateAndTime
                                                  displayType:AKFormFieldDateDisplayWithTime
                                                displayFormat:nil
                                                styleProvider:self];
    [fields addObject:endField];
    startField.periodEndDateField = endField;

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"DATE PERIODS";
    section.footerTitle = @"Associating a field with a 'period end' field will make sure that 'end field' is always on or after it.";
    [self addSection:section];
}

- (void)addDateFormatsSection
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormFieldDate *dateField = [AKFormFieldDate fieldWithKey:@"date"
                                                         title:@"No Time"
                                                   placeholder:@"optional"
                                                datePickerMode:UIDatePickerModeDate
                                                   displayType:AKFormFieldDateDisplayNoTime
                                                 displayFormat:nil
                                                 styleProvider:self];
    [fields addObject:dateField];

    AKFormFieldDate *dateField2 = [AKFormFieldDate fieldWithKey:@"date"
                                                         title:@"With Time"
                                                   placeholder:@"optional"
                                                datePickerMode:UIDatePickerModeDateAndTime
                                                   displayType:AKFormFieldDateDisplayWithTime
                                                 displayFormat:nil
                                                 styleProvider:self];
    [fields addObject:dateField2];

    AKFormFieldDate *dateField3 = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Today Time Only"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDateAndTime
                                                    displayType:AKFormFieldDateDisplayTodayTimeOnly
                                                  displayFormat:nil
                                                  styleProvider:self];
    [fields addObject:dateField3];
    
    AKFormFieldDate *dateField4 = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Relative"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDateAndTime
                                                    displayType:AKFormFieldDateDisplayRelative
                                                  displayFormat:nil
                                                  styleProvider:self];
    [fields addObject:dateField4];

    AKFormFieldDate *dateField5 = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Relative Short"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDateAndTime
                                                    displayType:AKFormFieldDateDisplayRelativeShort
                                                  displayFormat:nil
                                                  styleProvider:self];
    [fields addObject:dateField5];

    AKFormFieldDate *dateField6 = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Custom Format"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDateAndTime
                                                    displayType:AKFormFieldDateDisplayCustom
                                                  displayFormat:@"EEE, MMM d, yyyy"
                                                  styleProvider:self];
    [fields addObject:dateField6];

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"DATE FORMATS";
    [self addSection:section];
}

- (void)addLabelStringLengthsSection
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormFieldDate *dateField = [AKFormFieldDate fieldWithKey:@"date"
                                                         title:@"Date"
                                                   placeholder:@"optional"
                                                datePickerMode:UIDatePickerModeDate
                                                   displayType:AKFormFieldDateDisplayCustom
                                                 displayFormat:@"EEE, MMM d, yyyy"
                                                 styleProvider:self];
    [fields addObject:dateField];

    AKFormFieldDate *dateField2 = [AKFormFieldDate fieldWithKey:@"date"
                                                         title:@"From Date"
                                                   placeholder:@"optional"
                                                datePickerMode:UIDatePickerModeDate
                                                   displayType:AKFormFieldDateDisplayCustom
                                                 displayFormat:@"EEE, MMM d, yyyy"
                                                 styleProvider:self];
    [fields addObject:dateField2];

    AKFormFieldDate *dateField3 = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Date of Birth"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDate
                                                    displayType:AKFormFieldDateDisplayCustom
                                                  displayFormat:@"EEE, MMM d, yyyy"
                                                  styleProvider:self];
    [fields addObject:dateField3];

    AKFormFieldDate *dateField4 = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Your Date of Birth"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDate
                                                    displayType:AKFormFieldDateDisplayCustom
                                                  displayFormat:@"EEE, MMM d, yyyy"
                                                  styleProvider:self];
    [fields addObject:dateField4];

    AKFormFieldDate *dateField5 = [AKFormFieldDate fieldWithKey:@"date"
                                                          title:@"Please Enter Your Date of Birth"
                                                    placeholder:@"optional"
                                                 datePickerMode:UIDatePickerModeDate
                                                    displayType:AKFormFieldDateDisplayCustom
                                                  displayFormat:@"EEE, MMM d, yyyy"
                                                  styleProvider:self];
    [fields addObject:dateField5];

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"LABEL STRING LENGTHS";
    [self addSection:section];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - Completing a Form

- (IBAction)completeForm:(id)sender
{
    if ([super validateForm]) {
        [[[UIAlertView alloc] initWithTitle:@"Passed"
                                    message:@"Validation Passed"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark -
#pragma mark Text Field Cell—Style Provider

- (void)setLabelWidth:(CGFloat)labelWidth
{
    _labelWidth = labelWidth;
    [self.tableView reloadData];
}

- (void)setLabelCellStyle:(AKFormCellLabelStyle)labelCellStyle
{
    _labelCellStyle = labelCellStyle;
    [self.tableView reloadData];
}

- (CGFloat)titleLabelWidthForLabelCell
{
    return _labelWidth;
}

- (AKFormCellLabelStyle)styleForLabelCell
{
    return _labelCellStyle;
}

- (UIFont *)titleLabelFontForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style
{
    switch (mode) {
        case CSFormCellTextFieldModeEmpty:
        case CSFormCellTextFieldModeFilled:
        case CSFormCellTextFieldModeReadOnly:
            return [UIFont systemFontOfSize:17.f];
            break;
        case CSFormCellTextFieldModeEditing:
        case CSFormCellTextFieldModeInvalid:
            return [UIFont boldSystemFontOfSize:17.f];
            break;
    }
}

- (UIFont *)valueLabelFontForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style
{
    if (style == AKFormCellLabelStyleTwoLines) {
        return [UIFont systemFontOfSize:13.f];
    } else {
        return [UIFont systemFontOfSize:17.f];
    }
}

- (UIColor *)titleLabelTextColorForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style
{
    if (mode == CSFormCellTextFieldModeInvalid) {
        return [UIColor colorWithHexString:HEX_COLOR_RED];
    } else {
        return [UIColor darkGrayColor];
    }
}

- (UIColor *)valueLabelTextColorForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style
{
    switch (mode) {
        case CSFormCellTextFieldModeEmpty:
            return [UIColor lightGrayColor];
            break;
        case CSFormCellTextFieldModeFilled:
        case CSFormCellTextFieldModeReadOnly:
            return [UIColor grayColor];
            break;
        case CSFormCellTextFieldModeEditing:
            return [UIColor colorWithHexString:@"#E67D2C"];
        case CSFormCellTextFieldModeInvalid:
            return [UIColor colorWithHexString:HEX_COLOR_RED];
            break;
    }
}

@end


#define MIN_LABEL_WIDTH 30.f
#define MAX_LABEL_WIDTH 300.f

@interface DatePickerFieldsFormContainer ()
@property(nonatomic, strong) IBOutlet DatePickerFieldsForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation DatePickerFieldsFormContainer

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //for some reason, not doing this (selecting each segment in turn before selecting the first one again),
    //will result in the tint color for the segments being blue (perhaps it's the window tint?)
    for (int i=0; i<6; i++) {
        [self.segmentedControl setSelectedSegmentIndex:i];
    }
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    [self segmentedControlDidChangeSelectedSegmentIndex:self.segmentedControl];
}

- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.slider.enabled = YES;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.form setLabelCellStyle:AKFormCellLabelStyleTitleWithStaticWidth1];
            break;
        case 1:
            [self.form setLabelCellStyle:AKFormCellLabelStyleTitleWithStaticWidth2];
            break;
        case 2:
            [self.form setLabelCellStyle:AKFormCellLabelStyleTitleWithStaticWidth3];
            break;
        case 3:
            [self.form setLabelCellStyle:AKFormCellLabelStyleNoTitle];
            break;
        case 4:
            [self.form setLabelCellStyle:AKFormCellLabelStyleTitleWithDynamicWidth];
            self.slider.enabled = NO;
            break;
        case 5:
            [self.form setLabelCellStyle:AKFormCellLabelStyleTwoLines];
            self.slider.enabled = NO;
            break;
    }
}

- (IBAction)pressedValidate:(id)sender
{
    [self.form completeForm:sender];
}

- (IBAction)sliderValueDidChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat width = ((MAX_LABEL_WIDTH - MIN_LABEL_WIDTH) * slider.value) + MIN_LABEL_WIDTH;
    [self.form setLabelWidth:width];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"form_embed"]) {
        self.form = (DatePickerFieldsForm *) [segue destinationViewController];
        
        CGFloat sliderValue = (150.f - MIN_LABEL_WIDTH) / (MAX_LABEL_WIDTH - MIN_LABEL_WIDTH);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end