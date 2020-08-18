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
}


@property (nonatomic, strong)FunctionHeaderView * headView;
@property (nonatomic, strong)CircleView * circleView1;
@property (nonatomic, strong)CircleView * circleView2;
@property (nonatomic, strong)KneadView* kneadView;

@property (nonatomic, strong)BottomView * bottomView;
@property (nonatomic, strong)UIView  * bgView;

@property (nonatomic, strong)NSArray * writeInstructArray;

@property (nonatomic, strong)NSArray * headerTipArray;//头部图片，提示数组

@property (nonatomic, strong)CBCharacteristic * writeCharacteristic;//写入特征
@property (nonatomic, strong)CBCharacteristic * notifyCharacteristic;//通知特征

@property (nonatomic, strong)NSMutableArray * instructArray;//硬件返回的指令

@property (nonatomic, copy)NSString *  massInstruct;//硬件返回的指令

@property (nonatomic, strong)UITapGestureRecognizer *  currentTimeTap;//当前选择的按摩时间
@property (nonatomic, strong)UIButton *  currentTimeBtn;//当前选择的按摩时间
@end

@implementation FunctionVC
-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    isGetMemory = 1;
    
    NSLog(@"进入");
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        NSLog(@"延时");
        //获取主板的记忆状态
        timeTV = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block:^(NSTimer * _Nonnull timer) {
            
            NSLog(@"timeTV");
            self->isGetTV = 1;
            if ([self.titleStr containsString:@"KQ"])
            {
                 [self sendDataWithString:@"FFFFFFFF03001400035F05"];
            }else if ([self.titleStr containsString:@"MQ"])
            {
                 [self sendDataWithString:@"FFFFFFFF03001800039F06"];
            }else
            {
                 [self sendDataWithString:@"FFFFFFFF03001600097EC2"];
            }
           
        }];
        
        timeZG = [NSTimer scheduledTimerWithTimeInterval:0.4 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timeZG");
            self->isGetZG = 1;
            if ([self.titleStr containsString:@"KQ"])
            {
                [self sendDataWithString:@"FFFFFFFF03001C0003DEC7"];
            }else if ([self.titleStr containsString:@"MQ"])
            {
                [self sendDataWithString:@"FFFFFFFF03002000031ECB"];
            }else
            {
               [self sendDataWithString:@"FFFFFFFF03001F0009AEC0"];
            }
            
            
        }];
        
        timeAS = [NSTimer scheduledTimerWithTimeInterval:0.6 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timeAS");
            self->isGetAS = 1;
            if ([self.titleStr containsString:@"KQ"])
            {
               
            }else if ([self.titleStr containsString:@"MQ"])
            {
                [self sendDataWithString:@"FFFFFFFF03003800039ECC"];
            }else
            {
                [self sendDataWithString:@"FFFFFFFF03003A0009BF0B"];
            }
            
        }];
        
        timeMemory1 = [NSTimer scheduledTimerWithTimeInterval:0.8 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timeMemory1");
            self->isGetMemory1= 1;
            if ([self.titleStr containsString:@"KQ"])
            {
                [self sendDataWithString:@"FFFFFFFF03002400035F0A"];
            }else if ([self.titleStr containsString:@"MQ"])
            {
                [self sendDataWithString:@"FFFFFFFF03002800039F09"];
            }else
            {
                [self sendDataWithString:@"FFFFFFFF03002800091F0E"];
            }
            
        }];
        
        timeMemory2 = [NSTimer scheduledTimerWithTimeInterval:0.10 repeats:NO block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timeMemory2");
            self->isGetMemory2 =1;
            if ([self.titleStr containsString:@"KQ"])
            {
                [self sendDataWithString:@"FFFFFFFF03002C0003DEC8"];
            }else if ([self.titleStr containsString:@"MQ"])
            {
                [self sendDataWithString:@"FFFFFFFF03003000031F0E"];
            }else
            {
               [self sendDataWithString: @"FFFFFFFF0300310009CEC9"];
            }
            
        }];
        
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.TitleNav.text=self.titleStr;
    ishHuiMa = 0;
    isWeiTiao = 0;
    WeiTiaoIsHighlight = 0;
    if ([self.titleStr containsString:@"JQ-D"])
    {
        self.TitleNav.text =@"Tri-mix-JQ-D";
        
    }else if ([self.titleStr containsString:@"JQ"] ||[self.titleStr containsString:@"NQ"])
    {
        //self.TitleNav.text =@"Tri-mix-JQ";
        
         self.TitleNav.text =@"QMS-NQ";
    }
#pragma mark-----6.12新加KQ和MQ
    else if ([self.titleStr containsString:@"KQ"])
    {
        if ([self.titleStr containsString:@"KQ-H"])
        {
            self.TitleNav.text =@"Tri-mix-KQ-H";
        }else
        {
            self.TitleNav.text =@"Tri-mix-KQ";
        }
        
    } else if ([self.titleStr containsString:@"MQ"])
    {
        self.TitleNav.text =@"Tri-mix-MQ";
    }else if ([self.titleStr containsString:@"LQ"])
    {
        self.TitleNav.text =@"Tri-mix-LQ";
    }else
    {
        self.TitleNav.text =@"Tri-mix-IQ";
    }
    
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

#pragma mark - view
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
    [self sendDataWithString:@"FFFFFFFF0500000000D700"];
}


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
        [self sendDataWithString:@"FFFFFFFF050000A10A2E97"];
    }
}
-(void)clickCircleView1WithLongPress:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan)
    {
        if(isMemory1){
            [self sendDataWithString:@"FFFFFFFF050000AF0A2AF7"];
        }else{
            [self sendDataWithString:@"FFFFFFFF050000A00A2F07"];
        }
        isMemory1=!isMemory1;
        self.circleView1.isMemory=isMemory1;
    }
}


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
        [self sendDataWithString:@"FFFFFFFF050000B10BE297"];
    }
}
-(void)clickCircleView2WithLongPress:(UILongPressGestureRecognizer *)tap{
        if (tap.state == UIGestureRecognizerStateBegan) {
            if(isMemory2){
                [self sendDataWithString:@"FFFFFFFF050000BF0BE6F7"];
            }else{
                [self sendDataWithString:@"FFFFFFFF050000B00BE307"];
            }
            isMemory2=!isMemory2;
            self.circleView2.isMemory=isMemory2;
        }
}

#pragma mark - 底部view
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
        case 1:
            ishHuiMa = 0;
            isWeiTiao = 0;
            [self setFunctionView1];
            break;
        case 2:
#pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改   名字以及发码的修改
            if ([self.titleStr containsString:@"KQ"]&&![self.titleStr containsString:@"KQ-H"])
            {
                [self setFunctionKQView];
            }else if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
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
            ishHuiMa = 1;
            isWeiTiao = 0;
            [self setFunctionView3];
            break;
        case 4:
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
    
        self.writeInstructArray=@[@"FFFFFFFF05000000051703",@"FFFFFFFF0500005F0521F3",@"FFFFFFFF050000000F9704 ",@"FFFFFFFF0500000008D6C6",@"FFFFFFFF0500000028D71E",@"FFFFFFFF050000002916DE"];
        NSArray * imageArray=@[@"图层1",@"零压力",@"止鼾",@"复原",@"听音乐",@"向上倾斜"];
        NSArray * titleArray=@[@"TV",@"ZG",@"ANTI SNORE",@"FLAT",@"Music",@"Leg Relax"];
    
    
    #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改   名字以及发码的修改
    if ([self.titleStr containsString:@"KQ"])
    {
        titleArray=@[@"TV",@"ZG",@"LUMBER",@"FLAT",@"Music",@"Leg Relax"];
        self.writeInstructArray=@[@"FFFFFFFF05000000051703",@"FFFFFFFF0500005F0521F3",@"FFFFFFFF050000002E571C ",@"FFFFFFFF0500000008D6C6",@"FFFFFFFF0500000028D71E",@"FFFFFFFF050000002916DE"];
    }
    
    NSInteger  count;count =imageArray.count;
    float jianGe = 0;
    float jianGe1 = 0;
    #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断
    if ([self.titleStr containsString:@"JQ"]||[self.titleStr containsString:@"JQ-D"]||[self.titleStr containsString:@"KQ"]||[self.titleStr containsString:@"MQ"])
    {
        count = 4;
        jianGe = 25;
        jianGe1 = 20;
    }
    
    
        for (int i =0; i<count; i++)
        {
            FunctionView * view = [[FunctionView alloc] initWithFrame:CGRectMake(24 *kScreenscale+ 173*kScreenscale*(i%2), (GMAXY(self.circleView1)+9)+jianGe+(60*kScreenscale+jianGe1)*(i/2), 157*kScreenscale, 52*kScreenscale)];
            view.tag=100+i;
            view.userInteractionEnabled=YES;
            
            
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
                    if ([self.titleStr containsString:@"KQ"])
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
           
            if ([self.titleStr containsString:@"KQ"]&&i ==3)
            {
                
            }else
            {
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewWithTap:)];
                [view addGestureRecognizer:tap];
            }
         
            
#pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改  取消顶腰的长按以及新增复原的长按
            if ([self.titleStr containsString:@"KQ"])
            {
                if(i<2)
                {
                    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewWithLongPress:)];
                    longPress.minimumPressDuration = 3.0;
                    [view addGestureRecognizer:longPress];
                    
                   
                }
                
                
                if(i ==3)
                {
                    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(huanYuanclickViewWithLongPress:)];
                    longPress.minimumPressDuration = 0.01;
                    [view addGestureRecognizer:longPress];
                    
                    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KQClickViewWithTap)];
                    [view addGestureRecognizer:tap];
                }
                
            }else
            {
                if(i<3)
                {
                    
                    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewWithLongPress:)];
                    longPress.minimumPressDuration = 3.0;
                    [view addGestureRecognizer:longPress];
                }
            }
           
            
            
            
            
            [view setupSubViewsWithFunctionImageName:imageArray[i] andFunctionName:titleArray[i]];
            [self.bgView addSubview:view];
        }
    
    self.headerTipArray=@[@{@"name":@"TV",@"image":@"图层1"},@{@"name":@"ZG",@"image":@"零压力"},@{@"name":@"ANTI SNORE",@"image":@"止鼾"},@{@"name":@"FLAT",@"image":@"复原"},@{@"name":@"Music",@"image":@"听音乐"},@{@"name":@"Leg Relax",@"image":@"向上倾斜"}];
    
    
#pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改  修改圆圈内的显示
    if ([self.titleStr containsString:@"KQ"])
    {
    self.headerTipArray=@[@{@"name":@"TV",@"image":@"图层1"},@{@"name":@"ZG",@"image":@"零压力"},@{@"name":@"LUMBER",@"image":@"止鼾"},@{@"name":@"FLAT",@"image":@"复原"},@{@"name":@"Music",@"image":@"听音乐"},@{@"name":@"Leg Relax",@"image":@"向上倾斜"}];
    }
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

-(void)clickViewWithTap:(UITapGestureRecognizer *)tap{
    
    
    FunctionView * view=(FunctionView *)tap.view;

    _state1=view.tag-100;
    switch (_state1) {
        case 0:
            if (isTV)
            {
                [self sendDataWithString:@"FFFFFFFF05000051052A93"];
            }
            else{
                [self sendDataWithString:@"FFFFFFFF05000000051703"];
            }
 
            
            break;
        case 1:
            if (isZG) {
                [self sendDataWithString:@"FFFFFFFF05000091097A96"];
            }
            else{
                
                [self sendDataWithString:@"FFFFFFFF05000000091706"];

            }
            
            
            break;
        case 2:
            
            #pragma mark----6.12关于新加KQ的快捷调整--新增KQ的判断修改 顶腰发码的修改
            if (isAS) {
                
                if ([self.titleStr containsString:@"KQ"])
                {
                    [self sendDataWithString:@"FFFFFFFF050000002E571C"];
                }else
                {
                    [self sendDataWithString:@"FFFFFFFF050000F10FD294"];
                }
            }
            else{
                if ([self.titleStr containsString:@"KQ"])
                {
                   [self sendDataWithString:@"FFFFFFFF050000002E571C"];
                }else
                {
                    [self sendDataWithString:@"FFFFFFFF050000000F9704"];
                }
                
            }
            break;

        default:
            [self sendDataWithString:self.writeInstructArray[_state1]];
            break;
    }
    [self setheadViewWithinfo:self.headerTipArray[_state1]];
}

 #pragma mark----6.12关于新加KQ的快捷调整--还原加入长按的处理
-(void)KQClickViewWithTap
{
     [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[3][@"image"] andFunctionName:self.headerTipArray[3][@"name"] ];
    
    [self sendDataWithString:@"FF FF FF FF 05 00 00 F1 0F D2 94"];
}
-(void)huanYuanclickViewWithLongPress:(UILongPressGestureRecognizer *)tap{
    
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

        __weak typeof(self) weakSelf = self;
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
        NSLog(@"1----%d",KQTime);
        dispatch_source_set_cancel_handler(KQTimer, ^{
            
            NSLog(@"cancel");
            
        });
        KQTimer = nil;
        NSLog(@"4----%d",KQTime);
        if (KQTime < 3)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 F1 0F D2 94"];
        }else
        {
             [self getbeforeimage:view wwithSatus:0];
        }
        
        KQTime= 0;
    }
    
}



-(void)clickViewWithLongPress:(UILongPressGestureRecognizer *)tap{
    FunctionView * view=(FunctionView *)tap.view;
    
    _state1=view.tag-100;
    ishHuiMa = 1;
    NSLog(@"clickViewWithLongPress=====%ld",(long)_state1);
    if (tap.state == UIGestureRecognizerStateBegan) {
        
        switch (_state1) {
            case 0:
                if (isTV) {
                    [self sendDataWithString:@"FFFFFFFF0500005F052EF3"];
                }
                else{
                    [self sendDataWithString:@"FFFFFFFF05000050052B03"];
                }
                isTV=!isTV;
                break;
            case 1:
                if (isZG) {
                    [self sendDataWithString:@"FFFFFFFF0500009F097EF6"];
                }
                else{
                    [self sendDataWithString:@"FFFFFFFF05000090097B06"];
                }
                isZG=!isZG;
                break;
            case 2:
                
                if (isAS) {
                    [self sendDataWithString:@"FFFFFFFF050000FF0FD6F4"];
                }
                else{
                    [self sendDataWithString:@"FFFFFFFF050000F00FD304"];
                }
                isAS=!isAS;
                break;
              
            default:
                break;
        }
    }
    
   
   if (tap.state == UIGestureRecognizerStateEnded)
   {

   }
    
     [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[_state1][@"image"] andFunctionName:self.headerTipArray[_state1][@"name"] ];
    
}


#pragma mark================================================
#pragma mark----6.12关于新加KQ的微调界面     这里的图标以及文字需要修改
-(void)setFunctionKQView{
    
    NSLog(@"新加KQ的微调界面");
    
    self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"Leg Circulation",@"image":@"图层1"},@{@"name":@"Hip Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}];
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
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(KQClickViewWithLongPress:)];
        longPress.minimumPressDuration = 0.1;
        [imgV addGestureRecognizer:longPress];
    }
}
#pragma mark----6.12关于新加KQ的长按处理
-(void)KQClickViewWithLongPress:(UILongPressGestureRecognizer*)tap
{
    UIImageView * imgV=(FunctionView *)tap.view;
   
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        
        if (imgV.tag  ==1000)
        {
            [self sendDataWithString:@"FFFFFFFF05000000039701"];
        }else
        {
            [self sendDataWithString:@"FFFFFFFF0500000004D6C3"];
        }
        
        
        NSArray * newArray=@[@{@"name":@"BACK",@"image":@"背部调整111f"},@{@"name":@"BACK",@"image":@"背部调整111"},@{@"name":@"HEAD",@"image":@"头部调整1112"},@{@"name":@"LEG",@"image":@"腿部调整111"}];
        [_headView setupSubViewsWithGIFImageName:newArray[imgV.tag -1000][@"image"] andFunctionName:newArray[imgV.tag -1000][@"name"]];
        
    }

    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (imgV.tag  ==1000)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 00 D700"];
        }else
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 00 D7 00"];
        }
        
        [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[0][@"image"] andFunctionName:self.headerTipArray[0][@"name"] ];
    }
  
    
}

#pragma mark xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#pragma mark----6.12关于新加MQ的微调界面     修改h了 这个无效了
-(void)setFunctionMQView{
    
    NSLog(@"新加KQ的微调界面");
    
    self.headerTipArray=@[@{@"name":@"",@"image":@"背部调整f2"},@{@"name":@"Hip Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}];
    [self setheadViewWithinfo:self.headerTipArray[0]];
    
    for (int i =0; i < 2; i ++)
    {
        UIImageView * imgV=  [[UIImageView alloc]initWithFrame:CGRectMake(35*kScreenscale+(135*kScreenscale+35*kScreenscale)*i, GVH(self.bgView)/2.0-67.5*kScreenscale, 135*kScreenscale, 135*kScreenscale)];
        imgV.backgroundColor = [UIColor blueColor];
        imgV.tag  =1100+i;
        [self.bgView addSubview:imgV];
        
        
        imgV.userInteractionEnabled = 1;
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(MQClickViewWithLongPress:)];
        longPress.minimumPressDuration = 0.1;
        [imgV addGestureRecognizer:longPress];
    }
}
#pragma mark----6.12关于新加MQ的长按处理
-(void)MQClickViewWithLongPress:(UILongPressGestureRecognizer*)tap
{
    UIImageView * imgV=(FunctionView *)tap.view;
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        
        if (imgV.tag  ==1100)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 03 97 01"];
        }else if (imgV.tag  ==1101)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 04 D6 C3"];
        }else if (imgV.tag  ==1102)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 06 57 02"];
        }else
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 07 96 C2"];
        }
        
        
        NSArray * newArray=@[@{@"name":@"BACK",@"image":@"背部调整111f"},@{@"name":@"HIP",@"image":@""},@{@"name":@"HEAD",@"image":@"头部调整1112"},@{@"name":@"LEG",@"image":@"腿部调整111"}];
        [_headView setupSubViewsWithGIFImageName:newArray[2][@"image"] andFunctionName:newArray[2][@"name"]];
        
    }
    
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (imgV.tag  ==1100)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 00 D7 00"];
        }else if (imgV.tag  ==1101)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 00 D7 00"];
        }else if (imgV.tag  ==1102)
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 00 D7 00"];
        }else
        {
            [self sendDataWithString:@"FF FF FF FF 05 00 00 00 00 D7 00"];
        }
        
        [_headView setupSubViewsWithFunctionImageName:self.headerTipArray[_state1][@"image"] andFunctionName:self.headerTipArray[_state1][@"name"] ];
    }
}
#pragma mark xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#pragma mark - 微调
-(void)setFunctionView2{//图层1  图层1拷贝13
    NSArray * imageArray=@[@"背部调整f2",@"图层1",@"头部调整F-1",@"图层1拷贝11"];
    NSArray * titleArray=@[@"BACK",@"HIP",@"HEAD",@"LEG"];
   
    self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"HIP",@"image":@"图层1"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
    #pragma mark----6.12关于新加MQ的微调界面
    if ([self.titleStr containsString:@"JQ-D"])
    {
        self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"WAIST",@"image":@"图层1拷贝13"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
        imageArray=@[@"背部调整f2",@"图层1拷贝13",@"头部调整F-1",@"图层1拷贝11"];
        titleArray=@[@"BACK",@"WAIST",@"HEAD",@"LEG"];

    }
    else if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
    {
        #pragma mark----6.19新加MQ
        if ([self.titleStr containsString:@"KQ-H"])
        {
            imageArray=@[@"背部调整f2",@"复原"];
            titleArray=@[@"BACK",@"Overall Lifting"];
        self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"Overall Lifting",@"image":@"复原"}];
        }else
        {
            imageArray=@[@"背部调整f2",@"图层1拷贝11"];
            titleArray=@[@"BACK",@"LEG"];
        self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
        }
    } else if ([self.titleStr containsString:@"IQ"]||[self.titleStr containsString:@"LQ"])
    {
        self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"HIP",@"image":@"图层1拷贝13"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
        imageArray=@[@"背部调整f2",@"图层1拷贝13",@"头部调整F-1",@"图层1拷贝11"];
        titleArray=@[@"BACK",@"HIP",@"HEAD",@"LEG"];
#pragma mark=-------7.13修改JQ
    }else  if ([self.titleStr containsString:@"JQ"]&&![self.titleStr containsString:@"JQ-D"])
    {
        self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"WAIST",@"image":@"图层1拷贝13"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
        imageArray=@[@"背部调整f2",@"图层1",@"图层1拷贝13",@"图层1拷贝11"];
        titleArray=@[@"BACK",@"BACK AND LEG",@"WAIST",@"LEG"];
    }else
    {
        self.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
        imageArray=@[@"背部调整f2",@"图层1",@"头部调整F-1",@"图层1拷贝11"];
        titleArray=@[@"BACK",@"BACK AND LEG",@"HEAD",@"LEG"];
    }
    
    //NSArray * titleH=@[@"全身循环",@"背腿循环",@"头部循环",@"腿部循环"];
     NSArray *   titleH=@[@"Whole Body Circulation",@"Hip Circulation",@"Head Circulation",@"Leg Circulation"];
    for (int i =0; i<titleArray.count; i++)
    {
        float  height;
        #pragma mark----6.19新加MQ  7.13  KQ-H
        if ([self.titleStr containsString:@"MQ"]|[self.titleStr containsString:@"KQ-H"])
        {
            height = 60.00f;
        }else
        {
            height = 0.00f;
        }
        
        TrimmingView  * view=[[TrimmingView alloc] initWithFrame:CGRectMake(24 *kScreenscale+ 173*kScreenscale*(i%2), 52+130*kScreenscale*(i/2)+height, 157*kScreenscale, 60*kScreenscale)];
        view.stateImageView.image=kxImageNameWith(imageArray[i]);
        view.delegate=self;
        view.tag=200+i;
        [self.bgView addSubview:view];
        
    
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(24 *kScreenscale+ 173*kScreenscale*(i%2), GMAXY(view)+10, GVW(view), 20)];
        label.textColor=[UIColor whiteColor];
        label.text=Localized(titleArray[i]);
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:15];
        label.tag = 888+i;
        
        if (WeiTiaoIsHighlight ==1)
        {
            view.backImgV.image = [UIImage imageNamed:@"下沉按钮"];
            label.text=Localized(titleH[i]);
            
    
            view.upButton.hidden =1;
            view.downButton.hidden = 1;
            
             self.headerTipArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Hip Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}];
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
            if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
            {
                
                return ;
            }
            
            if (self->WeiTiaoIsHighlight ==1)
            {
                
                if (index ==1)
                {
                    
                    self.headerTipArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Hip Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}];
                    if ([self.titleStr containsString:@"JQ-D"])//腰部调整
                    {
                        
                        self.headerTipArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Waist Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}];
                    }
#pragma  mark----7.13
                    if (![self.titleStr containsString:@"JQ-D"]&&[self.titleStr containsString:@"JQ"])//jq
                    {
                        
                        self.headerTipArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Back Leg Circulation",@"image":@"图层1"},@{@"name":@"Waist Circulation",@"image":@"图层1拷贝13"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}];
                    }
                    [self->_headView setupSubViewsWithFunctionImageName:self.headerTipArray[self->_state2][@"image"] andFunctionName:self.headerTipArray[self->_state2][@"name"]];
                    
                    
                }else if (index ==0)//高亮下点击  也就是循环下点击
                {
                    self->_state2 = view.tag  - 200;
              
                    NSArray * newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@""},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
#pragma  mark----7.13
                    if (![self.titleStr containsString:@"JQ-D"]&&[self.titleStr containsString:@"JQ"])//jq
                    {
                        
                        newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@""},@{@"name":@"Waist Circulation",@"image":@"臀部上升111"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
                    }
#pragma mark----7.13调整


                    if (self->_state2 ==1)
                    {
                        if ([self.titleStr containsString:@"JQ-D"])//腰部调整
                        {
                            newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Waist Circulation",@"image":@"臀部上升111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
                        }else if ([self.titleStr containsString:@"IQ"]||[self.titleStr containsString:@"LQ"])//臀部调整
                        {
                            newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"臀部上升111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
                        }
                        #pragma mark----7.13调整
                        else if ([self.titleStr containsString:@"JQ"] && ![self.titleStr containsString:@"JQ-D"]) {
                            
                            newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Back Leg Circulation",@"image":@"背腿升起111"},@{@"name":@"Waist Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
                        }
                        else//背腿调整
                        {
                            newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"背腿升起111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
                        }
                    }
                    
    //a设置的动图
                    
                    [self->_headView setupSubViewsWithGIFImageName:newArray[self->_state2][@"image"] andFunctionName:newArray[self->_state2][@"name"]];
                    
                      
                    NSArray *  writeInstructArr=
                    @[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E38688",@"FFFFFFFF05000500E5068A"];
                    
#pragma mark=====5.24新加的
 #pragma mark=====7.14修改的

                     if (![self.titleStr containsString:@"JQ-D"]&&[self.titleStr containsString:@"JQ"])//jq
                     {
                         
                         writeInstructArr=
                         @[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E8C74F",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E5068A"];
                         
                     }
                    [self sendDataWithString:writeInstructArr[self->_state2]];
                    
                }
                
            }
            
            
        };
    }
    
    
    __weak typeof(self)weakSelf = self;
    //长按
    self.headView.longPressClick = ^(NSInteger index) {
       
    
#pragma mark----6.19新加MQ   7.13
        if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
        {
            
            return ;
        }
        
        
        if (self->isWeiTiao ==1)
        {
            self->WeiTiaoIsHighlight = !self->WeiTiaoIsHighlight;
            if (self->WeiTiaoIsHighlight ==0)//这个是由循环变为微调的
            {
                NSArray * imageArray=@[@"背部调整f2",@"图层1",@"头部调整F-1",@"图层1拷贝11"];
                NSArray * titleArray=@[@"BACK",@"HIP",@"HEAD",@"LEG"];
                
                weakSelf.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"HIP",@"image":@"图层1"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
                
                if ([weakSelf.titleStr containsString:@"JQ-D"])
                {
                    weakSelf.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"WAIST",@"image":@"图层1拷贝13"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
                    imageArray=@[@"背部调整f2",@"图层1拷贝13",@"头部调整F-1",@"图层1拷贝11"];
                    titleArray=@[@"BACK",@"WAIST",@"HEAD",@"LEG"];
                    
                }else if ([weakSelf.titleStr containsString:@"IQ"]||[self.titleStr containsString:@"LQ"])
                {
                    weakSelf.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"HIP",@"image":@"图层1拷贝13"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
                    imageArray=@[@"背部调整f2",@"图层1拷贝13",@"头部调整F-1",@"图层1拷贝11"];
                    titleArray=@[@"BACK",@"HIP",@"HEAD",@"LEG"];
                }else
                {
                    weakSelf.headerTipArray=@[@{@"name":@"BACK",@"image":@"背部调整f2"},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"HEAD",@"image":@"头部调整F-1"},@{@"name":@"LEG",@"image":@"图层1拷贝11"}];
                    imageArray=@[@"背部调整f2",@"图层1",@"头部调整F-1",@"图层1拷贝11"];
                    titleArray=@[@"BACK",@"BACK AND LEG",@"HEAD",@"LEG"];
                }
                
                for (int i =0; i<titleArray.count; i++)
                {
                    UILabel * lable =(UILabel*) [weakSelf.bgView viewWithTag:888+i];
                    lable.text = Localized(titleArray[i]);;
                    
                    TrimmingView  * TrimmingV = [weakSelf.bgView viewWithTag:200+i];
                    
                    TrimmingV.backImgV.image = [UIImage imageNamed:@"不下沉按钮"];
                    TrimmingV.upButton.hidden =0;
                    TrimmingV.downButton.hidden = 0;
                }
                
                 [self->_headView setupSubViewsWithFunctionImageName:weakSelf.headerTipArray[0][@"image"] andFunctionName:weakSelf.headerTipArray[0][@"name"]];
            }else
            {
                NSLog(@"高亮");
#pragma mark-----4.24新加的
                #pragma mark----这个才是设置循环显示的
                
                NSArray *   title=@[@"Whole Body Circulation",@"Hip Circulation",@"Head Circulation",@"Leg Circulation"];
                
                 if ([weakSelf.titleStr containsString:@"JQ-D"])
                 {
                     
                     title=@[@"Whole Body Circulation",@"Waist Circulation",@"Head Circulation",@"Leg Circulation"];
                 }
                
                if ([weakSelf.titleStr containsString:@"JQ"] && ![weakSelf.titleStr containsString:@"JQ-D"])
                {
                    
                    title=@[@"Whole Body Circulation",@"Back Leg Circulation",@"Waist Circulation",@"Leg Circulation"];
                }
                
                for (int i =0; i<titleArray.count; i++)
                {
                    UILabel * lable =(UILabel*) [weakSelf.bgView viewWithTag:888+i];
                    lable.text = Localized(title[i]);
                    
                    TrimmingView  * TrimmingV = [weakSelf.bgView viewWithTag:200+i];
                    
                    TrimmingV.backImgV.image = [UIImage imageNamed:@"下沉按钮"];
                    
                    TrimmingV.upButton.hidden =1;
                    TrimmingV.downButton.hidden = 1;
                }
                
                weakSelf.headerTipArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整f2"},@{@"name":@"Hip Circulation",@"image":@"图层1"},@{@"name":@"Head Circulation",@"image":@"头部调整F-1"},@{@"name":@"Leg Circulation",@"image":@"图层1拷贝11"}];

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
    [self sendDataWithString:@"FFFFFFFF0500000000D700"];
    TrimmingView * view=(TrimmingView *)sender.superview;
    _state2=view.tag-200;
    [self setheadViewWithinfo:self.headerTipArray[_state2]];
}


#pragma mark---微调模块的向上的按钮的方法
-(void)clickUpdateButton:(UIButton *)sender{
    
    TrimmingView * view=(TrimmingView *)sender.superview;
    _state2=view.tag-200;

    
    if (WeiTiaoIsHighlight ==1)//高亮下的微调
    {
        NSArray * newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@""},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
        if (_state2 ==1)
        {
            if ([self.titleStr containsString:@"JQ-D"])//腰部调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"臀部上升111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
            }else if ([self.titleStr containsString:@"IQ"]||[self.titleStr containsString:@"LQ"])//臀部调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"臀部上升111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
            }else//背腿调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"背腿升起111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
            }
        }
        
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
        
         NSArray *  writeInstructArr=
        @[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E38688",@"FFFFFFFF05000500E5068°"];
        [self sendDataWithString:writeInstructArr[_state2]];
        
        return;
    }
    

    if (_state2 !=1)
    {
        NSArray * newArray=@[@{@"name":@"BACK",@"image":@"背部调整111f"},@{@"name":@"HIP",@"image":@""},@{@"name":@"HEAD",@"image":@"头部调整1112"},@{@"name":@"LEG",@"image":@"腿部调整111"}];
        
#pragma mark=-------7.13修改JQ
      if ([self.titleStr containsString:@"JQ"]&&![self.titleStr containsString:@"JQ-D"])
    {
        newArray=@[@{@"name":@"BACK",@"image":@"背部调整111f"},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"WAIST",@"image":@"臀部上升111"},@{@"name":@"LEG",@"image":@"腿部调整111"}];
    }
    
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
        
    }else
    {
        #pragma mark----6.19新加MQ
        NSArray * array = [NSArray array];
        if ([self.titleStr containsString:@"JQ-D"])//腰部调整
        {
            array = @[@{@"name":@"WAIST",@"image":@"臀部上升111"}];
        }else if ([self.titleStr containsString:@"IQ"]||[self.titleStr containsString:@"LQ"])//臀部调整
        {
            array = @[@{@"name":@"HIP",@"image":@"臀部上升111"}];
        }else if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
        {
            if ([self.titleStr containsString:@"MQ"])
            {
                 array =  @[@{@"name":@"LEG",@"image":@"腿部调整111"}];
            }else
            {
                 array =  @[@{@"name":@"Overall Lifting",@"image":@"复原"}];
            }
        }else//背腿调整
        {
            array = @[@{@"name":@"BACK AND LEG",@"image":@"背腿升起111"}];
        }
        #pragma mark----7.20修改
        
        if ([self.titleStr containsString:@"KQ-H"])
        {
             [_headView setupSubViewsWithFunctionImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }else
        {
             [_headView setupSubViewsWithGIFImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }
        
        
       
    }
   
    #pragma mark----7.13仅JQ 界面 调整
    
    NSArray * writeInstructArray=@[@"FFFFFFFF05000000039701",@"FFFFFFFF050000000D16C5",@"FFFFFFFF050000000116C0",@"FFFFFFFF05000000065702"];
     if (![self.titleStr containsString:@"JQ-D"] && [self.titleStr containsString:@"JQ"])
     {
     writeInstructArray=@[@"FFFFFFFF05000000039701",@"FFFFFFFF050000002B971F",@"FFFFFFFF050000000D16C5",@"FFFFFFFF05000000065702"];
      }
    
     #pragma mark----6.19新加MQ
    if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
    {
        writeInstructArray=@[@"FF FF FF FF 05 00 00 00 03 97 01",@"FF FF FF FF 05 00 00 00 06 57 02"];
    }

    [self sendDataWithString:writeInstructArray[_state2]];

}
#pragma mark--微调模块的向下的按钮的方法
-(void)clickDownButton:(UIButton *)sender{
    TrimmingView * view=(TrimmingView *)sender.superview;
    _state2=view.tag-200;
    
    
    if (WeiTiaoIsHighlight ==1)
    {
        NSArray * newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@""},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
        if (_state2 ==1)
        {
            if ([self.titleStr containsString:@"JQ-D"])//腰部调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"臀部上升111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
            }else if ([self.titleStr containsString:@"IQ"]||[self.titleStr containsString:@"LQ"])//臀部调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"臀部上升111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
            }else//背腿调整
            {
                newArray=@[@{@"name":@"Whole Body Circulation",@"image":@"背部调整111f"},@{@"name":@"Hip Circulation",@"image":@"背腿升起111"},@{@"name":@"Head Circulation",@"image":@"头部调整1112"},@{@"name":@"Leg Circulation",@"image":@"腿部调整111"}];
            }
        }
        
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
        
        NSArray *  writeInstructArr=
        @[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E38688",@"FFFFFFFF05000500E5068°"];
        [self sendDataWithString:writeInstructArr[_state2]];
        
        return;
    }
    
    
    if (_state2 !=1)
    {
        NSArray * newArray=@[@{@"name":@"BACK",@"image":@"背部调整111"},@{@"name":@"HIP",@"image":@""},@{@"name":@"HEAD",@"image":@"头部调整111F"},@{@"name":@"LEG",@"image":@"腿部调整111F"}];
#pragma mark=-------7.13修改JQ
        if ([self.titleStr containsString:@"JQ"]&&![self.titleStr containsString:@"JQ-D"])
        {
            newArray=@[@{@"name":@"BACK",@"image":@"背部调整111"},@{@"name":@"BACK AND LEG",@"image":@"图层1"},@{@"name":@"WAIST",@"image":@"臀部下降111"},@{@"name":@"LEG",@"image":@"腿部调整111F"}];
        }
        
        [_headView setupSubViewsWithGIFImageName:newArray[_state2][@"image"] andFunctionName:newArray[_state2][@"name"]];
        
    }else
    {
        NSArray * array = [NSArray array];
        if ([self.titleStr containsString:@"JQ-D"])//腰部调整
        {
            array = @[@{@"name":@"WAIST",@"image":@"臀部下降111"}];
        }else if ([self.titleStr containsString:@"IQ"]||[self.titleStr containsString:@"LQ"])//臀部调整
        {
            array = @[@{@"name":@"HIP",@"image":@"臀部下降111"}];
        }else if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
        {
             #pragma mark----6.19新加MQ
            if ([self.titleStr containsString:@"MQ"])
            {
                array =  @[@{@"name":@"LEG",@"image":@"腿部调整111"}];
            }else
            {
                array =  @[@{@"name":@"Overall Lifting",@"image":@"复原"}];
            }
        }else//背腿调整
        {
            array = @[@{@"name":@"BACK AND LEG",@"image":@"背腿下降111"}];
        }
        
        if ([self.titleStr containsString:@"KQ-H"])
        {
            [_headView setupSubViewsWithFunctionImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }else
        {
            [_headView setupSubViewsWithGIFImageName:array[0][@"image"] andFunctionName:array[0][@"name"]];
        }
    
    }


     NSArray  * writeInstructArray=@[@"FFFFFFFF0500000004D6C3",@"FFFFFFFF050000000E56C4",@"FFFFFFFF050000000256C1",@"FFFFFFFF050000000796C2"];
#pragma mark----7.13   JQ键值更新
    
    if (![self.titleStr containsString:@"JQ-D"] && [self.titleStr containsString:@"JQ"])
    {
        writeInstructArray=@[@"FFFFFFFF0500000004D6C3",@"FFFFFFFF050000002CD6DD",@"FFFFFFFF050000000E56C4",@"FFFFFFFF050000000796C2"];
    }
    
    if (WeiTiaoIsHighlight ==1)
    {
        writeInstructArray=
        @[@"FFFFFFFF05000500E4C74A",@"FFFFFFFF05000500E6468B",@"FFFFFFFF05000500E38688",@"FFFFFFFF05000500E5068°"];
    }
    
     #pragma mark----6.19新加MQ
    if ([self.titleStr containsString:@"MQ"]||[self.titleStr containsString:@"KQ-H"])
    {
        writeInstructArray=
        @[@"FF FF FF FF 05 00 00 00 04 D6 C3",@"FF FF FF FF 05 00 00 00 07 96 C2"];
        NSLog(@"----%@",writeInstructArray[_state2]);
    }

    [self sendDataWithString:writeInstructArray[_state2]];

}

#pragma mark - 按摩
-(void)setFunctionView3{
    [self.bgView addSubview:self.kneadView];
    self.headerTipArray=@[@{@"name":@"MASS",@"image":@"图层1拷贝2"}];
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
        return;
        
        
        NSInteger i=0;
        switch (sender.tag-100) {
            case 0:
            {
                if (_kneadView.frequencyValue!=3) {
                    _kneadView.frequencyValue++;
                }
                i=_kneadView.frequencyValue;
            }
                break;
            case 1:
            {
                if (_kneadView.headValue!=3) {
                    _kneadView.headValue++;
                }
                i=_kneadView.headValue;
            }
               
                break;
            case 2:
            {
                if (_kneadView.footValue!=3) {
                    _kneadView.footValue++;
                }
                i=_kneadView.footValue;
            }
                break;
            default:
                break;
        }
        [self sendDataWithString:writeInstructArray[sender.tag-100][i]];
    }
}
#pragma mark--减少按钮的方法
-(void)clickReduceButton:(UIButton *)sender{
    if (isMassing) {

        NSArray *writeInstructArray=@[@"FFFFFFFF050000001516CF",@"FFFFFFFF0500000011170C",@"FFFFFFFF050000001396CD"];
        ishHuiMa = 1;
        NSLog(@"减少----%@",writeInstructArray[sender.tag-10]);
        [self sendDataWithString:writeInstructArray[sender.tag-10]];

        return;
        
        
        NSInteger i=0;
        switch (sender.tag-10) {
            case 0:
            {
//                if (_kneadView.frequencyValue) {
//                    _kneadView.frequencyValue--;
//                }
//                i=_kneadView.frequencyValue;
                
                if (_kneadView.frequencyValue==-1) {
                     i=_kneadView.frequencyValue;
                }else if (_kneadView.frequencyValue==0)
                {
                      _kneadView.frequencyValue = -1;
                }else
                {
                    _kneadView.frequencyValue--;
                }
            }
                break;
            case 1:
            {
                if (_kneadView.headValue) {
                    _kneadView.headValue--;
                }
                i=_kneadView.headValue;
            }
                break;
            case 2:
            {
                if (_kneadView.footValue) {
                    _kneadView.footValue--;
                }
                i=_kneadView.footValue;
            }
              
                break;
            default:
                break;
        }
        
     
        
        if (i<0) {
            _kneadView.frequencyValue = -1;
            return;
        }else
        {
            [self sendDataWithString:writeInstructArray[sender.tag-10][i]];
        }
        
        
    
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
    
//    if(self.currentTimeTap==tap){
//        isMassing=YES;
//        NSArray * writeStopInstructArray=@[@"FFFFFFFF050000001CD6C9"];
//        [self sendDataWithString:writeStopInstructArray[0]];
////        return;
//    }else
//    {
//        self.currentTimeTap=tap;
//        isMassing=YES;
//        NSArray * writeInstructArray=@[@"FFFFFFFF050000001656CE",@"FFFFFFFF0500000017970E",@"FFFFFFFF0500000018D70A"];
//        UIView * view=tap.view;
//        [self sendDataWithString:writeInstructArray[view.tag-10]];
//    }
//
  
}

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
    
    self.headerTipArray=@[@{@"name":@"LIGHT",@"image":@"图层1拷贝"}];
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



#pragma mark -6.19新修改 发送，读取指令
-(void)sendDataWithString:(NSString *)writeInstruct1{
    
    NSString * writeInstruct = [writeInstruct1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"发送的指令======%@",writeInstruct);
    
    
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


-(void)rx_ble_event:(Byte *)bytes :(int)len;
{
    if( check1==false )
    {
        NSString *str = [self Byte_to_String:bytes :len ];
        rx_len_count+=len;
        NSLog(@"rx_len_count===%@",[NSString stringWithFormat:@"%@%dBytes",@"接收：",rx_len_count]);
        //str=[str stringByAppendingString:@"eee" ];
        //[ string_buffer appendFormat:@"%@", str ];
        string_buffer = [NSString stringWithFormat:@"%@\r\n%@",string_buffer,str];
    }
    else
    {
        NSString *str = [self Byte_to_hexString:bytes :len ];
        rx_len_count+=len;
       // NSLog(@"rx_len_count===%@",[NSString stringWithFormat:@"%@%dBytes",@"接收：",rx_len_count]);
        string_buffer = [NSString stringWithFormat:@"%@\n%@",string_buffer,str];
        //NSLog(@"string_buffer====%@",string_buffer);
        
        if (isGetMemory)
        {
            NSArray * array = [string_buffer componentsSeparatedByString:@"\n"];
            
            
            NSString * last = [array lastObject];
            
            
            
            NSString * responeStr = [last substringWithRange:NSMakeRange(12, 4)];
            
            NSLog(@"isGetMemory=========%@===",array);
            
            
            
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
            
            if ([responeStr isEqualToString:@"00af"]&& ![last isEqualToString:@"ffffffff050000af0a2af7"])
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
            
             NSLog(@"======%@=======%@===%@",[array lastObject],array[0],last);
            
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
            
            else if ([last isEqualToString:@"ffffffff050000f00fd304"] && [self.titleStr containsString:@"KQ"])
            {
                _kneadView.frequencyValue=3;
            }
            
            
            else
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
 
                        }
                        else{
                            
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

                        }
                        else{
                            
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
                        }
                        else{
                            
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
        return;
       
        
        
        if(ishHuiMa)
        {
            
            [self.instructArray insertObject:str atIndex:self.instructArray.count];
            self.massInstruct=[self.instructArray componentsJoinedByString:@""];
            if (self.massInstruct.length==88)
            {
                NSLog(@"self.instructArray====%@，self.massInstruct.legnth=%ld",self.massInstruct,self.massInstruct.length);
                NSArray * array=[self.massInstruct componentsSeparatedByString:@"ffffffff"];
                self.instructArray=[NSMutableArray arrayWithArray:array];
                [self.instructArray removeObjectAtIndex:0];
                NSArray * writeInstructArray=@[@[@"FFFFFFFF050000001656CE",@"FFFFFFFF0500000017970E",@"FFFFFFFF0500000018D70A"],@[@"FFFFFFFF0500000100D690",@"FFFFFFFF050000011E1844",@"FFFFFFFF050000011F5845",@"FFFFFFFF05000001209985"],@[@"FFFFFFFF0500000200D660",@"FFFFFFFF050000022118B4",@"FFFFFFFF050000022258B5",@"FFFFFFFF05000002239975"],@[@"FFFFFFFF05000003241844",@"FFFFFFFF05000003255845",@"FFFFFFFF05000003269985",@"FFFFFFFF050000032735C6"]];
                
                
                
                for (int i = 0; i<writeInstructArray.count; i++) {
                    for (int j = 0 ; j<[writeInstructArray[i] count]; j++) {
                        NSString * searchStr=writeInstructArray[i][j];
                        NSString *instruct=[NSString stringWithFormat:@"ffffffff%@",self.instructArray[i]];
                        if ([searchStr caseInsensitiveCompare:instruct] == NSOrderedSame) {
                            NSLog(@"包含 %@,位置为:%d,%d",instruct,i,j);
                            switch (i) {
                                case 0:
                                    selectTime = j;
                                    break;
                                case 1:
                                    _kneadView.frequencyValue=j;

                                    break;
                                case 2:
                                    _kneadView.headValue=j;
                                    break;
                                case 3:
                                    _kneadView.footValue=j;
                                    break;

                                default:
                                    break;
                            }
                        }else
                        {

                        }
                    }
                }

            }
        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
