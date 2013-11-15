//
//  CSFormToggleCell.m
//  CitySwagga
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import "CSFormToggleCell.h"

@implementation CSFormToggleCell

#pragma mark - Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
        
        self.containerView = [[UISegmentedControl alloc] init];
        [self.contentView addSubview:self.containerView];
        
        self.segmentedControl = [[UISegmentedControl alloc] init];
        [self.containerView addSubview:self.segmentedControl];
        
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
    self.containerView.frame = [self rightViewFrame];

    //restrict to size to what's available
    CGSize controlSize = self.segmentedControl.frame.size;
    controlSize = CGSizeMake(MIN(controlSize.width, self.containerView.frame.size.width),
                             controlSize.height);
    
    //right align switch within container
    CGSize containerSize = self.containerView.frame.size;
    CGRect controlFrame = CGRectMake(containerSize.width - controlSize.width,
                                    (containerSize.height / 2.0) - (controlSize.height / 2.0),
                                    controlSize.width,
                                    controlSize.height);
    self.segmentedControl.frame = controlFrame;
}

- (void)recreateSegmentedControlWithItems:(NSArray *)items
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [self.containerView addSubview:self.segmentedControl];    
    [self layoutSubviews];
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
//    [self.switchControl setOn:!self.switchControl.on animated:YES];
}

@end
