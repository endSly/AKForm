//
//  CSFormCellPickerView.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 8/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormCellPickerView.h"

@implementation CSFormCellPickerView

#pragma mark - Initializers

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_PICKER];
    if (self) {
        self.pickerView = [[UIPickerView alloc] init];
        [self.contentView addSubview:self.pickerView];

        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.metadataCollection numberOfComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.metadataCollection numberOfMetadataForComponent:component];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CSMetadata *metadata = [self.metadataCollection metadataAtIndex:row inComponent:component];
    if (metadata) {
        return metadata.name;
    } else {
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //save the value
    CSMetadata *metadata = [self.metadataCollection metadataAtIndex:row inComponent:component];
    if ([self.metadataCollection isSingular]) {
        if (self.valueDelegate && [self.valueDelegate respondsToSelector:@selector(didInputValue:)]) {
            [self.valueDelegate didInputValue:[CSFormValue value:metadata withType:CSFormValueMetadata]];
        }
    } else {
        if (self.valueDelegate && [self.valueDelegate respondsToSelector:@selector(didSelectMetadata:inComponent:)]) {
            [self.valueDelegate didSelectMetadata:metadata inComponent:component];
        }
    }
    
    //tell the form about it so it may make changes elsewhere (like in the label representing this)
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeValueForPickerViewCell:)]) {
        [self.delegate didChangeValueForPickerViewCell:self];
    }
}

@end
