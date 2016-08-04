//
//  CellToolBarView.h
//  Fanner
//
//  Created by 赵麦 on 8/2/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellToolBarView;
@protocol CellToolBarDelegate

-(void)starWithCellTollBarView:(CellToolBarView *)toolBar sender:(id)sender forEvent:(UIEvent *)event;
-(void)unstarWithCellTollBarView:(CellToolBarView *)toolBar sender:(id)sender forEvent:(UIEvent *)event;


@end

@interface CellToolBarView : UIView
@property (nonatomic, weak) id <CellToolBarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;

-(void)setupStarButtonWithBool:(Boolean)favorited;

@end
