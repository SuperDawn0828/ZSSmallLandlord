//
//  ZSRequestManager.m
//  ZSMoneytocar
//
//  Created by 武 on 16/8/3.
//  Copyright © 2016年 Wu. All rights reserved.
//
#import "ZSRequestManager.h"

#define Boundary @"tarena"
#define Encode(string) [string dataUsingEncoding:NSUTF8StringEncoding]
#define NewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
static NSTimeInterval TimeOut = 15.0f;//普通的

@interface ZSRequestManager()

@end

@implementation ZSRequestManager

+ (ZSRequestManager*)shareManager
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark http异步请求
+ (void)requestWithParameter:(NSMutableDictionary*)parameter
                         url:(NSString*)url
                SuccessBlock:(SuccessBlock)successBlock
                  ErrorBlock:(ErrorBlock)errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//请求数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//接收的数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    //固定入参
    if (!parameter) {
        parameter=@{}.mutableCopy;
    }
    [parameter setObject:@"ios" forKey:@"edition"];
    [parameter setObject:@"ios" forKey:@"deviceType"];
    [parameter setObject:@"abc" forKey:@"signature"];
    //token
    NSString *token = [USER_DEFALT objectForKey:tokenForApp];
    if (token && token.length > 0) {
        [parameter setObject:token forKey:@"token"];
    }
    //userID
    if ([ZSTool readUserInfo].tid.length > 0) {
        [parameter setObject:[ZSTool readUserInfo].tid forKey:@"userId"];
    }
    ZSLOG(@"请求的url==%@ 请求参parameter==%@",url,parameter);
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TimeOut;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //开始请求
    [manager POST:url parameters:parameter headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        ZSLOG(@"请求成功:%@",responseObject);
        NSString *respCode = [responseObject objectForKey:@"respCode"];
        //请求成功
        if ([respCode intValue] == 1) {
            successBlock ([self removeNSNullObjectFromeData:responseObject]);//清除null
        }
        else
        {
            //请求接口出错
            if ([[responseObject objectForKey:@"respMsg"]length] > 0) {
                //1.token校验不通过
                if ([[responseObject objectForKey:@"respMsg"] isEqualToString:@"token验证不通过"]) {
                    [NOTI_CENTER postNotificationName:KSChekTokenState object:nil];
                }
                else{
                    //2.版本更新接口,检查该产品是否被禁用,获取API接口不提示错误信息
                    if (![url isEqualToString:[ZSURLManager getVersionUpdates]] &&
                        ![url isEqualToString:[ZSURLManager getCheckProductState]] &&
                        ![url isEqualToString:[ZSURLManager getAppAccessURL]]) {
                        UIView *view = [UIApplication sharedApplication].keyWindow;
                        [WKProgressHUD popMessage:[responseObject objectForKey:@"respMsg"] inView:view duration:1.5 animated:YES];
                    }
                }
                //3.报异常的时候隐藏转圈按钮
                if (errorBlock){
                    [LSProgressHUD hide];
                    errorBlock(nil);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZSLOG(@"请求失败:%@",error);
        //0,没网
        if (global.netStatus==0)
        {
            [ZSTool showMessage:@"网络已断开,请稍后重试" withDuration:DefaultDuration];
        }
        else
        {
            if (error.code==-1001)
            {
                //获取API,版本更新，订单列表  不提示请求超时
                if (![url isEqualToString:[ZSURLManager getAppAccessURL]])
                {
                    [ZSTool showMessage:@"网络已断开,请稍后重试" withDuration:DefaultDuration];
                }
            }
            else
            {
                [ZSTool showMessage:@"请求失败,请稍后重试" withDuration:DefaultDuration];
            }
        }
        errorBlock(error);
    }];
}

#pragma mark 上传单张图片或单个视频
+ (void)uploadImagesAndVideosWithParameters:(NSMutableDictionary *)parameters
                                        url:(NSString *)url
                                       Data:(NSData *)data
                                    isVideo:(BOOL)isVideo
                               SuccessBlock:(SuccessBlock)successBlock
                                 ErrorBlock:(ErrorBlock)errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//请求数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//接受数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    //固定入参
    if (!parameters) {
        parameters=@{}.mutableCopy;
    }
    [parameters setObject:editionStr forKey:@"edition"];
    [parameters setObject:@"ios" forKey:@"deviceType"];
    [parameters setObject:@"abc" forKey:@"signature"];
    //设置token
    NSString *token = [USER_DEFALT objectForKey:tokenForApp];
    if (token) {
        [parameters setObject:token forKey:@"token"];
    }
    //userID
    if ([ZSTool readUserInfo].tid.length > 0) {
        [parameters setObject:[ZSTool readUserInfo].tid forKey:@"userId"];
    }
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TimeOut;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //开始请求
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (data.length>0) {
            if (isVideo) {
                [formData appendPartWithFileData:data name:@"photo" fileName:[ZSTool  getVideoFileName] mimeType:@"video/mp4"];
            }else{
                [formData appendPartWithFileData:data name:@"photo" fileName:[ZSTool  getImageFileName] mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"respCode"] intValue]==1) {
            successBlock (responseObject);
        }else{
            UIView  *view = [UIApplication sharedApplication].keyWindow;
            [WKProgressHUD popMessage:[responseObject objectForKey:@"respMsg"] inView:view duration:1.5 animated:YES];
            [LSProgressHUD hide];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (global.netStatus==0) {//0,没网
            [ZSTool showMessage:@"网络已断开,请稍后重试" withDuration:DefaultDuration];
        }else{
            if (error.code==-1001) {
                [ZSTool showMessage:@"请求超时,请稍后重试" withDuration:DefaultDuration];
                [LSProgressHUD hide];
            }else{
//                [ZSTool showMessage:@"暂时无法获取到数据" withDuration:DefaultDuration];
            }
        }
        errorBlock(error);
    }];
}

//#pragma mark 上传单张图片(直传ZImg服务器)
//+ (void)uploadImagesData:(NSData *)data
//                     url:(NSString *)url
//            SuccessBlock:(SuccessBlock)successBlock
//              ErrorBlock:(ErrorBlock)errorBlock;
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//请求数据格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//接受数据格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
//    //设置超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = upImgTimeOut;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    //开始请求
//    NSString *stringUrl = APPDELEGATE.zsurlHead;
//    if ([stringUrl isEqualToString:KTestServerUrl]) {
//        stringUrl = KTestServerImgUploadUrl;
//    }
//    else{
//        stringUrl = KPreProductionImgUploadUrl;
//    }
//    ZSLOG(@"请求的url==%@",stringUrl);
//    [manager POST:stringUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if (data.length > 0) {
//            [formData appendPartWithFormData:data name:@"data"];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *newString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        //截取图片url
//        NSArray *array = [newString componentsSeparatedByString:@"<h1>"];
//        array = [array[1] componentsSeparatedByString:@"</h1>"];
//        NSString *urlString = [array[0] substringFromIndex:5];
//        successBlock (@{@"MD5":urlString});
//        ZSLOG(@"上传成功的url==%@",urlString);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        ZSLOG(@"错误日志==%@",error);
//        errorBlock(error);
//    }];
//}

#pragma mark 从ZImg服务器删除照片
+ (void)removeImageData:(NSString *)dataUrl
           SuccessBlock:(SuccessBlock)successBlock
             ErrorBlock:(ErrorBlock)errorBlock
{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];//请求数据格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//接受数据格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
//    //设置超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = upImgTimeOut;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    //开始请求
//    NSString *stringUrl = APPDELEGATE.zsurlHead;
//    if ([stringUrl isEqualToString:KTestServerUrl]) {
//        stringUrl = KTestServerImgUploadUrl;
//    }
//    else{
//        stringUrl = KPreProductionImgUploadUrl;
//    }
//    ZSLOG(@"请求的url==%@",stringUrl);
//    [manager GET:stringUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        ZSLOG(@"删除成功");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        ZSLOG(@"删除失败");
//        errorBlock(error);
//    }];
}

#pragma mark 清除nsnull数据
+ (id)removeNSNullObjectFromeData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]) {
                //将NSNull型的数据换成空字符串@""
                [resultDic setValue:@"" forKey:key];
            }
            else {
                //如果是非NSNull型的数据进入递归
                obj = [self removeNSNullObjectFromeData:obj];
                [resultDic setValue:obj forKey:key];
            }
        }];
        return resultDic;
    }
    else if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *resultArr = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]) {
                //将NSNull型的数据换成空字符串@""
                [resultArr addObject:@""];
            }
            else {
                //如果是非NSNull型的数据进入递归
                obj = [self removeNSNullObjectFromeData:obj];
                [resultArr addObject:obj];
            }
        }];
        return resultArr;
    }else {
        return data;
    }
}

#pragma mark ios原生方法上传图片(直传ZImg服务器)
#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
+ (void)uploadImageWithNativeAPI:(NSData *)data
                    SuccessBlock:(SuccessBlock)successBlock
                      ErrorBlock:(ErrorBlock)errorBlock;
{
    // 记录image的类型和data
    NSString *name = @"file";
    NSString *filename = [ZSTool getImageFileName];
    NSString *mimeType = @"image/jpeg";
   
    // 设置请求的url
    NSString *stringUrl = APPDELEGATE.zsurlHead;
    if ([stringUrl isEqualToString:KTestServerUrl]) {
        stringUrl = KTestServerImgUploadUrl;
    }
    else{
        stringUrl = KPreProductionImgUploadUrl;
    }
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
  
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
   
    // 设置文件参数
    [body appendData:YYEncode(@"--YY\r\n")];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:YYEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:YYEncode(type)];
    [body appendData:YYEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:YYEncode(@"\r\n")];
    
    // 参数结束
    [body appendData:YYEncode(@"--YY--\r\n")];
    request.HTTPBody = body;
    
    // 设置请求头
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length]forHTTPHeaderField:@"Content-Length"];
    // 设置上传类型 post
    [request setValue:@"multipart/form-data; boundary=YY"forHTTPHeaderField:@"Content-Type"];
   
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError) {
        if (data) {
            NSString *newString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //截取图片url
            NSArray *array = [newString componentsSeparatedByString:@"<h1>"];
            array = [array[1] componentsSeparatedByString:@"</h1>"];
            NSString *urlString = [array[0] substringFromIndex:5];
            successBlock(@{@"MD5":urlString});
            ZSLOG(@"上传成功的url==%@",urlString);
        }else {
            ZSLOG(@"上传失败");
            errorBlock(connectionError);
        }
    }];
}

@end
