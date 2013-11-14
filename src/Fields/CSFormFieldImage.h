//
//  CSFormFieldImage.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldDescriptive.h"
#import "CSFormCellImage.h"

#import "GKImagePicker.h"

@protocol CSFormFieldImageDelegate
- (void)didPickImageOnField:(CSFormField *)row;
- (UIViewController  *)viewControllerToPresentOn;
@end

@interface CSFormFieldImage : CSFormFieldDescriptive <UIImagePickerControllerDelegate, GKImagePickerDelegate, CSFormCellImageDelegate>

@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) CSFormCellImageThumbnailStyle thumbnailStyle;

@property(nonatomic, strong) id<CSFormFieldImageDelegate>delegate;
@property(nonatomic, weak) id<CSFormCellImageStyleProvider>styleProvider;

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
                  imageSize:(CGSize)imageSize
             thumbnailStyle:(CSFormCellImageThumbnailStyle)thumbnailStyle
                   delegate:(id<CSFormFieldImageDelegate>)delegate
              styleProvider:(id<CSFormCellImageStyleProvider>)styleProvider;

- (void)select;

@end
