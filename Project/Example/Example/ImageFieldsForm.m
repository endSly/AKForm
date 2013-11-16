//
//  ImageFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ImageFieldsForm.h"

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"

@interface ImageFieldsForm () <CSFormCellImageStyleProvider>
- (IBAction)completeForm:(id)sender;
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
    NSArray *thumbnailStyles = @[@(CSFormCellImageThumbnailStyleCircle),
                                 @(CSFormCellImageThumbnailStyleSquare),
                                 @(CSFormCellImageThumbnailStyleScaled)];
    
    CGFloat smallSide = 100.f;
    CGFloat standardSide = 320.f;
    CGFloat mediumSide = 640.f;
    CGFloat largeSide = 1280.f;
    
    NSValue *smallSquareSize = [NSValue valueWithCGSize:CGSizeMake(smallSide, smallSide)];
    NSValue *standardSquareSize = [NSValue valueWithCGSize:CGSizeMake(standardSide, standardSide)];
    NSValue *mediumSquareSize = [NSValue valueWithCGSize:CGSizeMake(mediumSide, mediumSide)];
    NSValue *largeSquareSize = [NSValue valueWithCGSize:CGSizeMake(largeSide, largeSide)];

    NSValue *smallPortraitSize = [NSValue valueWithCGSize:CGSizeMake(smallSide / 2.f, smallSide)];
    NSValue *standardPortraitSize = [NSValue valueWithCGSize:CGSizeMake(standardSide / 2.f, standardSide)];
    NSValue *mediumPortraitSize = [NSValue valueWithCGSize:CGSizeMake(mediumSide / 2.f, mediumSide)];
    NSValue *largePortraitSize = [NSValue valueWithCGSize:CGSizeMake(largeSide / 2.f, largeSide)];

    NSValue *smallLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(smallSide, smallSide / 2.f)];
    NSValue *standardLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(standardSide, standardSide / 2.f)];
    NSValue *mediumLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(mediumSide, mediumSide / 2.f)];
    NSValue *largeLandscapeSize = [NSValue valueWithCGSize:CGSizeMake(largeSide, largeSide / 2.f)];

    NSArray *sizesArray = @[mediumSquareSize, mediumLandscapeSize, mediumPortraitSize,
                            smallSquareSize, smallLandscapeSize, smallPortraitSize,
                            largeSquareSize, largeLandscapeSize, largePortraitSize,
                            standardSquareSize, standardLandscapeSize, standardPortraitSize];
    for (NSValue *sizeValue in sizesArray) {
        NSString *title = [NSString stringWithFormat:@"%d x %d", (int)sizeValue.CGSizeValue.width, (int)sizeValue.CGSizeValue.height];
        [self addSection:[self exampleFieldsSectionWithTitle:title
                                                   imageSize:sizeValue.CGSizeValue
                                              thumbnailSizes:thumbnailStyles]];
    }
}

- (AKFormSection *)exampleFieldsSectionWithTitle:(NSString *)title
                                       imageSize:(CGSize)imageSize
                                  thumbnailSizes:(NSArray *)thumbnailSizes
{
    NSMutableArray *fields = [NSMutableArray array];
    for (int i=0; i<thumbnailSizes.count; i++) {
        AKFormFieldImage *field = [AKFormFieldImage fieldWithKey:[NSString stringWithFormat:@"image_%d", i+1]
                                                            title:[NSString stringWithFormat:@"Image %d", i+1]
                                                      placeholder:[NSString stringWithFormat:@"Choose Image %d", i+1]
                                                        imageSize:imageSize
                                                   thumbnailStyle:((NSNumber *)thumbnailSizes[i]).integerValue
                                                   formController:self];
        NSString *failMessage = [NSString stringWithFormat:@"Please choose image %d", i+1];
        AKFormValidator *validator = [AKFormValidator requiredBlockWithFailMessage:failMessage];
        field.validators = @[validator];
        [fields addObject:field];
    }
    
    AKFormSection *section = [[AKFormSection alloc] initWithFields:fields];
    section.headerTitle = title;
    return section;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - Completing a Form

- (IBAction)completeForm:(id)sender
{
    if ([super validateForm]) {
        [[[UIAlertView alloc] initWithTitle:@"Passed"
                                    message:@"Validation Passed"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
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

@end


@interface LeftLabelImageFields : ImageFieldsForm
@end

@implementation LeftLabelImageFields

- (CSFormCellImageLabelStyle)labelStyleForImageCell:(AKFormCellImage *)cell
{
    return CSFormCellImageLabelStyleLeft;
}
@end


@interface RightLabelImageFields : ImageFieldsForm
@end

@implementation RightLabelImageFields

- (CSFormCellImageLabelStyle)labelStyleForImageCell:(AKFormCellImage *)cell
{
    return CSFormCellImageLabelStyleRight;
}
@end