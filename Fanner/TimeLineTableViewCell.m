//
//  TimeLineTableViewCell.m
//  Fanner
//
//  Created by 赵麦 on 7/28/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "User.h"
#import <UIImageView+WebCache.h>
#import "Status+CoreDataProperties.h"
#import <DTCoreText/DTCoreText.h>

@implementation TimeLineTableViewCell

-(void)configureWithStatus:(Status *)status {
    self.nameLabel.text = status.user.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSFormattingUnitStyleShort;
    formatter.timeStyle = NSFormattingUnitStyleShort;
    
    self.publishLabel.text = [formatter stringFromDate:status.created_at ];
//    self.contentLabel.text = status.text;
    NSDictionary *options = @{DTDefaultFontName:@"HelveticaNeue-Light",
                              DTDefaultFontSize:@16,
                              DTDefaultLinkColor:[UIColor yellowColor]};
    NSAttributedString *attribStr = [[NSAttributedString alloc] initWithHTMLData:[status.text dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil];
    self.contentLabel.attributedString = attribStr;
    self.contentLabel.numberOfLines = 0;
    
                                          
                                          
    NSURL *url = [NSURL URLWithString:status.user.iconURL];
    [self.iconImage sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"]
                               options:SDWebImageRefreshCached];
    
    NSURL *photoUrl = [NSURL URLWithString:status.photo.imageurl];
    if (status.photo.imageurl) {
        _imageHeight.constant = 200;
        [self.photoImageView sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"BackgroundImage"] options:SDWebImageProgressiveDownload];
    } else {
//        [self.photoImageView sd_setImageWithURL:photoUrl placeholderImage:nil options:SDWebImageProgressiveDownload];
        _imageHeight.constant = 0;
    }
    
}

//IBAction is a method that needs add to .m
- (IBAction)showLargePhoto:(UIButton *)sender {
    _didSelectPhotoBlock(self);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
