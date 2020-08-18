//
//  FunctionView.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "FunctionView.h"

@interface FunctionView()

@property (nonatomic, strong)UIImageView * functionImageView;
@property (nonatomic, strong)UILabel * functionLabel;

@end

@implementation FunctionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //Base self for 圆角矩形 1 拷贝 2
//    self.layer.cornerRadius = 5;
//    self.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
//    self.alpha = 1;
    
   
    self.image = [UIImage imageNamed:@"不下沉按钮"];
    
    //Gradient 0 fill for 圆角矩形 1 拷贝 2
//    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
//    gradientLayer0.cornerRadius = 5;
//    gradientLayer0.frame = self.bounds;
//    gradientLayer0.colors = @[
//                              (id)[UIColor colorWithRed:74.0f/255.0f green:70.0f/255.0f blue:74.0f/255.0f alpha:1.0f].CGColor,
//                              (id)[UIColor colorWithRed:52.0f/255.0f green:50.0f/255.0f blue:52.0f/255.0f alpha:1.0f].CGColor];
//    gradientLayer0.locations = @[@0, @1];
//    [gradientLayer0 setStartPoint:CGPointMake(1, 0)];
//    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
//    [self.layer addSublayer:gradientLayer0];
    
    
    self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imgV.userInteractionEnabled = 1;
    //self.imgV.image = [UIImage imageNamed:@"不下沉按钮"];
    self.imgV.hidden =1;
   // [self addSubview:self.imgV];
    
    
    
   
    
    self.functionImageView=[[UIImageView alloc] initWithImage:kxImageNameWith(@"向上倾斜")];
    self.functionImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.functionImageView.frame=CGRectMake(17*kScreenscale, 13*kScreenscale, 52*kScreenscale, 25*kScreenscale);
    [self addSubview:self.functionImageView];
    
    self.functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(68*kScreenscale, 20*kScreenscale, 73*kScreenscale, 16*kScreenscale)];
    self.functionLabel.text=@"看电视";
    self.functionLabel.textColor=[UIColor whiteColor];
    self.functionLabel.adjustsFontSizeToFitWidth=YES;
    self.functionLabel.textAlignment=NSTextAlignmentRight;
    self.functionLabel.font=[UIFont systemFontOfSize:14*kScreenscale];
    [self addSubview:self.functionLabel];
    
   
    
    
    

}

-(void)setupSubViewsWithFunctionImageName:(NSString *)functionImageName andFunctionName:(NSString *)functionName{
    self.functionImageView.image=kxImageNameWith(functionImageName);
    self.functionLabel.text=Localized(functionName);

}

-(void)setBackImageWithName:(NSString*)name
{
    
    NSData *data1 = UIImagePNGRepresentation(self.image);
    
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"不下沉按钮"]);
    
    if ([data1 isEqual:data2])
    {
        self.image = [UIImage imageNamed:@"下沉按钮"];
        
    }else
    {
        self.image = [UIImage imageNamed:@"不下沉按钮"];
        

    }
}
@end
