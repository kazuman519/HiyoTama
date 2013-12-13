//
//  PictureBookLayer.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/08/15.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "FMResultSet.h"
#import "GameData.h"

@interface PictureBookLayer : CCLayer {
    @private
    GameData *gameData_;
    CGSize winSize_;
    
    UIView *view_;
    UIScrollView *scrollView_;
}

// 指定したレア度のひよの番号が入っている配列
@property (nonatomic, retain) NSMutableArray *hiyoNumberArray;
@property (nonatomic, retain) NSMutableArray *labelArray;
@end
