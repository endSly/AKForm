//
//  CSFormTextViewCell.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormTextViewCell.h"

@implementation CSFormTextViewCell

#pragma mark - Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textView = [[UITextView alloc] init];
        self.textView.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:self.textView];
     
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tappedCell:)];
        [self.contentView addGestureRecognizer:tgr];        
    }
    return self;
}

#pragma mark - Inherited Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setLeftViewHeight:self.textViewHeight];
    self.textView.frame = [self leftViewFrame];
}

#pragma mark - Actions

- (void)tappedCell:(id)sender
{
    [self.textView becomeFirstResponder];
}

@end
