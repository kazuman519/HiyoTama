//
//  DetailsView.h
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/09/20.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"
#import "Hiyo.h"

@interface DetailsView : UIView {
    GameData *gameData_;
    UIView *view_;
    UIImageView *bgView_;
}

-(void)setDetails:(int)hiyoNum;
@end
