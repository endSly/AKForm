//
//  AKFormFieldExpandablePicker.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldExpandable.h"

@interface AKFormFieldExpandablePicker : AKFormFieldExpandable <CSFormCellPickerViewDelegate>

@property(nonatomic, strong) NSString *formatString;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
          metadataCollection:(AKFormMetadataCollection *)metadataCollection
               styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider;

@end
