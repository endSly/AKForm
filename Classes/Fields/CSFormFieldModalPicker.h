//
//  CSFormFieldModalPicker.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldModal.h"

@protocol CSFormFieldModalPickerDelegate
- (void)didSelectItemOnModalPicker;
@end

@interface CSFormFieldModalPicker : CSFormFieldModal <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) id<CSFormFieldModalPickerDelegate> delegate;

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
         metadataCollection:(AKFormMetadataCollection *)metadataCollection
                   delegate:(id<CSFormFieldModalPickerDelegate>)delegate;

@end
