/************************************************************************/
/* copyright(C) 2013-2016 北京易道博识科技有限公司                      */
/************************************************************************/
#ifndef __EX_VECARD_RECO_H__
#define __EX_VECARD_RECO_H__

#ifdef __cplusplus
extern "C" {
#endif

/////////////////////////////////////////////////////////////////////////////
typedef struct tagVECard 
{
	char szPlateNo[64];				//号牌号码
	char szVehicleType[64];			//车辆类型
	char szOwner[128];				//所有人
	char szAddress[256];			//住址
	char szModel[64];				//品牌型号
	char szUseCharacter[64];		//使用性质
	char szEngineNo[64];			//发动机号
	char szVIN[64];					//车辆识别代码
	char szRegisterDate[32];		//注册日期
	char szIssueDate[32];			//发证日期
	//////////////////////////////////////////////////////////////////////////
	//以下矩形是相对于整个stdimage的坐标系
	TRect rtPlateNo;
	TRect rtVehicleType;
	TRect rtOwner;
	TRect rtAddress;
	TRect rtModel;
	TRect rtUseCharacter;
	TRect rtEngineNo;
	TRect rtVIN;
	TRect rtRegisterDate;
	TRect rtIssueDate;
	//////////////////////////////////////////////////////////////////////////
	TRect rtTitle; //标题
	TRect rtBound; //证在大图中位置
	//////////////////////////////////////////////////////////////////////////
	int nConfNum;
	int nUnConfNum; //整张识别可信度
	float fzoom;
	float fAngle;	//skew整张图像

	int type; //1: 2010年之后的， 2：之前的
	int nPosRgt; //顺带求一下PlateNo 右边
	//////////////////////////////////////////////////////////////////////////
	//校正后的图像 rtBound
	TBitmap *imCard;
	//////////////////////////////////////////////////////////////////////////
}EXVECard;

//////////////////////////////////////////////////////////////////////////
STD_API(int) EXVECardResToStrInfo(char *szResBuf, const int iBufSize, EXVECard *pstVECard);
STD_API(int) EXVECARDSaveRects(EXVECard *pstVECard, int *pRects);
STD_API(int) EXVECardResToStr(char *szResBuf, const int iBufSize, EXVECard *pstVECard);

//////////////////////////////////////////////////////////////////////////
int EXVECardRecoV2(TBitmap *pstImage, int nRecoMode, int bWantImg, EXVECard *pstVECard);

STD_API(int) EXVECardRecoImageFileSTV2(const char *szImgFile, int nRecoMode, int bWantImg, EXVECard *pstVECard);
STD_API(int) EXVECardRecoStillImageRGBA32STV2(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int bWantImg, EXVECard *pstVECard);
STD_API(int) EXVECardRecoStillImageSTV2(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXVECard *pstVECard);
STD_API(int) EXVECardRecoNV12STV2(unsigned char *pbY, unsigned char *pbUV, int nWidth, int nHeight, int bWantImg, EXVECard *pstVECard);
STD_API(int) EXVECardRecoNV21STV2(unsigned char *pbY, unsigned char *pbVU, int nWidth, int nHeight, int bWantImg, EXVECard *pstVECard);
STD_API(int) EXVECardRecoRawDateSTV2(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXVECard *pstVECard);


#ifdef __cplusplus
}
#endif

#endif //__EX_VECARD_RECO_H__

