//
//  AKFormFieldImage.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldImage.h"
#import <UIImage+Resize.h>

@interface AKFormFieldImage()
@property(nonatomic, strong) GKImagePicker *imagePicker;
@property(nonatomic, strong) URBMediaFocusViewController *focusViewController;
@end

@implementation AKFormFieldImage

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
             placeholderText:(NSString *)placeholderText
        placeholderImageName:(NSString *)placeholderImageName
                   imageSize:(CGSize)imageSize
              thumbnailStyle:(AKFormCellImageThumbnailStyle)thumbnailStyle
              formController:(AKFormController *)formController
               styleProvider:(id<AKFormCellImageStyleProvider>)styleProvider
{
    return [[AKFormFieldImage alloc] initWithKey:key title:title placeholderText:placeholderText placeholderImageName:placeholderImageName imageSize:imageSize thumbnailStyle:thumbnailStyle formController:formController styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
            placeholderText:(NSString *)placeholderText
       placeholderImageName:(NSString *)placeholderImageName
                  imageSize:(CGSize)imageSize
             thumbnailStyle:(AKFormCellImageThumbnailStyle)thumbnailStyle
             formController:(AKFormController *)formController
            styleProvider:(id<AKFormCellImageStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title placeholder:placeholderText];
    if (self) {
        self.formController = formController;
        self.imageSize = imageSize;
        self.thumbnailStyle = thumbnailStyle;
        self.placeholderImageName = placeholderImageName;
        self.styleProvider = styleProvider;
    }
    return self;
}

/**
 *  Returns an image cell by first attempting to dequeue it from the provided tableView, or creating
 *  one if necessary.
 *
 *  @param tableView The tableView from which to try and dequeue the cell.
 *
 *  @return The image cell casted as a UITableViewcell.
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    AKFormCellImage *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_IMAGE];
    if (!cell) {
        cell = [[AKFormCellImage alloc] initWithStyleProvider:(id)self.formController];
    }

    cell.valueDelegate = self;
    cell.delegate = self;
    cell.styleProvider = self.styleProvider;
    
    cell.imageSize = self.imageSize;
    cell.thumbnailStyle = self.thumbnailStyle;
    cell.placeholderImageName = self.placeholderImageName;
    
    self.cell = cell;
    return cell;
}

//place any cell height dependent code here (as it may not be already set in cell for tableview
- (void)willBeDisplayed
{
    [super willBeDisplayed];
    
    AKFormCellImage *imageCell = (AKFormCellImage *)self.cell;
    if (imageCell) {
        if ([self.value imageValue]) {
            imageCell.label.text = self.title;
            [imageCell fillThumbnailImage:[self.value imageValue]];
        } else {
            imageCell.label.text = self.placeholder;
            [imageCell clearThumbnail];
        }
        
//        self.value = [AKFormValue value:[UIImage imageNamed:@"DummyUserProfile"]
//                               withType:AKFormValueImage];
//        [imageCell fillThumbnailImage:[UIImage imageNamed:@"DummyUserProfile"]];
    }
}

#pragma mark - Selecting an Image Field

- (void)select
{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = self.imageSize;
    self.imagePicker.delegate = self;
    [self.imagePicker showActionSheetOnViewController:(UIViewController *)self.formController
                                    onPopoverFromView:nil];
}

- (NSString *)labelStringForImageCell:(AKFormCellImage *)cell
{
    return self.title;
}

- (NSString *)placeholderStringForImageCell:(AKFormCellImage *)cell
{
    return self.placeholder;
}

- (void)didTapThumbnailOnImageCell:(AKFormCellImage *)cell
{
    if (self.value && [self.value isImage]) {
        UINavigationController *navigationController = ((UIViewController *)self.formController).navigationController;
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        self.focusViewController = [[URBMediaFocusViewController alloc] init];
        self.focusViewController.parallaxMode = YES;
        self.focusViewController.delegate = self;
        [self.focusViewController showImage:[self.value imageValue]
                                   fromView:cell.thumbnail
                           inViewController:navigationController];
    } else {
        [self select];
    }
}

#pragma mark - URBMediaFocusViewControllerDelegate

- (void)mediaFocusViewControllerDidDisappear:(URBMediaFocusViewController *)mediaFocusViewController
{
    UINavigationController *navigationController = ((UIViewController *)self.formController).navigationController;
    navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - GKImagePickerDelegate

- (void)updateThumbnailWithImage:(UIImage *)image
{
    if (self.cell && [self.cell isKindOfClass:[AKFormCellImage class]]) {
        AKFormCellImage *imageCell = (AKFormCellImage *)self.cell;
        [imageCell fillThumbnailImage:image];
        
        imageCell.label.text = self.title;
    }
}

- (void)__resizeAndSaveImage:(UIImage *)image
{
    image = [image resizedImageToFitInSize:self.imageSize scaleIfSmaller:YES];
    self.value = [AKFormValue value:image withType:AKFormValueImage];
    [self performSelectorOnMainThread:@selector(updateThumbnailWithImage:) withObject:image waitUntilDone:NO];
}

- (void)didPickImage:(UIImage *)image
{
    self.value = [AKFormValue value:image withType:AKFormValueImage];
    [self performSelectorInBackground:@selector(__resizeAndSaveImage:) withObject:image];
    [self updateThumbnailWithImage:image];
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    [self didPickImage:image];
}

@end
