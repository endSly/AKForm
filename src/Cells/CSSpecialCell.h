//
//  CSSpecialCell.h
//  CitySwagga
//
//  Created by Ahmed Khalaf on 16/10/13.
//  Copyright (c) 2013 arkuana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSSpecialCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *picImageView;
@property(nonatomic, strong) IBOutlet UILabel *venueNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *specialTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel *usesLeftLabel;
@property(nonatomic, strong) IBOutlet UILabel *expiryLabel;

@end
