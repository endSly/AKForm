//
//  AKFormFieldImage.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldDescriptive.h"
#import "AKFormCellImage.h"

#import "GKImagePicker.h"

@class  AKFormController;

@interface AKFormFieldImage : AKFormFieldDescriptive <UIImagePickerControllerDelegate, GKImagePickerDelegate, CSFormCellImageDelegate>

@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) CSFormCellImageThumbnailStyle thumbnailStyle;

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
                 placeholder:(NSString *)placeholder
                   imageSize:(CGSize)imageSize
              thumbnailStyle:(CSFormCellImageThumbnailStyle)thumbnailStyle
              formController:(AKFormController *)formController;

- (void)select;

@end
