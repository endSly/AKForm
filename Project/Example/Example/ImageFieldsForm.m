//
//  ImageFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ImageFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"

@interface ImageFieldsForm () <CSFormDelegate, CSFormCellImageStyleProvider>
@end

@implementation ImageFieldsForm

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createForm];
}

#pragma mark -
#pragma mark Form Creation

- (void)createForm
{
    AKFormFieldImage *imageField = [[AKFormFieldImage alloc] initWithKey:@"profile_photo"
                                                                   title:@"Avatar"
                                                             placeholder:@"Choose a profile photo"
                                                               imageSize:CGSizeMake(640, 640)
                                                          thumbnailStyle:CSFormCellImageThumbnailStyleCircle
                                                          formController:self];
    AKFormValueValidator *requiredValidator = [AKFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    imageField.validators = @[requiredValidator];
    
    AKFormSection *s1 = [[AKFormSection alloc] initWithFields:@[imageField]];
    s1.headerTitle = @"YOUR DETAILS";
    [self addSection:s1];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark Image Cell—Style Provider

- (UIFont *)imageCell:(AKFormCellImage *)cell labelFontForMode:(CSFormCellImageMode)mode
{
    return [UIFont systemFontOfSize:17.f];
}

- (UIColor *)imageCell:(AKFormCellImage *)cell labelTextColorForMode:(CSFormCellImageMode)mode
{
    switch (mode) {
        case CSFormCellImageModeEmpty:
            return [UIColor colorWithHexString:HEX_COLOR_GREY_PLACEHOLDER];
        case CSFormCellImageModeFilled:
        case CSFormCellImageModeReadOnly:
            return [UIColor darkGrayColor];
            break;
    }
}

- (UIImage *)placeholderImageForImageCell:(AKFormCellImage *)cell
{
    return [UIImage imageNamed:@"PlaceholderProfile2"];
}

- (CGFloat)heightForImageCell:(AKFormCellImage *)cell
{
    return 100.f;
}

- (CSFormCellImageLabelStyle)labelStyleForImageCell:(AKFormCellImage *)cell
{
    return CSFormCellImageLabelStyleLeft;
}

@end
