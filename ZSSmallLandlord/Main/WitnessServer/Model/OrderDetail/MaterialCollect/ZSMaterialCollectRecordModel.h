//
//  ZSMaterialCollectRecordModel.h
//  ZSSmallLandlord
//
//  Created by 黄曼文 on 2017/9/25.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSMaterialCollectRecordModel : NSObject
@property (nonatomic,copy  )NSString *tid;
@property (nonatomic,copy  )NSString *userId;
@property (nonatomic,copy  )NSString *userName;   //上传人名字
@property (nonatomic,copy  )NSString *orderId;
@property (nonatomic,copy  )NSString *docIds;
@property (nonatomic,copy  )NSString *docNames;   //资料名
@property (nonatomic,copy  )NSString *createDate; //上传时间
@property (nonatomic,copy  )NSString *updateDate;
@property (nonatomic,copy  )NSString *state;
@end
