//
//  MenuLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/09/16.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "MenuLayer.h"
#import "TitleLayer.h"
#import "GameLayer.h"
#import "PictureBookMenuLayer.h"

@implementation MenuLayer
-(id)init{
    if (self=[super init]) {
        
        // レイヤーの初期化
        [self initLayer];
    }
    return self;
}

#pragma mark private

-(void)initLayer{
    winSize_ = [[CCDirector sharedDirector] winSize];
    gameData_ = [GameData getInstance];
    
    // 背景
    NSString *spriteName = [NSString string];
    if (winSize_.width == 568) {
        spriteName = @"menuBg-568h@2x.png";
    }else{
        spriteName = @"menuBg.png";
    }
    CCSprite *bgSprite = [CCSprite spriteWithFile:spriteName];
    bgSprite.position = ccp(winSize_.width * 0.5, winSize_.height * 0.5)
    ;
    [self addChild:bgSprite];
    
    // ------ データ表示部分 -----
    // 画像
    CCSprite *dataSprite = [CCSprite spriteWithFile:@"dataImage.png"];
    dataSprite.position = ccp(winSize_.width - dataSprite.contentSize.width * 0.5, dataSprite.contentSize.height * 0.5);
    [self addChild:dataSprite];
    
    // ラベル
    staminaLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[gameData_ getStamina]]  fontName:@"Marker Felt" fontSize:30];
    highScoreLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[gameData_ getHighScore]] fontName:@"Marker Felt" fontSize:30];
    staminaLabel_.anchorPoint = ccp(1.0, 0.5);
    highScoreLabel_.anchorPoint = ccp(1.0, 0.5);
    staminaLabel_.position = ccp(dataSprite.position.x - winSize_.height * 0.01, dataSprite.position.y);
    highScoreLabel_.position = ccp(dataSprite.position.x + winSize_.height* 0.32, dataSprite.position.y);
    [self addChild:staminaLabel_];
    [self addChild:highScoreLabel_];
    
    // ------ メニュー -------
    // ゲームプレイボタン
    CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"playBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"playBtn2.png"] block:^(id sender) {
        
        // 体力があればゲームスタート
        if ([gameData_ getStamina] >= [gameData_ getUseStaminaValue]) {
            NSLog(@"GAME PLAY");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer node] ]];
            
            [gameData_ useStamina];
            [self useStaminaAction];
        }
    }];
    playItem.position = ccp(winSize_.width - playItem.contentSize.width * 0.5, winSize_.height - playItem.contentSize.height * 0.5);
    
    // 図鑑ボタン
    CCMenuItemSprite *pictureBookItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"pictureBookBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"pictureBookBtn2.png"] block:^(id sender) {
        
        // ボタンを押したときのアクション
        NSLog(@"PICTURE BOOK");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PictureBookMenuLayer node] ]];
    }];
    pictureBookItem.position = ccp(playItem.position.x, playItem.position.y - playItem.contentSize.height * 0.9);
    
    // 戻るボタン
    CCMenuItemSprite *returnItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"returnTitleBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"returnTitleBtn2.png"] block:^(id sender) {
        
        // ボタンを押したときのアクション
        NSLog(@"RETURN TITLE");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer node] ]];
    }];
    returnItem.position = ccp(pictureBookItem.position.x, pictureBookItem.position.y - pictureBookItem.contentSize.height * 0.9);
    
    // メニュー
    CCMenu *menu = [CCMenu menuWithItems:playItem, pictureBookItem, returnItem, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    //にわとり
    NSString *chickenString = [NSString string];
    if ([gameData_ getStamina] <= [gameData_ getMaxStamina]/2) {
        NSLog(@"%d<%d",[gameData_ getStamina],[gameData_ getMaxStamina]);
        chickenString = @"chicken_tired.png";
    }
    else{
        chickenString = @"chicken.png";
    }
    CCSprite *chickenSprite = [CCSprite spriteWithFile:chickenString];
    chickenSprite.flipX = YES;
    chickenSprite.scale = 1.3;
    chickenSprite.position = ccp(winSize_.width * 0.2, winSize_.height * 0.25);
    [self addChild:chickenSprite];
    
    [self schedule:@selector(updateStamina)];
}

-(void)updateStamina{
    [staminaLabel_ setString:[NSString stringWithFormat:@"%d",[gameData_ getStamina]]];
    if ([gameData_ getStamina] == [gameData_ getMaxStamina]) {
        [self unschedule:@selector(updateStamina)];
        NSLog(@"STOP UPDATE STAMINA");
    }
}

-(void)useStaminaAction{
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"-%d",[gameData_ getUseStaminaValue]] fontName:@"Marker Felt" fontSize:30];
    label.color = ccc3(0, 204, 255);
    label.position = ccp(staminaLabel_.position.x, staminaLabel_.position.y);
    [self addChild:label];
    
    id scaleBy = [CCScaleBy actionWithDuration:0.2 scale:1.2];
    id moveBy = [CCMoveBy actionWithDuration:0.2 position:ccp(0, winSize_.height*0.05)];
    id spawn = [CCSpawn actions:scaleBy, moveBy, nil];
    [label runAction:spawn];
}
@end
