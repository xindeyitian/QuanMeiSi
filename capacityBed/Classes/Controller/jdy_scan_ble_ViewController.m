//
//  ViewController.m
//  77777
//
//  Created by LXXAVR on 14-1-9.
//  Copyright (c) 2014年 LXXAVR. All rights reserved.
//

#import "jdy_scan_ble_ViewController.h"
#import "FunctionVC.h"

@interface jdy_scan_ble_ViewController ()<JDY_BLE_Delegate>
{
    //YGHTabBarController *tabBarViewController_;
    
    FunctionVC *touchuang_view;
  
    
    Byte selected_type;
    
    int select_index ;
    
    Byte de_type ;
    
    NSInteger index ;
    NSTimer * timer ;
}
@property(nonatomic,copy)NSString *titleStr;
@end

@implementation jdy_scan_ble_ViewController
//@synthesize refreshControl;


#define PASS_ENABLE   1   //true时表示采用加密  false表示不采用加密
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSLog(@"Creating Variable in Memory");
        
        
        UITabBarItem *tbi2 = [[UITabBarItem alloc]
                              initWithTabBarSystemItem:UITabBarSystemItemFavorites
                              tag:0];
        [self setTabBarItem:tbi2];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    de_type = 0;
    self.title = @"设备";
    self.TitleNav.text=Localized(@"Equipment");

   UIBarButtonItem*  editButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"扫描"
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(toggleEdit:)];
    editButton.tag=1;
    
 
    int t55=0;
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSLog(@"这个设备是iphone");
        if(self.view.frame.size.height>480){t55=0;NSLog(@"这个设备是iphone5");}
        else {t55=65;NSLog(@"这个设备是iphone4");}
        tt6=0;
    } else {
        NSLog(@"这个设备是ipad");
        t55=0;
        tt6=1;
    }
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version > 5.1) {
        NSLog(@"ios6以上");
        hb=1;
    }else{
        NSLog(@"ios5");
        hb=0;
    }
    NSLog(@"ios000000");
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
    selected_type = touchuang;
    
    t = [[JDY_BLE alloc] init];
    t.delegate = self;
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, GVH(self.Nav)+24, kScreenwidth, kScreenheight-GVH(self.Nav)-24-KPHONEXHeight-50)];
    tab.tableFooterView=[[UIView alloc] init];
    [self.view addSubview:tab];
    [tab setDataSource:self ];
    [tab setDelegate:self];
    tab.separatorColor=[UIColor blackColor];
    tab.backgroundColor=[UIColor colorWithWhite:0.07 alpha:1];
    
    
    
    UIButton * btn =  [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenheight-KPHONEXHeight-50, kScreenwidth, 50)];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:Localized(@"Scanning Nearby Equipment") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag =1;
    [self.view addSubview:btn];
    
    
    
    dfg=0;

    
    
   
    
    
    
    [self setConect_status:0];
    [self setSelect_st:0];
    
    
  
    select_index = 0;
    
    aPeripheral8=nil;
    cont_status=0;
    
    
    ivt=0;
    dly=0;
    hbn=0;

    select_index = 0;
    

     [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
}



- (void)scanTimer:(NSTimer *)timer
{
    NSLog( @"send_data: %d",111 );
    select_index = 0;
    
    [t start_scan_ble];
    NSLog(@"Scan_Dev");
    [tab reloadData];
}



//uart_function_select=true表示透传
//uart_function_select=false表示功能
//hex_or_string=true表示十六进制发
//hex_or_string=false表示字符串发
-(void) TY_send_data_hex:(NSString*)data : (Boolean) uart_function_select :(Boolean)hex_or_string
{
    if( uart_function_select)//透传 UUID FFE1
    {
        //NSLog( @"TY_send_data: %@",data );
        if( hex_or_string )
        {
            if([data length]>0);
            else return;
            //Str=[NSString stringWithFormat:@"%@",Str];
            NSData *da2=[t stringToByte:data];
            Byte *testbyte=(Byte*)[da2 bytes];
            
            int len=(int)[da2 length];
            [ t send_uart_data:testbyte pp:len ];
        }
        else
        {
            NSData *dat = [data dataUsingEncoding:NSUTF8StringEncoding];
            Byte *testbyte=(Byte*)[dat bytes];
            [ t send_uart_data:testbyte pp:(int)dat.length ];
        }
    }
    else//功能 UUID FFE2
    {
        NSLog( @"send_data: %@",data );
        
        if([data length]>0);
        else return;
        //Str=[NSString stringWithFormat:@"%@",Str];
        NSData *da2=[t stringToByte:data];
        Byte *testbyte=(Byte*)[da2 bytes];
        NSLog(@"hh=%@",data);
        int len=(int)[da2 length];
        
        
        //[t send_function_data:testbyte p:[t activePeripheral] pp:len];
        [ t send_function_data:testbyte pp:len ];
    }
}


-(void) tabBar_Delegate_send_data_hex:(NSString*)data
{
    NSLog( @"send_data: %@",data );
    
    if([data length]>0);
    else return;
    //Str=[NSString stringWithFormat:@"%@",Str];
    NSData *da2=[t stringToByte:data];
    Byte *testbyte=(Byte*)[da2 bytes];
    NSLog(@"hh=%@",data);
    int len=(int)[da2 length];
    
    

    [ t send_function_data:testbyte pp:len ];

    
}



-(void)toggleEdit:(UIBarButtonItem*)tag
{
    NSLog(@"button_down");
    if(tag.tag==0)
    {
        NSLog(@"Set_Inf");
        NSLog(@"tag==1");

    }
    else if(tag.tag==1)
    {
        select_index = 0;

        [t start_scan_ble];
        NSLog(@"Scan_Dev");
        [tab reloadData];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return (NSInteger)[t.foundPeripherals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    CBPeripheral    *aPeripheral;
    NSInteger        row    = [indexPath row];
    aPeripheral = (CBPeripheral*)[t.foundPeripherals objectAtIndex:row];

    cell.textLabel.font = [UIFont systemFontOfSize:17];
    NSString * title = [aPeripheral.name stringByReplacingOccurrencesOfString:@";" withString:@""];
    NSString * aftersStr1 =  [title stringByReplacingOccurrencesOfString:@":" withString:@"A"];
    NSString * aftersStr2 =  [aftersStr1 stringByReplacingOccurrencesOfString:@";" withString:@"B"];
    NSString * aftersStr3 =  [aftersStr2 stringByReplacingOccurrencesOfString:@"<" withString:@"C"]; NSString * aftersStr4 =  [aftersStr3 stringByReplacingOccurrencesOfString:@"=" withString:@"D"];
    NSString * aftersStr5 =  [aftersStr4 stringByReplacingOccurrencesOfString:@">" withString:@"E"];
    NSString * aftersStr6 =  [aftersStr5 stringByReplacingOccurrencesOfString:@"?" withString:@"F"];
    cell.textLabel.text = aftersStr6;
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}


- (NSString *)stringFromHexString:(NSString *)hexString {
    
    int asciiCode = [hexString characterAtIndex:1];
    NSString * str = [NSString stringWithFormat:@"%c",asciiCode];
    
    return str;
    
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CBPeripheral    *aPeripheral;
    NSInteger        row    = [indexPath row];
    if (t.foundPeripherals.count ==0) {
          return;
    }
    aPeripheral = (CBPeripheral*)[t.foundPeripherals objectAtIndex:row];
    self.titleStr = [aPeripheral.name  stringByReplacingOccurrencesOfString:@";" withString:@""];

    UITableViewCell * cell = [tab cellForRowAtIndexPath:indexPath];
    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"connect"];

    select_row=(int)(row);
//    [[NSUserDefaults standardUserDefaults] setObject:t.MAC_ADDRESS[indexPath.row] forKey:@"UDID"];
    [t stop_scan_ble];

    if([t get_connected_status])
    {
        [t disconnected_JDY_BLE:row ];
    }
    
    if (![t get_connected_status])//[[t activePeripheral] isConnected])
    {
        if( selected_type==touchuang||selected_type==pwm_dentiao )
        {
            [t connect_JDY_BLE:row];
        }
        else
        {
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"目前暂不支持此功能！" preferredStyle:  UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];

            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
    }
    else
    {

    }
    
    [self setConect_status:(int)(row+1)];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    index = 1;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self addtTimer];
    }];
    [self.rigltbutton setTitle:[NSString stringWithFormat:@"%lds",index] forState:UIControlStateNormal];
    

    ivt=0;

    if ([t get_connected_status])
    {

        [t disconnectPeripheral ];

    }
    
}

-(void)addtTimer
{
    index ++;
    [self.rigltbutton setTitle:[NSString stringWithFormat:@"%lds",index] forState:UIControlStateNormal];
    if (index > 5 && t.JDY_BLE_NAME.count ==0)
    {
        [timer invalidate];
        touchuang_view = [[FunctionVC alloc] init];
        touchuang_view.titleStr = self.titleStr;
        
        touchuang_view.delegate = (id)self;
        //[self.navigationController pushViewController:touchuang_view animated:YES];
        index = 0;
    }
    
#pragma mark----7.13
    if (t.JDY_BLE_NAME.count !=0)
    {
        [timer invalidate];
         [self.rigltbutton setTitle:[NSString stringWithFormat:@"%@",@""] forState:UIControlStateNormal];
        index = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    touchuang_view = nil;
    
    [t start_scan_ble];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



- (void)myTask {
    sleep(10);
}
- (void)myTask1 {
    sleep(2);
}
- (void)myProgressTask {
 
}
- (void)myMixedTask {

}


-(void)handleTimer99
{
 
}



- (void)Scan {
    ivt = 0;
    [t start_scan_ble ];
    
    NSLog(@"查找设备");
    [tab reloadData];
}


// 透传通道 数据回调函数
-(void)rx_data_event:(Byte *)bytes :(int)len
{
    //NSString *hexStr=[t Byte_to_String:bytes :len];//[t Byte_to_hexString:bytes :len];
    if( touchuang_view!=nil )
    {
        [ touchuang_view rx_ble_event:bytes :len ];
    }
    
}
//功能配置 通道回调函数
-(void)rx_function_event:(Byte *)bytes :(int)len
{
    //NSString *hexStr=[t Byte_to_String:bytes :len];//[t Byte_to_hexString:bytes :len];
    if( touchuang_view!=nil )
    {
        [ touchuang_view rx_ble_function_event:bytes :len ];
    }
    
}


-(void) keyValuesUpdated:(char)sw {
    
}

//模块连接后会调用此函数
-(void) JDY_BLE_Ready {

    
    [t enable_JDY_BLE_uart];
    [t enable_JDY_BLE_function];
    
    NSLog(@"yyyyyyyyyyyyyyy\r\n");
    NSLog(@"didSelectRowAtIndexPath－－－－－－－=%02x",selected_type);
    [tab reloadData];
    
    if(ivt==0)
    {
        [t stop_scan_ble];
        
        ivt=1;
        if( selected_type==ibeacon )//iBeacon设备
        {

        }
        else if( selected_type==sensor_temp )//温度传感器
        {
            
        }
        
        else if( selected_type==touchuang )// 透传
        {
            touchuang_view = [[FunctionVC alloc] init];
            touchuang_view.titleStr = self.titleStr;
            //touchuang_view.titleStr = @"KQ-H";
            touchuang_view.delegate = (id)self;
            [self.navigationController pushViewController:touchuang_view animated:YES];
        }
        else if( selected_type==pwm_dentiao )// LED灯
        {

        }
        else if( selected_type==pwm_anmoqi_0 )// 按摩棒
        {
            
        }
        else if( selected_type==io_key4 )// 四路开关控制器
        {
            
        }
        else
        {
            
        }
    }
    viewData[0]=0xcc;
    viewData[1]=0x33;
    viewData[2]=0xc3;
    viewData[3]=0x3c;
    viewData[4]=0x01;
    viewData[5]=0x01;
    viewData[6]=0x01;
    viewData[7]=0x01;
    viewData[8]=0x01;
}
//扫描到列表时调用此函数
-(void)discoveryDidRefresh
{
    NSLog(@"---%@===%@",t.foundPeripherals,t.MAC_ADDRESS);
    [tab reloadData];
}



@end
