//
//  TextFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "TextFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"
#define HEX_COLOR_RED               @"#790c06"

@interface TextFieldsForm () <CSFormCellTextFieldStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setLabelWidth:(CGFloat)labelWidth;
- (void)setTextFieldStyle:(CSFormCellTextFieldStyle)textFieldStyle;
@end

@implementation TextFieldsForm {
    CGFloat _labelWidth;
    CSFormCellTextFieldStyle _textFieldStyle;
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
    NSMutableArray *fields = [NSMutableArray array];
    
    NSArray *labels = @[@"label", @"another label", @"a longer label", @"an even longer label", @"this label is far too long", @"this label is even longer than far longer" ];
    for (NSString *label in labels) {
        AKFormFieldText *field = [[AKFormFieldText alloc] initWithKey:label
                                                                title:label
                                                          placeholder:label
                                                             delegate:self
                                                        styleProvider:self];
//        if (r==0) {
//            AKFormValidator *validator = [AKFormValidator requiredBlockWithFailMessage:@"Please enter your first name"];
//            field.validators = @[validator];
//        }
        [fields addObject:field];
    }
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"LABEL WIDTHS";
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

- (void)setTextFieldStyle:(CSFormCellTextFieldStyle)textFieldStyle
{
    _textFieldStyle = textFieldStyle;
    [self.tableView reloadData];
}

- (CGFloat)labelWidthForTextFieldCell:(AKFormCellTextField *)cell
{
    return _labelWidth;
}

- (CSFormCellTextFieldStyle)styleForTextFieldCell:(AKFormCellTextField *)cell
{
    return _textFieldStyle;
}

- (UIFont *)textFieldCell:(AKFormCellTextField *)cell labelFontForMode:(CSFormCellTextFieldMode)mode
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

- (UIColor *)textFieldCell:(AKFormCellTextField *)cell labelTextColorForMode:(CSFormCellTextFieldMode)mode
{
    if (mode == CSFormCellTextFieldModeInvalid) {
        return [UIColor colorWithHexString:HEX_COLOR_RED];
    } else {
        return [UIColor darkGrayColor];
    }
}

- (UIFont *)textFieldCell:(AKFormCellTextField *)cell textFieldFontForMode:(CSFormCellTextFieldMode)mode
{
    return [UIFont systemFontOfSize:17.f];
}

- (UIColor *)textFieldCell:(AKFormCellTextField *)cell textFieldTextColorForMode:(CSFormCellTextFieldMode)mode
{
    switch (mode) {
        case CSFormCellTextFieldModeEmpty:
        case CSFormCellTextFieldModeFilled:
        case CSFormCellTextFieldModeReadOnly:
            return [UIColor darkGrayColor];
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

@interface TextFieldsFormContainer ()
@property(nonatomic, strong) IBOutlet TextFieldsForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation TextFieldsFormContainer

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.segmentedControl setSelectedSegmentIndex:2];
    [self.segmentedControl setSelectedSegmentIndex:3];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self segmentedControlDidChangeSelectedSegmentIndex:self.segmentedControl];
}

- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.slider.enabled = YES;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.form setTextFieldStyle:CSFormCellTextFieldStyleLabelWithStaticWidth1];
            break;
        case 1:
            [self.form setTextFieldStyle:CSFormCellTextFieldStyleLabelWithStaticWidth2];
            break;
        case 2:
            [self.form setTextFieldStyle:CSFormCellTextFieldStyleLabelWithStaticWidth3];
            break;
        default:
            [self.form setTextFieldStyle:CSFormCellTextFieldStyleLabelWithDynamicWidth];
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
        self.form = (TextFieldsForm *) [segue destinationViewController];
        
        CGFloat sliderValue = (135.f - MIN_LABEL_WIDTH) / (MAX_LABEL_WIDTH - MIN_LABEL_WIDTH);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end