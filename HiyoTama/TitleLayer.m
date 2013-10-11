//
//  TitleLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/06.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "TitleLayer.h"
#import "GameData.h"
#import "MenuLayer.h"

@implementation TitleLayer
-(id)init{
    if (self=[super init]) {
        
        // レイヤーの初期化
        [self initLayer];
    }
    return self;
}

#pragma mark private

-(void)initLayer{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 背景
    NSString *spriteName = [NSString string];
    if (winSize.width == 568) {
        spriteName = @"titleBg-568h@2x.png";
    }else{
        spriteName = @"titleBg.png";
    }
    CCSprite *bgSprite = [CCSprite spriteWithFile:spriteName];
    bgSprite.position = ccp(winSize.width * 0.5, winSize.height * 0.5)
    ;
    [self addChild:bgSprite];
    
    //　タイトルロゴ
    CCSprite *logoSprite = [CCSprite spriteWithFile:@"titleLogo.png"];
    logoSprite.position = ccp(winSize.width * 0.5, winSize.height * 0.75);
    [self addChild:logoSprite];
    
    // ------ メニュー -------
    // スタートボタン
    CCMenuItemSprite *startItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"startBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"startBtn2.png"] block:^(id sender) {
        NSLog(@"START");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuLayer node] ]];
    }];
    startItem.position = ccp(winSize.width * 0.5, winSize.height * 0.46);
    
    // その他のゲームボタン
    CCMenuItemSprite *otherGameItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"otherGameBtn1.png"] selectedSprite:[CCSprite spriteWithFile:@"otherGameBtn2.png"] block:^(id sender) {
        NSLog(@"OTHER GAME");
    }];
    otherGameItem.position = ccp(winSize.width * 0.5, startItem.position.y - startItem.contentSize.height);
    
    // メニュー
    CCMenu *menu = [CCMenu menuWithItems:startItem, otherGameItem, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}
-(void)onEnter{
    [super onEnter];
}
-(void)onExit{
    [super onExit];
}
@end
