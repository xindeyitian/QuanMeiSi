//
//  KneadView.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/28.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "KneadView.h"

@implementation KneadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self setupTimeView];
    [self setFunctionView1];
}


-(void)setupTimeView{
    NSArray * titleArray = @[@"10min",@"20min",@"30min"];
    NSArray * imageArray = @[@"1",@"2",@"组6"];
    
    NSArray * selectedImageArray = @[@"组9",@"20",@"30"];
    for (int i = 0 ; i<titleArray.count; i++) {
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(26*kScreenscale+115*kScreenscale*i, 22*kScreenscale, 94*kScreenscale, 42*kScreenscale)];
        [self addSubview:contentView];
        contentView.tag=10+i;
        
        
        UIImageView * imageView=[[UIImageView alloc] initWithImage:kxImageNameWith(imageArray[i])];
        imageView.frame=CGRectMake(0, 0, 42*kScreenscale, 42*kScreenscale);
        imageView.tag=30;
       // [contentView addSubview:imageView];
        
        UIButton * btn  =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42*kScreenscale, 42*kScreenscale)];
        btn.selected = 0;
        btn.tag  =30+i;
        [btn setBackgroundImage:kxImageNameWith(imageArray[i]) forState:UIControlStateNormal];
        [btn setBackgroundImage:kxImageNameWith(selectedImageArray[i]) forState:UIControlStateSelected];
        [contentView addSubview:btn];
        
        
        
        btn.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedTime:)];
        [btn addGestureRecognizer:tap];
        
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(GVW(imageView)+5, 0, GVW(contentView) - GVW(imageView), 42)];
        label.textColor=[UIColor whiteColor];
        label.text=titleArray[i];
        label.font=[UIFont systemFontOfSize:15];
        [contentView addSubview:label];
        label.adjustsFontSizeToFitWidth=YES;
    }
}

-(void)setFunctionView1{
    NSArray * titleArray = @[@"WAVE",@"HEAD ",@"FOOT"];
    NSArray * imageArray = @[@"图层1拷贝2",@"头部按摩",@"图层3"];
    for (int i = 0 ; i<titleArray.count; i++) {
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(53*kScreenscale, 91*kScreenscale + 70*kScreenscale*i, 264*kScreenscale, 62*kScreenscale)];
        [self addSubview:contentView];
        contentView.tag=1000+i;
        UIImageView * imageView=[[UIImageView alloc] initWithImage:kxImageNameWith(imageArray[i])];
        imageView.frame=CGRectMake(86*kScreenscale, 0, 32*kScreenscale, 32*kScreenscale);
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        [contentView addSubview:imageView];
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(GMAXX(imageView)+8, 0, 100*kScreenscale, 32*kScreenscale)];
        label.textColor=[UIColor whiteColor];
        label.text=Localized(titleArray[i]);
        label.font=[UIFont systemFontOfSize:13];
        [contentView addSubview:label];
        
        UIView * lineView=[[UIView alloc] initWithFrame:CGRectMake(34*kScreenscale, 45*kScreenscale, 198*kScreenscale, 5*kScreenscale)];
        lineView.backgroundColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        [contentView addSubview:lineView];

        UIView * lineView1=[[UIView alloc] initWithFrame:CGRectMake(34*kScreenscale, 45*kScreenscale, 198*kScreenscale*0, 5*kScreenscale)];
        lineView1.backgroundColor=[UIColor colorWithRed:110.0f/255.0f green:65.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
        lineView1.tag=200;
        [contentView addSubview:lineView1];

        
        UIButton * reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GVH(imageView)+3*kScreenscale, 27*kScreenscale, 27*kScreenscale)];
        [reduceButton setImage:[UIImage imageNamed:@"组7"] forState:UIControlStateNormal];
        [reduceButton addTarget:self action:@selector(clickReduceButton:) forControlEvents:UIControlEventTouchUpInside];
        reduceButton.tag=10+i;
        [contentView addSubview:reduceButton];

        UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(GVW(contentView) - 27*kScreenscale, GVH(imageView)+3*kScreenscale, 27*kScreenscale, 27*kScreenscale)];
        [addButton setImage:[UIImage imageNamed:@"组7拷贝"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        addButton.tag=100+i;
        [contentView addSubview:addButton];

    }
}


-(void)selectedTime:(UITapGestureRecognizer *)tap{
    
    
    NSLog(@"=====%@",tap.view);
    UIButton * btn = (UIButton*)[tap view];
    if (self.timeBtn ==  btn)
    {
        btn.selected = !btn.selected;
    }else
    {
        self.timeBtn.selected = 0;
        self.timeBtn = btn;
        btn.selected = !btn.selected;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedTime:)]) {
        [self.delegate selectedTime:btn];
    }
    
    
    return;
    
    if(self.currentTap==tap)
    {
        UIView * currentView=self.currentTap.view;
        UIImageView * currentimageView=[currentView viewWithTag:30];
        switch (currentView.tag) {
            case 10:
                currentimageView.image=kxImageNameWith(@"1");
                break;
            case 11:
                currentimageView.image=kxImageNameWith(@"2");
                break;
            case 12:
                currentimageView.image=kxImageNameWith(@"组6");
                break;
                
            default:
                break;
        }
    }
    else{
        
        
    UIView * currentView=self.currentTap.view;
        UIImageView * currentimageView=[currentView viewWithTag:30];
        switch (currentView.tag) {
            case 10:
                currentimageView.image=kxImageNameWith(@"1");
                break;
            case 11:
                currentimageView.image=kxImageNameWith(@"2");
                break;
            case 12:
                currentimageView.image=kxImageNameWith(@"组6");
                break;
                
            default:
                break;
        }

        self.currentTap=tap;
        UIView * view=tap.view;
        UIImageView * imageView=[view viewWithTag:30];
        switch (view.tag) {
            case 10:
                imageView.image=kxImageNameWith(@"组9");
                break;
            case 11:
                imageView.image=kxImageNameWith(@"20");
                break;
            case 12:
                imageView.image=kxImageNameWith(@"30");
                break;
                
            default:
                break;
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(selectedTime:)]) {
        [self.delegate selectedTime:tap];
    }

}
#pragma mark--按摩模块减少按钮的点击事件
-(void)clickReduceButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickReduceButton:)]) {
        [self.delegate clickReduceButton:sender];
    }

}
#pragma mark--按摩模块增加按钮的点击事件
-(void)clickAddButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickAddButton:)]) {
        [self.delegate clickAddButton:sender];
    }
}

-(void)setFootValue:(float)footValue{
    _footValue = footValue;
    UIView * view= [self viewWithTag:1002];
    UIView * view1= [view viewWithTag:200];
    view1.frame=CGRectMake(34*kScreenscale, 45*kScreenscale, 198*kScreenscale*footValue/3.0, 5*kScreenscale);
    
}

-(void)setHeadValue:(float)headValue{
    _headValue = headValue;
    UIView * view= [self viewWithTag:1001];
    UIView * view1= [view viewWithTag:200];
    view1.frame=CGRectMake(34*kScreenscale, 45*kScreenscale, 198*kScreenscale*headValue/3.0, 5*kScreenscale);

}

-(void)setFrequencyValue:(float)frequencyValue{
    _frequencyValue=frequencyValue;
    UIView * view= [self viewWithTag:1000];
    UIView * view1= [view viewWithTag:200];
    view1.frame=CGRectMake(34*kScreenscale, 45*kScreenscale, 198*kScreenscale*(frequencyValue+1)/4.0, 5*kScreenscale);
}

@end
