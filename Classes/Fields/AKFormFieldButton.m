//
//  AKFormFieldButton.m
//  AKForm
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "AKFormFieldButton.h"

@implementation AKFormFieldButton

+ (instancetype)fieldWithKey:(NSString *)key
                       title:(NSString *)title
                    subtitle:(NSString *)subtitle
                       image:(UIImage *)image
                    delegate:(id<AKFormCellButtonDelegate>)delegate
               styleProvider:(id<AKFormCellButtonStyleProvider>)styleProvider
{
    return [[AKFormFieldButton alloc] initWithKey:key
                                            title:title
                                         subtitle:subtitle
                                            image:image
                                         delegate:delegate
                                    styleProvider:styleProvider];
}

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                   subtitle:(NSString *)subtitle
                      image:(UIImage *)image
                   delegate:(id<AKFormCellButtonDelegate>)delegate
              styleProvider:(id<AKFormCellButtonStyleProvider>)styleProvider
{
    self = [super initWithKey:key title:title placeholder:nil];
    if (self) {
        self.delegate = delegate;
        self.styleProvider = styleProvider;
        
        self.title = title;
        self.subtitle = subtitle;
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

/**
 *  Returns a field cell by first attempting to dequeue it from the provided tableView, or creating
 *  one if necessary.
 *
 *  @param tableView The tableView from which to try and dequeue the cell.
 *  @return The field cell casted as a UITableViewcell.
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    AKFormCellButton *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_TEXTFIELD];
    if (!cell) {
        cell = [[AKFormCellButton alloc] initWithStyleProvider:self.styleProvider];
    }
    
    cell.delegate = self.delegate;
    cell.valueDelegate = self;
    
    cell.selectionStyle = self.selectionStyle;
    cell.accessoryType = self.accessoryType;
    
    cell.label.text = self.title;
    cell.detailLabel.text = self.subtitle;
    [cell.icon setImage:self.image];
    
    //now rearrange the layout!
    [cell layoutSubviews];
    
    self.cell = cell;
    return cell;
}

@end
