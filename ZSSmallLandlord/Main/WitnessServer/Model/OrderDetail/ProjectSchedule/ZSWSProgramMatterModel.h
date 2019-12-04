//
//  ZSWSProgramMatterModel.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/6/8.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSWSProgramMatterModel : NSObject
@property (nonatomic , copy) NSString              *category;

@property (nonatomic , copy) NSString              *name;

@property (nonatomic , assign) NSInteger           updateDate;

@property (nonatomic , assign) NSInteger           state;

@property (nonatomic , copy) NSString              *updateBy;

@property (nonatomic , copy) NSString              *value;

@property (nonatomic , assign) NSInteger           createDate;

@property (nonatomic , assign) NSInteger           version;

@property (nonatomic , copy) NSString              *tid;

@property (nonatomic , copy) NSString              *categoryName;
@end
