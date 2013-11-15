//
//  CSFormCellImage.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFormCell.h"
#import <FXImageView.h>

#define CELL_IDENTIFIER_IMAGE           @"imageCell"

typedef NS_ENUM(NSInteger, CSFormCellImageLabelStyle) {
    CSFormCellImageLabelStyleNone,
    CSFormCellImageLabelStyleLeft,
    CSFormCellImageLabelStyleRight
};

typedef NS_ENUM(NSInteger, CSFormCellImageThumbnailStyle) {
    CSFormCellImageThumbnailStyleCircle,
    CSFormCellImageThumbnailStyleSquare,
    CSFormCellImageThumbnailStyleScaled
};

typedef NS_ENUM(NSInteger, CSFormCellImageMode) {
    CSFormCellImageModeEmpty,
    CSFormCellImageModeFilled,
    CSFormCellImageModeReadOnly
};

@class CSFormCellImage;

@protocol CSFormCellImageStyleProvider <NSObject>
@optional
- (CSFormCellImageLabelStyle)labelStyleForImageCell:(CSFormCellImage *)cell;
- (CGFloat)heightForImageCell:(CSFormCellImage *)cell;
- (UIFont *)imageCell:(CSFormCellImage *)cell labelFontForMode:(CSFormCellImageMode)mode;
- (UIColor *)imageCell:(CSFormCellImage *)cell labelTextColorForMode:(CSFormCellImageMode)mode;
- (UIImage *)placeholderImageForImageCell:(CSFormCellImage *)cell;
@end

@protocol CSFormCellImageDelegate <NSObject>
- (void)didTapThumbnailOnImageCell:(CSFormCellImage *)cell;
- (NSString *)placeholderStringForLabelCell:(CSFormCellImage *)cell;
- (NSString *)labelStringForLabelCell:(CSFormCellImage *)cell;
@end

@interface CSFormCellImage : CSFormCell

//image cell specific stuff
@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) CSFormCellImageThumbnailStyle thumbnailStyle;

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) FXImageView *thumbnail;

@property(nonatomic, weak) id<CSFormCellImageDelegate> delegate;

- (instancetype)initWithStyleProvider:(id<CSFormCellImageStyleProvider>)styleProvider;

- (void)fillThumbnailImage:(UIImage *)image;
- (void)clearThumbnail;

@end
