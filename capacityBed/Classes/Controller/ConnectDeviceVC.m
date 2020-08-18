//
//  ConnectDeviceVC.m
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/21.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "ConnectDeviceVC.h"
#import "BabyBluetooth.h"
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#import "FunctionVC.h"


#import "sys/utsname.h"

@interface ConnectDeviceVC ()<UITableViewDelegate,UITableViewDataSource>{
    BabyBluetooth *  _babyBluetooth;
}

// 存储的设备
@property (nonatomic, strong) NSMutableArray *peripherals;

//tableview
@property (nonatomic, strong) UITableView * deviceTableview;

@end

// 蓝牙4.0设备名
static NSString * const kBlePeripheralName = @"Quansi";

@implementation ConnectDeviceVC

- (NSMutableArray *)peripherals
{
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

-(UITableView *)deviceTableview{
    if(!_deviceTableview){
        _deviceTableview=[[UITableView alloc] initWithFrame:CGRectMake(0, GVH(self.Nav)+24, kScreenwidth, kScreenwidth-GVH(self.Nav)-24) style:UITableViewStylePlain];
        _deviceTableview.delegate=self;
        _deviceTableview.dataSource=self;
        _deviceTableview.tableFooterView=[[UIView alloc] init];
        _deviceTableview.rowHeight=44;
        _deviceTableview.rowHeight=UITableViewAutomaticDimension;
        _deviceTableview.backgroundColor=[UIColor colorWithWhite:0.07 alpha:1];
    }
    return _deviceTableview;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化BabyBluetooth 蓝牙库
    _babyBluetooth = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
    _babyBluetooth.scanForPeripherals().begin();
    [self.view addSubview:self.deviceTableview];
}

//设置蓝牙委托
-(void)babyDelegate{
    @WeakObj(self);
    //设置扫描到设备的委托
    [_babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        for (CBPeripheral *peripheral1 in selfWeak.peripherals) {
            if ([peripheral.name isEqualToString:peripheral1.name]) {
                return ;
            }
        }
        [selfWeak.peripherals addObject:peripheral];
        [selfWeak.deviceTableview reloadData];
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [_babyBluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备 most common usage is discover for peripheral that name has common prefix
        if ([peripheralName hasPrefix:kBlePeripheralName]) {
            return YES;
        }
        return NO;
    }];
    
    //.......
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripherals.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    CBPeripheral *peripheral=self.peripherals[indexPath.row];
    cell.textLabel.text=peripheral.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //连接设备
    CBPeripheral *peripheral=self.peripherals[indexPath.row];
    
    FunctionVC *vc = [[FunctionVC alloc]init];
    vc.currPeripheral = peripheral;
    vc->baby =_babyBluetooth;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
