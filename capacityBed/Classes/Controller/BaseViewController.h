//
//  BaseViewController.h
//  capacityBed
//
//  Created by 吾诺翰卓 on 2018/8/21.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong)UILabel *TitleNav;
@property (nonatomic, strong)UIView *Nav;
@property (nonatomic, strong)UIButton * rigltbutton;
@property (nonatomic, strong)UIButton * leftbutton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong)UIImageView * bgImgV;

-(void)leftEvents;


- (void)rightEvents;


@end
