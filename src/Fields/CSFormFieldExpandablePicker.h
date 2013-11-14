//
//  CSFormFieldExpandablePicker.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldExpandable.h"

@interface CSFormFieldExpandablePicker : CSFormFieldExpandable <CSFormCellPickerViewDelegate>

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                placeholder:(NSString *)placeholder
         metadataCollection:(CSMetadataCollection *)metadataCollection
              styleProvider:(id<CSFormCellLabelStyleProvider>)styleProvider;

@end
