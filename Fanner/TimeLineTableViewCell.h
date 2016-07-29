//
//  TimeLineTableViewCell.h
//  Fanner
//
//  Created by 赵麦 on 7/28/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;
@interface TimeLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
-(void)configureWithStatus:(Status *)status;
@end
