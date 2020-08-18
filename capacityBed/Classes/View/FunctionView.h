//
//  FunctionView.h
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionView : UIImageView

@property (nonatomic, strong)UIImageView * imgV;


-(void)setupSubViewsWithFunctionImageName:(NSString *)functionImageName andFunctionName:(NSString *)functionName;


-(void)setBackImageWithName:(NSString*)name;
@end
