//
//  CSFormSwitchCell.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormSwitchCell.h"

@implementation CSFormSwitchCell

#pragma mark - Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
        
        self.switchContainerView = [[UIView alloc] init];
        [self.contentView addSubview:self.switchContainerView];
        
        self.switchControl = [[UISwitch alloc] init];
        [self.switchContainerView addSubview:self.switchControl];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                              action:@selector(tappedCell:)];
//        [self.contentView addGestureRecognizer:tgr];
    }
    return self;
}

#pragma mark - Inherited Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = [self leftViewFrame];
    self.switchContainerView.frame = [self rightViewFrame];
    
    //right align switch within container
    CGSize switchSize = self.switchControl.frame.size;
    CGSize containerSize = self.switchContainerView.frame.size;
    CGRect switchFrame = CGRectMake(containerSize.width - switchSize.width,
                                    (containerSize.height / 2.0) - (switchSize.height / 2.0),
                                    switchSize.width,
                                    switchSize.height);
    self.switchControl.frame = switchFrame;
}

- (void)setLabelString:(NSString *)labelString
{
    [super setLabelString:labelString];
    self.label.text = self.labelString;
    [self setLeftViewSize:[self sizeForLabel]];
    
    [self layoutSubviews];
}

#pragma mark - Actions

- (void)tappedCell:(id)sender
{
    [self.switchControl setOn:!self.switchControl.on animated:YES];
}

@end
