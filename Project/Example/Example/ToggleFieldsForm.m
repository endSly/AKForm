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

@interface ToggleFieldsForm () <AKFormCellSwitchStyleProvider, AKFormCellTextFieldStyleProvider, AKFormCellLabelStyleProvider>
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
    [self addTogglesWithinOn];
    [self addTogglesWithinOff];
    [self addTogglesWithinOnOff];
    [self addTogglesNewOn];
    [self addTogglesNewOff];
    [self addTogglesNewOnOff];
    [self addTogglesWithinOn];
    [self addTogglesWithinOff];
    [self addTogglesWithinOnOff];
    [self addTogglesNewOn];
    [self addTogglesNewOff];
    [self addTogglesNewOnOff];
}

- (NSArray *)fields
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
    
    return [NSArray arrayWithArray:fields];
}

- (NSArray *)fields2
{
    NSMutableArray *fields = [NSMutableArray array];
    
    //Number Field
    AKFormFieldTextField *numberField = [AKFormFieldTextField fieldWithKey:@"twitter"
                                                           title:@"Twitter"
                                                     placeholder:@"optional"
                                                        delegate:self
                                                   styleProvider:self];
    numberField.keyboardType = UIKeyboardTypeTwitter;
    [fields addObject:numberField];

    //Image Field
    AKFormFieldImage *imageField = [AKFormFieldImage fieldWithKey:@"image_1"
                                                            title:@"Image"
                                                  placeholderText:@"Choose Image"
                                             placeholderImageName:@"Placeholder1"
                                                        imageSize:CGSizeMake(320, 320)
                                                   thumbnailStyle:AKFormCellImageThumbnailStyleCircle
                                                   formController:self];
    [fields addObject:imageField];

    //Date Field
    AKFormFieldDate *dateField = [AKFormFieldDate fieldWithKey:@"date"
                                                        title:@"Date of Birth"
                                                placeholder:@"optional"
                                                datePickerMode:UIDatePickerModeDate
                                                displayType:AKFormFieldDateDisplayCustom
                                                displayFormat:@"EEE, MMM d, yyyy"
                                                styleProvider:self];
    [fields addObject:dateField];
    
    return [NSArray arrayWithArray:fields];
}

- (void)addTogglesWithinOn
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormFieldSwitch *switchField = [AKFormFieldSwitch fieldWithKey:@"switch1" title:@"Only on ON" delegate:self styleProvider:self];
    [fields addObject:switchField];
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"WITHIN SECTION";

    NSMapTable *fieldsToShowOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToShowOnOn setObject:[self fields]
                         forKey:section];
    switchField.fieldsToShowOnOn = fieldsToShowOnOn;    
    [self addSection:section];
}

- (void)addTogglesWithinOff
{
    NSMutableArray *fields = [NSMutableArray array];
    
    AKFormFieldSwitch *switchField = [AKFormFieldSwitch fieldWithKey:@"switch2" title:@"Only on OFF" delegate:self styleProvider:self];
    [fields addObject:switchField];
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    
    NSMapTable *fieldsToHideOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToHideOnOn setObject:[self fields]
                         forKey:section];
    switchField.fieldsToHideOnOn = fieldsToHideOnOn;

    [self addSection:section];
}

- (void)addTogglesWithinOnOff
{
    NSMutableArray *fields = [NSMutableArray array];
    
    /** SWITCH **/
    AKFormFieldSwitch *switchField = [AKFormFieldSwitch fieldWithKey:@"switch3" title:@"ON & OFF" delegate:self styleProvider:self];
    [fields addObject:switchField];
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    
    NSMapTable *fieldsToShowOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToShowOnOn setObject:[self fields2]
                         forKey:section];
    switchField.fieldsToShowOnOn = fieldsToShowOnOn;

    NSMapTable *fieldsToHideOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToHideOnOn setObject:[self fields]
                         forKey:section];
    switchField.fieldsToHideOnOn = fieldsToHideOnOn;
    [self addSection:section];    
}

- (void)addTogglesNewOn
{
    NSMutableArray *fields = [NSMutableArray array];
    
    /** SWITCH **/
    AKFormFieldSwitch *switchField = [AKFormFieldSwitch fieldWithKey:@"switch4" title:@"Only on ON" delegate:self styleProvider:self];
    
    // toggled section
    AKFormSection *toggledSection = [[AKFormSection alloc] initWithFields:nil];
    toggledSection.key = @"section";
    
    NSMapTable *fieldsToShowOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToShowOnOn setObject:[self fields]
                         forKey:toggledSection];
    switchField.fieldsToShowOnOn = fieldsToShowOnOn;
    [fields addObject:switchField];
    /**/
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = @"IN A NEW SECTION";
    [self addSection:section];
}

- (void)addTogglesNewOff
{
    NSMutableArray *fields = [NSMutableArray array];
    
    /** SWITCH **/
    AKFormFieldSwitch *switchField = [AKFormFieldSwitch fieldWithKey:@"switch5" title:@"Only on OFF" delegate:self styleProvider:self];
    
    // toggled section
    AKFormSection *toggledSection = [[AKFormSection alloc] initWithFields:nil];
    toggledSection.key = @"section";
    
    NSMapTable *fieldsToHideOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToHideOnOn setObject:[self fields]
                         forKey:toggledSection];
    switchField.fieldsToHideOnOn = fieldsToHideOnOn;
    [fields addObject:switchField];
    /**/
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    [self addSection:section];
}

- (void)addTogglesNewOnOff
{
    NSMutableArray *fields = [NSMutableArray array];
    
    /** SWITCH **/
    AKFormFieldSwitch *switchField = [AKFormFieldSwitch fieldWithKey:@"switch6" title:@"ON & OFF" delegate:self styleProvider:self];
    
    // toggled section
    AKFormSection *toggledSection = [[AKFormSection alloc] initWithFields:nil];
    toggledSection.key = @"section";
    
    NSMapTable *fieldsToShowOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToShowOnOn setObject:[self fields]
                         forKey:toggledSection];
    switchField.fieldsToShowOnOn = fieldsToShowOnOn;

    NSMapTable *fieldsToHideOnOn = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                         valueOptions:NSMapTableStrongMemory];
    [fieldsToHideOnOn setObject:[self fields2]
                         forKey:toggledSection];
    switchField.fieldsToHideOnOn = fieldsToHideOnOn;
    [fields addObject:switchField];
    /**/
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
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

- (UITableViewRowAnimation)rowAnimationDeleteForSwitchCell
{
    return UITableViewRowAnimationFade;
}

- (UITableViewRowAnimation)rowAnimationInsertForSwitchCell
{
    return UITableViewRowAnimationFade;
}

- (UITableViewRowAnimation)sectionAnimationDeleteForSwitchCell
{
    return UITableViewRowAnimationFade;
}

- (UITableViewRowAnimation)sectionAnimationInsertForSwitchCell
{
    return UITableViewRowAnimationFade;
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
        default:
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
        
        CGFloat sliderValue = (220.f - MIN_LABEL_WIDTH) / (MAX_LABEL_WIDTH - MIN_LABEL_WIDTH);
        [self.slider setValue:sliderValue];
        [self sliderValueDidChange:self.slider];
    }
}
@end