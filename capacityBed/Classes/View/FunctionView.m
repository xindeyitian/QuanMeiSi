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
@property (nonatomic, strong)UIImageView * functionRightImageView;

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

    self.image = [UIImage imageNamed:@"不下沉按钮"];
    
    self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imgV.userInteractionEnabled = 1;
    self.imgV.hidden =1;
    
    self.functionImageView=[[UIImageView alloc] initWithImage:kxImageNameWith(@"向上倾斜")];
    self.functionImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.functionImageView.frame=CGRectMake(17*kScreenscale, 13*kScreenscale, 52*kScreenscale, 25*kScreenscale);
    [self addSubview:self.functionImageView];
    
    self.functionRightImageView=[[UIImageView alloc] initWithImage:kxImageNameWith(@"向上倾斜")];
    self.functionRightImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.functionRightImageView.frame=CGRectMake(self.frame.size.width-69*kScreenscale, 13*kScreenscale, 52*kScreenscale, 25*kScreenscale);
    [self addSubview:self.functionRightImageView];
    self.functionRightImageView.hidden = 1;
    
    self.functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(68*kScreenscale, 20*kScreenscale, 73*kScreenscale, 16*kScreenscale)];
    self.functionLabel.text=@"看电视";
    self.functionLabel.textColor=[UIColor whiteColor];
    self.functionLabel.adjustsFontSizeToFitWidth=YES;
    self.functionLabel.textAlignment=NSTextAlignmentRight;
    self.functionLabel.font=[UIFont systemFontOfSize:14*kScreenscale];
    [self addSubview:self.functionLabel];

}

-(void)setupSubViewsWithFunctionImageName:(NSString *)functionImageName andFunctionName:(NSString *)functionName withFuncType:(FunctionType)funcType index:(NSInteger)index{
    
    self.functionImageView.image=kxImageNameWith(functionImageName);
    self.functionRightImageView.image=kxImageNameWith(functionImageName);
    
    self.functionLabel.text=Localized(functionName);
    self.functionLabel.textAlignment = 2;
    self.functionImageView.hidden = 0;
    if ((funcType == FunctionType430And730 ||funcType == FunctionType420And442And720) && index ==4) {
        
        self.functionRightImageView.hidden = 0;
        self.functionLabel.frame = CGRectMake(68*kScreenscale, 20*kScreenscale, kScreenwidth-(68+24)*kScreenscale*2, 16*kScreenscale);
        self.functionLabel.textAlignment = 1;
    }else{
        self.functionRightImageView.hidden = 1;
        self.functionLabel.frame = CGRectMake(68*kScreenscale, 20*kScreenscale, 73*kScreenscale, 16*kScreenscale);
    }
}

-(void)setupSubViewsWithFunctionName:(NSString *)functionName
{
    self.functionLabel.text=Localized(functionName);
    self.functionImageView.hidden = 1;
    self.functionLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.functionLabel.textAlignment=1;
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
