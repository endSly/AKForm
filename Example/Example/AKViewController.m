//
//  AKViewController.m
//  Example
//
//  Created by Ahmed Khalaf on 14/11/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKViewController.h"
#import <AKForm.h>

#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"

@interface AKViewController () <CSFormDelegate, CSFormCellImageStyleProvider>
@property(nonatomic, strong) CSForm *form;
@end

@implementation AKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createForm];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Form Creation

- (void)createForm
{
    self.form = [[CSForm alloc] init];
    self.form.tableView = self.tableView;
    self.form.viewController = self;
    
    self.tableView.dataSource = self.form;
    self.tableView.delegate = self.form;
    
    CSFormSection *s1 = [[CSFormSection alloc] initWithFields:[self debugFieldsWithThumbnailStyle:CSFormCellImageThumbnailStyleCircle]];
    s1.headerTitle = @"YOUR DETAILS";
    [self.form addSection:s1];
}

- (NSArray *)debugFieldsWithThumbnailStyle:(CSFormCellImageThumbnailStyle)thumbnailStyle
{
    CSFormFieldImage *field = [[CSFormFieldImage alloc] initWithKey:@"profile_photo"
                                                              title:@"Avatar"
                                                        placeholder:@"Choose a profile photo"
                                                          imageSize:CGSizeMake(640, 640)
                                                     thumbnailStyle:thumbnailStyle
                                                           delegate:self.form
                                                      styleProvider:self];
    CSFormValueValidator *requiredValidator = [CSFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field.validators = @[requiredValidator];
    
    CSFormFieldImage *field2 = [[CSFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(600, 234)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    CSFormValueValidator *requiredValidator2 = [CSFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field2.validators = @[requiredValidator2];
    
    CSFormFieldImage *field3 = [[CSFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(320, 320)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    CSFormValueValidator *requiredValidator3 = [CSFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field3.validators = @[requiredValidator3];
    
    CSFormFieldImage *field4 = [[CSFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(640, 640)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    CSFormValueValidator *requiredValidator4 = [CSFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field4.validators = @[requiredValidator4];
    
    CSFormFieldImage *field5 = [[CSFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(50, 80)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    CSFormValueValidator *requiredValidator5 = [CSFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field5.validators = @[requiredValidator5];
    
    CSFormFieldImage *field6 = [[CSFormFieldImage alloc] initWithKey:@"profile_photo"
                                                               title:@"Avatar"
                                                         placeholder:@"Choose a profile photo"
                                                           imageSize:CGSizeMake(80, 30)
                                                      thumbnailStyle:thumbnailStyle
                                                            delegate:self.form
                                                       styleProvider:self];
    CSFormValueValidator *requiredValidator6 = [CSFormValueValidator blockForRequiredImageWithMessage:@"Please choose a profile picture"];
    field6.validators = @[requiredValidator6];
    
    return @[field, field2];
    //    return @[field, field2, field3, field4, field5, field6];
}

#pragma mark - CSFormCellImageStyleProvider

- (UIFont *)imageCell:(CSFormCellImage *)cell labelFontForMode:(CSFormCellImageMode)mode
{
    return [UIFont systemFontOfSize:17.f];
}

- (UIColor *)imageCell:(CSFormCellImage *)cell labelTextColorForMode:(CSFormCellImageMode)mode
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

- (UIImage *)placeholderImageForImageCell:(CSFormCellImage *)cell
{
    return [UIImage imageNamed:@"PlaceholderProfile2"];
}

- (CGFloat)heightForImageCell:(CSFormCellImage *)cell
{
    return 100.f;
}

- (CSFormCellImageLabelStyle)labelStyleForImageCell:(CSFormCellImage *)cell
{
    return CSFormCellImageLabelStyleLeft;
}

@end
