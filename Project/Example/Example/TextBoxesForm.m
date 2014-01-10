//
//  TextBoxesForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "TextBoxesForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"
#define HEX_COLOR_RED               @"#790c06"

@interface TextBoxesForm () <AKFormCellTextBoxStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setLabelWidth:(CGFloat)labelWidth;
- (void)setTextBoxLabelStyle:(AKFormCellTextBoxLabelStyle)textBoxLabelStyle;
- (void)setTextBoxHeightStyle:(AKFormCellTextBoxHeightStyle)textBoxHeightStyle;
@end

@implementation TextBoxesForm {
    CGFloat _labelWidth;
    AKFormCellTextBoxHeightStyle _textBoxHeightStyle;
    AKFormCellTextBoxLabelStyle _textBoxLabelStyle;
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
    [self addInputStylesSection];
}

- (void)addInputStylesSection
{
    NSMutableArray *fields = [NSMutableArray array];

    AKFormFieldTextBox *textBox = [AKFormFieldTextBox fieldWithKey:@"textbox"
                                                             title:@"Text Box"
                                                       placeholder:@"optional"
                                                          delegate:self
                                                     styleProvider:self];
    [fields addObject:textBox];

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"TEXT BOXES";
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

- (void)setTextBoxHeightStyle:(AKFormCellTextBoxHeightStyle)textBoxHeightStyle
{
    _textBoxHeightStyle = textBoxHeightStyle;
    [self.tableView reloadData];
}

- (void)setTextBoxLabelStyle:(AKFormCellTextBoxLabelStyle)textBoxLabelStyle
{
    _textBoxLabelStyle = textBoxLabelStyle;
    [self.tableView reloadData];
}

- (CGFloat)labelWidthForTextFieldCell
{
    return _labelWidth;
}

- (AKFormCellTextBoxLabelStyle)labelStyleForTextBoxCell
{
    return _textBoxLabelStyle;
}

- (AKFormCellTextBoxHeightStyle)heightStyleForTextBoxCell
{
    return _textBoxHeightStyle;
}

- (UIFont *)labelFontForTextBoxMode:(AKFormCellTextBoxMode)mode
{
    switch (mode) {
        case AKFormCellTextBoxModeEmpty:
        case AKFormCellTextBoxModeFilled:
        case AKFormCellTextBoxModeReadOnly:
            return [UIFont systemFontOfSize:17.f];
            break;
        case AKFormCellTextBoxModeEditing:
        case AKFormCellTextBoxModeInvalid:
            return [UIFont boldSystemFontOfSize:17.f];
            break;
    }
}

- (UIColor *)labelTextColorForMode:(AKFormCellImageMode)mode
{
    if (mode == AKFormCellTextBoxModeInvalid) {
        return [UIColor colorWithHexString:HEX_COLOR_RED];
    } else {
        return [UIColor darkGrayColor];
    }
}

- (UIFont *)textBoxFontForTextBoxMode:(AKFormCellTextBoxMode)mode
{
    return [UIFont systemFontOfSize:17.f];
}

- (UIColor *)textBoxTextColorForTextBoxMode:(AKFormCellTextBoxMode)mode
{
    switch (mode) {
        case AKFormCellTextBoxModeEmpty:
            return [UIColor lightGrayColor];
        case AKFormCellTextBoxModeFilled:
        case AKFormCellTextBoxModeReadOnly:
            return [UIColor grayColor];
            break;
        case AKFormCellTextBoxModeEditing:
            return [UIColor colorWithHexString:@"#E67D2C"];
        case AKFormCellTextBoxModeInvalid:
            return [UIColor colorWithHexString:HEX_COLOR_RED];
            break;
    }
}

- (CGFloat)heightForTextBoxCell
{
    switch (_textBoxHeightStyle) {
        case AKFormCellTextBoxHeightStyleAutomatic:
            return 44.f;
            break;
        case AKFormCellTextBoxHeightStyleManual:
            return 100.f;
            break;
    }
}

@end



#define MIN_LABEL_WIDTH 30.f
#define MAX_LABEL_WIDTH 300.f

@interface TextBoxesFormContainer ()
@property(nonatomic, strong) IBOutlet TextBoxesForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation TextBoxesFormContainer

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.segmentedControl setSelectedSegmentIndex:2];
    [self.segmentedControl setSelectedSegmentIndex:3];
    [self.segmentedControl setSelectedSegmentIndex:4];
    [self.segmentedControl setSelectedSegmentIndex:5];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self segmentedControlDidChangeSelectedSegmentIndex:self.segmentedControl];
}

- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.slider.enabled = YES;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.form setTextBoxLabelStyle:AKFormCellTextBoxLabelStyleOnLeftLeftAligned];
            [self.form setTextBoxHeightStyle:AKFormCellTextBoxHeightStyleAutomatic];
            break;
        case 1:
            [self.form setTextBoxLabelStyle:AKFormCellTextBoxLabelStyleOnLeftRightAligned];
            [self.form setTextBoxHeightStyle:AKFormCellTextBoxHeightStyleAutomatic];
            break;
        case 2:
            [self.form setTextBoxLabelStyle:AKFormCellTextBoxLabelStyleOnTop];
            [self.form setTextBoxHeightStyle:AKFormCellTextBoxHeightStyleAutomatic];
            break;
        case 3:
            [self.form setTextBoxLabelStyle:AKFormCellTextBoxLabelStyleOnLeftLeftAligned];
            [self.form setTextBoxHeightStyle:AKFormCellTextBoxHeightStyleManual];
            break;
        case 4:
            [self.form setTextBoxLabelStyle:AKFormCellTextBoxLabelStyleOnLeftRightAligned];
            [self.form setTextBoxHeightStyle:AKFormCellTextBoxHeightStyleManual];
            break;
        case 5:
            [self.form setTextBoxLabelStyle:AKFormCellTextBoxLabelStyleOnTop];
            [self.form setTextBoxHeightStyle:AKFormCellTextBoxHeightStyleManual];
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
        self.form = (TextBoxesForm *) [segue destinationViewController];
        
        CGFloat sliderValue = (135.f - MIN_LABEL_WIDTH) / (MAX_LABEL_WIDTH - MIN_LABEL_WIDTH);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end