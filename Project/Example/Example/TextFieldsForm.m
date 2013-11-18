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
    [self addLabelStringLengthsSection];
    [self addValidatorsSection];
    [self addInputStylesSection];
}

- (void)addLabelStringLengthsSection
{
    NSMutableArray *fields = [NSMutableArray array];
    
    NSArray *labels = @[@"Label", @"Another label", @"A longer label", @"An even longer label", @"This label is far too long", @"This label is even longer than the far longer one" ];
    for (NSString *label in labels) {
        AKFormFieldText *field = [AKFormFieldText fieldWithKey:label
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
    AKFormFieldText *numberField = [AKFormFieldText fieldWithKey:@"number"
                                                           title:@"Number"
                                                     placeholder:@"optional"
                                                        delegate:self
                                                   styleProvider:self];
    numberField.keyboardType = UIKeyboardTypeDecimalPad;
    [fields addObject:numberField];

    //Secure Field
    AKFormFieldText *secureField = [AKFormFieldText fieldWithKey:@"secure"
                                                           title:@"Secure"
                                                     placeholder:@"optional"
                                                        delegate:self
                                                   styleProvider:self];
    secureField.secureTextEntry = YES;
    [fields addObject:secureField];

    //The Works Field
    AKFormFieldText *theWorksField = [AKFormFieldText fieldWithKey:@"the_works"
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
    AKFormFieldText *requiredField = [AKFormFieldText fieldWithKey:@"label"
                                                             title:@"Label"
                                                       placeholder:@"required"
                                                          delegate:self
                                                     styleProvider:self];
    AKFormValidator *requiredValidator = [AKFormValidator requiredValidator:@"Please enter a value"];
    requiredField.validators = @[requiredValidator];
    [fields addObject:requiredField];
    
    //Email Field
    AKFormFieldText *emailField = [AKFormFieldText fieldWithKey:@"email"
                                                          title:@"Email"
                                                    placeholder:@"required email"
                                                       delegate:self
                                                  styleProvider:self];
    AKFormValidator *emailValidator = [AKFormValidator emailValidator:@"Please enter a valid email"];
    emailField.validators = @[emailValidator];
    [fields addObject:emailField];

    //Password Field
    AKFormFieldText *passwordField = [AKFormFieldText fieldWithKey:@"password"
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
    AKFormFieldText *passwordConfirmField = [AKFormFieldText fieldWithKey:@"confirm password" title:@"Confirm"
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
            return [UIColor lightGrayColor];
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