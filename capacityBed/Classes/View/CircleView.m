//
//  CircleView.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "CircleView.h"
@interface CircleView()

@property (nonatomic, strong)UILabel * functionLabel;
@property (nonatomic, strong)UIView * greenView;

@end

@implementation CircleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    //Gradient 0 fill for 椭圆 2
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.frame = self.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:74.0f/255.0f green:70.0f/255.0f blue:74.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:52.0f/255.0f green:50.0f/255.0f blue:52.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 0)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [self.layer addSublayer:gradientLayer0];
    
    self.greenView=[[UIView alloc] initWithFrame:CGRectMake(44*kScreenscale, 13*kScreenscale, 16*kScreenscale, 16*kScreenscale)];
    self.greenView.backgroundColor = [UIColor greenColor];
    self.greenView.layer.masksToBounds=YES;
    self.greenView.layer.cornerRadius=8*kScreenscale;
    [self addSubview:self.greenView];
    
    self.functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 43*kScreenscale, 100*kScreenscale, 16*kScreenscale)];
    self.functionLabel.text=@"看电视";
    self.functionLabel.textColor=[UIColor whiteColor];
    self.functionLabel.textAlignment=NSTextAlignmentCenter;
    self.functionLabel.font=[UIFont systemFontOfSize:16*kScreenscale];
    [self addSubview:self.functionLabel];
    
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=52*kScreenscale;
}


-(void)setViewWithFunction:(NSString *)function{
    self.functionLabel.text=Localized(function);
}

- (void)setIsMemory:(BOOL)isMemory{
    _isMemory = isMemory;
    if(isMemory){
        self.greenView.backgroundColor = [UIColor redColor];
    }
    else{
        self.greenView.backgroundColor = [UIColor greenColor];
    }
}

@end
