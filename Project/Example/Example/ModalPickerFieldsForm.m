//
//  ModalPickerFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ModalPickerFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"
#define HEX_COLOR_RED               @"#790c06"

@interface ModalPickerFieldsForm () <AKFormCellLabelStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setLabelWidth:(CGFloat)labelWidth;
- (void)setLabelCellStyle:(AKFormCellLabelStyle)labelCellStyle;
@end

@implementation ModalPickerFieldsForm {
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
}

- (void)addStandardPickers
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormMetadataCollection *gendersCollection = [AKFormMetadataCollection metadataCollectionWithArray:[self gendersArray]];
    AKFormFieldModalPicker *gendersField = [AKFormFieldModalPicker fieldWithKey:@"single"
                                                                          title:@"Single"
                                                                    placeholder:@"optional"
                                                             metadataCollection:gendersCollection
                                                                  multiplePicks:NO
                                                                  styleProvider:self];
    [fields addObject:gendersField];

    AKFormMetadataCollection *occupationsCollection = [AKFormMetadataCollection metadataCollectionWithArray:[self occupationsArray]];
    occupationsCollection.descriptionSeparator = @", ";
    AKFormFieldModalPicker *occupationsField = [AKFormFieldModalPicker fieldWithKey:@"multiple"
                                                                              title:@"Multiple"
                                                                        placeholder:@"optional"
                                                                 metadataCollection:occupationsCollection
                                                                      multiplePicks:YES
                                                                      styleProvider:self];
    [fields addObject:occupationsField];
    

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

- (AKFormCellLabelStyle)styleForLabelCell:(AKFormCellLabel *)cell
{
    return _labelCellStyle;
}

- (UIFont *)titleLabelFontForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style forLabelCell:(AKFormCellLabel *)cell
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

- (UIFont *)valueLabelFontForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style forLabelCell:(AKFormCellLabel *)cell
{
    if (style == AKFormCellLabelStyleTwoLines) {
        return [UIFont systemFontOfSize:13.f];
    } else {
        return [UIFont systemFontOfSize:17.f];
    }
}

- (UIColor *)titleLabelTextColorForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style forLabelCell:(AKFormCellLabel *)cell
{
    if (mode == AKFormCellTextFieldModeInvalid) {
        return [UIColor colorWithHexString:HEX_COLOR_RED];
    } else {
        return [UIColor darkGrayColor];
    }
}

- (UIColor *)valueLabelTextColorForMode:(AKFormCellLabelMode)mode style:(AKFormCellLabelStyle)style forLabelCell:(AKFormCellLabel *)cell
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

@interface ModalPickerFieldsFormContainer ()
@property(nonatomic, strong) IBOutlet ModalPickerFieldsForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation ModalPickerFieldsFormContainer {
    NSInteger _selectedSegment;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedSegment = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //for some reason, not doing this (selecting each segment in turn before selecting the first one again),
    //will result in the tint color for the segments being blue (perhaps it's the window tint?)
    for (int i=0; i<6; i++) {
        [self.segmentedControl setSelectedSegmentIndex:i];
    }
    [self.segmentedControl setSelectedSegmentIndex:_selectedSegment];
    [self segmentedControlDidChangeSelectedSegmentIndex:self.segmentedControl];
}

- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.slider.enabled = YES;
    _selectedSegment = segmentedControl.selectedSegmentIndex;
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
        self.form = (ModalPickerFieldsForm *) [segue destinationViewController];
        
        CGFloat sliderValue = (150.f - MIN_LABEL_WIDTH) / (MAX_LABEL_WIDTH - MIN_LABEL_WIDTH);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end