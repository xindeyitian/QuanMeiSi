//
//  TrimmingView.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/24.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "TrimmingView.h"

@implementation TrimmingView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{

    self.layer.cornerRadius = 8;
    self.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
    self.alpha = 1;
    
    //Gradient 0 fill for 圆角矩形 1 拷贝 2
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 7.5;
    gradientLayer0.frame = self.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:73.0f/255.0f green:65.0f/255.0f blue:72.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:52.0f/255.0f green:50.0f/255.0f blue:53.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 0)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [self.layer addSublayer:gradientLayer0];
    
    
    
    self.backImgV = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backImgV.image = [UIImage imageNamed:@"不下沉按钮"];
    self.backImgV.clipsToBounds =1;
    self.backImgV.layer.cornerRadius = 4;
    [self addSubview:self.backImgV];
    
    
    self.backImgV.userInteractionEnabled  =1;
    UILongPressGestureRecognizer * longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)];
    longPress2.minimumPressDuration =0.01;
    [self.backImgV addGestureRecognizer:longPress2];
    
    
    
    
    self.upButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54*kScreenscale, 60*kScreenscale)];
    [self.upButton setImage:kxImageNameWith(@"多边形1") forState:UIControlStateNormal];
    
    
    self.upButton.userInteractionEnabled = 1;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickUpdateButton:)];
    longPress.minimumPressDuration =0.01;
    [self.upButton addGestureRecognizer:longPress];
    
    [self addSubview:self.upButton];
    
    
    
    
    
    
    
    
    
    self.stateImageView=[[UIImageView alloc] initWithFrame:CGRectMake(54*kScreenscale, 16*kScreenscale, 54*kScreenscale, 28*kScreenscale)];
    self.stateImageView.image=kxImageNameWith(@"");
    self.stateImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:self.stateImageView];
    
    
    
    
    
    
    
    self.downButton=[[UIButton alloc] initWithFrame:CGRectMake(108*kScreenscale, 0, 54*kScreenscale, 60*kScreenscale)];
    [self.downButton setImage:kxImageNameWith(@"多边形1拷贝") forState:UIControlStateNormal];
  
    self.downButton.userInteractionEnabled = 1;
    UILongPressGestureRecognizer * longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickDownButton:)];
    longPress1.minimumPressDuration =0.01;
    [self.downButton addGestureRecognizer:longPress1];
    [self addSubview:self.downButton];
}

-(void)clickUpdateButton:(UILongPressGestureRecognizer *)longPresss
{
    
    if (longPresss.state  == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(clickStopButton:)]) {
            [self.delegate clickStopButton:(UIButton*)[longPresss view]];
        }
    }else if (longPresss.state  == UIGestureRecognizerStateBegan)
    {
        if ([self.delegate respondsToSelector:@selector(clickUpdateButton:)]) {
            [self.delegate clickUpdateButton:(UIButton*)[longPresss view]];
        }
    }
}

-(void)clickDownButton:(UILongPressGestureRecognizer *)longPresss{
    
    
    if (longPresss.state  == UIGestureRecognizerStateEnded)
    {
        
        if ([self.delegate respondsToSelector:@selector(clickStopButton:)]) {
            [self.delegate clickStopButton:(UIButton*)[longPresss view]];
        }
    }else if (longPresss.state  == UIGestureRecognizerStateBegan)
    {
        if ([self.delegate respondsToSelector:@selector(clickDownButton:)]) {
            [self.delegate clickDownButton:(UIButton*)[longPresss view]];
        }
    }
   
}


-(void)clickButton:(UILongPressGestureRecognizer *)longPresss
{
    
    if (longPresss.state  == UIGestureRecognizerStateEnded)
    {
        NSLog(@"高亮结束");
        if (_clickblock)
        {
            _clickblock(1);
        }
    }else if (longPresss.state  == UIGestureRecognizerStateBegan)
    {
        NSLog(@"高亮开始");
        if (_clickblock)
        {
            _clickblock(0);
        }
    }
}



@end
