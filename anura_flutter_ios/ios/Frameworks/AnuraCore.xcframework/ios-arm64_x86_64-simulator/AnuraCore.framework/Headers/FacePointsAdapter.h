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

#ifndef FacePointsAdapter_h
#define FacePointsAdapter_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class TrackedFace;

@interface FacePointsAdapter : NSObject

+(void)adaptFacePointsIn:(TrackedFace * _Nonnull)trackedFace;

@end

#endif /* FacePointsAdapter_h */
