//
//  AKFormCellTextBox.m
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCellTextBox.h"

#define DEFAULT_LABEL_STYLE     AKFormCellTextBoxLabelStyleOnLeftLeftAligned
#define DEFAULT_HEIGHT_STYLE    AKFormCellTextBoxHeightStyleAutomatic

@interface AKFormCellTextBox()
@property(nonatomic, assign) AKFormCellTextBoxLabelStyle labelStyle;
@property(nonatomic, assign) AKFormCellTextBoxHeightStyle heightStyle;
@property(nonatomic, assign) AKFormCellTextBoxMode mode;
- (void)tappedCell:(id)sender;
@end

@implementation AKFormCellTextBox

///---------------------------------------------------------------------------------------
#pragma mark - Creating a Text Field Cell
///---------------------------------------------------------------------------------------

- (instancetype)initWithStyleProvider:(id<AKFormCellTextBoxStyleProvider>)styleProvider
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_TEXTBOX];
    if (self) {
        
        self.styleProvider = styleProvider;
        [self styleTextBox];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.label = [[UILabel alloc] init];
        [self styleLabel];
        [self.contentView addSubview:self.label];
        
        self.textView = [[UITextView alloc] init];
        self.textView.delegate = self;
        [self styleTextBox];
        [self.contentView addSubview:self.textView];
        
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
    [self setMode:AKFormCellTextBoxModeInvalid];
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
    [self styleTextBox];
    [self styleFrames];
}

/**
 *  This is an override to the default setter, which also re-styles the label and
 *  text field in case the mode had changed.
 *
 *  @param mode The mode in which this cell is in now.
 */
- (void)setMode:(AKFormCellTextBoxMode)mode
{
    _mode = mode;
    [self styleLabel];
    [self styleTextBox];
    [self layoutSubviews];
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Actions
///---------------------------------------------------------------------------------------

- (void)tappedCell:(id)sender
{
    [self.textView becomeFirstResponder];
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
    switch (self.labelStyle) {
        case AKFormCellTextBoxLabelStyleOnLeftLeftAligned:
            self.label.textAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellTextBoxLabelStyleOnLeftRightAligned:
            self.label.textAlignment = NSTextAlignmentRight;
            break;
        case AKFormCellTextBoxLabelStyleOnTop:
            self.label.textAlignment = NSTextAlignmentLeft;
            break;
        default:
            break;
    }
    self.textView.textAlignment = NSTextAlignmentLeft;
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Repeated Style Helpers
///---------------------------------------------------------------------------------------

- (void)styleFrames
{
    CGFloat labelWidth, labelX, textBoxX, textBoxY, textBoxWidth;
    CGRect contentFrame = [self contentFrame];
    switch (self.labelStyle) {
        case AKFormCellTextBoxLabelStyleOnLeftLeftAligned:
        case AKFormCellTextBoxLabelStyleOnLeftRightAligned:
            if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelWidthForTextBoxCell:)]) {
                labelWidth = [self.styleProvider labelWidthForTextBoxCell:self];
            } else {
                labelWidth = DEFAULT_TITLE_WIDTH;
            }
            labelWidth = MAX(MINIMUM_TITLE_WIDTH, labelWidth);
            CGFloat maxLabelWidth = contentFrame.size.width - PADDING_HORIZONTAL - MINIMUM_VALUE_WIDTH;
            labelWidth = MIN(labelWidth, maxLabelWidth);
            
            textBoxX = labelWidth;
            labelX = contentFrame.origin.x;
            break;
            
        case AKFormCellTextBoxLabelStyleOnTop:
            labelWidth = contentFrame.size.width;
            labelX = contentFrame.origin.x;
            textBoxX = 0;
            break;
    }

    [self.label sizeToFit];
    CGFloat labelHeight = MIN(self.label.frame.size.height, contentFrame.size.height);
    self.label.frame = CGRectMake(labelX,
                                  contentFrame.origin.y,
                                  labelWidth,
                                  labelHeight);

    CGFloat textBoxHeight = contentFrame.size.height;
    textBoxWidth = contentFrame.size.width;
    if (self.labelStyle != AKFormCellTextBoxLabelStyleOnTop && self.label.frame.size.width > 0.f) {
        textBoxX += PADDING_HORIZONTAL;
        textBoxWidth = contentFrame.size.width - textBoxX;
        textBoxY = 0;
    } else {
        textBoxHeight = contentFrame.size.height - labelHeight - PADDING_VERTICAL;
        textBoxY = labelHeight + PADDING_VERTICAL;
    }
    
    self.textView.frame = CGRectMake(contentFrame.origin.x + textBoxX,
                                     contentFrame.origin.y + textBoxY,
                                     textBoxWidth,
                                     textBoxHeight);
    
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 *  Styles the label by asking the delegate for the font and textColor, or resorting to
 *  using defaults.
 */
- (void)styleLabel
{
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelFontForTextBoxMode:forTextBoxCell:)]) {
        UIFont *font = [self.styleProvider labelFontForTextBoxMode:self.mode forTextBoxCell:self];
        self.label.font = font;
    } else {
        self.label.font = DEFAULT_FONT_TITLE;
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelTextColorForTextBoxMode:forTextBoxCell:)]) {
        self.label.textColor = [self.styleProvider labelTextColorForTextBoxMode:self.mode forTextBoxCell:self];
    } else {
        self.label.textColor = DEFAULT_TEXTCOLOR_TITLE;
    }
}

/**
 *  Styles the text field by asking the delegate for the font and textColor, or
 *  resorting to using defaults.
 */
- (void)styleTextBox
{
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelStyleForTextBoxCell:)]) {
        self.labelStyle = [self.styleProvider labelStyleForTextBoxCell:self];
    } else {
        self.labelStyle = DEFAULT_LABEL_STYLE;
    }

    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(heightStyleForTextBoxCell:)]) {
        self.heightStyle = [self.styleProvider heightStyleForTextBoxCell:self];
    } else {
        self.heightStyle = DEFAULT_HEIGHT_STYLE;
    }

    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(textBoxFontForTextBoxMode:forTextBoxCell:)]) {
        self.textView.font = [self.styleProvider textBoxFontForTextBoxMode:self.mode forTextBoxCell:self];
    } else {
        self.textView.font = DEFAULT_FONT_VALUE;
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(textBoxTextColorForTextBoxMode:forTextBoxCell:)]) {
        self.textView.textColor = [self.styleProvider textBoxTextColorForTextBoxMode:self.mode forTextBoxCell:self];
    } else {
        self.textView.textColor = DEFAULT_TEXTCOLOR_VALUE;
    }
}

- (void)updateMode
{
    NSString *stringValue = [[self.valueDelegate inputValue] stringValue];
    if ([self.textView isFirstResponder]) {
        [self setMode:AKFormCellTextBoxModeEditing];
    } else if (stringValue && stringValue.length > 0) {
        [self setMode:AKFormCellTextBoxModeFilled];
    } else {
        [self setMode:AKFormCellTextBoxModeEmpty];
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Text Field Delegate
///---------------------------------------------------------------------------------------

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateMode];
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChangeOnTextBoxCell:)]) {
        [self.delegate textViewDidChangeOnTextBoxCell:self];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.mode == AKFormCellTextBoxModeEmpty || self.clearsOnInsertion == YES) {
        self.textView.text = @"";
    }
    
    [self updateMode];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginEditingOnTextBoxCell:)]) {
        [self.delegate didBeginEditingOnTextBoxCell:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.valueDelegate && [self.valueDelegate respondsToSelector:@selector(didInputValue:)]) {
        AKFormValue *value = [AKFormValue value:textView.text withType:AKFormValueString];
        [self.valueDelegate didInputValue:value];
    }

    [self updateMode];
    
    if (self.mode == AKFormCellTextBoxModeEmpty) {
        self.textView.text = self.placeholderString;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndEditingOnTextBoxCell:)]) {
        [self.delegate didEndEditingOnTextBoxCell:self];
    }
}

@end
