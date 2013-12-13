//
//  MenuLayer.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/09/16.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "GameData.h"

@interface MenuLayer : CCLayer {
    CGSize winSize_;
    GameData *gameData_;
    CCLabelTTF *staminaLabel_;
    CCLabelTTF *highScoreLabel_;
}

@end
