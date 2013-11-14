//
//  CSFormCellImage.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormCellImage.h"
#import "UIImageView+CircleMask.h"

#define DEFAULT_LABEL_STYLE             CSFormCellImageLabelStyleLeft
#define DEFAULT_THUMBNAIL_STYLE         CSFormCellImageThumbnailStyleCircle
#define DEFAULT_MODE                    CSFormCellImageModeEmpty
#define DEFAULT_IMAGE_SIZE              CGSizeMake(320, 320)

@interface CSFormCellImage()
@property(nonatomic, assign) CSFormCellImageLabelStyle labelStyle;
@property(nonatomic, assign) CSFormCellImageMode mode;
@property(nonatomic, weak) id<CSFormCellImageStyleProvider> styleProvider;
@end

@implementation CSFormCellImage

///---------------------------------------------------------------------------------------
#pragma mark - Creating an Image Cell
///---------------------------------------------------------------------------------------

- (instancetype)initWithStyleProvider:(id<CSFormCellImageStyleProvider>)styleProvider
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_IMAGE];
    if (self) {
        self.styleProvider = styleProvider;
        if (styleProvider && [styleProvider respondsToSelector:@selector(labelStyleForImageCell:)]) {
            self.labelStyle = [styleProvider labelStyleForImageCell:self];
        } else {
            self.labelStyle = DEFAULT_LABEL_STYLE;
        }

        self.thumbnail = [[UIImageView alloc] init];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnail.clipsToBounds = YES;
        self.thumbnail.userInteractionEnabled = YES;
        [self styleThumbnail];
        [self.contentView addSubview:self.thumbnail];

        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedThumbnail:)];
        [self.thumbnail addGestureRecognizer:tgr];

        if (self.labelStyle != CSFormCellImageLabelStyleNone) {
            self.label = [[UILabel alloc] init];
            [self styleLabel];
            [self.contentView addSubview:self.label];
        }
        
        self.thumbnailStyle = DEFAULT_THUMBNAIL_STYLE;
        self.imageSize = DEFAULT_IMAGE_SIZE;
        [self setupInitialStyle];
        [self setMode:DEFAULT_MODE];
    }
    return self;
}

///---------------------------------------------------------------------------------------
#pragma mark - Setting and clearing the thumbnail
///---------------------------------------------------------------------------------------

- (void)setThumbnailImage:(UIImage *)image
{
    [self.thumbnail setImage:image];
    if (self.thumbnailStyle == CSFormCellImageThumbnailStyleCircle) {
        [self.thumbnail maskWithCircle];
    } else {
        [self.thumbnail removeMask];
    }
}

- (void)fillThumbnailImage:(UIImage *)image
{
    if (image) {
        [self setMode:CSFormCellImageModeFilled];
        [self setThumbnailImage:image];
    }
}

- (void)clearThumbnail
{
    [self setMode:CSFormCellImageModeEmpty];
}

///---------------------------------------------------------------------------------------
#pragma mark - Overrides
///---------------------------------------------------------------------------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self styleFrames];
    [self styleLabel];
    [self styleThumbnail];
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Initial Style Helpers
///---------------------------------------------------------------------------------------

- (void)tappedThumbnail:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapThumbnailOnImageCell:)]) {
        [self.delegate didTapThumbnailOnImageCell:self];
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Initial Style Helpers
///---------------------------------------------------------------------------------------

- (void)setupInitialStyle
{
    [self styleAccessoryType];
    [self styleTextAlignments];
    [self styleFrames];
}

- (void)styleAccessoryType
{
    switch (self.mode) {
        case CSFormCellImageModeReadOnly:
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case CSFormCellImageModeEmpty:
        case CSFormCellImageModeFilled:
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
}

- (void)styleTextAlignments
{
    switch (self.labelStyle) {
        case CSFormCellImageLabelStyleLeft:
            self.label.textAlignment = NSTextAlignmentLeft;
            break;
        case CSFormCellImageLabelStyleRight:
            self.label.textAlignment = NSTextAlignmentRight;
            break;
        case CSFormCellImageLabelStyleNone:
            break;
    }
}

- (CGSize)thumbnailSizeConstrainedToWidth:(CGFloat)availableWidth
{
    CGFloat side, neededWidth;
    switch (self.thumbnailStyle) {
        case CSFormCellImageThumbnailStyleCircle:
        case CSFormCellImageThumbnailStyleSquare:
            side = MIN(availableWidth, [self contentFrame].size.height);
            return CGSizeMake(side, side);
            break;
        case CSFormCellImageThumbnailStyleScaled:
            neededWidth = self.imageSize.width * [self contentFrame].size.height / self.imageSize.height;
            if (neededWidth <= availableWidth) {
                return CGSizeMake(neededWidth, [self contentFrame].size.height);
            } else {
                return CGSizeMake(availableWidth, self.imageSize.height * availableWidth / self.imageSize.width);
            }
            break;
    }
}

- (CGFloat)longestLabelWidth
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(labelStringForLabelCell:)]
        && [self.delegate respondsToSelector:@selector(placeholderStringForLabelCell:)]) {

        UILabel *labelLabel = [[UILabel alloc] init];
        labelLabel.font = self.label.font;
        labelLabel.text = [self.delegate labelStringForLabelCell:self];
        [labelLabel sizeToFit];
        
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.font = self.label.font;
        placeholderLabel.text = [self.delegate placeholderStringForLabelCell:self];
        [placeholderLabel sizeToFit];
        
        return MAX(labelLabel.frame.size.width, placeholderLabel.frame.size.width);
    } else {
        [self.label sizeToFit];
        return self.label.frame.size.width;
    }
}

- (void)styleFrames
{
    CGRect contentFrame = [self contentFrame];
    CGFloat availableWidth = contentFrame.size.width - PADDING_HORIZONTAL;
    
    // give the label as much room as possible
    if (self.labelStyle != CSFormCellImageLabelStyleNone) {
        CGFloat longestLabelWidth = [self longestLabelWidth];
        if (availableWidth - longestLabelWidth < MINIMUM_VALUE_WIDTH) {
            self.label.frame = CGRectMake(self.label.frame.origin.x,
                                          self.label.frame.origin.y,
                                          availableWidth - MINIMUM_VALUE_WIDTH,
                                          self.label.frame.size.height);
        } else {
            self.label.frame = CGRectMake(self.label.frame.origin.x,
                                          self.label.frame.origin.y,
                                          longestLabelWidth,
                                          self.label.frame.size.height);
        }
        availableWidth -= self.label.frame.size.width;
    }

    // now give the thumbnail the remaining width or what it needs, whichever is
    CGSize thumbnailSize = [self thumbnailSizeConstrainedToWidth:availableWidth];
    CGRect thumbnailFrame = CGRectMake(contentFrame.origin.x,
                                       contentFrame.origin.y + ((contentFrame.size.height - thumbnailSize.height) / 2.),
                                       thumbnailSize.width,
                                       thumbnailSize.height);

    
    //now stretch the label across the remaining space
    self.label.frame = CGRectMake(contentFrame.origin.x + thumbnailSize.width + PADDING_HORIZONTAL,
                                  contentFrame.origin.y,
                                  contentFrame.size.width - (thumbnailSize.width + PADDING_HORIZONTAL),
                                  [self contentFrame].size.height);
    
    self.thumbnail.frame = thumbnailFrame;
}

- (void)styleLabel
{
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(imageCell:labelFontForMode:)]) {
        self.label.font = [self.styleProvider imageCell:self labelFontForMode:self.mode];
    } else {
        switch (self.mode) {
            case CSFormCellImageModeEmpty:
            case CSFormCellImageModeFilled:
            case CSFormCellImageModeReadOnly:
                self.label.font = DEFAULT_FONT_TITLE;
                break;
        }
    }
    
    //color
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(imageCell:labelTextColorForMode:)]) {
        self.label.textColor = [self.styleProvider imageCell:self labelTextColorForMode:self.mode];
    } else {
        switch (self.mode) {
            case CSFormCellImageModeEmpty:
            case CSFormCellImageModeFilled:
            case CSFormCellImageModeReadOnly:
                self.label.textColor = DEFAULT_TEXTCOLOR_TITLE;
                break;
        }
    }
}

- (void)styleThumbnail
{
    if (self.mode == CSFormCellImageModeEmpty) {
        if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(placeholderImageForImageCell:)]) {
            UIImage *placeholderImage = [self.styleProvider placeholderImageForImageCell:self];
            [self setThumbnailImage:placeholderImage];
        }
    }
}

///---------------------------------------------------------------------------------------
#pragma mark - (Private) Overrides
///---------------------------------------------------------------------------------------

- (void)setMode:(CSFormCellImageMode)mode
{
    _mode = mode;
    [self layoutSubviews];
}

@end
