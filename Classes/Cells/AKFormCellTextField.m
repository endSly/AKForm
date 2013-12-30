//
//  AKFormCellTextField.m
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCellTextField.h"

#define DEFAULT_STYLE                   AKFormCellTextFieldStyleLabelWithStaticWidth1

@interface AKFormCellTextField()
@property(nonatomic, assign) AKFormCellTextFieldStyle style;
@property(nonatomic, assign) AKFormCellTextFieldMode mode;
@property(nonatomic, weak) id<AKFormCellTextFieldStyleProvider> styleProvider;
- (void)tappedCell:(id)sender;
@end

@implementation AKFormCellTextField

///---------------------------------------------------------------------------------------
#pragma mark - Creating a Text Field Cell
///---------------------------------------------------------------------------------------

- (instancetype)initWithStyleProvider:(id<AKFormCellTextFieldStyleProvider>)styleProvider
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_TEXTFIELD];
    if (self) {

        self.styleProvider = styleProvider;
        [self styleTextField];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.label = [[UILabel alloc] init];
        [self styleLabel];
        [self.contentView addSubview:self.label];

        self.textField = [[UITextField alloc] init];
        self.textField.delegate = self;
        [self styleTextField];
        [self.contentView addSubview:self.textField];
        
        [self styleTextAlignments];
        [self setupInitialStyle];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCell:)];
        [self.contentView addGestureRecognizer:tgr];
    }
    return self;
}

///---------------------------------------------------------------------------------------
#pragma mark - Invalidating a Text Field Cell
///---------------------------------------------------------------------------------------

- (void)invalidate
{
    [super invalidate];
    [self setMode:AKFormCellTextFieldModeInvalid];
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Overrides
///---------------------------------------------------------------------------------------

//Since these cells are reused, we must only do the essential here,
// ie. what may actually be changed after a text view cell is created
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self styleTextAlignments];
    [self styleLabel];
    [self styleTextField];
    [self styleFrames];
}

/**
 *  This is an override to the default setter, which also re-styles the label and 
 *  text field in case the mode had changed.
 *
 *  @param mode The mode in which this cell is in now.
 */
- (void)setMode:(AKFormCellTextFieldMode)mode
{
    _mode = mode;
    [self styleLabel];
    [self styleTextField];
    [self layoutSubviews];
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Actions
///---------------------------------------------------------------------------------------

- (void)tappedCell:(id)sender
{
    [self.textField becomeFirstResponder];
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Initial Style Helpers
///---------------------------------------------------------------------------------------

/**
 *  This method sets up the initial style-specific properties of this cell and its
 *  subviews. These do not have to be modified again once the mode of the cell has changed
 *  or the user performs any input on it.
 */
- (void)setupInitialStyle
{
    [self updateMode];
    [self styleFrames];
}

- (void)styleTextAlignments
{
    switch (self.style) {
        case AKFormCellTextFieldStyleLabelWithDynamicWidth:
            self.label.textAlignment = NSTextAlignmentLeft;
            self.textField.textAlignment = NSTextAlignmentRight;
            break;
        case AKFormCellTextFieldStyleLabelWithStaticWidth1:
            self.label.textAlignment = NSTextAlignmentLeft;
            self.textField.textAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellTextFieldStyleLabelWithStaticWidth2:
            self.label.textAlignment = NSTextAlignmentRight;
            self.textField.textAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellTextFieldStyleLabelWithStaticWidth3:
            self.label.textAlignment = NSTextAlignmentLeft;
            self.textField.textAlignment = NSTextAlignmentRight;
            break;
        case AKFormCellTextFieldStyleNoLabel:
            self.textField.textAlignment = NSTextAlignmentLeft;
            break;
        default:
            break;
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Repeated Style Helpers
///---------------------------------------------------------------------------------------

- (void)styleFrames
{
    CGFloat labelWidth;
    CGRect contentFrame = [self contentFrame];
    switch (self.style) {
        case AKFormCellTextFieldStyleLabelWithStaticWidth1:
        case AKFormCellTextFieldStyleLabelWithStaticWidth2:
        case AKFormCellTextFieldStyleLabelWithStaticWidth3:
            if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelWidthForTextFieldCell)]) {
                labelWidth = [self.styleProvider labelWidthForTextFieldCell];
            } else {
                labelWidth = DEFAULT_TITLE_WIDTH;
            }
            labelWidth = MAX(MINIMUM_TITLE_WIDTH, labelWidth);
            CGFloat maxLabelWidth = contentFrame.size.width - PADDING_HORIZONTAL - MINIMUM_VALUE_WIDTH;
            labelWidth = MIN(labelWidth, maxLabelWidth);
            self.label.frame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y, labelWidth, contentFrame.size.height);
            break;
        case AKFormCellTextFieldStyleLabelWithDynamicWidth:
            [self.label sizeToFit];
            CGFloat maximumLabelWidth = contentFrame.size.width - (MINIMUM_VALUE_WIDTH + PADDING_HORIZONTAL);
            self.label.frame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y,
                                          MIN(self.label.frame.size.width, maximumLabelWidth),
                                          MAX(self.label.frame.size.height, contentFrame.size.height));
            
            break;
        case AKFormCellTextFieldStyleNoLabel:
            self.label.frame = CGRectZero;
            break;
    }
    CGFloat textFieldX = self.label.frame.size.width;
    if (self.style != AKFormCellTextFieldStyleNoLabel) {
        textFieldX += PADDING_HORIZONTAL;
    }
    CGFloat textFieldWidth = MAX(MINIMUM_VALUE_WIDTH, contentFrame.size.width - textFieldX);
    self.textField.frame = CGRectMake(contentFrame.origin.x + textFieldX, contentFrame.origin.y,
                                      textFieldWidth, contentFrame.size.height);
}

/**
 *  Styles the label by asking the delegate for the font and textColor, or resorting to
 *  using defaults.
 */
- (void)styleLabel
{
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelFontForMode:style:)]) {
        self.label.font = [self.styleProvider labelFontForMode:self.mode style:self.style];
    } else {
        switch (self.mode) {
            case AKFormCellTextFieldModeEditing:
            case AKFormCellTextFieldModeEmpty:
            case AKFormCellTextFieldModeFilled:
            case AKFormCellTextFieldModeReadOnly:
            case AKFormCellTextFieldModeInvalid:
                self.label.font = DEFAULT_FONT_TITLE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelTextColorForMode:style:)]) {
        self.label.textColor = [self.styleProvider labelTextColorForMode:self.mode style:self.style];
    } else {
        switch (self.mode) {
            case AKFormCellTextFieldModeEditing:
            case AKFormCellTextFieldModeEmpty:
            case AKFormCellTextFieldModeFilled:
            case AKFormCellTextFieldModeReadOnly:
            case AKFormCellTextFieldModeInvalid:
                self.label.textColor = DEFAULT_TEXTCOLOR_TITLE;
                break;
        }
    }
}

/**
 *  Styles the text field by asking the delegate for the font and textColor, or 
 *  resorting to using defaults.
 */
- (void)styleTextField
{
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(styleForTextFieldCell)]) {
        self.style = [self.styleProvider styleForTextFieldCell];
    } else {
        self.style = DEFAULT_STYLE;
    }

    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(textFieldFontForMode:style:)]) {
        self.textField.font = [self.styleProvider textFieldFontForMode:self.mode style:self.style];
    } else {
        switch (self.mode) {
            case AKFormCellTextFieldModeEditing:
            case AKFormCellTextFieldModeEmpty:
            case AKFormCellTextFieldModeFilled:
            case AKFormCellTextFieldModeReadOnly:
            case AKFormCellTextFieldModeInvalid:
                self.label.font = DEFAULT_FONT_VALUE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(textFieldTextColorForMode:style:)]) {
        self.textField.textColor = [self.styleProvider textFieldTextColorForMode:self.mode style:self.style];
    } else {
        switch (self.mode) {
            case AKFormCellTextFieldModeEditing:
            case AKFormCellTextFieldModeEmpty:
            case AKFormCellTextFieldModeFilled:
            case AKFormCellTextFieldModeReadOnly:
            case AKFormCellTextFieldModeInvalid:
                self.textField.textColor = DEFAULT_TEXTCOLOR_VALUE;
                break;
        }
    }
}

- (void)updateMode
{
    if ([self.textField isFirstResponder]) {
        [self setMode:AKFormCellTextFieldModeEditing];
    } else if (self.textField.text.length > 0) {
        [self setMode:AKFormCellTextFieldModeFilled];
    } else {
        [self setMode:AKFormCellTextFieldModeEmpty];
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Text Field Delegate
///---------------------------------------------------------------------------------------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self updateMode];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginEditingOnTextFieldCell:)]) {
        [self.delegate didBeginEditingOnTextFieldCell:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateMode];
    
    if (self.valueDelegate && [self.valueDelegate respondsToSelector:@selector(didInputValue:)]) {
        AKFormValue *value = [AKFormValue value:textField.text withType:AKFormValueString];
        [self.valueDelegate didInputValue:value];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldReturnOnTextFieldCell:)]) {
        return [self.delegate shouldReturnOnTextFieldCell:self];
    } else {
        return YES;
    }
}

@end
