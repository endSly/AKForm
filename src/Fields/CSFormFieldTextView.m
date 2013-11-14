//
//  CSFormFieldTextView.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 30/10/2013.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormFieldTextView.h"

#define DEFAULT_TEXTVIEW_HEIGHT     150.f
#define HEX_COLOR_GREY_PLACEHOLDER  @"#ccccd1"

@implementation CSFormFieldTextView

- (instancetype)initWithKey:(NSString *)key
                placeholder:(NSString *)placeholder
{
    self = [super initWithKey:key title:nil placeholder:placeholder];
    if (self) {
        self.textViewHeight = DEFAULT_TEXTVIEW_HEIGHT;
    }
    
    return self;
}

/**
 *  Returns a text view cell by first attempting to dequeue it from the provided tableView, or creating
 *  one if necessary.
 *
 *  @param tableView The tableView from which to try and dequeue the cell.
 *  @return The text view cell casted as a UITableViewcell.
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView
{
    CSFormTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_TEXTVIEW];
    if (!cell) {
        cell = [[CSFormTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CELL_IDENTIFIER_TEXTVIEW];
    }
    
    cell.textView.delegate = self;
    cell.textViewHeight = self.textViewHeight;
    
    if ([self.value stringValue] && [[self.value stringValue] length] > 0) {
        cell.textView.textColor = [UIColor blackColor];
        cell.textView.text = [self.value stringValue];
    } else {
        cell.textView.textColor = [UIColor colorWithHexString:HEX_COLOR_GREY_PLACEHOLDER];
        cell.textView.text = self.placeholder;
    }
    
    self.cell = cell;
    return cell;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.textColor isEqual:[UIColor colorWithHexString:HEX_COLOR_GREY_PLACEHOLDER]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.value = [CSFormValue value:textView.text withType:CSFormValueString];
}

@end
