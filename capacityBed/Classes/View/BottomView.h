//
//  BottomView.h
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/27.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickButtonBlock)(NSInteger type);

@interface BottomView : UIView

@property (nonatomic, strong) clickButtonBlock block;

@end
