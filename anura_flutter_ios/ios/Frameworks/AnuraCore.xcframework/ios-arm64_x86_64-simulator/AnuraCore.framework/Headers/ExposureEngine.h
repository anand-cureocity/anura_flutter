//
//  Copyright (c) 2016-2024, Nuralogix Corp.
//  All Rights reserved
//  THIS SOFTWARE IS LICENSED BY AND IS THE CONFIDENTIAL AND
//  PROPRIETARY PROPERTY OF NURALOGIX CORP. IT IS
//  PROTECTED UNDER THE COPYRIGHT LAWS OF THE USA, CANADA
//  AND OTHER FOREIGN COUNTRIES. THIS SOFTWARE OR ANY 
//  PART THEREOF, SHALL NOT, WITHOUT THE PRIOR WRITTEN CONSENT
//  OF NURALOGIX CORP, BE USED, COPIED, DISCLOSED, 
//  DECOMPILED, DISASSEMBLED, MODIFIED OR OTHERWISE TRANSFERRED
//  EXCEPT IN ACCORDANCE WITH THE TERMS AND CONDITIONS OF A 
//  NURALOGIX CORP SOFTWARE LICENSE AGREEMENT.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoFrame;
@protocol CameraProtocol;

@interface ExposureEngine : NSObject

-(BOOL)calibrate:(VideoFrame * _Nonnull)videoFrame camera:(id<CameraProtocol> _Nonnull)camera;
-(void)reset;

@property (nonatomic) BOOL isCalibrated;
@property (nonatomic) BOOL isDebugging;

@property (nonatomic, readonly) NSString* _Nullable debugExposureStatus;

@end

NS_ASSUME_NONNULL_END
