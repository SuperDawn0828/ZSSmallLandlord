//
//  ZSTool.h
//  ZSMoneytocar
//
//  Created by 武 on 16/7/5.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSTimeInterval DefaultDuration = 1.25f;//提示语展示的默认时长

#define imageH ZSWIDTH==320?96:108 // 图片高度
#define imageW  imageH // 图片宽度
#define wide   (ZSWIDTH-3*imageH)
#define SPACING   wide/4.0

typedef void(^FeeBlock)(NSMutableArray *feeArray,NSMutableArray *feeNameArray);
@interface ZSTool : NSObject

#pragma mark 初始化
+ (ZSTool*)shareInfo;

#pragma mark 设置行间距
+(void)setLineSpacingWithView:(UIView*)view Lab:(UILabel *)lab Sting:(NSString*)str Font:(float)font;

#pragma mark 获取本地版本号
+(NSString*)localVersionShort;

#pragma mark 保存用户相关的信息
+(void)saveUserInfoWithDic:(NSDictionary *)Dic;

#pragma mark 获取用户信息
+(ZSUidInfo*)readUserInfo;

+(void)removeDicWithSeriesNo:(NSString*)seriesNo;

+(void)saveImagDic:(NSMutableDictionary*)dic;

+(void)saveSeriesDic:(NSMutableDictionary*)dic WithSeriesNo:(NSString*)seriesNo;

+(NSString *)getImagPath;

+(NSMutableDictionary*)getImagDic;

+(NSMutableDictionary*)getSeriesNoDic:(NSString*)seriesNo;

+(NSString *)getImageFileName;

+(NSString*)getVideoFileName;

#pragma mark 改登录
+(NSMutableDictionary*)GetshoopingCartFoodsDic;

+(NSString*)getFoodPath;

+(void)saveToShoppingCartWithDict:(NSMutableDictionary*)dict;

#pragma mark 小数转百分数
+(CFStringRef )getLoanAmountPercentWith:(float)percent;

#pragma mark 是否第一次登陆
+(NSString*)gesturePasswordPath;

#pragma mark 储存视频
+(void)saveVideoWithVideoData:(NSData*)data UUid:(NSString*)uuid;

#pragma mark 储存视频
+(void)saveVideoWithVideoData:(NSData*)data path:(NSString*)path;

#pragma mark 删除视频
+(void)deleteVideoByUUid:(NSString*)uuid;

#pragma mark 获取视频路径
+(NSString*)getVideoPathWithUUid:(NSString*)uuid;

#pragma mark 截取数组
+(NSArray*)getDownPaymentArrayWith:(NSNumber *)downPayment withMaxPayment:(NSNumber*)maxPayment;

#pragma mark 获取行数
+(int)getNumberOfLines:(NSInteger)Count;

#pragma mark 获取首付总额
+(NSString*)getTotleCostWithFeeArray:(NSMutableArray*)feesArray downpayment:(NSString*)downpaymnet;

#pragma markk 获取各项费用总额(不包括首付)
+(NSString*)getAllFeesWithFeeArray:(NSMutableArray*)feesArray;

#pragma mark 获取文字图标
+(NSAttributedString*)getAttributestrWithImgeName:(NSString *)imageName imgeBounds:(CGRect)bounds;

#pragma mark判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

#pragma mark 空字符串替换
+ (NSString *)beJudgedString:(NSString *)string theReplaceString:(NSString *)newString;

#pragma mark 拨打电话(修复ios10.2反应慢的问题)
+ (void)callPhoneStr:(NSString*)phoneString withVC:(UIViewController *)viewCtrl;

#pragma mark 时间比较大小
+ (BOOL)compareOneDay:(NSString *)beginTimeStr withAnotherDay:(NSString *)endTimeStr;

#pragma mark 判断手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

#pragma mark 判断身份证号码
+ (BOOL)checkUserIDCard:(NSString *)userID;

#pragma mark 判断是否是数字字母下划线
+ (BOOL)isLettersAndNumbersAndUnderScore:(NSString *)string;

#pragma mark 密码输入规则
+ (BOOL)isPassword:(NSString *)password;

#pragma mark 获取label中最后一行字
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

#pragma mark 检查是否有需要上传的图片
+(BOOL)chekIsNeedUploadFilesWithArray:(NSMutableArray*)fileArray;

#pragma mark 判断新房见证订单是否可编辑
+(BOOL)checkWitnessServerOrderIsCanEditing;

#pragma mark 判断金融产品订单是否可编辑
+ (BOOL)checkStarLoanOrderIsCanEditingWithType:(NSString *)prdType;

#pragma mark 判断是否是订单创建人
+ (BOOL)checkFinancialOrderMasterWithType:(NSString *)prdType;

#pragma mark 判断数值大小
+(BOOL)checkMaxNumWithInputNum:(NSString *)inputNum MaxNum:(NSString *)maxNum alert:(BOOL)isAlert;

#pragma mark 计算数值差
+(NSString *)calculateNumWithTheNum:(NSString *)theNum ortherNum:(NSString *)ortherNum;

#pragma mark 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*)color;

#pragma mark 点击cell的动画
+(void)showCellAnimation:(CGRect)oldFrame;

#pragma mark iOS限制输入表情(emoji)，出现九宫格不能输入的解决方法
+ (BOOL)isNineKeyBoard:(NSString *)string;

#pragma mark 判断是否全是空格
+ (BOOL)isEmpty:(NSString *)string;

#pragma mark 检查是否有需要上传的图片（非必填）
+(NSString *)checkingIsNotNeedUploadFilesWithArray:(NSArray*)fileArray;

#pragma mark 检查是否有需要上传的图片（必填和非必填）
+(NSString *)isCheckingNeedingUploadFilesWithArray:(NSArray *)fileArray;

#pragma mark 删除手机号里面的空格
+ (NSString *)filteringTheBlankSpace:(NSString *)string;

#pragma mark 往手机号里塞空格
+ (NSString *)addTheBlankSpace:(NSString *)string;

#pragma mark 把之前大数组套小数组的对象整合成一个新的数组,里面全部是对象,用于传给服务器和下一个页面
+ (NSMutableArray *)getModelArrayWithArray:(NSMutableArray *)array;

#pragma mark 获取普通label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font;

#pragma mark 获取普通label的宽度
+ (CGFloat)getStringWidth:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font;

#pragma mark 获取带行间距label的高度
+ (CGFloat)getStringHeight:(NSString *)string
                 withframe:(CGSize)size
              withSizeFont:(UIFont*)font
          winthLineSpacing:(CGFloat)lineSpacing;

#pragma mark label内容左右对齐
+ (NSAttributedString *)setTextString:(NSString *)text withSizeFont:(UIFont *)font;

#pragma mark 拉伸图片
+ (UIImage *)changeImage:(UIImage *)image Withview:(UIView *)view;

#pragma mark 获取当前年限
+ (NSInteger )getCurrentYear;

#pragma mark 生成随机数, 用于图片上传的压缩系数
+ (double)configureRandomNumber;

#pragma mark 重新定义提示语的位置,ost
+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration;

#pragma mark 万元和元之间的转化
+ (NSString *)yuanIntoTenThousandYuanWithCount:(NSString *)count WithType:(BOOL)isYuan;//isYuan为yes表示元转化成万元,反之万元转成元

@end
