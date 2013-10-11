//
//  AdLayer.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/10/09.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "cocos2d.h"
#import "GADBannerView.h"

@interface AdLayer : CCLayer <ADBannerViewDelegate, GADBannerViewDelegate>
{
    
}
-(void)removeAd;
+ (id)layer;
@end
