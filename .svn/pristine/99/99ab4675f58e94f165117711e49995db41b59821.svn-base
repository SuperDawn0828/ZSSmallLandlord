//
//  ZSURLManager.m
//  ZSMoneytocar
//
//  Created by 武 on 16/8/11.
//  Copyright © 2016年 Wu. All rights reserved.
//

#import "ZSURLManager.h"

@implementation ZSURLManager

#pragma mark****************************************************************公共接口***************************************************************/
#pragma mark 获取接口地址
+(NSString *)getAppAccessURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/getAppServicePath",APPDELEGATE.zsurlHead];
}

#pragma mark 获取项目名称列表
+(NSString *)getProductList
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/listProjects",APPDELEGATE.zsurlHead];
}

#pragma mark 获取银行名称列表(跟项目关联)
+(NSString *)getBankListWithProduct
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/queryBankListByProject",APPDELEGATE.zsurlHead];
}

#pragma mark 获取省份名称列表
+(NSString *)getProvincesList
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/provinces",APPDELEGATE.zsurlHead];
}

#pragma mark 获取城市名称列表
+(NSString *)getCitysList
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/citys",APPDELEGATE.zsurlHead];
}

#pragma mark 获取区名称列表
+(NSString *)getAreasList
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/districts",APPDELEGATE.zsurlHead];
}

#pragma mark 上传照片返回url
+(NSString *)getDataUpload
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/uploadFile",APPDELEGATE.zsurlHead];
}

#pragma mark 查询产品是否被禁用(金融产品通用)
+(NSString *)getCheckProductState
{
    return [NSString stringWithFormat:@"%@/zs/prd/v1_1/productState",APPDELEGATE.zsurlHead];
}

#pragma mark 查询所有中介机构
+(NSString *)getAllAgency
{
    return [NSString stringWithFormat:@"%@/zs/agency/v1_1/list",APPDELEGATE.zsurlHead];
}

#pragma mark 通知列表
+(NSString *)getAllNotification
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/listMsgNotes",APPDELEGATE.zsurlHead];
}

#pragma mark 版本更新
+(NSString *)getVersionUpdates
{
    return [NSString stringWithFormat:@"%@/zs/v1/base/getVersionUpdate",APPDELEGATE.zsurlHead];
}

#pragma mark 所有订单列表
+(NSString *)getAllOrderList
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_1/list",APPDELEGATE.zsurlHead];
}

#pragma mark 所有订单列表数据权限(金融产品通用)
+(NSString *)getAllOrderListDataPermission
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_7/getDataPermission",APPDELEGATE.zsurlHead];
}

#pragma mark 银行/审批人员订单列表
+(NSString *)getBankOrCheckOrderList
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_2/listOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 关闭订单(金融产品通用)
+(NSString *)getAllOrderCloseURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_3/close",APPDELEGATE.zsurlHead];
}

#pragma mark 删除配偶(金融产品通用)
+(NSString *)getDeleteMate
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_3/deleteCust",APPDELEGATE.zsurlHead];
}

#pragma mark 首页轮播图
+(NSString *)getRoastingChart
{
    return [NSString stringWithFormat:@"%@/zs/carousel/v1_4/list",APPDELEGATE.zsurlHead];
}

#pragma mark 提交订单(除新房见证, 其他金融产品通用)
+(NSString *)getCommitOrderURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_4/commitOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 资料文本上传(回款确认)星速贷、赎楼宝、抵押贷
+(NSString *)getMateriaInsSureURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_5/saveMateriaIns",APPDELEGATE.zsurlHead];
}

#pragma mark 资料上传/删除(产权情况表)(星速贷、赎楼宝、抵押贷
+(NSString *)getuploadOrDelPhotoDataForPropertyRightURL
{
    return [NSString stringWithFormat:@"%@/zs/bizCustomer/uploadOrDelPhotoData/v1_5",APPDELEGATE.zsurlHead];
}

#pragma mark 审批订单(产权情况表)(星速贷、赎楼宝、抵押贷, 提交资料也用这个
+(NSString *)getAuditOrderURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_3/handleNode",APPDELEGATE.zsurlHead];
}

#pragma mark 删除暂存订单接口(星速贷、赎楼宝、抵押贷,车位分期)(1.6新改接口)
+(NSString *)getDeleteOrderOfNoSubmitURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_6/delete",APPDELEGATE.zsurlHead];
}

#pragma mark 大数据风控重查(所有产品通用)
+(NSString *)getReloadBigDataURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/v1_6/reQueryCustCreditInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 修改订单客户来源(金融产品通用)
+(NSString *)changeCustomerSourceURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_7/updateOrderSrc",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单资料列表（金融产品四个公用）
+(NSString *)getOrderListOrderMateriaURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_1/listOrderMateria",APPDELEGATE.zsurlHead];
}

#pragma mark 获取驳回节点列表（金融产品四个公用）
+(NSString *)getOrderRejectNodeURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_1/listRejectNode",APPDELEGATE.zsurlHead];
}

#pragma mark 所有金融产品贷款银行
+(NSString *)getLoanBankListURL
{
    return [NSString stringWithFormat:@"%@/zs/loanbank/v1_7_8/list",APPDELEGATE.zsurlHead];
}

#pragma mark 爬虫新闻(审核用)
+(NSString *)getNewsDataURL
{
    return [NSString stringWithFormat:@"%@/zs/tool/captureNews",APPDELEGATE.zsurlHead];
}

#pragma mark OCR识别(身份证,银行卡)
+(NSString *)getOCRRecognitionURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/ocrRecognition",APPDELEGATE.zsurlHead];
}

#pragma mark 金融产品撤回订单
+(NSString *)getWithdrawOrderURL
{
    return [NSString stringWithFormat:@"%@/zs/order/withdrawOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 金融产品催办接口
+(NSString *)getRushtodoURL
{
    return [NSString stringWithFormat:@"%@/zs/order/urgeOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 获取月供列表数据集
+(NSString *)getQueryRepayDetailsURL
{
    return [NSString stringWithFormat:@"%@/zs/loanCalculator/queryRepayDetails",APPDELEGATE.zsurlHead];
}

#pragma mark ****************************************************************个人相关***************************************************************/
#pragma mark 一键登录token验证
+(NSString *)getquickLoginTokenValidateURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/quickLoginTokenValidate",APPDELEGATE.zsurlHead];
}

#pragma mark 登录
+(NSString *)getLoginURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/login",APPDELEGATE.zsurlHead];
}

#pragma mark 注册
+(NSString *)getRegisteredURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/regist",APPDELEGATE.zsurlHead];
}

#pragma mark 获取验证码
+(NSString *)getVerificationCode
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/getValidateCode",APPDELEGATE.zsurlHead];
}

#pragma mark 验证验证码
+(NSString *)getVerificationCodeCompare
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/checkValidateCode",APPDELEGATE.zsurlHead];
}

#pragma mark 忘记密码
+(NSString *)getForgetPassword
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/resetPass",APPDELEGATE.zsurlHead];
}

#pragma mark 重置密码
+(NSString *)getRsetPassword
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/changePwdByOldPassword",APPDELEGATE.zsurlHead];
}

#pragma mark 获取个人资料
+(NSString *)getUserInformation
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/getUserInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 修改个人资料
+(NSString *)updateUserInformation
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/updateUserInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 绑定手机号时获取验证码
+(NSString *)getVerificationCodeOfBindingTelephone
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/getBindingValidateCode",APPDELEGATE.zsurlHead];
}

#pragma mark 绑定新的手机号
+(NSString *)updateTheBindingPhone
{
    return [NSString stringWithFormat:@"%@/zs/v1/user/updateBindingTelphone",APPDELEGATE.zsurlHead];
}

#pragma mark 获取日签
+(NSString *)getDaySignUrl
{
    return [NSString stringWithFormat:@"%@/zs/tool/getDaySign",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************新房见证***************************************************************/
#pragma mark 获取按揭进度事项
+(NSString *)getListProgramMattersURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/listProgramMatters",APPDELEGATE.zsurlHead];
}

#pragma mark 修改订单反馈状态
+(NSString *)getUpdateOrderFedbackState
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/updateOrderFedbackState",APPDELEGATE.zsurlHead];
}

#pragma mark 关闭订单
+(NSString *)getCloseOrder
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/closeWitnessOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 新增按揭进度
+(NSString *)getAddOrderScheduleURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/addOrderSchedule",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑按揭贷款信息
+(NSString *)getUpdateOrderDataURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/updateOrderData",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑房产信息
+(NSString *)getUpdateHouseDataURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/updateHouseData",APPDELEGATE.zsurlHead];
}

#pragma mark 订单详情
+(NSString *)getQueryWitnessOrderDetails
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/queryWitnessOrderDetails",APPDELEGATE.zsurlHead];
}

#pragma mark 新增/编辑人员信息
+(NSString *)getAddOrEditorCustomer
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/addOrUpdateCust",APPDELEGATE.zsurlHead];
}

#pragma mark 删除人员信息
+(NSString *)getDeleteCustomer
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/delCust",APPDELEGATE.zsurlHead];
}

#pragma mark 删除资料照片
+(NSString *)getInformationPhoto
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/delPhotoData",APPDELEGATE.zsurlHead];
}

#pragma mark 银行征信编辑
+(NSString *)getEditorBankCreditInvestigation
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/updateCreditInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 资料照片上传
+(NSString *)getUploadInfoemation
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/uploadPhotoData",APPDELEGATE.zsurlHead];
}

#pragma mark 资料收集状态编辑
+(NSString *)getUploadBeCollectURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/updateBeCollect",APPDELEGATE.zsurlHead];
}

#pragma mark 资料收集记录列表
+(NSString *)getUploadCollectRecoredListUrl
{
    return [NSString stringWithFormat:@"%@/zs/witness/v1_6/queryDocsCollectHis",APPDELEGATE.zsurlHead];
}

#pragma mark 获取资料收集详情
+(NSString *)getQueryWitnessDocDataByDocIdURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/queryWitnessDocDataByDocId",APPDELEGATE.zsurlHead];
}

#pragma mark 资料照片上传或删除
+(NSString *)getUpdateOrDelPhotoDataURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/bizCustomer/uploadOrDelPhotoData",APPDELEGATE.zsurlHead];
}

#pragma mark 完成订单
+(NSString *)getCompleteWitnessOrderURL
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/completeWitnessOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 修改订单银行和项目
+(NSString *)getChangeOrderBankAndProduct
{
    return [NSString stringWithFormat:@"%@/zs/v1/witnessOrder/updateOrderProjAndBank",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************星速贷***************************************************************/
#pragma mark 新增/编辑人员信息（1.4新接口）
+(NSString *)getStarLoanAddOrEditorCustomer
{
    return [NSString stringWithFormat:@"%@/zs/spdOrder/v1_4/addOrUpdateCustForSprd",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑房产信息
+(NSString *)getSpdUpdateHouseInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/spdOrder/v1_1/updateHouseInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑按揭贷款信息
+(NSString *)getSpdUpdateMortgageInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/spdOrder/v1_1/updateMortgageInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 资料文本上传
+(NSString *)getSpdSaveMateriaTxtURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_1/saveMateriaTxt",APPDELEGATE.zsurlHead];
}

#pragma mark 订单详情
+(NSString *)getSpdQueryOrderDetailURL
{
    return [NSString stringWithFormat:@"%@/zs/spdOrder/v1_1/querySpdOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单资料详情
+(NSString *)getSpdQueryOrderDocURL
{
    return [NSString stringWithFormat:@"%@/zs/spdOrder/v1_1/querySpdOrderDoc",APPDELEGATE.zsurlHead];
}


#pragma mark 上传资料和删除
+(NSString *)getSpdUploadOrDelPhotoDataURL
{
    return [NSString stringWithFormat:@"%@/zs/bizCustomer/uploadOrDelPhotoData/v1_1",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情（未提交定单前--暂存状态下）（1.4新接口）
+(NSString *)getSpdQueryOrderDetailForZCURL
{
    return [NSString stringWithFormat:@"%@/zs/spdOrder/v1_4/querySpdOrderDetailZC",APPDELEGATE.zsurlHead];
}

#pragma mark 获取动态资料列表展示(1.9.0新街口)
+(NSString *)getDynamicListURL
{
    return [NSString stringWithFormat:@"%@/zs/prdDocs/queryPrdDocsDetailField",APPDELEGATE.zsurlHead];
}

#pragma mark 动态资料列表数据上传(1.9.0新街口)
+(NSString *)getDynamicListDataUploadURL
{
    return [NSString stringWithFormat:@"%@/zs/order/updateOrderExtData",APPDELEGATE.zsurlHead];
}

#pragma mark 获取人员详情
+(NSString *)getCustomerInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/order/getCustomerInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 订单添加备注信息
+(NSString *)getAddOrderRemarkURL
{
    return [NSString stringWithFormat:@"%@/zs/order/addOrderRemark",APPDELEGATE.zsurlHead];
}

#pragma mark 当前产品的订单复制成其他产品的订单
+(NSString *)getCopyOrderkURL
{
    return [NSString stringWithFormat:@"%@/zs/order/createRelatedOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 角色互换
+(NSString *)getExchangeRelationURL
{
    return [NSString stringWithFormat:@"%@/zs/order/exchangeRelation",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************赎楼宝***************************************************************/
#pragma mark 新增/编辑人员信息 （1.4新接口）
+(NSString *)getRedeemFloorAddOrEditorCustomer
{
    return [NSString stringWithFormat:@"%@/zs/redeemOrder/v1_4/addOrUpdateCustForRedeem",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑 放款信息
+(NSString *)getRedeemFloorUpdateMortgageInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/redeemOrder/v1_5/updateMortgageInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑房产信息
+(NSString *)getRedeemFloorUpdateHouseInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/redeemOrder/v1_2/updateHouseInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 资料文本上传
+(NSString *)getRedeemFloorSaveMateriaTxtURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_2/saveMateriaTxt",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情 
+(NSString *)getRedeemFloorQueryOrderDetailURL
{
    return [NSString stringWithFormat:@"%@/zs/redeemOrder/v1_2/queryRedeemOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单资料详情
+(NSString *)getRedeemFloorQueryOrderDocURL
{
    return [NSString stringWithFormat:@"%@/zs/redeemOrder/v1_2/querySpdOrderDoc",APPDELEGATE.zsurlHead];
}

#pragma mark 资料上传和删除
+(NSString *)getRedeemFloorUploadOrDelPhotoDataURL
{
    return [NSString stringWithFormat:@"%@/zs/bizCustomer/uploadOrDelPhotoData/v1_2",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情（未提交定单前--暂存状态下）（1.4新接口）
+(NSString *)getRedeemFloorQueryOrderDetailForZCURL
{
    return [NSString stringWithFormat:@"%@/zs/redeemOrder/v1_4/queryRedeemOrderDetailZC",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************抵押贷***************************************************************/
#pragma mark 新增/编辑人员信息 （1.4新接口）
+(NSString *)getMortgageLoanAddOrEditorCustomer
{
    return [NSString stringWithFormat:@"%@/zs/dydOrder/v1_4/addOrUpdateCustForDyd",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑放款信息
+(NSString *)getMortgageLoanUpdateMortgageInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/dydOrder/v1_3/updateMortgageInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑房产信息
+(NSString *)getMortgageLoanUpdateHouseInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/dydOrder/v1_3/updateHouseInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情
+(NSString *)getMortgageLoanQueryOrderDetailURL
{
    return [NSString stringWithFormat:@"%@/zs/dydOrder/v1_3/queryDydOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单资料详情
+(NSString *)getMortgageLoanQueryOrderDocURL
{
    return [NSString stringWithFormat:@"%@/zs/dydOrder/v1_3/queryDydOrderDoc",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情（未提交定单前--暂存状态下）（1.4新接口）
+(NSString *)getMortgageLoanQueryOrderDetailForZCURL
{
    return [NSString stringWithFormat:@"%@/zs/dydOrder/v1_4/queryDydOrderDetailZC",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************融易贷***************************************************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getEasyLoanAddOrEditorCustomer
{
    return [NSString stringWithFormat:@"%@/zs/easyOrder/v1_4/addOrUpdateCustForEasy",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑放款信息
+(NSString *)getEasyLoanUpdateMortgageInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/easyOrder/v1_3/updateMortgageInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑房产信息
+(NSString *)getEasyLoanUpdateHouseInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/easyOrder/v1_3/updateHouseInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情
+(NSString *)getEasyLoanQueryOrderDetailURL
{
    return [NSString stringWithFormat:@"%@/zs/easyOrder/v1_3/queryEasyOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单资料详情
+(NSString *)getEasyLoanQueryOrderDocURL
{
    return [NSString stringWithFormat:@"%@/zs/easyOrder/v1_3/queryEasyOrderDoc",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情（未提交定单前--暂存状态下
+(NSString *)getEasyLoanQueryOrderDetailForZCURL
{
    return [NSString stringWithFormat:@"%@/zs/easyOrder/v1_4/queryEasyOrderDetailZC",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************车位分期***************************************************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getCarHireAddOrEditorCustomer
{
    return [NSString stringWithFormat:@"%@/zs/cwfqOrder/v1_7/addOrUpdateCustForCwfq",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑贷款信息
+(NSString *)getCarHireUpdateMortgageInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/cwfqOrder/v1_7/updateMortgageInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑车位信息
+(NSString *)getCarHireUpdateCarInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/cwfqOrder/v1_7/updateParkingInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情
+(NSString *)getCarHireQueryOrderDetailURL
{
    return [NSString stringWithFormat:@"%@/zs/cwfqOrder/v1_7/queryCwfqOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 查询暂存订单详情
+(NSString *)getCarHireQueryOrderDetailForZCURL
{
    return [NSString stringWithFormat:@"%@/zs/cwfqOrder/v1_7/queryCwfqOrderDetailZC",APPDELEGATE.zsurlHead];
}

#pragma mark 查询资料详情
+(NSString *)getCarHireQueryOrderDocURL
{
    return [NSString stringWithFormat:@"%@/zs/cwfqOrder/v1_7/queryCwfqOrderDoc",APPDELEGATE.zsurlHead];
}

#pragma mark 提交资料
+(NSString *)getSubmitDocumentOrderDocURL
{
    return [NSString stringWithFormat:@"%@/zs/cwfqOrder/v1_7/submitDocument",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************代办业务***************************************************************/
#pragma mark 新增/编辑人员信息
+(NSString *)getAngencyBusinessAddOrEditorCustomer
{
    return [NSString stringWithFormat:@"%@/zs/insteadOrder/addOrUpdateCustForInstead",APPDELEGATE.zsurlHead];
}

#pragma mark 查询暂存订单详情
+(NSString *)getAngencyBusinessQueryOrderDetailForZCURL
{
    return [NSString stringWithFormat:@"%@/zs/insteadOrder/queryInsteadOrderDetailZC",APPDELEGATE.zsurlHead];
}

#pragma mark 查询订单详情
+(NSString *)getAngencyBusinessQueryOrderDetailURL
{
    return [NSString stringWithFormat:@"%@/zs/insteadOrder/queryInsteadOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑按揭贷款信息
+(NSString *)getAngencyBusinessUpdateMortgageInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/insteadOrder/updateMortgageInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑房产信息
+(NSString *)getAngencyBusinessUpdateHouseInfoURL
{
    return [NSString stringWithFormat:@"%@/zs/insteadOrder/updateHouseInfo",APPDELEGATE.zsurlHead];
}

#pragma mark 查询资料详情
+(NSString *)getAngencyBusinessQueryOrderDocURL
{
    return [NSString stringWithFormat:@"%@/zs/insteadOrder/queryInsteadOrderDoc",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************微信申请***************************************************************/
#pragma mark 微信申请订单列表
+(NSString *)getApplyOnlineOrderListURL
{
    return [NSString stringWithFormat:@"%@/zs/apply/v1_5/onlineApplyListForHandler",APPDELEGATE.zsurlHead];
}

#pragma mark 微信申请订单详情
+(NSString *)getApplyOnlineOrderDetailURL
{
    return [NSString stringWithFormat:@"%@/zs/apply/v1_5/onlineApplyDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 关闭订单
+(NSString *)getCloseApplyOnlineOrderURL
{
    return [NSString stringWithFormat:@"%@/zs/apply/v1_5/close",APPDELEGATE.zsurlHead];
}

#pragma mark 添加跟进记录
+(NSString *)getAddRecordURL
{
    return [NSString stringWithFormat:@"%@/zs/apply/v1_5/addApplyFollow",APPDELEGATE.zsurlHead];
}

#pragma mark 获取跟进记录列表
+(NSString *)getRecordListURL
{
    return [NSString stringWithFormat:@"%@/zs/apply/v1_5/listApplyFollow",APPDELEGATE.zsurlHead];
}

#pragma mark 上传银行卡资料
+(NSString *)getSaveBankURL
{
    return [NSString stringWithFormat:@"%@/zs/order/v1_7_8/saveBank",APPDELEGATE.zsurlHead];
}

#pragma mark**************************************************************预授信评估************************************************************/
#pragma mark 获取预授信评估列表
+(NSString *)getListPrecreditOrders
{
    return [NSString stringWithFormat:@"%@/zs/order/listPrecreditOrders",APPDELEGATE.zsurlHead];
}

#pragma mark 获取预授信评估订单详情
+(NSString *)getPrecreditOrderDetail
{
    return [NSString stringWithFormat:@"%@/zs/order/getPrecreditOrderDetail",APPDELEGATE.zsurlHead];
}

#pragma mark 获取贷款银行
+(NSString *)getListPrecreditBank
{
    return [NSString stringWithFormat:@"%@/zs/loanbank/listPrecreditBank",APPDELEGATE.zsurlHead];
}

#pragma mark 提交预授信
+(NSString *)submitPrecredit
{
    return [NSString stringWithFormat:@"%@/zs/order/submitPrecredit",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************派单***************************************************************/
#pragma mark 获取派单列表
+(NSString *)getListDistributeOrders
{
    return [NSString stringWithFormat:@"%@/zs/order/listDistributeOrders",APPDELEGATE.zsurlHead];
}

#pragma mark 获取接收派单人员列表
+(NSString *)getListReceiveDistributeUsers
{
    return [NSString stringWithFormat:@"%@/zs/order/listReceiveDistributeUsers",APPDELEGATE.zsurlHead];
}

#pragma mark 提交派单
+(NSString *)submitDistributeBatch
{
    return [NSString stringWithFormat:@"%@/zs/order/submitDistributeBatch",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************中介端跟进***************************************************************/
#pragma mark 获取中介端跟进列表
+(NSString *)getListFollowOrdersURL
{
    return [NSString stringWithFormat:@"%@/zs/order/listFollowOrders",APPDELEGATE.zsurlHead];
}

#pragma mark 不做了
+(NSString *)cancelPrecreditOrderURL
{
    return [NSString stringWithFormat:@"%@/zs/order/cancelPrecreditOrder",APPDELEGATE.zsurlHead];
}

#pragma mark 提交订单
+(NSString *)confirmPrecreditOrderURL
{
    return [NSString stringWithFormat:@"%@/zs/order/confirmPrecreditOrder",APPDELEGATE.zsurlHead];
}

#pragma mark****************************************************************工具页面**********************************************************/
#pragma mark 工具页面
+(NSString *)getToolListURL
{
    return [NSString stringWithFormat:@"%@/zs/tool/list",APPDELEGATE.zsurlHead];
}

#pragma mark 统计时间段内所有新增订单数和总金额
+(NSString *)getQueryNewOrderData
{
    return [NSString stringWithFormat:@"%@/zs/report/queryNewOrderData",APPDELEGATE.zsurlHead];
}

#pragma mark 统计时间段内所有完成订单数和总金额
+(NSString *)getQueryCompleteOrderData
{
    return [NSString stringWithFormat:@"%@/zs/report/queryCompleteOrderData",APPDELEGATE.zsurlHead];
}

#pragma mark 统计时间段内各产品类型新增订单数
+(NSString *)getQueryPrdOrderData
{
    return [NSString stringWithFormat:@"%@/zs/report/queryPrdOrderData",APPDELEGATE.zsurlHead];
}

#pragma mark 统计时间段内各区域新增订单数
+(NSString *)getQueryAreaOrderData
{
    return [NSString stringWithFormat:@"%@/zs/report/queryAreaOrderData",APPDELEGATE.zsurlHead];
}

#pragma mark 统计时间段内各贷款银行新增订单数
+(NSString *)getQueryBankOrderData
{
    return [NSString stringWithFormat:@"%@/zs/report/queryBankOrderData",APPDELEGATE.zsurlHead];
}

#pragma mark 统计时间段内订单来源新增订单数
+(NSString *)getQuerySourceOrderData
{
    return [NSString stringWithFormat:@"%@/zs/report/querySourceOrderData",APPDELEGATE.zsurlHead];
}

#pragma mark 统计时间段内订单月变化、订单日变化
+(NSString *)getQueryOrderChangerURL
{
    return [NSString stringWithFormat:@"%@/zs/report/queryOrderChange",APPDELEGATE.zsurlHead];
}

#pragma mark 报表列表(不返回默认台账)
+(NSString *)getQueryAccListingsURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/queryAccListings",APPDELEGATE.zsurlHead];
}

#pragma mark 新增报表
+(NSString *)getAddAccListingURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/addAccListing",APPDELEGATE.zsurlHead];
}

#pragma mark 编辑报表
+(NSString *)getUpdateAccListingURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/updateAccListing",APPDELEGATE.zsurlHead];
}

#pragma mark 删除报表
+(NSString *)getDeleteAccListingURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/deleteAccListing",APPDELEGATE.zsurlHead];
}

#pragma mark 报表排序
+(NSString *)getUpdateAccListingSequenceURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/updateAccListingSequence",APPDELEGATE.zsurlHead];
}

#pragma mark 查询报表字段
+(NSString *)getQueryAccListingColsURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/queryAccListingCols",APPDELEGATE.zsurlHead];
}

#pragma mark 设置报表字段
+(NSString *)getUpdateAccListingColsURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/updateAccListingCols",APPDELEGATE.zsurlHead];
}

#pragma mark 报表详情
+(NSString *)getQueryAccListingDataForAppURL
{
    return [NSString stringWithFormat:@"%@/zs/ledger/queryAccListingData",APPDELEGATE.zsurlHead];
}

@end
