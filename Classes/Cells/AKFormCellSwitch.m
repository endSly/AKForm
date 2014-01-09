//
//  AKFormCellSwitch.m
//  AKForm
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCellSwitch.h"

#define DEFAULT_STYLE                   AKFormCellSwitchStyleLabelWithStaticWidth1

@interface AKFormCellSwitch()
@property(nonatomic, assign) AKFormCellSwitchStyle style;
@property(nonatomic, assign) AKFormCellSwitchMode mode;
@property(nonatomic, weak) id<AKFormCellSwitchStyleProvider> styleProvider;
- (void)tappedCell:(id)sender;
@end

@implementation AKFormCellSwitch {
    NSTextAlignment _switchAlignment;
}

///---------------------------------------------------------------------------------------
#pragma mark - Creating a Text Field Cell
///---------------------------------------------------------------------------------------

- (instancetype)initWithStyleProvider:(id<AKFormCellSwitchStyleProvider>)styleProvider
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_SWITCH];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.styleProvider = styleProvider;
        [self setStyle];
        
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
        [self styleLabel];
        
        self.switchContainerView = [[UIView alloc] init];
        [self.contentView addSubview:self.switchContainerView];
        self.switchControl = [[UISwitch alloc] init];
        [self.switchContainerView addSubview:self.switchControl];
        [self styleSwitch];
        
        [self styleTextAlignments];
        [self styleFrames];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCell:)];
        [self.contentView addGestureRecognizer:tgr];
    }
    return self;
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Overrides
///---------------------------------------------------------------------------------------

//Since these cells are reused, we must only do the essential here,
// ie. what may actually be changed after a text view cell is created
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setStyle];
    [self styleTextAlignments];
    [self styleLabel];
    [self styleSwitch];
    [self styleFrames];
}

/**
 *  This is an override to the default setter, which also re-styles the label and
 *  text field in case the mode had changed.
 *
 *  @param mode The mode in which this cell is in now.
 */
- (void)setMode:(AKFormCellSwitchMode)mode
{
    _mode = mode;
    [self styleLabel];
    [self styleSwitch];
    [self layoutSubviews];
}

- (void)setStyle
{
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(styleForSwitchCell)]) {
        self.style = [self.styleProvider styleForSwitchCell];
    } else {
        self.style = DEFAULT_STYLE;
    }
    [self styleTextAlignments];
}

#pragma mark - Actions

- (void)tappedCell:(id)sender
{
    //TODO: look into this
    //NOTE: This bit of code was what was leaving the form in inconsistent states at times.
    //      I think we may have to manually call the 'switchValueChanged' method when doing things this way
//    if (self.switchControl.userInteractionEnabled) {
//        [self.switchControl setOn:!self.switchControl.on animated:YES];
//    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Initial Style Helpers
///---------------------------------------------------------------------------------------

- (void)styleTextAlignments
{
    switch (self.style) {
        case AKFormCellSwitchStyleLabelWithDynamicWidth:
            self.label.textAlignment = NSTextAlignmentLeft;
            _switchAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellSwitchStyleLabelWithStaticWidth1:
            self.label.textAlignment = NSTextAlignmentLeft;
            _switchAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellSwitchStyleLabelWithStaticWidth2:
            self.label.textAlignment = NSTextAlignmentRight;
            _switchAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellSwitchStyleLabelWithStaticWidth3:
            self.label.textAlignment = NSTextAlignmentLeft;
            _switchAlignment = NSTextAlignmentRight;
            break;
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Repeated Style Helpers
///---------------------------------------------------------------------------------------

#define MINIMUM_SWITCH_WIDTH 50.f

- (void)styleFrames
{
    CGFloat labelWidth;
    CGRect contentFrame = [self contentFrame];
    switch (self.style) {
        case AKFormCellSwitchStyleLabelWithStaticWidth1:
        case AKFormCellSwitchStyleLabelWithStaticWidth2:
        case AKFormCellSwitchStyleLabelWithStaticWidth3:
            if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelWidthForSwitchCell)]) {
                labelWidth = [self.styleProvider labelWidthForSwitchCell];
            } else {
                labelWidth = DEFAULT_TITLE_WIDTH;
            }
            labelWidth = MAX(MINIMUM_TITLE_WIDTH, labelWidth);
            CGFloat maxLabelWidth = contentFrame.size.width - PADDING_HORIZONTAL - MINIMUM_SWITCH_WIDTH;
            labelWidth = MIN(labelWidth, maxLabelWidth);
            self.label.frame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y, labelWidth, contentFrame.size.height);
            break;
        case AKFormCellSwitchStyleLabelWithDynamicWidth:
            [self.label sizeToFit];
            CGFloat maximumLabelWidth = contentFrame.size.width - (MINIMUM_SWITCH_WIDTH + PADDING_HORIZONTAL);
            self.label.frame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y,
                                          MIN(self.label.frame.size.width, maximumLabelWidth),
                                          MAX(self.label.frame.size.height, contentFrame.size.height));
            
            break;
    }
    CGFloat switchContainerX = self.label.frame.size.width;
    switchContainerX += PADDING_HORIZONTAL;
    CGFloat switchContainerWidth = MAX(MINIMUM_SWITCH_WIDTH, contentFrame.size.width - switchContainerX);
    self.switchContainerView.frame = CGRectMake(contentFrame.origin.x + switchContainerX, contentFrame.origin.y,
                                                switchContainerWidth, contentFrame.size.height);
    
    if (_switchAlignment == NSTextAlignmentLeft) {
        self.switchControl.frame = CGRectMake(0, 0, MINIMUM_SWITCH_WIDTH, contentFrame.size.height);
    } else if (_switchAlignment == NSTextAlignmentCenter) {
        self.switchControl.frame = CGRectMake(0, 0, MINIMUM_SWITCH_WIDTH, contentFrame.size.height);
        self.switchControl.center = self.switchContainerView.center;
    } else {
        self.switchControl.frame = CGRectMake(self.switchContainerView.frame.size.width - MINIMUM_SWITCH_WIDTH,
                                              0, MINIMUM_SWITCH_WIDTH, contentFrame.size.height);
    }
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
            case AKFormCellSwitchModeEditable:
            case AKFormCellSwitchModeReadOnly:
                self.label.font = DEFAULT_FONT_TITLE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelTextColorForMode:style:)]) {
        self.label.textColor = [self.styleProvider labelTextColorForMode:self.mode style:self.style];
    } else {
        switch (self.mode) {
            case AKFormCellSwitchModeEditable:
            case AKFormCellSwitchModeReadOnly:
                self.label.textColor = DEFAULT_TEXTCOLOR_TITLE;
                break;
        }
    }
}

- (void)styleSwitch
{
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(switchTintColor)]) {
        self.switchControl.onTintColor = [self.styleProvider switchTintColor];
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Text Field Delegate
///---------------------------------------------------------------------------------------

- (void)switchDidChangeValue:(UISwitch *)aSwitch
{
    if (self.valueDelegate && [self.valueDelegate respondsToSelector:@selector(didInputValue:)]) {
        AKFormValue *value = [AKFormValue value:[NSNumber numberWithBool:aSwitch.selected] withType:AKFormValueBool];
        [self.valueDelegate didInputValue:value];
    }
}

@end
