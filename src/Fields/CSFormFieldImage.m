//
//  CSFormFieldImage.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldImage.h"
#import "URBMediaFocusViewController.h"
#import <UIImage+Resize.h>

@interface CSFormFieldImage()
@property(nonatomic, strong) GKImagePicker *imagePicker;
@property(nonatomic, strong) URBMediaFocusViewController *focusViewController;
@end

@implementation CSFormFieldImage

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
                  imageSize:(CGSize)imageSize
             thumbnailStyle:(CSFormCellImageThumbnailStyle)thumbnailStyle
                   delegate:(id<CSFormFieldImageDelegate>)delegate
              styleProvider:(id<CSFormCellImageStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title placeholder:placeholder];
    if (self) {
        self.delegate = delegate;
        self.styleProvider = styleProvider;
        
        self.imageSize = imageSize;
        self.thumbnailStyle = thumbnailStyle;
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
    CSFormCellImage *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_IMAGE];
    if (!cell) {
        cell = [[CSFormCellImage alloc] initWithStyleProvider:self.styleProvider];
    }

    cell.valueDelegate = self;
    cell.delegate = self;

    cell.imageSize = self.imageSize;
    cell.thumbnailStyle = self.thumbnailStyle;
    
    self.cell = cell;
    return cell;
}

//place any cell height dependent code here (as it may not be already set in cell for tableview
- (void)willBeDisplayed
{
    [super willBeDisplayed];
    
    CSFormCellImage *imageCell = (CSFormCellImage *)self.cell;
    if (imageCell) {
        if ([self.value imageValue]) {
            imageCell.label.text = self.title;
            [imageCell fillThumbnailImage:[self.value imageValue]];
        } else {
            imageCell.label.text = self.placeholder;
            [imageCell clearThumbnail];
        }
        
//        self.value = [CSFormValue value:[UIImage imageNamed:@"DummyUserProfile"]
//                               withType:CSFormValueImage];
//        [imageCell fillThumbnailImage:[UIImage imageNamed:@"DummyUserProfile"]];
    }
}

#pragma mark - Selecting an Image Field

- (void)select
{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = self.imageSize;
    self.imagePicker.delegate = self;
    [self.imagePicker showActionSheetOnViewController:[self.delegate viewControllerToPresentOn]
                                    onPopoverFromView:nil];
}

- (NSString *)labelStringForLabelCell:(CSFormCellImage *)cell
{
    return self.title;
}

- (NSString *)placeholderStringForLabelCell:(CSFormCellImage *)cell
{
    return self.placeholder;
}

- (void)didTapThumbnailOnImageCell:(CSFormCellImage *)cell
{
    if (self.value && [self.value isImage]) {
        self.focusViewController = [[URBMediaFocusViewController alloc] init];
        self.focusViewController.parallaxMode = YES;
        [self.focusViewController showImage:[self.value imageValue]
                                   fromView:cell.thumbnail
                           inViewController:[self.delegate viewControllerToPresentOn]];
    } else {
        [self select];
    }
}

#pragma mark - GKImagePickerDelegate

- (void)updateThumbnailWithImage:(UIImage *)image
{
    if (self.cell && [self.cell isKindOfClass:[CSFormCellImage class]]) {
        CSFormCellImage *imageCell = (CSFormCellImage *)self.cell;
        [imageCell fillThumbnailImage:image];
        
        imageCell.label.text = self.title;
    }
}

- (void)__resizeAndSaveImage:(UIImage *)image
{
    image = [image resizedImageToFitInSize:self.imageSize scaleIfSmaller:YES];
    self.value = [CSFormValue value:image withType:CSFormValueImage];
    [self performSelectorOnMainThread:@selector(updateThumbnailWithImage:) withObject:image waitUntilDone:NO];
}

- (void)didPickImage:(UIImage *)image
{
    self.value = [CSFormValue value:image withType:CSFormValueImage];
    [self performSelectorInBackground:@selector(__resizeAndSaveImage:) withObject:image];
    [self updateThumbnailWithImage:image];
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    [self didPickImage:image];
}

@end
