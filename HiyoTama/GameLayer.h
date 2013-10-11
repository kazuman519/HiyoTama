//
//  GameLayer.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/03.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Chicken.h"
#import "GameData.h"
#import "AdLayer.h"

@interface GameLayer : CCLayer {
    @private
    CGSize winSize_;
    GameData *gameData_;
    
    CCLabelTTF *timerLabel_;
    CCLabelTTF *scoreLabel_;
    Chicken *chicken_;
    float gameTime_;
    
    BOOL isGameEnd_;
    
    AdLayer *adLayer_;
}

@end
