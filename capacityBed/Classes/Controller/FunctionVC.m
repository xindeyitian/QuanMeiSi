//
//  FunctionVC.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "FunctionVC.h"
#import "FunctionHeaderView.h"
#import "CircleView.h"
#import "FunctionView.h"
#import "TrimmingView.h"
#import "BottomView.h"
#import "KneadView.h"
#import "SettingVC.h"

#import "YYModel.h"
#import "CodeNameImageModel.h"

#import "FunctionShortCutDataCenter.h"
#import "FunctionMicroAdjDataCenter.h"

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define channelOnPeropheralView @"peripheralView"
#define WriteCharacteristic  @"FFE1"
#define NotifyCharacteristic  @"FEA1"

#define channelOnCharacteristicView @"CharacteristicView"

@interface FunctionVC ()<TrimmingViewDelegate,KneadViewDelegate,UIGestureRecognizerDelegate>{
    BabyBluetooth *  _babyBluetooth;
    NSInteger  _state1;
    NSInteger  _state2;

    
    Boolean check1,check2;
    
    Boolean io1,io2,io3,io4;
    
    
    //    NSMutableString *string_buffer ;
    NSString *string_buffer;
    
    int rx_len_count;
    int tx_len_count;
    
    BOOL isMassing;
    BOOL isMemory1;
    BOOL isMemory2;
    BOOL isTV;//电视
    BOOL isZG;//零压力
    BOOL isAS;//止鼾

    BOOL ishHuiMa;
    
    BOOL isWeiTiao;//是否是微调
    
    BOOL WeiTiaoIsHighlight;//微调是否高亮
    
    NSInteger selectTime;//选择的时间
    
    NSTimer * timeTV;
    NSTimer * timeZG;
    NSTimer * timeAS;
    NSTimer * timeMemory1;
    NSTimer * timeMemory2;
    
    int  KQTime;
    dispatch_source_t  KQTimer;
    
    BOOL  isGetMemory;//获取快捷记忆状态
    BOOL isLast;//是不是最后一个
    
    BOOL isGetTV;
    BOOL isGetZG;
    BOOL isGetAS;
    BOOL isGetMemory1;
    BOOL isGetMemory2;
    
    
    NSString * initialStopCode;//停止码
    
    NSString * kuaiJieOneTapCode;//快捷1的点击码
    NSString * kuaiJieOneLongPressMemoryCode;//记忆状态下快捷1的长按编码
    NSString * kuaiJieOneLongPressNotMemoryCode;//非记忆状态下快捷1的长按编码
    
    NSString * kuaiJieTwoTapCode;//快捷2的点击码
    NSString * kuaiJieTwoLongPressMemoryCode;//记忆状态下快2的长按编码
    NSString * kuaiJieTwoLongPressNotMemoryCode;//非记忆状态下快捷2的长按编码
    
    NSString * kuaijieType;
}

@property (nonatomic, strong)FunctionHeaderView * headView;
@property (nonatomic, strong)CircleView * circleView1;
@property (nonatomic, strong)CircleView * circleView2;

@property (nonatomic, strong)CircleView * circleView3;//430  420  等的记忆

@property (nonatomic, strong)KneadView* kneadView;

@property (nonatomic, strong)BottomView * bottomView;
@property (nonatomic, strong)UIView  * bgView;

@property (nonatomic, strong)NSMutableArray * writeInstructAry;

@property (nonatomic, strong)NSMutableArray * headerTipArray;//头部图片，提示数组

@property (nonatomic, strong)CBCharacteristic * writeCharacteristic;//写入特征
@property (nonatomic, strong)CBCharacteristic * notifyCharacteristic;//通知特征

@property (nonatomic, strong)NSMutableArray * instructArray;//硬件返回的指令

@property (nonatomic, copy)NSString *  massInstruct;//硬件返回的指令

@property (nonatomic, strong)UITapGestureRecognizer *  currentTimeTap;//当前选择的按摩时间
@property (nonatomic, strong)UIButton *  currentTimeBtn;//当前选择的按摩时间

@property (nonatomic, strong)FunctionShortCutDataCenter * shortCutdataCenter;
@property (nonatomic, strong)FunctionMicroAdjDataCenter * microAdjdataCenter;

@end

@implementation FunctionVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    isGetMemory = 1;
    
    [self SetInitialSendCode];
    [self getMemoryStatus];
}

-(FunctionShortCutDataCenter*)shortCutdataCenter
{
    if (!_shortCutdataCenter) {
        _shortCutdataCenter = [[FunctionShortCutDataCenter alloc]init];
    }
    return _shortCutdataCenter;
}

-(FunctionMicroAdjDataCenter*)microAdjdataCenter
{
    if (!_microAdjdataCenter) {
        _microAdjdataCenter = [[FunctionMicroAdjDataCenter alloc]init];
    }
    return _microAdjdataCenter;
}

#pragma mark-----设置初始编码
-(void)SetInitialSendCode
{
    initialStopCode = @"FFFFFFFF0500000000D700"; //停止码
    
    kuaiJieOneTapCode = @"FFFFFFFF050000A10A2E97"; //快捷1的点击码
    kuaiJieOneLongPressMemoryCode = @"FFFFFFFF050000AF0A2AF7"; //记忆状态下快捷1的长按编码
    kuaiJieOneLongPressNotMemoryCode = @"FFFFFFFF050000A00A2F07"; //非记忆状态下快捷1的长按编码
     
    kuaiJieTwoTapCode = @"FFFFFFFF050000B10BE297"; //快捷2的点击码
    kuaiJieTwoLongPressMemoryCode = @"FFFFFFFF050000BF0BE6F7";//记忆状态下快2的长按编码
    kuaiJieTwoLongPressNotMemoryCode = @"FFFFFFFF050000B00BE307";//非记忆状态下快捷2的长按编码
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    ishHuiMa = 0;
    isWeiTiao = 0;
    WeiTiaoIsHighlight = 0;

    self.TitleNav.text = @"TRI-MIX";
  
    isMassing = YES;
    [self.rigltbutton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];

    [self.view addSubview:self.headView];
    [self.view addSubview:self.bottomView];
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, GMAXY(self.headView), kScreenwidth, kScreenheight - GMAXY(self.headView) - GVH(self.bottomView))];
    [self.view addSubview:self.bgView];
    _state1=0;
    _state2=0;
    [self setFunctionView1];
    
    [self initData];
}
- (void)rightEvents{

    SettingVC * vc=[[SettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ===== 头部试图View
-(FunctionHeaderView *)headView{
    if (!_headView) {
        _headView = [[FunctionHeaderView alloc] initWithFrame:CGRectMake((kScreenwidth - 345*kScreenscale) * 0.5, GMAXY(self.Nav)+29*kScreenscale, 345*kScreenscale, 210*kScreenscale)];
        [_headView setupSubViewsWithFunctionImageName:@"图层1" andFunctionName:@"TV"];
        
        _headView.userInteractionEnabled =1;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopClick:)];
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}

#pragma mark---停止码
-(void)stopClick:(UITapGestureRecognizer*)tap
{
    [self sendDataWithString:initialStopCode];
}

#pragma mark ===== 底部BottomView
-(BottomView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[BottomView alloc] initWithFrame:CGRectMake(0, kScreenheight - 52*kScreenscale, kScreenwidth, 52*kScreenscale)];
        @WeakObj(self);
        _bottomView.block = ^(NSInteger type) {
            [selfWeak showCurrentViewWithType:type];
        };
    }
    return _bottomView;
}

#pragma mark---下面四个按钮的点击事件
-(void)showCurrentViewWithType:(NSInteger )type{
    for (UIView * view in self.bgView.subviews) {
        [view removeFromSuperview];
    }
      
    switch (type) {
            //快捷
        case 1:
            ishHuiMa = 0;
            isWeiTiao = 0;
            [self setFunctionView1];
            break;
        case 2:
            //微调
#pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改   名字以及发码的修改
            if (self.functionType == FunctionTypeKQ ||self.functionType == FunctionTypeKQ2)
            {
                [self setFunctionKQView];
            }else if (self.functionType == FunctionTypeMQ || self.functionType == FunctionTypeKQH)
            {
                ishHuiMa = 0;
                isWeiTiao = 1;
                WeiTiaoIsHighlight =0;
                [self setFunctionView2];
            }else
            {
                ishHuiMa = 0;
                isWeiTiao = 1;
                [self setFunctionView2];
            }
            break;
        case 3:
            //按摩
            ishHuiMa = 1;
            isWeiTiao = 0;
            [self setFunctionView3];
            break;
        case 4:
            //灯光
            ishHuiMa = 0;
            isWeiTiao = 0;
            [self setFunctionView4];
            break;
        default:
            break;
    }
}

#pragma mark - 快捷
-(void)setFunctionView1{
    
    [self.bgView addSubview:self.circleView1];
    [self.bgView addSubview:self.circleView2];
    
    NSMutableArray * array = [self.shortCutdataCenter getKuaiJieFunctionTypeWithType:self.functionType];
    self.writeInstructAry = [array objectAtIndex:0];
    NSMutableArray * imageArray = [array objectAtIndex:1];
    NSMutableArray * titleArray = [array objectAtIndex:2];
    
    NSInteger num = 2;//一行的个数
   
    float hengJianGe = 16*kScreenscale;
    float oneWidth = (kScreenwidth - 24*kScreenscale * 2 -(num-1)*hengJianGe)/num;

    NSInteger count =imageArray.count;
    
    float jianGe = 0;
    float jianGe1 = 0;
    
    #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断
    if (self.functionType == FunctionTypeJQ || self.functionType == FunctionTypeJQD || self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ2 || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeMQ || self.functionType == FunctionTypeU700)
    {
        count = 4;
        jianGe = 25;
        jianGe1 = 20;
    }
    
    if (self.functionType == FunctionType430And730 || self.functionType == FunctionType420And442And720) {
        
        hengJianGe = 10 * kScreenscale;
        jianGe = 20;
        self.circleView1.hidden = self.circleView2.hidden = YES;
        [self.bgView addSubview:self.circleView3];
    }
    
    for (int i =0; i<count; i++)
    {
        if ((self.functionType == FunctionType430And730 || self.functionType == FunctionType420And442And720) && i == 4) {
            
            hengJianGe = 0;
            oneWidth = kScreenwidth - 24*kScreenscale * 2;
        }
        FunctionView * view = [[FunctionView alloc] initWithFrame:CGRectMake(24 *kScreenscale+ (oneWidth +hengJianGe)*(i%num), (GMAXY(self.circleView1)+9)+jianGe+(60*kScreenscale+jianGe1)*(i/num), oneWidth, 52*kScreenscale)];
        view.tag=100+i;
        view.userInteractionEnabled=YES;
        
        if ((self.functionType == FunctionType430And730 || self.functionType == FunctionType420And442And720) && i <2) {
            
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(24 *kScreenscale+ (oneWidth +hengJianGe)*(i%num), GMAXY(self.circleView1), oneWidth, 20)];
            lab.textColor = [UIColor whiteColor];
            lab.textAlignment = 1;
            lab.font = [UIFont systemFontOfSize:15];
            lab.text = Localized(i ==0?@"Left":@"Right");
            [self.bgView addSubview:lab];
        }
        
        if (i<3)
        {
            view.imgV.hidden = 0;
            view.backgroundColor = [UIColor clearColor];
            
            if (i ==0)
            {
                [self getbeforeimage:view wwithSatus:isTV];
            }else if (i==1)
            {
                [self getbeforeimage:view wwithSatus:isZG];
            }else
                 #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断
            {
                if ( self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2)
                {
                    view.imgV.hidden = 1;
                    view.alpha = 1;
                }else
                {
                     [self getbeforeimage:view wwithSatus:isAS];
                }
            }
        }else
        {
            view.imgV.hidden = 1;
            view.alpha = 1;
        }
       
        #pragma mark-----2020.5.20新增
        //KQ并且i=3不做处理
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewWithTap:)];
        [view addGestureRecognizer:tap];
        
    #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改  取消顶腰的长按以及新增复原的长按
        #pragma mark-----2020.5.20新增
        if ((self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2 ) && i ==3) {
            
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(huanYuanclickViewClickWithLongPress:)];
            longPress.minimumPressDuration = 0.01;
            [view addGestureRecognizer:longPress];
            
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KQViewClickWithTap)];
            [view addGestureRecognizer:tap];
            
        }else{
            
            //KQ  在i小于2的时候做处理
            //没有KQ 在i小于3的时候做处理
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewWithLongPress:)];
            longPress.minimumPressDuration = 3.0;
            [view addGestureRecognizer:longPress];
        }
        [view setupSubViewsWithFunctionImageName:imageArray[i] andFunctionName:titleArray[i] withFuncType:self.functionType index:i];
        [self.bgView addSubview:view];
    }
    
    //获取头部数据信息
    self.headerTipArray = [self.shortCutdataCenter getKuaiJieHeaderFunctionTypeWithType:self.functionType];
    [self setheadViewWithinfo:self.headerTipArray[_state1]];
}

-(void)getbeforeimage:(UIImageView*)imgV wwithSatus:(BOOL)status
{
    if (status)
    {
        imgV.image = [UIImage imageNamed:@"下沉按钮"];
        
    }else
    {
        imgV.image = [UIImage imageNamed:@"不下沉按钮"];
    }
}

#pragma mark=====快捷的点击事件===快捷的点击事件===快捷的点击事件=====快捷的点击事件
-(void)clickViewWithTap:(UITapGestureRecognizer *)tap{
    
    FunctionView * view=(FunctionView *)tap.view;
    _state1=view.tag-100;
    
    if ((self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2)&& _state1==3)
    {
        return;
    }
    if (self.functionType == FunctionType430And730) {
        
        [self setFunctionType430And730CodeWithType:_state1 withIsTap:1];
        [self setheadViewWithinfo:self.headerTipArray[_state1]];
        return;
    }
    
     NSString *  code = [self.shortCutdataCenter getKuaiJieTapNormalCodeWithType:_state1 withIsTV:isTV withIsZG:isZG withIsAS:isAS withType:self.functionType withAry:self.writeInstructAry];
    [self sendDataWithString:code];
    
    [self setheadViewWithinfo:self.headerTipArray[_state1]];
}

#pragma mark=========-======430And730的发码
-(void)setFunctionType430And730CodeWithType:(NSInteger)index withIsTap:(BOOL)isTap
{
    NSString * code = [self.shortCutdataCenter setFunctionType430And730CodeWithType:index withIsZG:isZG  withIsTV:isTV withIsTap:1];
    [self sendDataWithString:code];
}

 #pragma mark----6.12关于新加KQ的快捷调整--还原加入长按的处理
-(void)KQViewClickWithTap
{
     [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[3][@"image"] andFunctionName:self.headerTipArray[3][@"name"] ];
    
    #pragma mark-----2020.5.20新增
    if (self.functionType == FunctionTypeKQ2) {
        
        [self sendDataWithString:@"FF FF FF FF 05 00 00 00 08 D6 C6"];
    }else{
        
         [self sendDataWithString:@"FF FF FF FF 05 00 00 F1 0F D2 94"];
    }
}

 #pragma mark----KQ还原长按的处理
-(void)huanYuanclickViewClickWithLongPress:(UILongPressGestureRecognizer *)tap{
    
     [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[3][@"image"] andFunctionName:self.headerTipArray[3][@"name"] ];
    
    FunctionView * view=(FunctionView *)tap.view;

    if (tap.state == UIGestureRecognizerStateBegan)
    {
        dispatch_queue_t queue = dispatch_get_main_queue();
        //创建一个定时器（dispatch_source_t本质上还是一个OC对象）
        KQTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
  
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(1.0*NSEC_PER_SEC);
        dispatch_source_set_timer(KQTimer, start, interval, 0);

        dispatch_source_set_event_handler(KQTimer, ^{
            self->KQTime += 1;
            
             if (self->KQTime >2  )
             {
                 self->ishHuiMa  =1;
                 [self sendDataWithString:@"FF FF FF FF 05 00 00 F0 0F D3 04"];
                 
                 [self getbeforeimage:view wwithSatus:1];
             }
        });
        dispatch_resume(KQTimer);
    }

    if (tap.state == UIGestureRecognizerStateEnded)
    {
        KQTimer = nil;
        if (KQTime < 3)
        {
            #pragma mark-----2020.5.20新增
            if (self.functionType == FunctionTypeKQ2) {
                
                [self sendDataWithString:@"FF FF FF FF 05 00 00 00 08 D6 C6"];
            }else{
                
                [self sendDataWithString:@"FF FF FF FF 05 00 00 F1 0F D2 94"];
            }
        }else
        {
             [self getbeforeimage:view wwithSatus:0];
        }
        KQTime= 0;
    }
}
 #pragma mark---快捷长按-view长按的处理
-(void)clickViewWithLongPress:(UILongPressGestureRecognizer *)tap{
    FunctionView * view=(FunctionView *)tap.view;
    
    _state1=view.tag-100;
    #pragma mark-----2020.5.20新增
    //KQ  在i小于2的时候做处理
    //没有KQ 在i小于3的时候做处理
    if (self.functionType == FunctionType430And730) {
        
        [self setFunctionType430And730CodeWithType:_state1 withIsTap:0];
        return;
    }

    if (self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2) {
        
        if (_state1 >1)  return;
    }else{
        if (_state1 >2)  return;
    }
    
    ishHuiMa = 1;
    if (tap.state == UIGestureRecognizerStateBegan) {
        
        NSString * code = [self.shortCutdataCenter  getFunctionTypeNormalCodeWithType:_state1 withIsTV:isTV withIsZG:isZG withIsAS:isAS];
        [self sendDataWithString:code];
        if (_state1 == 0) {
            isTV=!isTV;
        }else if (_state1 == 1){
            isZG=!isZG;
        }else if (_state1 == 2){
            isAS=!isAS;
        }
    }
     [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[_state1][@"image"] andFunctionName:self.headerTipArray[_state1][@"name"] ];
}

#pragma mark======分割线======分割线===分割线=====分割线====分割线========分割线======分割线===分割线====
#pragma mark================微调部分================================
#pragma mark================微调部分================================

#pragma mark----6.12关于新加KQ的微调界面     这里的图标以及文字需要修改
-(void)setFunctionKQView{
    
    NSLog(@"新加KQ的微调界面");
    
    self.headerTipArray = [self.microAdjdataCenter getWeiTiaoKQHeaderDataAryWithType:self.functionType];
    [self setheadViewWithinfo:self.headerTipArray[0]];

    for (int i =0; i < 2; i ++)
    {
        UIImageView * imgV=  [[UIImageView alloc]initWithFrame:CGRectMake(65*kScreenscale+(90*kScreenscale+65*kScreenscale)*i, GVH(self.bgView)/2.0-61.5*kScreenscale, 90*kScreenscale, 123*kScreenscale)];
        imgV.tag  =1000+i;
        imgV.image = [UIImage imageNamed:@"不下沉按钮"];
        imgV.layer.cornerRadius = 4;
        imgV.clipsToBounds = 1;
        
        [self.bgView addSubview:imgV];
        
        //多边形1
        UIImageView * imageUP=[[UIImageView alloc] initWithImage:kxImageNameWith(i ==0?@"多边形1":@"多边形1拷贝")];
        imageUP.frame=CGRectMake(34*kScreenscale, 25*kScreenscale, 22*kScreenscale, 22*kScreenscale);
        imageUP.userInteractionEnabled =1;
        [imgV addSubview:imageUP];
        
        
        UIImageView * imageP=[[UIImageView alloc] initWithImage:kxImageNameWith(@"背部调整f2")];
        imageP.frame=CGRectMake(18*kScreenscale, 65*kScreenscale, 54*kScreenscale, 28*kScreenscale);
        imageP.userInteractionEnabled =1;
        [imgV addSubview:imageP];

        imgV.userInteractionEnabled = 1;
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(KQViewClickWithLongPress:)];
        longPress.minimumPressDuration = 0.1;
        [imgV addGestureRecognizer:longPress];
    }
}
#pragma mark----6.12关于新加KQ的长按处理
-(void)KQViewClickWithLongPress:(UILongPressGestureRecognizer*)tap
{
    UIImageView * imgV=(FunctionView *)tap.view;
   
    NSInteger index = imgV.tag -1000;
    
    NSString * code = [self.microAdjdataCenter getWeiTiaoKQLongPressCodeDataAryWithType:self.functionType WithLongPress:tap withIndex:index];
    [self sendDataWithString:code];
    
    if (tap.state == UIGestureRecognizerStateBegan) {
    
        NSArray * newArray= [self.microAdjdataCenter getWeiTiaoKQLongPressGIFDataAryWithType:self.functionType];
        [_headView setupSubViewsWithGIFImageName:newArray[index][@"image"] andFunctionName:newArray[index][@"name"]];
    }

    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[0][@"image"] andFunctionName:self.headerTipArray[0][@"name"] ];
    }
}

-(void)setFunctionView2{//图层1  图层1拷贝13

    self.headerTipArray= [self.microAdjdataCenter getWeiTiaoHeaderDataAryWithType:self.functionType];
    
    //NSArray * titleH=@[@"全身循环",@"背腿循环",@"头部循环",@"腿部循环"];
     NSArray *   titleH=@[@"Whole Body Circulation",@"Hip Circulation",@"Head Circulation",@"Leg Circulation"];
    for (int i =0; i< self.headerTipArray.count; i++)
    {
        float  height;
        float firstY = 52;
        #pragma mark----6.19新加MQ  7.13  KQ-H
        if (self.functionType == FunctionTypeMQ||self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ2)
        {
            height = 60.00f;
        }else
        {
            height = 0.00f;
        }
        if (self.functionType == FunctionType420And442And720 || self.functionType == FunctionType430And730) {
            
            [self.bgView addSubview:self.circleView3];
            self.circleView3.hidden  = 0;
            firstY = CGRectGetMaxY(self.circleView3.frame)+20;
            
        }else{
            self.circleView3.hidden  = 1;
        }
        NSDictionary * dataDic = self.headerTipArray[i];
        
        TrimmingView  * view=[[TrimmingView alloc] initWithFrame:CGRectMake(24 *kScreenscale+ 173*kScreenscale*(i%2), firstY+130*kScreenscale*(i/2)+height, 157*kScreenscale, 60*kScreenscale)];
        
        view.stateImageView.image=kxImageNameWith(dataDic[@"image"]);
        view.delegate=self;
        view.tag=200+i;
        [self.bgView addSubview:view];
        
    
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(24 *kScreenscale+ 173*kScreenscale*(i%2), GMAXY(view)+10, GVW(view), 20)];
        if (i == 2 && self.functionType == FunctionType420And442And720) {
            
            view.frame = CGRectMake(109 *kScreenscale, firstY+130*kScreenscale*(i/2)+height, 157*kScreenscale, 60*kScreenscale);
            label.frame = CGRectMake(109 *kScreenscale, GMAXY(view)+10, GVW(view), 20);
        }
        label.textColor=[UIColor whiteColor];
        label.text=Localized(dataDic[@"name"]);
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:15];
        label.tag = 888+i;
        
        if ((self.functionType == FunctionType430And730 || self.functionType == FunctionType420And442And720) && i <2) {
            
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(24 *kScreenscale+ 173*kScreenscale*(i%2), firstY - 30, 157*kScreenscale, 20)];
            lab.textColor = [UIColor whiteColor];
            lab.textAlignment = 1;
            lab.font = [UIFont systemFontOfSize:15];
            lab.text = Localized(i ==0?@"Left":@"Right");
            [self.bgView addSubview:lab];
        }
        
        if (WeiTiaoIsHighlight ==1)
        {
            view.backImgV.image = [UIImage imageNamed:@"下沉按钮"];
            label.text=Localized(titleH[i]);
        
            view.upButton.hidden =1;
            view.downButton.hidden = 1;
            
            self.headerTipArray = [self.microAdjdataCenter getWeiTiaoHighlightHeaderDataAryWithType:self.functionType];
        }else
        {
            view.upButton.hidden =0;
            view.downButton.hidden = 0;
            view.backImgV.image = [UIImage imageNamed:@"不下沉按钮"];
        }
        [self.bgView addSubview:label];
        
        [self setheadViewWithinfo:self.headerTipArray[_state2]];
    
        //index点击开始    1停止
        view.clickblock = ^(NSInteger index) {
             #pragma mark----6.19新加MQ
            if (self.functionType == FunctionTypeMQ||self.functionType == FunctionTypeKQH)
            {
                return ;
            }
            
            if (self->WeiTiaoIsHighlight ==1)
            {
                if (index ==1)
                {
                     self.headerTipArray = [self.microAdjdataCenter getWeiTiaoHighlightHeaderDataAryWithType:self.functionType];
                    [self->_headView setupSubViewsWithFunctionImageName:self.headerTipArray[self->_state2][@"image"] andFunctionName:self.headerTipArray[self->_state2][@"name"]];
                    
                }else if (index ==0)//高亮下点击  也就是循环下点击
                {
                    self->_state2 = view.tag  - 200;
              
                    NSMutableArray * newArray= [self.microAdjdataCenter getWeiTiaoHighlightHeaderClickGIFDataAryWithType:self.functionType withIndex:view.tag - 200];
                    
                    //a设置的动图
                    [self->_headView setupSubViewsWithGIFImageName:newArray[self->_state2][@"image"] andFunctionName:newArray[self->_state2][@"name"]];
                      
                    NSMutableArray *  writeInstructArr = [self.microAdjdataCenter getWeiTiaoHighlightHeaderClickCodeDataAryWithType:self.functionType];
                    [self sendDataWithString:writeInstructArr[self->_state2]];
                }
            }
        };
    }
    
    __weak typeof(self)weakSelf = self;
    //长按
    self.headView.longPressClick = ^(NSInteger index) {
       
#pragma mark----6.19新加MQ   7.13
        if (self.functionType == FunctionTypeMQ||self.functionType == FunctionTypeKQH)
        {
            return ;
        }
        
        if (self->isWeiTiao ==1)
        {
            self->WeiTiaoIsHighlight = !self->WeiTiaoIsHighlight;
            if (self->WeiTiaoIsHighlight ==0)//这个是由循环变为微调的
            {
                
                NSMutableArray * array = [weakSelf.microAdjdataCenter getWeiTiaoHighlightHeaderLongPressDataAryWithType:weakSelf.functionType];
                
                weakSelf.headerTipArray = [array objectAtIndex:0];
                NSMutableArray * imageArray = [array objectAtIndex:1];
                NSMutableArray * titleArray = [array objectAtIndex:2];

                for (int i =0; i<titleArray.count; i++)
                {
                    UILabel * lable =(UILabel*) [weakSelf.bgView viewWithTag:888+i];
                    lable.text = Localized(titleArray[i]);;
                    
                    TrimmingView  * TrimmingV = [weakSelf.bgView viewWithTag:200+i];
                    
                    TrimmingV.backImgV.image = [UIImage imageNamed:@"不下沉按钮"];
                    TrimmingV.upButton.hidden =0;
                    TrimmingV.downButton.hidden = 0;
                }
                
                 [_headView setupSubViewsWithFunctionImageName:weakSelf.headerTipArray[0][@"image"] andFunctionName:weakSelf.headerTipArray[0][@"name"]];
            }else
            {
                NSLog(@"高亮");
#pragma mark-----4.24新加的
                #pragma mark----这个才是设置循环显示的
                
                NSMutableArray *   title = [self.microAdjdataCenter getWeiTiaoXunhuanDataAryWithType:weakSelf.functionType];
                
                for (int i =0; i< self.headerTipArray.count; i++)
                {
                    UILabel * lable =(UILabel*) [weakSelf.bgView viewWithTag:888+i];
                    lable.text = Localized(title[i]);
                    
                    TrimmingView  * TrimmingV = [weakSelf.bgView viewWithTag:200+i];
                    
                    TrimmingV.backImgV.image = [UIImage imageNamed:@"下沉按钮"];
                    
                    TrimmingV.upButton.hidden =1;
                    TrimmingV.downButton.hidden = 1;
                }
                
                weakSelf.headerTipArray= [weakSelf.microAdjdataCenter getWeiTiaoXunhuanHeaderDataAryWithType:weakSelf.functionType];

                [self->_headView setupSubViewsWithFunctionImageName:weakSelf.headerTipArray[0][@"image"] andFunctionName:weakSelf.headerTipArray[0][@"name"]];
            }
            
        }else
        {
            NSLog(@"与我无关");
        }
    };
}

-(void)clickStopButton:(UIButton *)sender
{
    [self sendDataWithString:initialStopCode];
    TrimmingView * view=(TrimmingView *)sender.superview;
    _state2=view.tag-200;
    [self setheadViewWithinfo:self.headerTipArray[_state2]];
}

#pragma mark---微调模块的向上的按钮的方法
-(void)clickUpdateButton:(UIButton *)sender{
    
    TrimmingView * view=(TrimmingView *)sender.superview;
    _state2=view.tag-200;

    NSMutableArray * newArray = [self.microAdjdataCenter getWeiTiaoUpBtnClickDataWithType:self.functionType WeiTiaoIsHighlight:WeiTiaoIsHighlight state2:_state2];
    if (WeiTiaoIsHighlight ==1)//高亮下的微调
    {
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
        
         NSArray *  writeInstructArr=
        @[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E38688",@"FFFFFFFF05000500E5068°"];
        [self sendDataWithString:writeInstructArr[_state2]];
        return;
    }

    if (_state2 !=1)
    {
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
    }else
    {
        #pragma mark----6.19新加MQ
        NSMutableArray * array = [self.microAdjdataCenter getWeiTiaoUpBtnClickHeaderDataWithType:self.functionType];
        #pragma mark----7.20修改
        if (self.functionType == FunctionTypeKQH)
        {
             [_headView setupSubViewsWithFunctionImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }else
        {
             [_headView setupSubViewsWithGIFImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }
    }
    #pragma mark----7.13仅JQ 界面 调整
    NSMutableArray * writeInstructArray = [self.microAdjdataCenter getWeiTiaoUpBtnClickCodeDataWithType:self.functionType];
    [self sendDataWithString:writeInstructArray[_state2]];
}
#pragma mark--微调模块的向下的按钮的方法
-(void)clickDownButton:(UIButton *)sender{
    TrimmingView * view=(TrimmingView *)sender.superview;
    _state2=view.tag-200;

    NSArray * newArray = [self.microAdjdataCenter getWeiTiaoDownBtnClickDataWithType:self.functionType WeiTiaoIsHighlight:WeiTiaoIsHighlight state2:_state2];
    
    if (WeiTiaoIsHighlight ==1)
    {
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
        
        NSArray *  writeInstructArr=
        @[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E38688",@"FFFFFFFF05000500E5068°"];
        [self sendDataWithString:writeInstructArr[_state2]];
        return;
    }

    if (_state2 !=1)
    {
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
    }else
    {
        NSArray * array = [self.microAdjdataCenter getWeiTiaoDownBtnClickHeaderDataWithType:self.functionType];
        if (self.functionType == FunctionTypeKQH)
        {
            [_headView setupSubViewsWithFunctionImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }else
        {
            [_headView setupSubViewsWithGIFImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }
    }
    
    NSArray * codeAry = [self.microAdjdataCenter getWeiTiaoDownBtnClickCodeDataWithType:self.functionType];
    [self sendDataWithString:codeAry[_state2]];

}


-(void)rx_ble_event:(Byte *)bytes :(int)len;
{
    if( check1==false )
    {
        NSString *str = [self Byte_to_String:bytes :len ];
        rx_len_count+=len;
        NSLog(@"rx_len_count===%@",[NSString stringWithFormat:@"%@%dBytes",@"接收：",rx_len_count]);
        string_buffer = [NSString stringWithFormat:@"%@\r\n%@",string_buffer,str];
    }
    else
    {
        NSString *str = [self Byte_to_hexString:bytes :len ];
        rx_len_count+=len;
        string_buffer = [NSString stringWithFormat:@"%@\n%@",string_buffer,str];

        if (isGetMemory)
        {
            NSArray * array = [string_buffer componentsSeparatedByString:@"\n"];
            NSString * last = [array lastObject];
            NSString * responeStr = [last substringWithRange:NSMakeRange(12, 4)];
    
            if ([responeStr isEqualToString:@"00a5"]||[responeStr isEqualToString:@"0005"])
            {
                isTV = 1;
                FunctionView * view=(FunctionView *)[self.view viewWithTag:0+100];
                [self getbeforeimage:view wwithSatus:1];
            }
            
            if ([responeStr isEqualToString:@"00a9"]||[responeStr isEqualToString:@"0009"])
            {
                isZG = 1;
                FunctionView * view=(FunctionView *)[self.view viewWithTag:1+100];
                [self getbeforeimage:view wwithSatus:1];
            }
            
            if ([responeStr isEqualToString:@"00af"]&& ![last isEqualToString:kuaiJieOneLongPressMemoryCode.lowercaseString])
            {
                isAS = 1;
                FunctionView * view=(FunctionView *)[self.view viewWithTag:2+100];
                [self getbeforeimage:view wwithSatus:1];
            }
            if ([responeStr isEqualToString:@"000f"])
            {
                isAS = 1;
                FunctionView * view=(FunctionView *)[self.view viewWithTag:2+100];
                [self getbeforeimage:view wwithSatus:1];
            }
            
            if ([responeStr isEqualToString:@"00aa"]||[responeStr isEqualToString:@"000a"])
            {
                isMemory1  = 1;
                self.circleView1.isMemory=isMemory1;
            }
            
            if ([responeStr isEqualToString:@"00ab"]||[responeStr isEqualToString:@"000b"])
            {
                isMemory2 = 1;
                self.circleView2.isMemory=isMemory2;
            }
        }
        
        if (ishHuiMa)
        {
            NSArray * array = [string_buffer componentsSeparatedByString:@"\n"];
           
            
            NSString * last = [array lastObject];
            
             NSLog(@"ishHuiMa======%@=======%@===%@",[array lastObject],array[0],last);
            
            if ([last isEqualToString:@"ffffffff0500000100d690"])//头部按摩停止
            {
                _kneadView.headValue=0;
            }else if ([last isEqualToString:@"ffffffff050000011e5698"])//一档
            {
                _kneadView.headValue=1;
            }else if ([last isEqualToString:@"ffffffff050000011f9758"])//二挡
            {
                _kneadView.headValue=2;
            }else if ([last isEqualToString:@"ffffffff0500000120d748"])//三挡
            {
                _kneadView.headValue=3;
            }else if ([last isEqualToString:@"ffffffff0500000200d660"])//腿部按摩停止
            {
                _kneadView.footValue=0;
            }else if ([last isEqualToString:@"ffffffff05000002211678"])//腿部按摩一档
            {
                _kneadView.footValue=1;
            }else if ([last isEqualToString:@"ffffffff05000002225679"])//腿部按摩两档
            {
                _kneadView.footValue=2;
            }else if ([last isEqualToString:@"ffffffff050000022397b9"])//腿部按摩三挡
            {
                _kneadView.footValue=3;
            }else if ([last isEqualToString:@"ffffffff0500000324d7eb"])//按摩频率一档
            {
                _kneadView.frequencyValue=0;
            }else if ([last isEqualToString:@"ffffffff0500000325162b"])//按摩频率二档
            {
                _kneadView.frequencyValue=1;
            }else if ([last isEqualToString:@"ffffffff0500000326562a"])//按摩频率三档
            {
                _kneadView.frequencyValue=2;
            }else if ([last isEqualToString:@"ffffffff050000032797ea"])//按摩频率四档
            {
                _kneadView.frequencyValue=3;
            }
            #pragma mark -6.19新修改
            else if ([last isEqualToString:@"ffffffff050000f00fd304"] && (self.functionType == FunctionTypeKQH ||self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2))
            {
                _kneadView.frequencyValue=3;
            }else
            {
                FunctionView * view=(FunctionView *)[self.view viewWithTag:_state1+100];
                
                switch (_state1)
                {
                    case 0:
                        if (!isTV)
                        {
                            if ([last isEqualToString:@"ffffffff0500005f052ef3"])
                            {
                                [self getbeforeimage:view wwithSatus:0];
                            }
 
                        }else{
                            
                            if ([last isEqualToString:@"ffffffff05000050052b03"])
                            {
                                [self getbeforeimage:view wwithSatus:1];
                            }
                        }
                        break;
                    case 1:
                        if (!isZG)
                        {
                            if ([last isEqualToString:@"ffffffff0500009f097ef6"])
                            {
                                [self getbeforeimage:view wwithSatus:0];
                            }

                        }else{
                            
                            if ([last isEqualToString:@"ffffffff05000090097b06"])
                            {
                                [self getbeforeimage:view wwithSatus:1];
                            }
                        }
                        break;
                    case 2:
                        if (!isAS)
                        {
                            if ([last isEqualToString:@"ffffffff050000ff0fd6f4"])
                            {
                               [self getbeforeimage:view wwithSatus:0];
                            }
                        }else{
                            
                            if ([last isEqualToString:@"ffffffff050000f00fd304"])
                            {
                                [self getbeforeimage:view wwithSatus:1];
                            }
                        }
                        break;
                    default:
                        break;
            }
            
          }
        }
    }
}

#pragma mark=====================以下是获取记忆状态=================================
-(void)getMemoryStatus
{
    NSLog(@"进入");
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        NSLog(@"延时");
        //获取主板的记忆状态
        timeTV = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block:^(NSTimer * _Nonnull timer) {
            
            self->isGetTV = 1;
            if (self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2 )
            {
                 [self sendDataWithString:@"FFFFFFFF03001400035F05"];
            }else if (self.functionType == FunctionTypeMQ)
            {
                 [self sendDataWithString:@"FFFFFFFF03001800039F06"];
            }else
            {
                 [self sendDataWithString:@"FFFFFFFF03001600097EC2"];
            }
           
        }];
        
        timeZG = [NSTimer scheduledTimerWithTimeInterval:0.4 repeats:NO block:^(NSTimer * _Nonnull timer) {
    
            self->isGetZG = 1;
            if (self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2)
            {
                [self sendDataWithString:@"FFFFFFFF03001C0003DEC7"];
            }else if (self.functionType == FunctionTypeMQ)
            {
                [self sendDataWithString:@"FFFFFFFF03002000031ECB"];
            }else
            {
               [self sendDataWithString:@"FFFFFFFF03001F0009AEC0"];
            }
            
        }];
        
        timeAS = [NSTimer scheduledTimerWithTimeInterval:0.6 repeats:NO block:^(NSTimer * _Nonnull timer) {
    
            self->isGetAS = 1;
            if (self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2)
            {
               
            }else if (self.functionType == FunctionTypeMQ)
            {
                [self sendDataWithString:@"FFFFFFFF03003800039ECC"];
            }else
            {
                [self sendDataWithString:@"FFFFFFFF03003A0009BF0B"];
            }
            
        }];
        
        timeMemory1 = [NSTimer scheduledTimerWithTimeInterval:0.8 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
            self->isGetMemory1= 1;
            if (self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2)
            {
                [self sendDataWithString:@"FFFFFFFF03002400035F0A"];
            }else if (self.functionType == FunctionTypeMQ)
            {
                [self sendDataWithString:@"FFFFFFFF03002800039F09"];
            }else
            {
                [self sendDataWithString:@"FFFFFFFF03002800091F0E"];
            }
            
        }];
        
        timeMemory2 = [NSTimer scheduledTimerWithTimeInterval:0.10 repeats:NO block:^(NSTimer * _Nonnull timer) {
            
            self->isGetMemory2 =1;
            if (self.functionType == FunctionTypeKQH || self.functionType == FunctionTypeKQ || self.functionType == FunctionTypeKQ2 )
            {
                [self sendDataWithString:@"FFFFFFFF03002C0003DEC8"];
            }else if (self.functionType == FunctionTypeMQ)
            {
                [self sendDataWithString:@"FFFFFFFF03003000031F0E"];
            }else
            {
               [self sendDataWithString: @"FFFFFFFF0300310009CEC9"];
            }
        }];
    }];
}

-(NSMutableArray *)instructArray{
    if (!_instructArray) {
        self.instructArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _instructArray;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark=====================以下是快捷的记忆部分=================================
#pragma mark======= 快捷的记忆1
-(CircleView *)circleView1{
    if (!_circleView1) {
        
        _circleView1=[[CircleView alloc] initWithFrame:CGRectMake(51*kScreenscale, 6, 104*kScreenscale, 104*kScreenscale)];
        [_circleView1 setViewWithFunction:@"M1"];
        _circleView1.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCircleView1WithTap:)];
        [_circleView1 addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickCircleView1WithLongPress:)];
         [longPress setMinimumPressDuration:3];
        [_circleView1 addGestureRecognizer:longPress];
    }
    return _circleView1;
}

-(void)clickCircleView1WithTap:(UITapGestureRecognizer *)tap{
    if(isMemory1){
        [self sendDataWithString:kuaiJieOneTapCode];
    }
}
-(void)clickCircleView1WithLongPress:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan)
    {
        if(isMemory1){
            [self sendDataWithString:kuaiJieOneLongPressMemoryCode];
        }else{
            [self sendDataWithString:kuaiJieOneLongPressNotMemoryCode];
        }
        isMemory1=!isMemory1;
        self.circleView1.isMemory=isMemory1;
    }
}

#pragma mark======= 快捷的记忆1
-(CircleView *)circleView2{
    if (!_circleView2) {
        _circleView2=[[CircleView alloc] initWithFrame:CGRectMake(kScreenwidth- 152*kScreenscale, 6, 104*kScreenscale, 104*kScreenscale)];
       
        [_circleView2 setViewWithFunction:@"M2"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCircleView2WithTap:)];
        [_circleView2 addGestureRecognizer:tap];
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickCircleView2WithLongPress:)];
        [longPress setMinimumPressDuration:3];
        [_circleView2 addGestureRecognizer:longPress];
    }
    return _circleView2;
}

-(void)clickCircleView2WithTap:(UITapGestureRecognizer *)tap{
    if(isMemory2){
        [self sendDataWithString:kuaiJieTwoTapCode];
    }
}
-(void)clickCircleView2WithLongPress:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        if(isMemory2){
            [self sendDataWithString:kuaiJieTwoLongPressMemoryCode];
        }else{
            [self sendDataWithString:kuaiJieTwoLongPressNotMemoryCode];
        }
        isMemory2=!isMemory2;
        self.circleView2.isMemory=isMemory2;
    }
}

#pragma mark======= 420的
-(CircleView *)circleView3{
    if (!_circleView3) {
        _circleView3=[[CircleView alloc] initWithFrame:CGRectMake(kScreenwidth/2.0- 52*kScreenscale, 6, 104*kScreenscale, 104*kScreenscale)];
        [_circleView3 setViewWithFunction:@""];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCircleView3WithTap:)];
        [_circleView3 addGestureRecognizer:tap];
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickCircleView3WithLongPress:)];
        [longPress setMinimumPressDuration:3];
        [_circleView3 addGestureRecognizer:longPress];
    }
    return _circleView3;
}
-(void)clickCircleView3WithTap:(UITapGestureRecognizer *)tap{
    
}
-(void)clickCircleView3WithLongPress:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        
    }
}

#pragma mark=====================以上是快捷的记忆部分=================================

#pragma mark=====================以下是按摩部分=================================
#pragma mark - 按摩
-(void)setFunctionView3{
    
    [self.bgView addSubview:self.kneadView];
    self.headerTipArray=[@[@{@"name":@"MASS",@"image":@"图层1拷贝2"}] mutableCopy];
    [self setheadViewWithinfo:self.headerTipArray[0]];
}

-(KneadView *)kneadView{
    if (!_kneadView) {
        _kneadView = [[KneadView  alloc] initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight - GMAXY(self.headView) - GVH(self.bottomView))];
        _kneadView.delegate=self;
    }
    return _kneadView;
}

-(void)clickAddButton:(UIButton *)sender{
    if (isMassing) {
        //频率,头部，足部，
        NSArray *writeInstructArray=@[@"FFFFFFFF0500000014D70F",@"FFFFFFFF0500000010D6CC",@"FFFFFFFF0500000012570D"];
        ishHuiMa = 1;
        NSLog(@"增加----%@",writeInstructArray[sender.tag-100]);
        [self sendDataWithString:writeInstructArray[sender.tag-100]];
    }
}
#pragma mark--减少按钮的方法
-(void)clickReduceButton:(UIButton *)sender{
    if (isMassing) {

        NSArray *writeInstructArray=@[@"FFFFFFFF050000001516CF",@"FFFFFFFF0500000011170C",@"FFFFFFFF050000001396CD"];
        ishHuiMa = 1;
        NSLog(@"减少----%@",writeInstructArray[sender.tag-10]);
        [self sendDataWithString:writeInstructArray[sender.tag-10]];
    }
}
#pragma mark---时间选择
-(void)selectedTime:(UIButton *)tap{
    
    ishHuiMa = 1;
    self.instructArray=[NSMutableArray arrayWithCapacity:0];
    _kneadView.frequencyValue=-1;
    _kneadView.footValue=0;
    _kneadView.headValue=0;

//    选择时间的时候，第一次点击的时候发送对应的串口码，接着再点击同一个发送停止码
    
    if (self.currentTimeBtn == tap)
    {
        if (tap.selected ==1)
        {
            
            self.currentTimeBtn = tap;
            isMassing=YES;
            NSArray * writeInstructArray=@[@"FFFFFFFF050000001656CE",@"FFFFFFFF0500000017970E",@"FFFFFFFF0500000018D70A"];
            [self sendDataWithString:writeInstructArray[tap.tag-30]];
        }else
        {
            
            isMassing=YES;
            NSArray * writeStopInstructArray=@[@"FFFFFFFF050000001CD6C9"];
            [self sendDataWithString:writeStopInstructArray[0]];
        }
    }else
    {
       
        self.currentTimeBtn = tap;
        isMassing=YES;
        NSArray * writeInstructArray=@[@"FFFFFFFF050000001656CE",@"FFFFFFFF0500000017970E",@"FFFFFFFF0500000018D70A"];
       [self sendDataWithString:writeInstructArray[tap.tag-30]];
        
    }
}

#pragma mark=====================以上是按摩部分=================================

#pragma mark=====================以下是灯光部分=================================
#pragma mark - 灯光
-(void)setFunctionView4{

    NSArray * titleArray=@[@"10min",@"8h",@"10h"];
    for (int i = 0; i<titleArray.count; i++) {
        UIButton * button=[[UIButton alloc] initWithFrame:CGRectMake(73*kScreenscale, 31 *kScreenscale+ 90*kScreenscale*i, kScreenwidth - 146*kScreenscale, 50*kScreenscale)];
        CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
        gradientLayer0.cornerRadius = 7.5;
        gradientLayer0.frame = button.bounds;
        gradientLayer0.colors = @[
                                  (id)[UIColor colorWithRed:57.0f/255.0f green:54.0f/255.0f blue:57.0f/255.0f alpha:1.0f].CGColor,
                                  (id)[UIColor colorWithRed:74.0f/255.0f green:69.0f/255.0f blue:73.0f/255.0f alpha:1.0f].CGColor];
        gradientLayer0.locations = @[@0, @1];
        [gradientLayer0 setStartPoint:CGPointMake(1, 0)];
        [button.layer addSublayer:gradientLayer0];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:24];
        button.tag=300+i;
        [button addTarget:self action:@selector(clickLightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
    }
    self.headerTipArray=[@[@{@"name":@"LIGHT",@"image":@"图层1拷贝"}] mutableCopy];
    [self setheadViewWithinfo:self.headerTipArray[0]];
}


-(void)clickLightButton:(UIButton *)sender{
    NSArray * writeInstructArray=@[@"FFFFFFFF050000001916CA",@"FFFFFFFF050000001A56CB",@"FFFFFFFF050000001B970B"];
    [self sendDataWithString:writeInstructArray[sender.tag-300]];
}

#pragma mark - 设置头部view
-(void)setheadViewWithinfo:(NSDictionary *)dic
{
    [_headView setupSubViewsWithFunctionImageName:dic[@"image"] andFunctionName:dic[@"name"] ];
}

#pragma mark=====================以上是灯光部分=================================

#pragma mark------中间内容-----------禁止修改------------禁止修改------------------禁止修改----------------
//设置蓝牙委托
-(void)babyDelegate{
    @WeakObj(self);
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        self->baby.cancelScan;
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"===service name:%@",service.UUID);
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"------service name:%@",service.UUID);
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
        if ([characteristic.service.UUID.UUIDString isEqualToString:NotifyCharacteristic]) {
            selfWeak.notifyCharacteristic=characteristic;
            [selfWeak setNotifiy];
        }

    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
        if ([descriptor.characteristic.UUID.UUIDString isEqualToString:WriteCharacteristic]) {
            selfWeak.writeCharacteristic=descriptor.characteristic;
        }
    }];
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
}

//订阅一个值
-(void)setNotifiy{
    
    __weak typeof(self)weakSelf = self;
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (self.notifyCharacteristic.properties & CBCharacteristicPropertyNotify ||  self.notifyCharacteristic.properties & CBCharacteristicPropertyIndicate) {
        
        if(self.notifyCharacteristic.isNotifying) {
            [baby cancelNotify:self.currPeripheral characteristic:self.notifyCharacteristic];
        }else{
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.notifyCharacteristic];
            [baby notify:self.currPeripheral
          characteristic:self.notifyCharacteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       NSLog(@"notify block");
                   }];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
    
}

//string转16进制data
- (NSData *) convertHexStrToData: (NSString *)str {
    if(!str||[str length] == 0){
        return nil;
    }
    NSMutableData * hexData=[[NSMutableData alloc] initWithCapacity:0];
    NSRange range;
    if ([str length] % 2 == 0) {
        range  = NSMakeRange(0, 2);
    }
    else{
        range  = NSMakeRange(0, 1);
    }
    
    for (NSInteger i = range.location; i<str.length; i+=2) {
        unsigned int anInt;
        NSString * hexCharStr = [str substringWithRange:range];
        NSScanner * scanner = [[NSScanner alloc]  initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        
        NSData * entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

#pragma mark -6.19新修改 发送，读取指令
-(void)sendDataWithString:(NSString *)writeInstruct1{
    
    NSLog(@"发送的编码======%@",writeInstruct1);
    NSString * writeInstruct = [writeInstruct1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    int i_lend = (int)writeInstruct.length;
    if( i_lend%2!=0 )
    {
        writeInstruct = [NSString stringWithFormat:@"%@0",writeInstruct];
    }
    i_lend = (int)writeInstruct.length;
    i_lend = i_lend/2;
    
    [_delegate TY_send_data_hex:writeInstruct :true:check2];//发送的透传数据
    tx_len_count+=i_lend;
    writeInstruct = [NSString stringWithFormat:@"发送：%dBytes",tx_len_count ];
    
}

-(NSString*)Byte_to_hexString:(Byte *)bytes :(int)len
{
    NSString *hexStr=@"";
    //Byte *bytes = (Byte *)[data bytes];
    for(int i=0;i<len;i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff]; ///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

-(NSString*)Byte_to_String:(Byte *)bytes :(int)len
{
    NSString *hexStr=@"";//[t Byte_to_hexString:bytes :len];
    NSData *adata = [[NSData alloc] initWithBytes:bytes length:len];
    hexStr = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
    return hexStr;
}

//接收功能配置通道数据
-(void)rx_ble_function_event:(Byte *)bytes :(int)len
{
    if( len==5 )
    {
        if( bytes[0]==0xf6 )
        {
            if( bytes[1]==0x01 )
            {
                io2 = true;
                
            }else{
                io1 = false;
                
            }
            if( bytes[2]==0x01 )
            {
                io2 = true;
                
            }else{
                io2 = false;
                
            }
            if( bytes[3]==0x01 )
            {
                io3 = true;
                
            }else{
                io3 = false;
                
            }
            if( bytes[4]==0x01 )
            {
                io4 = true;
                
            }else{
                io4 = false;
                
            }
        }
    }
}

-(void)initData{
    string_buffer = @"";
    
    check1 = true;
    check2 = true;
    
    io1 = false;
    io2 = false;
    io3 = false;
    io4 = false;
    
    rx_len_count = 0;
    tx_len_count = 0;
}

#pragma mark-----------------禁止修改------------禁止修改------------------禁止修改----------------

@end
