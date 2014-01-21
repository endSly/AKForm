//
//  AKFormCellButton.m
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCellButton.h"

#define DEFAULT_STYLE                   AKFormCellButtonStyleLabelCentered

@interface AKFormCellButton()
@property(nonatomic, assign) AKFormCellButtonStyle style;
@property(nonatomic, assign) AKFormCellButtonMode mode;
@property(nonatomic, weak) id<AKFormCellButtonStyleProvider> styleProvider;
@property(nonatomic, strong) UIView *containerView;
- (void)tappedCell:(id)sender;
@end

@implementation AKFormCellButton

///---------------------------------------------------------------------------------------
#pragma mark - Creating a Text Field Cell
///---------------------------------------------------------------------------------------

- (instancetype)initWithStyleProvider:(id<AKFormCellButtonStyleProvider>)styleProvider
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_TEXTFIELD];
    if (self) {

        self.styleProvider = styleProvider;

        self.containerView = [[UIView alloc] init];
        [self.contentView addSubview:self.containerView];
        
        self.icon = [[UIImageView alloc] init];
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.clipsToBounds = YES;
        self.icon.userInteractionEnabled = YES;
        [self.containerView addSubview:self.icon];

        self.label = [[UILabel alloc] init];
        self.detailLabel = [[UILabel alloc] init];
        [self styleLabels];
        [self.containerView addSubview:self.label];
        [self.containerView addSubview:self.detailLabel];

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
    [self setMode:AKFormCellButtonModeDisabled];
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
    [self styleLabels];
    [self styleFrames];
}

/**
 *  This is an override to the default setter, which also re-styles the label and 
 *  text field in case the mode had changed.
 *
 *  @param mode The mode in which this cell is in now.
 */
- (void)setMode:(AKFormCellButtonMode)mode
{
    _mode = mode;
    [self styleLabels];
    [self layoutSubviews];
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Actions
///---------------------------------------------------------------------------------------

- (void)tappedCell:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressButtonCell:)]) {
        [self.delegate didPressButtonCell:self];
    }
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
        case AKFormCellButtonStyleLabelCentered:
            self.label.textAlignment = NSTextAlignmentCenter;
            self.detailLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case AKFormCellButtonStyleLabelLeft:
            self.label.textAlignment = NSTextAlignmentLeft;
            self.detailLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellButtonStyleLabelRight:
            self.label.textAlignment = NSTextAlignmentRight;
            self.detailLabel.textAlignment = NSTextAlignmentRight;
            break;
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Repeated Style Helpers
///---------------------------------------------------------------------------------------

- (void)styleFrames
{
    CGFloat labelWidth;
    CGFloat detailLabelWidth;
    CGFloat labelHeight;
    CGFloat detailLabelHeight;
    CGFloat iconHeight;
    CGFloat iconWidth;
    
    CGRect contentFrame = [self contentFrame];
    
    if (self.icon.frame.size.width > 0 && self.icon.frame.size.height > 0) {
        //fit icon
        iconHeight = contentFrame.size.height;
        iconWidth = (self.icon.frame.size.height / self.icon.frame.size.width) / contentFrame.size.height;
        self.icon.frame = CGRectMake(0, 0, iconWidth, iconHeight);
    } else {
        iconHeight = 0.f;
        iconWidth = 0.f;
    }

    BOOL haveIcon = self.icon.frame.size.width > 0;
    BOOL haveDetail = self.detailLabel.frame.size.width > 0;

    [self.label sizeToFit];
    [self.detailLabel sizeToFit];
    labelHeight = self.label.frame.size.height;
    labelWidth = self.label.frame.size.width;
    detailLabelHeight = self.detailLabel.frame.size.height;
    detailLabelWidth = self.detailLabel.frame.size.width;
    
    switch (self.style) {
        case AKFormCellButtonStyleLabelLeft:
            //size the container view
            self.containerView.frame = CGRectMake(0, 0,
                                                  iconWidth + MAX(labelWidth, detailLabelWidth),
                                                  MAX(iconHeight, labelHeight + detailLabelHeight));
            //position the elements
            if (haveIcon) {
                self.label.frame = CGRectMake(iconWidth, 0, labelWidth, labelHeight);
                if (haveDetail) {
                    self.detailLabel.frame = CGRectMake(iconWidth, labelHeight, detailLabelWidth, detailLabelHeight);
                }
            } else {
                self.label.frame = CGRectMake(0, 0, labelWidth, labelHeight);
                if (haveDetail) {
                    self.detailLabel.frame = CGRectMake(0, labelHeight, detailLabelWidth, detailLabelHeight);
                }
            }
            
            //center the contentView
            self.containerView.center = CGPointMake(CGRectGetMidX(contentFrame), CGRectGetMidY(contentFrame));
            
            break;
        case AKFormCellButtonStyleLabelRight:
        case AKFormCellButtonStyleLabelCentered:
            break;
    }
}

/**
 *  Styles the label by asking the delegate for the font and textColor, or resorting to
 *  using defaults.
 */
- (void)styleLabels
{
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelFontForMode:style:forButtonCell:)]) {
        UIFont *font = [self.styleProvider labelFontForMode:self.mode style:self.style forButtonCell:self];
        self.label.font = font;
    } else {
        switch (self.mode) {
            case AKFormCellButtonModeEnabled:
            case AKFormCellButtonModeDisabled:
                self.label.font = DEFAULT_FONT_TITLE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelTextColorForMode:style:forButtonCell:)]) {
        self.label.textColor = [self.styleProvider labelTextColorForMode:self.mode style:self.style forButtonCell:self];
    } else {
        switch (self.mode) {
            case AKFormCellButtonModeEnabled:
            case AKFormCellButtonModeDisabled:
                self.label.textColor = DEFAULT_TEXTCOLOR_TITLE;
                break;
        }
    }

    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(styleForButtonCell:)]) {
        self.style = [self.styleProvider styleForButtonCell:self];
    } else {
        self.style = DEFAULT_STYLE;
    }
    
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(detailLabelFontForMode:style:forButtonCell:)]) {
        self.detailLabel.font = [self.styleProvider detailLabelFontForMode:self.mode style:self.style forButtonCell:self];
    } else {
        switch (self.mode) {
            case AKFormCellButtonModeEnabled:
            case AKFormCellButtonModeDisabled:
                self.label.font = DEFAULT_FONT_VALUE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(detailLabelTextColorForMode:style:forButtonCell:)]) {
        self.detailLabel.textColor = [self.styleProvider detailLabelTextColorForMode:self.mode style:self.style forButtonCell:self];
    } else {
        switch (self.mode) {
            case AKFormCellButtonModeEnabled:
            case AKFormCellButtonModeDisabled:
                self.detailLabel.textColor = DEFAULT_TEXTCOLOR_VALUE;
                break;
        }
    }
}

- (void)updateMode
{
    [self setMode:AKFormCellButtonModeEnabled];
}

@end
