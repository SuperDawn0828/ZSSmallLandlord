/************************************************************************\
北京易道博识科技有限公司
CopyRight (C) 2015

File name: exbankcard.h
  Function : 银行卡识别接口文件
  Author   : zjm@exocr.com
  Version  : 2015.11.04	V2.0
***************************************************************************/

#ifndef __EX_BANK_CARD_H__
#define __EX_BANK_CARD_H__

#ifdef __cplusplus
extern "C" {
#endif

//视频流识别时四个方向
#define EX_ORIENTATION_LANDSCAPE_LEFT			1
#define EX_ORIENTATION_LANDSCAPE_RIGHT			2
#define EX_ORIENTATION_PORTRAIT					3
#define EX_ORIENTATION_PORTRAIT_UPSIDE_DOWN		4


//////////////////////////////////////////////////////////////////////////
//银行ID
#define CREDIT_BANK_ID_UNKNOW				0x0000	//信用卡未知
#define CREDIT_BANK_ID_CHINA_UNION_PAY		0x0001	//银联
#define CREDIT_BANK_ID_VISA					0x0002	//visa
#define CREDIT_BANK_ID_MASTER				0x0003  //master
#define CREDIT_BANK_ID_JCB					0x0004  //JCB
#define CREDIT_BANK_ID_AMERICAN_EXPRESS		0x0005  //American Experss
#define CREDIT_BANK_ID_DINERS_CLUB			0x0006  //Diners Club

//////////////////////////////////////////////////////////////////////////
/* 单字符信息 */
typedef struct tagEXChar
{
	short nCharIdx; //字索引号
	short nLft;
	short nTop; 
	short nW;
	short nH;
	unsigned short wCand;
	unsigned short wDist;
	float fDist;	
}TEXChar;

//////////////////////////////////////////////////////////////////////////
/* 银行卡信息 */
typedef struct tagEXBCard
{
	int nType; // 0 不清楚，1平字，2凸字
	//平均可信度
	int nRate; //字符的平均可信度*1024
	//银行名称
	char szBankName[64];
	//卡名称
	char szCardName[32];
	//卡类型：借记卡 准贷记卡和贷记卡 预付卡
	char szCardType[32];
	//两个数字的月1-12
	int expiryMonth;
	//4个数字的年
	int expiryYear;
	//是否是倒立识别的结果
	int bFlip;
	//////////////////////////////////////////////////////////////////////////
	//银行卡信息，包括空格
	int nNumCount;
	TEXChar ZInfo[32];	
	//////////////////////////////////////////////////////////////////////////
	//有效日期信息
	int nDateNum;
	TEXChar DInof[10];
	//////////////////////////////////////////////////////////////////////////
	//卡图像(根据情况使用)，格式是BGR存储，如果输入的是灰度图像，也是存储这个数据
	//图像数据可以根据需要保存成其他各种数据格式, 
	unsigned char *pbCard;
	int nW, nH, nPitch;
}TEXBCard;

//////////////////////////////////////////////////////////////////////////
//接口函数
//////////////////////////////////////////////////////////////////////////
//取得版本号
const char *BankCardGetVersion();
// 打开图像识别接口，调试识别其他接口使用
int BankCardRecoFile(const char *szImgFile, unsigned char *pbResult, int nMaxSize);
// 24位色 RGB或者BGR识别, 都可以识别
int BankCard24(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg24, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);
// 输入32(0xargb)位的图像，转成24位的图像，Android系统用
int BankCard32(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg32, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);

// 根据ImageFormat.NV21直接用来识别
int BankCardNV21(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbVU, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);
// 根据ImageFormat.NV12直接用来识别
int BankCardNV12(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbUV, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//返回结构体，支持多个方向，NV21接口V2 [10/31/2015 bomber]
// direction支持的方向
// bwantimg是否返回图像
// btryflip是否支持颠倒
// 如果返回图像，则excard中有图像，需要调用BankCardFreeST进行释放
int BankCardNV21ST(TEXBCard *excard, unsigned char *pbY, unsigned char *pbVU, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm, 
				   int direction, int bwantimg, int btryflip);
//返回结构体，支持多个方向，NV12接口V2 [10/31/2015 bomber]
// direction支持的方向
// bwantimg是否返回图像
// btryflip是否支持颠倒
// 如果返回图像，则excard中有图像，需要调用BankCardFreeST进行释放
int BankCardNV12ST(TEXBCard *excard, unsigned char *pbY, unsigned char *pbUV, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm,
				   int direction, int bwantimg, int btryflip);

// 获取对焦分数
float GetFocusScore(unsigned char *imgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);
// 将结果转换为字节流
int ZInfo2ZStream(unsigned char *pbResult, int nMaxSize, TEXBCard *excard);
// 第二个版本，保存更多的信息
int ZInfo2ZStreamV2(unsigned char *pbResult, int nMaxSize, TEXBCard *excard);


// 内存释放函数，如果确定返回图像
int BankCardFreeST(TEXBCard *pstCard);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 图片识别接口，输入图像pbImage, 标准的图像数据个数
// 支持图像类型灰度  GRAY  nBitCount = 8
// 支持图像类型彩色  BGR24 nBitCount = 24
int BankCardRecognizeImage(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bTryHarder, int bWantImg, TEXBCard *pstCard);
//////////////////////////////////////////////////////////////////////////
// 非标准图像接口，调用标准图像接口
// RGBA32位图像识别 Android, IOS
int BankCardRecognizeImageRGBA32(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int bTryHarder, int bWantImg, TEXBCard *pstCard);

//////////////////////////////////////////////////////////////////////////
// 打开文件识别接口, 返回结构体，可以要求返回图像
int BankCardRecoFileImageSTAPI(const char *szImgFile, int bTryHarder, int bWantImg, TEXBCard *pstCard);
//////////////////////////////////////////////////////////////////////////
// 打开文件识别接口，返回字节流，ZInfo2ZStreamV2
int BankCardRecoFileImageAPI(const char *szImgFile, unsigned char *pbResult, int nMaxSize);
//////////////////////////////////////////////////////////////////////////
//将内存里面的卡数据另存为指定格式，pbImage内存外部申请
int BankCardConvert2BGRA(TEXBCard *pstCard, unsigned char *pbImage, int width, int height, int stride);
//将内存里面的卡数据另存为指定格式，pbImage内存外部申请
int BankCardConvert2RGBA(TEXBCard *pstCard, unsigned char *pbImage, int width, int height, int stride);
//将内存里面的卡数据另存为指定格式，pbImage内存外部申请
int BankCardConvert2ABGR(TEXBCard *pstCard, unsigned char *pbImage, int width, int height, int stride);

//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
}
#endif

#endif //__EX_BANK_CARD_H__