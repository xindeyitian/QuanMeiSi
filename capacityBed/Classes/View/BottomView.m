//
//  BottomView.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/27.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "BottomView.h"

@interface  BottomView ()

@property (nonatomic, strong)UIButton * currentButton;

@end

@implementation BottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    NSArray * titleArray=@[@"SHORTCUT",@"MICRO ADJ",@"MASS",@"LIGHT"];
    for (int i = 0; i<titleArray.count; i++) {
        UIButton * button=[[UIButton alloc] initWithFrame:CGRectMake(kScreenwidth/4*i, 0, kScreenwidth/4, 52*kScreenscale)];
        [button setTitle:Localized(titleArray[i]) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:60.0f/255.0f green:55.0f/255.0f blue:61.0f/255.0f alpha:1.0f]];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        if (i==0) {
            self.currentButton=button;
            [button setBackgroundColor:[UIColor colorWithRed:110.0f/255.0f green:65.0f/255.0f blue:253.0f/255.0f alpha:1.0f]];
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i+1;
        [self addSubview:button];
    }
    
}

-(void)clickButton:(UIButton *)sender{
    [self.currentButton setBackgroundColor:[UIColor colorWithRed:60.0f/255.0f green:55.0f/255.0f blue:61.0f/255.0f alpha:1.0f]];
    self.currentButton=sender;
    [sender setBackgroundColor:[UIColor colorWithRed:110.0f/255.0f green:65.0f/255.0f blue:253.0f/255.0f alpha:1.0f]];
    self.block(sender.tag);
}

@end
