//
//  ExpandablePickerFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ExpandablePickerFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"
#define HEX_COLOR_RED               @"#790c06"

@interface ExpandablePickerFieldsForm () <AKFormCellLabelStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setLabelWidth:(CGFloat)labelWidth;
- (void)setLabelCellStyle:(AKFormCellLabelStyle)labelCellStyle;
@end

@implementation ExpandablePickerFieldsForm {
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
    [self addStandardPickers];
    [self addMultiComponentPickers];
}

- (void)addMultiComponentPickers
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormMetadataCollection *twoCollection = [AKFormMetadataCollection metadataCollectionWithArrays:[self gendersArray], [self occupationsArray], nil];
    twoCollection.descriptionSeparator = @" ";
    AKFormFieldExpandablePicker *twoField = [AKFormFieldExpandablePicker fieldWithKey:@"two"
                                                                                title:@"Two"
                                                                          placeholder:@"optional"
                                                                   metadataCollection:twoCollection
                                                                        styleProvider:self];
    [fields addObject:twoField];
    
    AKFormMetadataCollection *threeCollection = [AKFormMetadataCollection metadataCollectionWithArrays:[self gendersArray], [self gendersArray], [self gendersArray], nil];
    threeCollection.descriptionSeparator = @", ";
    AKFormFieldExpandablePicker *threeField = [AKFormFieldExpandablePicker fieldWithKey:@"three"
                                                                                  title:@"Three"
                                                                            placeholder:@"optional"
                                                                     metadataCollection:threeCollection
                                                                          styleProvider:self];
    [fields addObject:threeField];

    AKFormMetadataCollection *sixCollection = [AKFormMetadataCollection metadataCollectionWithArrays:[self hexArray], [self hexArray], [self hexArray], [self hexArray], [self hexArray], [self hexArray], nil];
    sixCollection.descriptionSeparator = @"";
    sixCollection.descriptionPrefix = @"#";
    AKFormFieldExpandablePicker *sixField = [AKFormFieldExpandablePicker fieldWithKey:@"six"
                                                                                title:@"Six"
                                                                          placeholder:@"optional"
                                                                   metadataCollection:sixCollection
                                                                        styleProvider:self];
    [fields addObject:sixField];
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"MULTI-COMPONENT PICKERS";
    [self addSection:section];
}

- (void)addStandardPickers
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormMetadataCollection *occupationsCollection = [AKFormMetadataCollection metadataCollectionWithArray:[self occupationsArray]];
    AKFormFieldExpandablePicker *occupationsField = [AKFormFieldExpandablePicker fieldWithKey:@"occupation"
                                                                                        title:@"Occupation"
                                                                                  placeholder:@"optional"
                                                                           metadataCollection:occupationsCollection
                                                                                styleProvider:self];
    [fields addObject:occupationsField];
    
    AKFormMetadataCollection *gendersCollection = [AKFormMetadataCollection metadataCollectionWithArray:[self gendersArray]];
    AKFormFieldExpandablePicker *gendersField = [AKFormFieldExpandablePicker fieldWithKey:@"gender"
                                                                                    title:@"Gender"
                                                                              placeholder:@"optional"
                                                                       metadataCollection:gendersCollection
                                                                            styleProvider:self];
    [fields addObject:gendersField];
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"STANDARD PICKERS";
    [self addSection:section];
}

- (NSArray *)occupationsArray
{
    return @[@{KEY_METADATA_ID: @"1",
               KEY_METADATA_NAME: @"Anaesthetist"},
             @{KEY_METADATA_ID: @"2",
               KEY_METADATA_NAME: @"Biochemist"},
             @{KEY_METADATA_ID: @"3",
               KEY_METADATA_NAME: @"Chemist"},
             @{KEY_METADATA_ID: @"4",
               KEY_METADATA_NAME: @"Doctor"},
             @{KEY_METADATA_ID: @"5",
               KEY_METADATA_NAME: @"Golfer"},
             @{KEY_METADATA_ID: @"6",
               KEY_METADATA_NAME: @"Gunsmith"},
             @{KEY_METADATA_ID: @"7",
               KEY_METADATA_NAME: @"Historian"},
             @{KEY_METADATA_ID: @"8",
               KEY_METADATA_NAME: @"Illustrator"},
             @{KEY_METADATA_ID: @"9",
               KEY_METADATA_NAME: @"Librarian"},
             @{KEY_METADATA_ID: @"10",
               KEY_METADATA_NAME: @"Midwife"},
             @{KEY_METADATA_ID: @"11",
               KEY_METADATA_NAME: @"Osteopath"},
             @{KEY_METADATA_ID: @"12",
               KEY_METADATA_NAME: @"Physicist"}];
}

- (NSArray *)gendersArray
{
    return @[@{KEY_METADATA_ID: @"M",
               KEY_METADATA_NAME: @"Male"},
             @{KEY_METADATA_ID: @"F",
               KEY_METADATA_NAME: @"Female"},
             @{KEY_METADATA_ID: @"X",
               KEY_METADATA_NAME: @"Other"}];
}

- (NSArray *)hexArray
{
    return @[@{KEY_METADATA_ID: @"1",
               KEY_METADATA_NAME: @"1"},
             @{KEY_METADATA_ID: @"2",
               KEY_METADATA_NAME: @"2"},
             @{KEY_METADATA_ID: @"3",
               KEY_METADATA_NAME: @"3"},
             @{KEY_METADATA_ID: @"4",
               KEY_METADATA_NAME: @"4"},
             @{KEY_METADATA_ID: @"5",
               KEY_METADATA_NAME: @"5"},
             @{KEY_METADATA_ID: @"6",
               KEY_METADATA_NAME: @"6"},
             @{KEY_METADATA_ID: @"7",
               KEY_METADATA_NAME: @"7"},
             @{KEY_METADATA_ID: @"8",
               KEY_METADATA_NAME: @"8"},
             @{KEY_METADATA_ID: @"9",
               KEY_METADATA_NAME: @"9"},
             @{KEY_METADATA_ID: @"A",
               KEY_METADATA_NAME: @"A"},
             @{KEY_METADATA_ID: @"B",
               KEY_METADATA_NAME: @"B"},
             @{KEY_METADATA_ID: @"C",
               KEY_METADATA_NAME: @"C"},
             @{KEY_METADATA_ID: @"D",
               KEY_METADATA_NAME: @"D"},
             @{KEY_METADATA_ID: @"E",
               KEY_METADATA_NAME: @"E"},
             @{KEY_METADATA_ID: @"F",
               KEY_METADATA_NAME: @"F"}
             ];
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
        case AKFormCellTextFieldModeEmpty:
        case AKFormCellTextFieldModeFilled:
        case AKFormCellTextFieldModeReadOnly:
            return [UIFont systemFontOfSize:17.f];
            break;
        case AKFormCellTextFieldModeEditing:
        case AKFormCellTextFieldModeInvalid:
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
    if (mode == AKFormCellTextFieldModeInvalid) {
        return [UIColor colorWithHexString:HEX_COLOR_RED];
    } else {
        return [UIColor darkGrayColor];
    }
}

- (UIColor *)valueLabelTextColorForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style
{
    switch (mode) {
        case AKFormCellTextFieldModeEmpty:
            return [UIColor lightGrayColor];
            break;
        case AKFormCellTextFieldModeFilled:
        case AKFormCellTextFieldModeReadOnly:
            return [UIColor grayColor];
            break;
        case AKFormCellTextFieldModeEditing:
            return [UIColor colorWithHexString:@"#E67D2C"];
        case AKFormCellTextFieldModeInvalid:
            return [UIColor colorWithHexString:HEX_COLOR_RED];
            break;
    }
}

@end


#define MIN_LABEL_WIDTH 30.f
#define MAX_LABEL_WIDTH 300.f

@interface ExpandablePickerFieldsFormContainer ()
@property(nonatomic, strong) IBOutlet ExpandablePickerFieldsForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation ExpandablePickerFieldsFormContainer

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
        self.form = (ExpandablePickerFieldsForm *) [segue destinationViewController];
        
        CGFloat sliderValue = (150.f - MIN_LABEL_WIDTH) / (MAX_LABEL_WIDTH - MIN_LABEL_WIDTH);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end