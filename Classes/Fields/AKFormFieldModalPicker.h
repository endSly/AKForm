//
//  AKFormFieldModalPicker.h
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldModal.h"

@interface AKFormFieldModalPicker : AKFormFieldModal <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) BOOL multiplePicks;
@property(nonatomic, strong) UIColor *checkmarkTintColor;
@property(nonatomic, strong) AKFormMetadataCollection *dirtyMetadataCollection;

- (void)updateLabelCell;

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                 placeholder:(NSString *)placeholder
          metadataCollection:(AKFormMetadataCollection *)metadataCollection
               multiplePicks:(BOOL)multiplePicks
               styleProvider:(id<AKFormCellLabelStyleProvider>)styleProvider;

@end
