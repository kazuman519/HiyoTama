//
//  Egg.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/10/10.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Egg : CCNode {
    CGSize winSize_;
    
    CCLabelTTF *touchLabel_;
    CCLabelTTF *efectLabel_;
    
    CCParticleSystemQuad *feverEggPS;
}
@property (nonatomic, retain) CCSprite *sprite;
@property BOOL isFeverEgg;
@property BOOL isTouchEnabled;

-(void)setStatus:(int)number;
-(void)setFever;

-(void)touchFeverEgg;
-(void)moveRightAction:(CGPoint)position;
@end
