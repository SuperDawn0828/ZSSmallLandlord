//
//  ZSShareManager.h
//  ZSYuegeche
//
//  Created by 武 on 2017/7/10.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSShareView.h"
@interface ZSShareManager : NSObject<ZSShareViewDelegate>
@property(nonatomic,strong)UIViewController *viewcontroller; 
@property(nonatomic,strong)ZSShareView *shareView;
+ (ZSShareManager*)sharedInstance;

- (void)shareOfcontroller:(UIViewController*)VC WithTitle:(NSString*)title Describe:(NSDictionary*)descri shareUrl:(NSString*)shareUrl thumb:(id)image;


//- (void)shareOfcontroller:(UIViewController*)VC;
@end
