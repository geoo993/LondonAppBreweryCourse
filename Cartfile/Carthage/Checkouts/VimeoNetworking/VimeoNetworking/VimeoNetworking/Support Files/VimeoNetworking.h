
//
//  VimeoNetworking.h
//  VimeoNetworking
//
//  Created by Huebner, Rob on 4/20/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

//! Project version number for VimeoNetworking.
FOUNDATION_EXPORT double VimeoNetworkingVersionNumber;

//! Project version string for VimeoNetworking.
FOUNDATION_EXPORT const unsigned char VimeoNetworkingVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <VimeoNetworking/PublicHeader.h>

#import "VIMAccount.h"
#import "VIMActivity.h"
#import "VIMAppeal.h"
#import "VIMCategory.h"
#import "VIMChannel.h"
#import "VIMComment.h"
#import "VIMConnection.h"
#import "VIMCredit.h"
#import "VIMGroup.h"
#import "VIMInteraction.h"
#import "VIMMappable.h"
#import "VIMModelObject.h"
#import "VIMNotification.h"
#import "VIMNotificationsConnection.h"
#import "VIMObjectMapper.h"
#import "VIMPicture.h"
#import "VIMPictureCollection.h"
#import "VIMPolicyDocument.h"
#import "VIMPreference.h"
#import "VIMPrivacy.h"
#import "VIMQuantityQuota.h"
#import "VIMRecommendation.h"
#import "VIMSeason.h"
#import "VIMSoundtrack.h"
#import "VIMTag.h"
#import "VIMThumbnailUploadTicket.h"
#import "VIMTrigger.h"
#import "VIMUploadTicket.h"
#import "VIMUser.h"
#import "VIMUserBadge.h"
#import "VIMVideo+VOD.h"
#import "VIMVideo.h"
#import "VIMVideoDASHFile.h"
#import "VIMVideoDRMFiles.h"
#import "VIMVideoFairPlayFile.h"
#import "VIMVideoFile.h"
#import "VIMVideoHLSFile.h"
#import "VIMVideoPlayFile.h"
#import "VIMVideoPlayRepresentation.h"
#import "VIMVideoPreference.h"
#import "VIMVideoProgressiveFile.h"
#import "VIMVideoUtils.h"
#import "VIMVODConnection.h"
#import "VIMVODItem.h"
#import "Objc_ExceptionCatcher.h"
#import "VimeoNetworking.h"

/*
#import <VimeoNetworking/VIMAccount.h>
#import <VimeoNetworking/VIMActivity.h>
#import <VimeoNetworking/VIMAppeal.h>
#import <VimeoNetworking/VIMCategory.h>
#import <VimeoNetworking/VIMChannel.h>
#import <VimeoNetworking/VIMComment.h>
#import <VimeoNetworking/VIMConnection.h>
#import <VimeoNetworking/VIMGroup.h>
#import <VimeoNetworking/VIMInteraction.h>
#import <VimeoNetworking/VIMPicture.h>
#import <VimeoNetworking/VIMPictureCollection.h>
#import <VimeoNetworking/VIMPreference.h>
#import <VimeoNetworking/VIMPrivacy.h>
#import <VimeoNetworking/VIMQuantityQuota.h>
#import <VimeoNetworking/VIMTag.h>
#import <VimeoNetworking/VIMTrigger.h>
#import <VimeoNetworking/VIMUploadTicket.h>
#import <VimeoNetworking/VIMUser.h>
#import <VimeoNetworking/VIMVideo.h>
#import <VimeoNetworking/VIMVideoFile.h>
#import <VimeoNetworking/VIMVideoPreference.h>
#import <VimeoNetworking/VIMVideoUtils.h>
#import <VimeoNetworking/VIMSoundtrack.h>
#import <VimeoNetworking/VIMVODItem.h>
#import <VimeoNetworking/VIMRecommendation.h>
#import <VimeoNetworking/VIMPolicyDocument.h>

#import <VimeoNetworking/Objc_ExceptionCatcher.h>

#import <VimeoNetworking/VIMMappable.h>
#import <VimeoNetworking/VIMModelObject.h>
#import <VimeoNetworking/VIMObjectMapper.h>

*/
