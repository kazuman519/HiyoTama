//
//  Egg.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/10/10.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "Egg.h"


@implementation Egg
-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        
        self.isFeverEgg = NO;
        self.isTouchEnabled = NO;
    }
    return self;
}

-(void)setStatus:(int)number{
    _sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"egg%d.png",number]];
    [self addChild:_sprite];
    
}
-(void)setFever{
    _sprite = [CCSprite spriteWithFile:@"touchEgg.png"];
    [self addChild:_sprite];
    self.isFeverEgg = YES;
    
    //[self feverEggParticle];
}
// タッチ文字を表示
-(void)setTouchLabel{
    touchLabel_ = [CCLabelTTF labelWithString:@"たっち！\n↓" fontName:@"Helvetica-Bold" fontSize:30];
    efectLabel_ = [CCLabelTTF labelWithString:@"たっち！\n↓" fontName:@"Helvetica-Bold" fontSize:30];
    touchLabel_.position = ccp(-touchLabel_.contentSize.width, -touchLabel_.contentSize.height);
    efectLabel_.position = ccp(-touchLabel_.contentSize.width, -touchLabel_.contentSize.height);
    touchLabel_.color = ccRED;
    efectLabel_.color = ccc3(61, 18, 18);
    [self addChild:efectLabel_];
    [self addChild:touchLabel_];
    
    [self schedule:@selector(labelPositionUpdate)];
}
-(void)labelPositionUpdate{
    touchLabel_.position = ccp(self.sprite.position.x, self.sprite.position.y + self.sprite.contentSize.height);
    efectLabel_.position = ccp(self.sprite.position.x + efectLabel_.fontSize*0.1, self.sprite.position.y + self.sprite.contentSize.height - efectLabel_.fontSize*0.1);
}

// フィーバーエッグをタッチしたとき
-(void)touchFeverEgg{
    [self unschedule:@selector(labelPositionUpdate)];
    [self removeChild:touchLabel_];
    [self removeChild:efectLabel_];
    
}

// 右に転がっていく
-(void)moveRightAction:(CGPoint)position{
    // 飛び出る座標の設定
    _sprite.position = ccp(position.x + winSize_.height * 0.27, position.y + winSize_.height * 0.4);
    
    // ジャンプする高さのランダム設定
    int randomJumpValue = CCRANDOM_0_1() * winSize_.height * 0.2 + winSize_.height * 0.2;
    id jumpTo = [CCJumpTo actionWithDuration:0.5 position:ccp(_sprite.position.x + winSize_.width * 0.2, _sprite.boundingBox.size.height/2 + 50) height:randomJumpValue jumps:1];
    id rotateBy = [CCRotateBy actionWithDuration:10 angle:7200];
    id moveTo = [CCMoveTo actionWithDuration:5.0 position:ccp(winSize_.width * 2, _sprite.boundingBox.size.height/2 + 50)];
    id block = [CCCallBlock actionWithBlock:^{
        self.isTouchEnabled = YES;
        if (self.isFeverEgg) {
            [self setTouchLabel];
        }
    }];
    id spawn = [CCSpawn actions:moveTo, block, nil];
    id sequence = [CCSequence actions:jumpTo, spawn, nil];
    
    [_sprite runAction:rotateBy];
    [_sprite runAction:sequence];
}

// フィーバーパーティクル
-(void)feverEggParticle{
    feverEggPS = [CCParticleSystemQuad particleWithFile:@"feverEgg.plist"];
    feverEggPS.position = ccp(_sprite.position.x, _sprite.position.y);
    feverEggPS.autoRemoveOnFinish = YES;
    [self addChild:feverEggPS];
    
    [self schedule:@selector(positionUpdate)];
}
-(void)positionUpdate{
    feverEggPS.position = ccp(_sprite.position.x, _sprite.position.y);
}
@end
