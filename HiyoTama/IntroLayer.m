//
//  IntroLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/03.
//  Copyright 三浦　和真 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameData.h"
#import "TitleLayer.h"
#import "MenuLayer.h"
#import "GameLayer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {
        // ゲームデータを読み込む
        NSLog(@"ここかああああ");
        [GameData getInstance];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
        
        NSString *spriteName = [NSString string];
        if (size.width == 568) {
            spriteName = @"gameBg-568h@2x.png";
        }else{
            spriteName = @"gameBg.png";
        }
        CCSprite *bgSprite = [CCSprite spriteWithFile:spriteName];
        bgSprite.position = ccp(size.width * 0.5, size.height * 0.5)
        ;
        [self addChild:bgSprite];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer node] ]];
}
@end
