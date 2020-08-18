//
//  FunctionHeaderView.h
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionHeaderView : UIView

@property (nonatomic, strong)UIImageView * bgImageView;

@property(nonatomic,strong)void(^longPressClick)(NSInteger index);


-(void)setupSubViewsWithFunctionImageName:(NSString *)functionImageName andFunctionName:(NSString *)functionName;


-(void)setupSubViewsWithGIFImageName:(NSString *)functionImageName andFunctionName:(NSString *)functionName;

@end
