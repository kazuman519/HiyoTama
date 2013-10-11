//
//  Hiyo.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/15.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "Hiyo.h"


@implementation Hiyo
-(id)init{
    if (self=[super init]) {
        winSize_ = [[CCDirector sharedDirector] winSize];
        gameData_ = [GameData getInstance];
        
        // ----- 初期化 ----
        // 画像
        sprite_ = [CCSprite spriteWithFile:@"hiyo1.png"];
        sprite_.anchorPoint = ccp(0.5, 0);
        sprite_.position = ccp(winSize_.width * 0.5,50);
        sprite_.scale = 0.8;
        [self addChild:sprite_];
        
        // ステータス
        number_ = 0;
        name_ = @"fa";
        rare_ = 0;
        kind_ = @"fa";
        sum_ = 0;
        explanation_ = @"fa";
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)setStatus:(int)number{
    [sprite_ setTexture:[[CCTextureCache sharedTextureCache] addImage: [NSString stringWithFormat:@"hiyo%d.png",number]]];
    number_ = number;
    name_ = [gameData_ getHiyoNameAppointNumber:number_];
    rare_ = [gameData_ getHiyoRareAppointNumber:number_];
    kind_ = [gameData_ getHiyoKindAppointNumber:number_];
    sum_ = [gameData_ getHiyoSumAppointNumber:number_];
    explanation_ = [gameData_ getHiyoExplanationAppointNumber:number_];
}
-(void)setPosition:(CGPoint)position{
    sprite_.position = position;
}
-(int)getNumber{
    return number_;
}
-(NSString*)getName{
    return name_;
}
-(int)getRare{
    return rare_;
}
-(NSString*)getKind{
    return kind_;
}
-(int)getSum{
    return sum_;
}
-(NSString*)getExpalanation{
    return explanation_;
}


-(void)moveLeftAction{
    sprite_.position = ccp(winSize_.width + sprite_.contentSize.width, 50);
    id jumpTo = [CCJumpTo actionWithDuration:2.5 position:ccp(- sprite_.contentSize.width, 50) height:winSize_.height*0.1 jumps:30];
    [sprite_ runAction:jumpTo];
}

// Newを表示する
-(void)setNewLabel{
    newLabel_ = [CCLabelTTF labelWithString:@"NEW!!" fontName:@"Marker Felt" fontSize:22];
    newLabel_.color = ccRED;
    newLabel_.position = ccp(sprite_.position.x, sprite_.position.y + sprite_.contentSize.height * 1.5);
    [self addChild:newLabel_];
    
    [self schedule:@selector(updateNewLabelPosition)];
}
// ラベルの座標を更新
-(void)updateNewLabelPosition{
    newLabel_.position = ccp(sprite_.position.x, newLabel_.position.y);
}
@end
