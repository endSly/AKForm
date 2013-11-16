//
//  AKFormCellImage.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFormCell.h"
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

@class AKFormCellImage;

@protocol CSFormCellImageStyleProvider <NSObject>
@optional
- (CSFormCellImageLabelStyle)labelStyleForImageCell:(AKFormCellImage *)cell;
- (CGFloat)heightForImageCell:(AKFormCellImage *)cell;
- (UIFont *)imageCell:(AKFormCellImage *)cell labelFontForMode:(CSFormCellImageMode)mode;
- (UIColor *)imageCell:(AKFormCellImage *)cell labelTextColorForMode:(CSFormCellImageMode)mode;
- (UIImage *)placeholderImageForImageCell:(AKFormCellImage *)cell;
@end

@protocol CSFormCellImageDelegate <NSObject>
- (void)didTapThumbnailOnImageCell:(AKFormCellImage *)cell;
- (NSString *)placeholderStringForLabelCell:(AKFormCellImage *)cell;
- (NSString *)labelStringForLabelCell:(AKFormCellImage *)cell;
@end

@interface AKFormCellImage : AKFormCell

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
