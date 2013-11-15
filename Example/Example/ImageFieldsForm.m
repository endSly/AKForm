//
//  ImageFieldsForm.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "ImageFieldsForm.h"
#import <AKForm.h>

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"

@interface ImageFieldsForm () <CSFormDelegate, CSFormCellImageStyleProvider>
@property(nonatomic, strong) AKForm *form;
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
    self.form = [[AKForm alloc] init];
    self.form.tableView = self.tableView;
    self.form.viewController = self;
    
    self.tableView.dataSource = self.form;
    self.tableView.delegate = self.form;
    
    AKFormSection *s1 = [[AKFormSection alloc] initWithFields:[self debugFieldsWithThumbnailStyle:CSFormCellImageThumbnailStyleCircle]];
    s1.headerTitle = @"YOUR DETAILS";
    [self.form addSection:s1];
}

- (NSArray *)debugFieldsWithThumbnailStyle:(CSFormCellImageThumbnailStyle)thumbnailStyle
{
    AKFormFieldImage *field = [[AKFormFieldImage alloc] initWithKey:@"profile_photo"
                                                              title:@"Avatar"
                                                        placeholder:@"Choose a profile photo"
                                                          imageSize:CGSizeMake(640, 640)
                                                     thumbnailStyle:thumbnailStyle
                                                           delegate:self.form
                                                      styleProvider:self];
    AKFormValueValidator *requiredValidator = [AKFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field.validators = @[requiredValidator];
    
    AKFormFieldImage *field2 = [[AKFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(600, 234)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    AKFormValueValidator *requiredValidator2 = [AKFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field2.validators = @[requiredValidator2];
    
    AKFormFieldImage *field3 = [[AKFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(320, 320)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    AKFormValueValidator *requiredValidator3 = [AKFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field3.validators = @[requiredValidator3];
    
    AKFormFieldImage *field4 = [[AKFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(640, 640)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    AKFormValueValidator *requiredValidator4 = [AKFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field4.validators = @[requiredValidator4];
    
    AKFormFieldImage *field5 = [[AKFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(50, 80)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    AKFormValueValidator *requiredValidator5 = [AKFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field5.validators = @[requiredValidator5];
    
    AKFormFieldImage *field6 = [[AKFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(80, 30)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    AKFormValueValidator *requiredValidator6 = [AKFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field6.validators = @[requiredValidator6];
    
    return @[field, field2];
    //    return @[field, field2, field3, field4, field5, field6];
}

#pragma mark - CSFormCellImageStyleProvider

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
