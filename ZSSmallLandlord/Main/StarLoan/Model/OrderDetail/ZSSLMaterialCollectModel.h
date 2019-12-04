//
//  ZSSLMaterialCollecModel.h
//  ZSSmallLandlord
//
//  Created by gengping on 17/7/18.
//  Copyright © 2017年 黄曼文. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Handles,Other,laterTodo,FileList;

@interface ZSSLMaterialCollectModel : NSObject

@property (nonatomic , assign)  NSInteger  handle_state;

@property (nonatomic , copy  )  NSString   *node_type;

@property (nonatomic , strong)  NSArray  <Handles *>   * handle;//资料为必传项,必传项里面分已上传,未上传,待上传

@property (nonatomic , strong)  NSArray  <Handles *>   * laterTodo; //后续要传的资料

@property (nonatomic , strong)  NSArray  <Handles *>   * other; //资料为非必传项,必传项里面分已上传和未上传

@end



@interface Handles :NSObject

@property (nonatomic , copy  )  NSString   *doccode;

@property (nonatomic , copy  )  NSString   *docid;

@property (nonatomic , copy  )  NSString   *docname;

@property (nonatomic , assign)  NSInteger  marrage;

@property (nonatomic , strong)  NSArray    <FileList *>   * fileList;

@property (nonatomic , assign)  NSInteger  need;       //是否必录

@property (nonatomic , assign)  NSInteger  finish;     //是否上传

@property (nonatomic , copy  )  NSString   *remark;    //备注

@property (nonatomic , assign)  BOOL       isHandle;   //本地所用的 是否显示红色(是否是当前节点所需资料)

@property (nonatomic , assign)  NSInteger  canDo;      //本地所用的 获取的数据没有这个字段

@property (nonatomic , copy  )  NSString   *type;      //资料类型: handle、laterTodo、other

@end



@interface laterTodo :NSObject

@end



@interface Other :NSObject

@end




