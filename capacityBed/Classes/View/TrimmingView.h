//
//  TrimmingView.h
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/24.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  TrimmingViewDelegate   <NSObject>

-(void)clickUpdateButton:(UIButton *)sender;

-(void)clickDownButton:(UIButton *)sender;


-(void)clickStopButton:(UIButton *)sender;
@end

@interface TrimmingView : UIView

@property (nonatomic, strong) UIImageView * stateImageView;
@property (nonatomic, strong) UIImageView * backImgV;

@property (nonatomic, strong) UIButton  *downButton;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) id <TrimmingViewDelegate> delegate;



@property(nonatomic,strong)void(^clickblock)(NSInteger index);//0 开始  1停止

@end
