//
//  CellToolBarView.m
//  Fanner
//
//  Created by 赵麦 on 8/2/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "CellToolBarView.h"

@implementation CellToolBarView

- (IBAction)reply:(id)sender forEvent:(UIEvent *)event {
    
}

- (IBAction)star:(id)sender forEvent:(UIEvent *)event {
    [_delegate starWithCellTollBarView:self sender:sender forEvent:event];
}

- (IBAction)repost:(id)sender forEvent:(UIEvent *)event {

}

-(void)setupStarButtonWithBool:(Boolean)favorited {

    if (favorited) {
        [_starBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    } else {
        [_starBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    
}


@end
