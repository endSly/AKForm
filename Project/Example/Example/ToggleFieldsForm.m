//
//  ToggleFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ToggleFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"
#define HEX_COLOR_RED               @"#790c06"

@interface ToggleFieldsForm () <AKFormCellSwitchStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setLabelWidth:(CGFloat)labelWidth;
- (void)setSwitchCellStyle:(AKFormCellSwitchStyle)switchCellStyle;
@end

@implementation ToggleFieldsForm {
    CGFloat _labelWidth;
    AKFormCellSwitchStyle _switchCellStyle;
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
    
    AKFormFieldSwitch *switchField = [AKFormFieldSwitch fieldWithKey:@"switch" title:@"Switch" delegate:self styleProvider:self];
    [fields addObject:switchField];

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"SWITCHES";
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

- (void)setSwitchCellStyle:(AKFormCellSwitchStyle)switchCellStyle
{
    _switchCellStyle = switchCellStyle;
    [self.tableView reloadData];
}

- (CGFloat)labelWidthForSwitchCell
{
    return _labelWidth;
}

- (AKFormCellSwitchStyle)styleForSwitchCell
{
    return _switchCellStyle;
}

- (UIFont *)labelFontForMode:(AKFormCellSwitchMode)mode style:(AKFormCellSwitchStyle)style
{
    switch (mode) {
        case AKFormCellSwitchModeEditable:
        case AKFormCellSwitchModeReadOnly:
            return [UIFont systemFontOfSize:17.f];
            break;
    }
}

- (UIColor *)labelTextColorForMode:(AKFormCellSwitchMode)mode style:(AKFormCellSwitchStyle)style
{
    if (mode == AKFormCellSwitchModeReadOnly) {
        return [UIColor lightGrayColor];
    } else {
        return [UIColor darkGrayColor];
    }
}

- (UIColor *)switchTintColor
{
    return [UIColor orangeColor];
}

@end


#define MIN_LABEL_WIDTH 30.f
#define MAX_LABEL_WIDTH 300.f

@interface ToggleFieldsFormContainer ()
@property(nonatomic, strong) IBOutlet ToggleFieldsForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation ToggleFieldsFormContainer {
    NSInteger _selectedSegment;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedSegment = 2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //for some reason, not doing this (selecting each segment in turn before selecting the first one again),
    //will result in the tint color for the segments being blue (perhaps it's the window tint?)
    for (int i=0; i<4; i++) {
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
            [self.form setSwitchCellStyle:AKFormCellSwitchStyleLabelWithStaticWidth1];
            self.slider.enabled = YES;
            break;
        case 1:
            [self.form setSwitchCellStyle:AKFormCellSwitchStyleLabelWithStaticWidth2];
            self.slider.enabled = YES;
            break;
        case 2:
            [self.form setSwitchCellStyle:AKFormCellSwitchStyleLabelWithStaticWidth3];
            self.slider.enabled = YES;
            break;
        case 3:
            [self.form setSwitchCellStyle:AKFormCellSwitchStyleLabelWithDynamicWidth];
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
        self.form = (ToggleFieldsForm *) [segue destinationViewController];
        
        CGFloat sliderValue = (150.f - MIN_LABEL_WIDTH) / (MAX_LABEL_WIDTH - MIN_LABEL_WIDTH);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end