//
//  AKFormCellLabel.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCellLabel.h"

#define DEFAULT_STYLE                   AKFormCellLabelStyleTitleWithStaticWidth1

@interface AKFormCellLabel()
@property(nonatomic, assign) AKFormCellLabelStyle style;
@property(nonatomic, assign) AKFormCellLabelMode mode;
@property(nonatomic, weak) id<AKFormCellLabelStyleProvider> styleProvider;
//- (void)tappedCell:(id)sender;
@end

@implementation AKFormCellLabel

#pragma mark - Initializers

- (instancetype)initWithStyleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_LABEL];
    if (self) {

        //set the style
        self.styleProvider = styleProvider;
        if (styleProvider && [styleProvider respondsToSelector:@selector(styleForLabelCell:)]) {
            self.style = [styleProvider styleForLabelCell:self];
        } else {
            self.style = DEFAULT_STYLE;
        }
        
        self.titleLabel = [[UILabel alloc] init];
        [self styleTitleLabel];
        [self.contentView addSubview:self.titleLabel];

        self.valueLabel = [[UILabel alloc] init];
        [self styleValueLabel];
        [self.contentView addSubview:self.valueLabel];

        [self setupInitialStyle];
    }
    return self;
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Initial Style Helpers
///---------------------------------------------------------------------------------------

- (void)setupInitialStyle
{
    [self setMode:AKFormCellLabelModeEmpty];
    [self styleFrames];
    [self styleTextAlignments];
}

- (void)styleTextAlignments
{
    switch (self.style) {
        case AKFormCellLabelStyleTitleWithDynamicWidth:
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.valueLabel.textAlignment = NSTextAlignmentRight;
            break;
        case AKFormCellLabelStyleTitleWithStaticWidth1:
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.valueLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellLabelStyleTitleWithStaticWidth2:
            self.titleLabel.textAlignment = NSTextAlignmentRight;
            self.valueLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellLabelStyleTitleWithStaticWidth3:
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.valueLabel.textAlignment = NSTextAlignmentRight;
            break;
        case AKFormCellLabelStyleNoTitle:
            self.valueLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case AKFormCellLabelStyleTwoLines:
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.valueLabel.textAlignment = NSTextAlignmentLeft;
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
        case AKFormCellLabelStyleTitleWithStaticWidth1:
        case AKFormCellLabelStyleTitleWithStaticWidth2:
        case AKFormCellLabelStyleTitleWithStaticWidth3:
            if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(titleLabelWidthForLabelCell:)]) {
                labelWidth = [self.styleProvider titleLabelWidthForLabelCell:self];
            } else {
                labelWidth = DEFAULT_TITLE_WIDTH;
            }
            self.titleLabel.frame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y, labelWidth, contentFrame.size.height);
            break;
        case AKFormCellLabelStyleTitleWithDynamicWidth:
            //fit the title label snugly
            [self.titleLabel sizeToFit];
            
            //determine the maximum available room for the label's width
            CGFloat maximumLabelWidth = contentFrame.size.width - (MINIMUM_VALUE_WIDTH + PADDING_HORIZONTAL);
            
            //make the frame accordingly
            self.titleLabel.frame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y,
                                               MIN(self.titleLabel.frame.size.width, maximumLabelWidth),
                                               MAX(self.titleLabel.frame.size.height, contentFrame.size.height));
            
            break;
        case AKFormCellLabelStyleNoTitle:
            self.titleLabel.frame = CGRectZero;
            break;
        case AKFormCellLabelStyleTwoLines:
            
            //fit the labels snugly
            [self.titleLabel sizeToFit];
            [self.valueLabel sizeToFit];
            CGFloat th = self.titleLabel.frame.size.height;
            CGFloat vh = self.valueLabel.frame.size.height;
            if (!(th == 0 && vh == 0)) {
                self.titleLabel.frame = CGRectMake(contentFrame.origin.x,
                                                   contentFrame.origin.y,
                                                   contentFrame.size.width,
                                                   contentFrame.size.height * (th / (th + vh)));
                self.valueLabel.frame = CGRectMake(contentFrame.origin.x,
                                                   contentFrame.origin.y + self.titleLabel.frame.size.height,
                                                   contentFrame.size.width,
                                                   contentFrame.size.height * (vh / (th + vh)));
            }
            break;
    }
    CGFloat valueLabelX = self.titleLabel.frame.size.width;
    if (self.style != AKFormCellLabelStyleNoTitle && self.style != AKFormCellLabelStyleTwoLines) {
        valueLabelX += PADDING_HORIZONTAL;
    }
    if (self.style != AKFormCellLabelStyleTwoLines) {
        self.valueLabel.frame = CGRectMake(contentFrame.origin.x + valueLabelX, contentFrame.origin.y,
                                           contentFrame.size.width - valueLabelX, contentFrame.size.height);
    }
}

- (void)styleTitleLabel
{
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelCell:titleLabelFontForMode:)]) {
        self.titleLabel.font = [self.styleProvider labelCell:self titleLabelFontForMode:self.mode];
    } else {
        switch (self.mode) {
            case AKFormCellLabelModeEditing:
            case AKFormCellLabelModeEmpty:
            case AKFormCellLabelModeFilled:
            case AKFormCellLabelModeReadOnly:
            case AKFormCellLabelModeInvalid:
                self.titleLabel.font = DEFAULT_FONT_TITLE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelCell:titleLabelTextColorForMode:)]) {
        self.titleLabel.textColor = [self.styleProvider labelCell:self titleLabelTextColorForMode:self.mode];
    } else {
        switch (self.mode) {
            case AKFormCellLabelModeEditing:
            case AKFormCellLabelModeEmpty:
            case AKFormCellLabelModeFilled:
            case AKFormCellLabelModeReadOnly:
            case AKFormCellLabelModeInvalid:
                self.titleLabel.textColor = DEFAULT_TEXTCOLOR_TITLE;
                break;
        }
    }
}

- (void)styleValueLabel
{
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelCell:valueLabelFontForMode:)]) {
        self.valueLabel.font = [self.styleProvider labelCell:self valueLabelFontForMode:self.mode];
    } else {
        switch (self.mode) {
            case AKFormCellLabelModeEditing:
            case AKFormCellLabelModeEmpty:
            case AKFormCellLabelModeFilled:
            case AKFormCellLabelModeReadOnly:
            case AKFormCellLabelModeInvalid:
                self.valueLabel.font = DEFAULT_FONT_VALUE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelCell:valueLabelTextColorForMode:)]) {
        self.valueLabel.textColor = [self.styleProvider labelCell:self valueLabelTextColorForMode:self.mode];
    } else {
        switch (self.mode) {
            case AKFormCellLabelModeEditing:
            case AKFormCellLabelModeEmpty:
            case AKFormCellLabelModeFilled:
            case AKFormCellLabelModeReadOnly:
            case AKFormCellLabelModeInvalid:
                self.valueLabel.textColor = DEFAULT_TEXTCOLOR_VALUE;
                break;
        }
    }
}

#pragma mark - Inherited Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.style == AKFormCellLabelStyleTitleWithDynamicWidth
        || self.style == AKFormCellLabelStyleTwoLines) {
        [self styleFrames];
    }
}

- (void)setMode:(AKFormCellLabelMode)mode
{
    _mode = mode;
    [self styleTitleLabel];
    [self styleValueLabel];
    [self layoutSubviews];
}

///---------------------------------------------------------------------------------------
#pragma mark - Invalidating a Text Field Cell
///---------------------------------------------------------------------------------------

- (void)invalidate
{
    [super invalidate];
    [self setMode:AKFormCellLabelModeInvalid];
}

@end
