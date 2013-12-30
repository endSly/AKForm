//
//  AKFormFieldImage.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormField.h"
#import "AKFormCellImage.h"

#import "GKImagePicker.h"
#import "URBMediaFocusViewController.h"

@class  AKFormController;

@interface AKFormFieldImage : AKFormField <UIImagePickerControllerDelegate, GKImagePickerDelegate, AKFormCellImageDelegate, URBMediaFocusViewControllerDelegate>

@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) AKFormCellImageThumbnailStyle thumbnailStyle;
@property(nonatomic, strong) NSString *placeholderImageName;
@property(nonatomic, weak) AKFormController *formController;

/// Things to Note
/// Image thumbnail will allow as much space as possible for the label while making sure it is still visible,
// so just make sure your labels aren't too long

///---------------------------------------------------------------------------------------
/// @name Managing the cell's label
///---------------------------------------------------------------------------------------


/**
 *
 *
 *  @param key
 *  @param title
 *  @param placeholder
 *  @param imageSize        The size of the image required. The image stored as the value
                            will be exactly what was expected, so expect up/down scaling
                            depending on the size of the original image.
 *  @param thumbnailStyle
 *  @param formController
 *
 *  @return
 */
+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
             placeholderText:(NSString *)placeholderText
        placeholderImageName:(NSString *)placeholderImageName
                   imageSize:(CGSize)imageSize
              thumbnailStyle:(AKFormCellImageThumbnailStyle)thumbnailStyle
              formController:(AKFormController *)formController;

- (void)select;

@end
