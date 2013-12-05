//
//  Chicken.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/06.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"
#import "Hiyo.h"
#import "Egg.h"

@interface Chicken : CCNode <CCTouchOneByOneDelegate>{
    @private
    CGSize winSize_;
    GameData *gameData_;
    CCSprite* sprite_;
    float scale_;
    BOOL isTouch_;
    BOOL isFever_;
    BOOL isTouchEnabled_;
    
    float feverEggProbability_;
    float feverTime_;
    float maxFeverTime_;
    
    CCLabelTTF *feverLabel_;
    CCParticleSystemQuad *feverPs;
}
@property (nonatomic,retain) NSMutableArray* eggArray;
@property BOOL isTouch;

-(void)setGameMode;
-(void)setResultMode;
@end
