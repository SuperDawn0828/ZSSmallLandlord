/************************************************************************/
/* copyright(C) 2013-2016 �����׵���ʶ�Ƽ����޹�˾                      */
/************************************************************************/
#ifndef __EX_VECARD_RECO_H__
#define __EX_VECARD_RECO_H__

#ifdef __cplusplus
extern "C" {
#endif

/////////////////////////////////////////////////////////////////////////////
typedef struct tagVECard 
{
	char szPlateNo[64];				//���ƺ���
	char szVehicleType[64];			//��������
	char szOwner[128];				//������
	char szAddress[256];			//סַ
	char szModel[64];				//Ʒ���ͺ�
	char szUseCharacter[64];		//ʹ������
	char szEngineNo[64];			//��������
	char szVIN[64];					//����ʶ�����
	char szRegisterDate[32];		//ע������
	char szIssueDate[32];			//��֤����
	//////////////////////////////////////////////////////////////////////////
	//���¾��������������stdimage������ϵ
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
	TRect rtTitle; //����
	TRect rtBound; //֤�ڴ�ͼ��λ��
	//////////////////////////////////////////////////////////////////////////
	int nConfNum;
	int nUnConfNum; //����ʶ����Ŷ�
	float fzoom;
	float fAngle;	//skew����ͼ��

	int type; //1: 2010��֮��ģ� 2��֮ǰ��
	int nPosRgt; //˳����һ��PlateNo �ұ�
	//////////////////////////////////////////////////////////////////////////
	//У�����ͼ�� rtBound
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

