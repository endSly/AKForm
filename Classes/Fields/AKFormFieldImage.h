//
//  AKFormFieldImage.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldDescriptive.h"
#import "AKFormCellImage.h"

#import "GKImagePicker.h"

@protocol CSFormFieldImageDelegate
- (void)didPickImageOnField:(AKFormField *)row;
- (UIViewController  *)viewControllerToPresentOn;
@end

@interface AKFormFieldImage : AKFormFieldDescriptive <UIImagePickerControllerDelegate, GKImagePickerDelegate, CSFormCellImageDelegate>

@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) CSFormCellImageThumbnailStyle thumbnailStyle;

@property(nonatomic, strong) id<CSFormFieldImageDelegate>delegate;
@property(nonatomic, weak) id<CSFormCellImageStyleProvider>styleProvider;

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
 *  @param delegate
 *  @param styleProvider
 *
 *  @return
 */
- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
                  imageSize:(CGSize)imageSize
             thumbnailStyle:(CSFormCellImageThumbnailStyle)thumbnailStyle
                   delegate:(id<CSFormFieldImageDelegate>)delegate
              styleProvider:(id<CSFormCellImageStyleProvider>)styleProvider;

- (void)select;

@end
