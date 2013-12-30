//
//  AKFormCellImage.h
//  AKForm
//
//  Created by Ahmed Khalaf on 7/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFormCell.h"

#define CELL_IDENTIFIER_IMAGE           @"imageCell"

typedef NS_ENUM(NSInteger, AKFormCellImageLabelStyle) {
    AKFormCellImageLabelStyleNone,
    AKFormCellImageLabelStyleLeft,
    AKFormCellImageLabelStyleRight
};

typedef NS_ENUM(NSInteger, AKFormCellImageThumbnailStyle) {
    AKFormCellImageThumbnailStyleCircle,
    AKFormCellImageThumbnailStyleSquare,
    AKFormCellImageThumbnailStyleScaled
};

typedef NS_ENUM(NSInteger, AKFormCellImageMode) {
    AKFormCellImageModeEmpty,
    AKFormCellImageModeFilled,
    AKFormCellImageModeReadOnly
};

@class AKFormCellImage;

@protocol AKFormCellImageStyleProvider <NSObject>
@optional
- (AKFormCellImageLabelStyle)labelStyleForImageCell;
- (CGFloat)heightForImageCell;
- (UIFont *)labelFontForMode:(AKFormCellImageMode)mode;
- (UIColor *)labelTextColorForMode:(AKFormCellImageMode)mode;
@end

@protocol AKFormCellImageDelegate <NSObject>
- (void)didTapThumbnailOnImageCell:(AKFormCellImage *)cell;
- (NSString *)placeholderStringForImageCell:(AKFormCellImage *)cell;
- (NSString *)labelStringForImageCell:(AKFormCellImage *)cell;
@end

@interface AKFormCellImage : AKFormCell

//image cell specific stuff
@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) AKFormCellImageThumbnailStyle thumbnailStyle;

///---------------------------------------------------------------------------------------
/// @name Cell Elements
///---------------------------------------------------------------------------------------

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIImageView *thumbnail;
@property(nonatomic, strong) NSString *placeholderImageName;
@property(nonatomic, weak) id<AKFormCellImageDelegate> delegate;

- (instancetype)initWithStyleProvider:(id<AKFormCellImageStyleProvider>)styleProvider;

- (void)fillThumbnailImage:(UIImage *)image;
- (void)clearThumbnail;

@end
