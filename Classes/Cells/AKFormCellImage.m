//
//  AKFormCellImage.m
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormCellImage.h"

#define DEFAULT_LABEL_STYLE             CSFormCellImageLabelStyleLeft
#define DEFAULT_THUMBNAIL_STYLE         CSFormCellImageThumbnailStyleCircle
#define DEFAULT_MODE                    CSFormCellImageModeEmpty
#define DEFAULT_IMAGE_SIZE              CGSizeMake(320, 320)


@interface UIImageView (Mask)
- (void)setCornerRadius:(CGFloat)cornerRadius;
@end

@interface UIBezierPath (ZEPolygon)
+ (UIBezierPath *)bezierPathWithPolygonInRect:(CGRect)rect numberOfSides:(NSUInteger)numberOfSides;
@end


@interface AKFormCellImage()
@property(nonatomic, assign) CSFormCellImageLabelStyle labelStyle;
@property(nonatomic, assign) CSFormCellImageMode mode;
@property(nonatomic, weak) id<CSFormCellImageStyleProvider> styleProvider;
@end

@implementation AKFormCellImage

///---------------------------------------------------------------------------------------
#pragma mark - Creating an Image Cell
///---------------------------------------------------------------------------------------

- (instancetype)initWithStyleProvider:(id<CSFormCellImageStyleProvider>)styleProvider
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_IMAGE];
    if (self) {
        self.styleProvider = styleProvider;

        self.thumbnail = [[UIImageView alloc] init];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnail.clipsToBounds = YES;
        self.thumbnail.userInteractionEnabled = YES;
        [self styleThumbnail];
        [self.contentView addSubview:self.thumbnail];

        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedThumbnail:)];
        [self.thumbnail addGestureRecognizer:tgr];

        self.label = [[UILabel alloc] init];
        [self styleLabel];
        [self.contentView addSubview:self.label];
        
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
    [self styleThumbnailMask];
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
    [self styleLabel];
    [self styleFrames];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(labelStringForImageCell:)]
        && [self.delegate respondsToSelector:@selector(placeholderStringForImageCell:)]) {

        UILabel *labelLabel = [[UILabel alloc] init];
        labelLabel.font = self.label.font;
        labelLabel.text = [self.delegate labelStringForImageCell:self];
        [labelLabel sizeToFit];
        
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.font = self.label.font;
        placeholderLabel.text = [self.delegate placeholderStringForImageCell:self];
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
    CGRect labelFrame = CGRectMake(contentFrame.origin.x + thumbnailSize.width + PADDING_HORIZONTAL,
                                   contentFrame.origin.y,
                                   contentFrame.size.width - (thumbnailSize.width + PADDING_HORIZONTAL),
                                   [self contentFrame].size.height);
    self.label.frame = self.labelStyle == CSFormCellImageLabelStyleNone ? CGRectZero : labelFrame;
    
    self.thumbnail.frame = thumbnailFrame;
}

- (void)styleLabel
{
    if (self.styleProvider
        && [self.styleProvider respondsToSelector:@selector(labelStyleForImageCell)]) {
        self.labelStyle = [self.styleProvider labelStyleForImageCell];
    } else {
        self.labelStyle = DEFAULT_LABEL_STYLE;
    }
    [self styleTextAlignments];
    
    //font
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelFontForMode:)]) {
        self.label.font = [self.styleProvider labelFontForMode:self.mode];
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
    if (self.styleProvider && [self.styleProvider respondsToSelector:@selector(labelTextColorForMode:)]) {
        self.label.textColor = [self.styleProvider labelTextColorForMode:self.mode];
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

- (void)styleThumbnailMask
{
    if (self.thumbnailStyle == CSFormCellImageThumbnailStyleCircle) {
        [self.thumbnail setCornerRadius:self.thumbnail.frame.size.width / 2.f];
    } else {
        [self.thumbnail setCornerRadius:0.0];
    }
}

- (void)styleThumbnail
{
    [self styleThumbnailMask];
    if (self.mode == CSFormCellImageModeEmpty) {
        UIImage *placeholderImage = [UIImage imageNamed:self.placeholderImageName];
        [self setThumbnailImage:placeholderImage];
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


@implementation UIImageView (Mask)

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
    [self.layer setMasksToBounds:YES];
}

@end
