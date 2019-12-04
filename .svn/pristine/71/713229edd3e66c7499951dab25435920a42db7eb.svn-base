//
//  ZSURLManager.h
//  ZSMoneytocar
//
//  Created by 武 on 16/8/11.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSURLManager : NSObject

#pragma mark********************************公共接口*******************************/
#pragma mark 获取接口地址
+(NSString*)getAppAccessURL;

#pragma mark 获取项目名称列表
+(NSString *)getProductList;

#pragma mark 获取银行名称列表(跟项目关联)
+(NSString *)getBankListWithProduct;

#pragma mark 获取省份名称列表
+(NSString*)getProvincesList;

#pragma mark 获取城市名称列表
+(NSString*)getCitysList;

#pragma mark 获取区名称列表
+(NSString*)getAreasList;

#pragma mark 上传照片返回url
+(NSString *)getDataUpload;

#pragma mark 查询产品是否被禁用
+(NSString*)getCheckProductState;

#pragma mark 查询所有中介机构
+(NSString*)getAllAgency;

#pragma mark 通知列表
+(NSString*)getAllNotification;

#pragma mark 版本更新
+(NSString*)getVersionUpdates;

#pragma mark 所有订单列表
+(NSString *)getAllOrderList;

#pragma mark 所有订单列表数据权限
+(NSString *)getAllOrderListDataPermission;

#pragma mark 银行/审批人员订单列表
+(NSString *)getBankOrCheckOrderList;

#pragma mark 关闭订单(金融产品通用)
+(NSString *)getAllOrderCloseURL;

#pragma mark 删除配偶(金融产品通用)
+(NSString *)getDeleteMate;

#pragma mark 首页轮播图
+(NSString *)getRoastingChart;

#pragma mark 提交订单(除新房见证, 其他金融产品通用)
+(NSString *)getCommitOrderURL;

#pragma mark 资料文本上传(回款确认)(星速贷、赎楼宝、抵押贷,新房见证(不支持))(1.5新接口)
+(NSString *)getMateriaInsSureURL;

#pragma mark 资料上传/删除(产权情况表)(星速贷、赎楼宝、抵押贷,新房见证(不支持))(1.5新接口)
+(NSString *)getuploadOrDelPhotoDataForPropertyRightURL;

#pragma mark 审批订单(产权情况表)(星速贷、赎楼宝、抵押贷,新房见证(不支持))(1.5新改接口) 提交资料也用这个
+(NSString *)getAuditOrderURL;

#pragma mark 删除暂存订单接口(星速贷、赎楼宝、抵押贷,新房见证(不支持))(1.6新改接口)
+(NSString *)getDeleteOrderOfNoSubmitURL;

#pragma mark 大数据风控重查(所有产品通用)
+(NSString *)getReloadBigDataURL;

#pragma mark 修改订单客户来源(除新房见证, 其他金融产品通用)
+(NSString *)changeCustomerSourceURL;

#pragma mark 所有金融产品贷款银行
+(NSString *)getLoanBankListURL;

#pragma mark 爬虫新闻(审核用)
+(NSString *)getNewsDataURL;

#pragma mark OCR识别(身份证,银行卡)
+(NSString *)getOCRRecognitionURL;

#pragma mark 金融产品撤回订单
+(NSString *)getWithdrawOrderURL;

#pragma mark 金融产品催办接口
+(NSString *)getRushtodoURL;

#pragma mark 获取月供列表数据集
+(NSString *)getQueryRepayDetailsURL;

#pragma mark********************************个人相关*******************************/
#pragma mark 一键登录token验证
+(NSString *)getquickLoginTokenValidateURL;

#pragma mark 登录
+(NSString *)getLoginURL;

#pragma mark 注册
+(NSString *)getRegisteredURL;

#pragma mark 获取验证码
+(NSString *)getVerificationCode;

#pragma mark 验证验证码
+(NSString *)getVerificationCodeCompare;

#pragma mark 忘记密码
+(NSString *)getForgetPassword;

#pragma mark 重置密码
+(NSString *)getRsetPassword;

#pragma mark 获取个人资料
+(NSString *)getUserInformation;

#pragma mark 修改个人资料
+(NSString *)updateUserInformation;

#pragma mark 绑定手机号时获取验证码
+(NSString *)getVerificationCodeOfBindingTelephone;

#pragma mark 绑定新的手机号
+(NSString *)updateTheBindingPhone;

#pragma mark 获取日签
+(NSString *)getDaySignUrl;

#pragma mark********************************新房见证*******************************/
#pragma mark 获取按揭进度事项
+(NSString *)getListProgramMattersURL;

#pragma mark 新增按揭进度
+(NSString *)getAddOrderScheduleURL;

#pragma mark 编辑按揭贷款信息
+(NSString *)getUpdateOrderDataURL;

#pragma mark 编辑房产信息
+(NSString *)getUpdateHouseDataURL;

#pragma mark 修改订单反馈状态
+(NSString *)getUpdateOrderFedbackState;

#pragma mark 关闭订单
+(NSString *)getCloseOrder;

#pragma mark 订单详情
+(NSString *)getQueryWitnessOrderDetails;

#pragma mark 资料收集状态编辑
+(NSString *)getUploadBeCollectURL;

#pragma mark 资料收集记录列表
+(NSString *)getUploadCollectRecoredListUrl;

#pragma mark 获取资料收集详情
+(NSString *)getQueryWitnessDocDataByDocIdURL;

#pragma mark 新增/编辑人员信息
+(NSString *)getAddOrEditorCustomer;

#pragma mark 删除人员信息
+(NSString *)getDeleteCustomer;

#pragma mark 删除资料照片
+(NSString *)getInformationPhoto;

#pragma mark 银行征信编辑
+(NSString *)getEditorBankCreditInvestigation;

#pragma mark 资料照片上传
+(NSString *)getUploadInfoemation;

#pragma mark 资料照片上传或删除
+(NSString *)getUpdateOrDelPhotoDataURL;

#pragma mark 完成订单
+(NSString *)getCompleteWitnessOrderURL;

#pragma mark 修改订单银行和项目
+(NSString *)getChangeOrderBankAndProduct;

#pragma mark 查询订单资料列表（金融产品四个公用）
+(NSString *)getOrderListOrderMateriaURL;

#pragma mark 获取驳回节点列表（金融产品四个公用）
+(NSString *)getOrderRejectNodeURL;

#pragma mark 获取动态资料列表展示(1.9.0新街口)
+(NSString *)getDynamicListURL;

#pragma mark 动态资料列表数据上传(1.9.0新街口)
+(NSString *)getDynamicListDataUploadURL;

#pragma mark********************************星速贷*******************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getStarLoanAddOrEditorCustomer;

#pragma mark 编辑房产信息
+(NSString *)getSpdUpdateHouseInfoURL;

#pragma mark 编辑按揭贷款信息
+(NSString *)getSpdUpdateMortgageInfoURL;


#pragma mark 资料文本上传
+(NSString *)getSpdSaveMateriaTxtURL;

#pragma mark 查询订单详情
+(NSString *)getSpdQueryOrderDetailURL;

#pragma mark 查询订单资料详情 
+(NSString *)getSpdQueryOrderDocURL;

#pragma mark 上传资料和删除
+(NSString *)getSpdUploadOrDelPhotoDataURL;

#pragma mark 查询订单详情（未提交定单前--暂存状态下）（1.4新接口）
+(NSString *)getSpdQueryOrderDetailForZCURL;

#pragma mark 获取人员详情
+(NSString *)getCustomerInfoURL;

#pragma mark 订单添加备注信息
+(NSString *)getAddOrderRemarkURL;

#pragma mark 当前产品的订单复制成其他产品的订单
+(NSString *)getCopyOrderkURL;

#pragma mark 角色互换
+(NSString *)getExchangeRelationURL;

#pragma mark********************************赎楼宝*******************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getRedeemFloorAddOrEditorCustomer;

#pragma mark 编辑房产信息
+(NSString *)getRedeemFloorUpdateHouseInfoURL;

#pragma mark 编辑 放款信息
+(NSString *)getRedeemFloorUpdateMortgageInfoURL;

#pragma mark 资料文本上传
+(NSString *)getRedeemFloorSaveMateriaTxtURL;

#pragma mark 查询订单详情
+(NSString *)getRedeemFloorQueryOrderDetailURL;

#pragma mark 查询订单资料详情
+(NSString *)getRedeemFloorQueryOrderDocURL;

#pragma mark 上传资料和删除
+(NSString *)getRedeemFloorUploadOrDelPhotoDataURL;

#pragma mark 查询订单详情（未提交定单前--暂存状态下）（1.4新接口）
+(NSString *)getRedeemFloorQueryOrderDetailForZCURL;

#pragma mark********************************抵押贷*******************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getMortgageLoanAddOrEditorCustomer;

#pragma mark 编辑房产信息
+(NSString *)getMortgageLoanUpdateHouseInfoURL;

#pragma mark 编辑 放款信息
+(NSString *)getMortgageLoanUpdateMortgageInfoURL;

#pragma mark 查询订单详情
+(NSString *)getMortgageLoanQueryOrderDetailURL;

#pragma mark 查询订单资料详情
+(NSString *)getMortgageLoanQueryOrderDocURL;

#pragma mark 查询订单详情（未提交定单前--暂存状态下）（1.4新接口）
+(NSString *)getMortgageLoanQueryOrderDetailForZCURL;

#pragma mark****************************************************************融易贷***************************************************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getEasyLoanAddOrEditorCustomer;

#pragma mark 编辑放款信息
+(NSString *)getEasyLoanUpdateMortgageInfoURL;

#pragma mark 编辑房产信息
+(NSString *)getEasyLoanUpdateHouseInfoURL;

#pragma mark 查询订单详情
+(NSString *)getEasyLoanQueryOrderDetailURL;

#pragma mark 查询订单资料详情
+(NSString *)getEasyLoanQueryOrderDocURL;

#pragma mark 查询订单详情（未提交定单前--暂存状态下
+(NSString *)getEasyLoanQueryOrderDetailForZCURL;

#pragma mark********************************车位分期*******************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getCarHireAddOrEditorCustomer;

#pragma mark 编辑 放款信息
+(NSString *)getCarHireUpdateMortgageInfoURL;

#pragma mark 编辑车位信息
+(NSString *)getCarHireUpdateCarInfoURL;

#pragma mark 查询订单详情
+(NSString *)getCarHireQueryOrderDetailURL;

#pragma mark 查询暂存订单详情
+(NSString *)getCarHireQueryOrderDetailForZCURL;

#pragma mark 查询资料详情
+(NSString *)getCarHireQueryOrderDocURL;

#pragma mark 提交资料
+(NSString *)getSubmitDocumentOrderDocURL;

#pragma mark*********************************代办业务****************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getAngencyBusinessAddOrEditorCustomer;

#pragma mark 查询暂存订单详情
+(NSString *)getAngencyBusinessQueryOrderDetailForZCURL;

#pragma mark 查询订单详情
+(NSString *)getAngencyBusinessQueryOrderDetailURL;

#pragma mark 编辑按揭贷款信息
+(NSString *)getAngencyBusinessUpdateMortgageInfoURL;

#pragma mark 编辑房产信息
+(NSString *)getAngencyBusinessUpdateHouseInfoURL;

#pragma mark 查询资料详情
+(NSString *)getAngencyBusinessQueryOrderDocURL;

#pragma mark********************************微信申请*******************************/
#pragma mark 微信申请订单列表
+(NSString *)getApplyOnlineOrderListURL;

#pragma mark 微信申请订单详情
+(NSString *)getApplyOnlineOrderDetailURL;

#pragma mark 关闭订单
+(NSString *)getCloseApplyOnlineOrderURL;

#pragma mark 添加跟进记录
+(NSString *)getAddRecordURL;

#pragma mark 获取跟进记录列表
+(NSString *)getRecordListURL;

#pragma mark 上传银行卡资料
+(NSString *)getSaveBankURL;

#pragma mark********************************预授信评估*********************************/
#pragma mark 获取预授信评估列表
+(NSString *)getListPrecreditOrders;

#pragma mark 获取预授信评估订单详情
+(NSString *)getPrecreditOrderDetail;

#pragma mark 获取贷款银行
+(NSString *)getListPrecreditBank;

#pragma mark 提交预授信
+(NSString *)submitPrecredit;

#pragma mark********************************派单*********************************/
#pragma mark 获取派单列表
+(NSString *)getListDistributeOrders;

#pragma mark 获取接收派单人员列表
+(NSString *)getListReceiveDistributeUsers;

#pragma mark 提交派单
+(NSString *)submitDistributeBatch;

#pragma mark********************************中介端跟进*********************************/
#pragma mark 获取中介端跟进列表
+(NSString *)getListFollowOrdersURL;

#pragma mark 不做了
+(NSString *)cancelPrecreditOrderURL;

#pragma mark 提交订单
+(NSString *)confirmPrecreditOrderURL;

#pragma mark**********************************工具页面********************************/

#pragma mark 工具页面
+(NSString *)getToolListURL;

#pragma mark 统计时间段内所有新增订单数和总金额
+(NSString *)getQueryNewOrderData;

#pragma mark 统计时间段内所有完成订单数和总金额
+(NSString *)getQueryCompleteOrderData;

#pragma mark 统计时间段内各产品类型新增订单数
+(NSString *)getQueryPrdOrderData;

#pragma mark 统计时间段内各区域新增订单数
+(NSString *)getQueryAreaOrderData;

#pragma mark 统计时间段内各贷款银行新增订单数
+(NSString *)getQueryBankOrderData;

#pragma mark 统计时间段内订单来源新增订单数
+(NSString *)getQuerySourceOrderData;

#pragma mark 统计时间段内订单月变化、订单日变化
+(NSString *)getQueryOrderChangerURL;

#pragma mark 报表列表(不返回默认台账)
+(NSString *)getQueryAccListingsURL;

#pragma mark 新增报表
+(NSString *)getAddAccListingURL;

#pragma mark 编辑报表
+(NSString *)getUpdateAccListingURL;

#pragma mark 删除报表
+(NSString *)getDeleteAccListingURL;

#pragma mark 报表排序
+(NSString *)getUpdateAccListingSequenceURL;

#pragma mark 查询报表字段
+(NSString *)getQueryAccListingColsURL;

#pragma mark 设置报表字段
+(NSString *)getUpdateAccListingColsURL;

#pragma mark 报表详情
+(NSString *)getQueryAccListingDataForAppURL;

@end
