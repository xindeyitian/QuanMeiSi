//
//  FunctionHeaderView.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "FunctionHeaderView.h"
#import <UIImage+GIF.h>
@interface FunctionHeaderView()

@property (nonatomic, strong)UIImageView * functionImageView;
@property (nonatomic, strong)UILabel * functionLabel;


@end

@implementation FunctionHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //背景色渐变
    self.layer.cornerRadius = 5;
    self.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
    self.alpha = 1;
    
    //Gradient 0 fill for 圆角矩形 1
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 5;
    gradientLayer0.frame = self.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:74.0f/255.0f green:70.0f/255.0f blue:74.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:52.0f/255.0f green:50.0f/255.0f blue:52.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 0)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [self.layer addSublayer:gradientLayer0];
    //图片
    self.bgImageView=[[UIImageView alloc] initWithImage:kxImageNameWith(@"椭圆1")];
    self.bgImageView.frame=CGRectMake(94*kScreenscale, 27*kScreenscale, 157*kScreenscale, 157*kScreenscale);
    self.bgImageView.userInteractionEnabled =1;
    [self addSubview:self.bgImageView];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewWithLongPress:)];
    longPress.minimumPressDuration = 3.0;
    [self.bgImageView addGestureRecognizer:longPress];
    
    
    self.functionImageView=[[UIImageView alloc] initWithImage:kxImageNameWith(@"向上倾斜")];
    self.functionImageView.frame=CGRectMake(44*kScreenscale, 51*kScreenscale, 70*kScreenscale, 34*kScreenscale);
   
    [self.bgImageView addSubview:self.functionImageView];
    
    self.functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GMAXY(self.functionImageView)+19, GVW(self.bgImageView), 16)];
    self.functionLabel.text=@"看电视";
    self.functionLabel.textColor=[UIColor whiteColor];
    self.functionLabel.textAlignment=NSTextAlignmentCenter;
    self.functionLabel.font=[UIFont systemFontOfSize:16];
    [self.functionLabel adjustsFontSizeToFitWidth];
    [self.bgImageView addSubview:self.functionLabel];

}

-(void)setupSubViewsWithFunctionImageName:(NSString *)functionImageName andFunctionName:(NSString *)functionName{
    self.functionImageView.image=kxImageNameWith(functionImageName);
    self.functionImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.functionLabel.text=Localized(functionName);
   
}

-(void)setupSubViewsWithGIFImageName:(NSString *)functionImageName andFunctionName:(NSString *)functionName
{
    NSString*filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:[NSString stringWithFormat:@"%@",functionImageName] ofType:nil];
    NSData*imageData = [NSData dataWithContentsOfFile:filePath];
    self.functionImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    self.functionImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.functionLabel.text=Localized(functionName);
}



-(void)clickViewWithLongPress:(UILongPressGestureRecognizer*)longPress
{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if (_longPressClick)
        {
            _longPressClick(1);
        }
    };
    
}

@end
