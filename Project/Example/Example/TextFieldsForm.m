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

@interface TextFieldsForm () <AKFormCellTextFieldStyleProvider>
- (IBAction)completeForm:(id)sender;
- (void)setLabelWidth:(CGFloat)labelWidth;
- (void)setTextFieldStyle:(AKFormCellTextFieldStyle)textFieldStyle;
@end

@implementation TextFieldsForm {
    CGFloat _labelWidth;
    AKFormCellTextFieldStyle _textFieldStyle;
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
    [self addValidatorsSection];
    [self addLabelStringLengthsSection];
}

- (void)addLabelStringLengthsSection
{
    NSMutableArray *fields = [NSMutableArray array];
    
    NSArray *labels = @[@"Label", @"Another label", @"A longer label", @"An even longer label", @"This label is far too long", @"This label is even longer than the far longer one" ];
    for (NSString *label in labels) {
        AKFormFieldTextField *field = [AKFormFieldTextField fieldWithKey:label
                                                         title:label
                                                   placeholder:@"optional"
                                                      delegate:self
                                                 styleProvider:self];
        [fields addObject:field];
    }
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"LABEL STRING LENGTHS";
    [self addSection:section];
}

- (void)addInputStylesSection
{
    NSMutableArray *fields = [NSMutableArray array];

    //Number Field
    AKFormFieldTextField *numberField = [AKFormFieldTextField fieldWithKey:@"number"
                                                           title:@"Number"
                                                     placeholder:@"optional"
                                                        delegate:self
                                                   styleProvider:self];
    numberField.keyboardType = UIKeyboardTypeDecimalPad;
    [fields addObject:numberField];

    //Secure Field
    AKFormFieldTextField *secureField = [AKFormFieldTextField fieldWithKey:@"secure"
                                                           title:@"Secure"
                                                     placeholder:@"optional"
                                                        delegate:self
                                                   styleProvider:self];
    secureField.secureTextEntry = YES;
    [fields addObject:secureField];

    //The Works Field
    AKFormFieldTextField *theWorksField = [AKFormFieldTextField fieldWithKey:@"the_works"
                                                             title:@"The Works"
                                                       placeholder:@"optional"
                                                          delegate:self
                                                     styleProvider:self];
    theWorksField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    theWorksField.autocorrectionType = UITextAutocorrectionTypeYes;
    theWorksField.clearButtonMode = UITextFieldViewModeWhileEditing;
    theWorksField.returnKeyType = UIReturnKeySend;
    [fields addObject:theWorksField];

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"INPUT STYLES";
    [self addSection:section];
}

- (void)addValidatorsSection
{
    NSMutableArray *fields = [NSMutableArray array];

    //Required Field
    AKFormFieldTextField *requiredField = [AKFormFieldTextField fieldWithKey:@"label"
                                                             title:@"Label"
                                                       placeholder:@"required"
                                                          delegate:self
                                                     styleProvider:self];
    AKFormValidator *requiredValidator = [AKFormValidator requiredValidator:@"Please enter a value"];
    requiredField.validators = @[requiredValidator];
    [fields addObject:requiredField];
    
    //Email Field
    AKFormFieldTextField *emailField = [AKFormFieldTextField fieldWithKey:@"email"
                                                          title:@"Email"
                                                    placeholder:@"required email"
                                                       delegate:self
                                                  styleProvider:self];
    AKFormValidator *emailValidator = [AKFormValidator emailValidator:@"Please enter a valid email"];
    emailField.validators = @[emailValidator];
    [fields addObject:emailField];

    //Password Field
    AKFormFieldTextField *passwordField = [AKFormFieldTextField fieldWithKey:@"password"
                                                             title:@"Password"
                                                       placeholder:@"password"
                                                          delegate:self
                                                     styleProvider:self];
    AKFormValidator *passwordValidator = [AKFormValidator passwordStrengthValidator:@"Please enter a password of at least 6 characters with at least 1 uppercase, lowercase, numerical and symbolic character"
                                                                      minimumLength:6
                                                                       alphanumeric:YES
                                                                         hasSymbols:YES
                                                                          bothCases:YES];
    passwordField.validators = @[passwordValidator];
    [fields addObject:passwordField];
    
    //Password Confirmation Field
    AKFormFieldTextField *passwordConfirmField = [AKFormFieldTextField fieldWithKey:@"confirm password" title:@"Confirm"
                                                              placeholder:@"confirm password"
                                                                 delegate:self
                                                            styleProvider:self];
    AKFormValidator *passwordConfirmValidator = [[AKFormValidator alloc] init];
    passwordConfirmValidator.failMessage = @"Please make sure the password confirmation matches";
    passwordConfirmValidator.failMessageTitle = @"Password Mismatch";
    
    passwordConfirmValidator.validationBlock = ^BOOL(AKFormValue *value) {
        if (value && [value isString]
            && passwordField.value
            && [passwordField.value isString]) {
            return [[value stringValue] isEqualToString:[passwordField.value stringValue]];
        }
        return NO;
    };
    passwordConfirmField.validators = @[passwordConfirmValidator];
    [fields addObject:passwordConfirmField];
    

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"VALIDATORS";
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

- (void)setTextFieldStyle:(AKFormCellTextFieldStyle)textFieldStyle
{
    _textFieldStyle = textFieldStyle;
    [self.tableView reloadData];
}

- (CGFloat)labelWidthForTextFieldCell
{
    return _labelWidth;
}

- (AKFormCellTextFieldStyle)styleForTextFieldCell
{
    return _textFieldStyle;
}

- (UIFont *)labelFontForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style
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

- (UIColor *)labelTextColorForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style
{
    if (mode == AKFormCellTextFieldModeInvalid) {
        return [UIColor colorWithHexString:HEX_COLOR_RED];
    } else {
        return [UIColor darkGrayColor];
    }
}

- (UIFont *)textFieldFontForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style
{
    return [UIFont systemFontOfSize:17.f];
}

- (UIColor *)textFieldTextColorForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style
{
    switch (mode) {
        case AKFormCellTextFieldModeEmpty:
            return [UIColor lightGrayColor];
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
            [self.form setTextFieldStyle:AKFormCellTextFieldStyleLabelWithStaticWidth1];
            break;
        case 1:
            [self.form setTextFieldStyle:AKFormCellTextFieldStyleLabelWithStaticWidth2];
            break;
        case 2:
            [self.form setTextFieldStyle:AKFormCellTextFieldStyleLabelWithStaticWidth3];
            break;
        default:
            [self.form setTextFieldStyle:AKFormCellTextFieldStyleLabelWithDynamicWidth];
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