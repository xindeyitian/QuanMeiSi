//
//  KneadView.h
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/28.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  KneadViewDelegate   <NSObject>

-(void)selectedTime:(UIButton *)tapBtn;




-(void)clickReduceButton:(UIButton *)sender;

-(void)clickAddButton:(UIButton *)sender;

@end

@interface KneadView : UIView

@property (nonatomic, strong) id <KneadViewDelegate > delegate;

@property (nonatomic, assign) float frequencyValue;//按摩频率
@property (nonatomic, assign) float headValue;//头部按摩
@property (nonatomic, assign) float footValue;//足部按摩

@property (nonatomic, strong) UITapGestureRecognizer * currentTap;//当前选择的时间


@property (nonatomic, strong) UIButton * timeBtn;//当前选择的时间


@end
