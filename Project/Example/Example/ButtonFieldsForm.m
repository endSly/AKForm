//
//  ButtonFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ButtonFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"
#define HEX_COLOR_RED               @"#790c06"

@interface ButtonFieldsForm () <AKFormCellButtonStyleProvider, AKFormCellButtonDelegate>
- (IBAction)completeForm:(id)sender;
@end

@implementation ButtonFieldsForm {
    AKFormCellButtonStyle _buttonStyle;
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
    [self addSection];
}

- (void)addSection
{
    NSMutableArray *fields = [NSMutableArray array];

    //Number Field
    AKFormFieldButton *buttonField = [AKFormFieldButton fieldWithKey:@"button"
                                                               title:@"Mates"
                                                            subtitle:@"23 mates in common"
                                                               image:[UIImage imageNamed:@"Placeholder1"]
                                                            delegate:self
                                                       styleProvider:self];
    buttonField.selectionStyle = UITableViewCellSelectionStyleGray;
    buttonField.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [fields addObject:buttonField];

    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"BUTTONS";
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

#pragma mark - Button Cell - Delegate

- (void)didPressButtonCell:(AKFormCellButton *)cell
{
    [[[UIAlertView alloc] initWithTitle:@"Yo" message:@"You PRESSED me? :@" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil] show];
}

#pragma mark -
#pragma mark Button Cell — Style Provider

- (void)setButtonStyle:(AKFormCellButtonStyle)buttonStyle
{
    _buttonStyle = buttonStyle;
    [self.tableView reloadData];
}

- (AKFormCellButtonStyle)styleForButtonCell:(AKFormCellButton *)cell
{
    return _buttonStyle;
}

- (UIFont *)labelFontForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell
{
    switch (mode) {
        case AKFormCellButtonModeDisabled:
        case AKFormCellButtonModeEnabled:
            return [UIFont systemFontOfSize:15.f];
    }
}

//- (UIColor *)labelTextColorForMode:(AKFormCellTextFieldMode)mode style:(AKFormCellTextFieldStyle)style
- (UIColor *)labelTextColorForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell
{
    if (mode == AKFormCellButtonModeEnabled) {
        return [UIColor darkGrayColor];
    } else {
        return [UIColor lightGrayColor];
    }
}

- (UIFont *)detailLabelFontForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell
{
    return [UIFont systemFontOfSize:13.f];
}

- (UIColor *)detailLabelTextColorForMode:(AKFormCellButtonMode)mode style:(AKFormCellButtonStyle)style forButtonCell:(AKFormCellButton *)cell
{
    switch (mode) {
        case AKFormCellButtonModeDisabled:
        case AKFormCellButtonModeEnabled:
            return [UIColor grayColor];
    }
}


@end


@interface ButtonFieldsFormContainer ()
@property(nonatomic, strong) IBOutlet ButtonFieldsForm *form;
- (IBAction)pressedValidate:(id)sender;
@end

@implementation ButtonFieldsFormContainer

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.segmentedControl setSelectedSegmentIndex:2];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self segmentedControlDidChangeSelectedSegmentIndex:self.segmentedControl];
}

- (IBAction)segmentedControlDidChangeSelectedSegmentIndex:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.form setButtonStyle:AKFormCellButtonStyleLabelLeft];
            break;
        case 1:
            [self.form setButtonStyle:AKFormCellButtonStyleLabelCentered];
            break;
        case 2:
            [self.form setButtonStyle:AKFormCellButtonStyleLabelRight];
            break;
    }
}

- (IBAction)pressedValidate:(id)sender
{
    [self.form completeForm:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"form_embed"]) {
        self.form = (ButtonFieldsForm *) [segue destinationViewController];
    }
}
@end