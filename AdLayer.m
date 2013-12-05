//
//  AdLayer.m
//  HiyoTama
//
//  Created by 三浦　和真 on 2013/10/09.
//  Copyright 2013年 三浦　和真. All rights reserved.
//

#import "AdLayer.h"


@implementation AdLayer
{
    ADBannerView* _adView;
    GADBannerView* _gadView;
    BOOL _bannerIsVisible;
}

+ (id)layer
{
    return [[self alloc] initLayer];
}

- (id)initLayer
{
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _bannerIsVisible = NO;
        // iAd設定
        _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [[[CCDirector sharedDirector] view] addSubview:_adView];
        _adView.frame = CGRectOffset(_adView.frame, -50, winSize.height);
        _adView.delegate = self;
        
        // AdMob設定
        _gadView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _gadView.adUnitID = @"a1525797a164cbc";
        _gadView.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [[[CCDirector sharedDirector] view] addSubview:_gadView];
        _gadView.frame = CGRectOffset(_gadView.frame, -50, winSize.height);
        _gadView.delegate = self;
    }
    return self;
}

- (void)dealloc{
    [_adView removeFromSuperview];
    [_gadView removeFromSuperview];
    
    [super dealloc];
}
-(void)onExitTransitionDidStart{
    [super onExitTransitionDidStart];
    [self removeAd];
}

//iAd広告取得成功時の処理
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible) {
        [UIView animateWithDuration:0.1 animations:^{
            _adView.frame = CGRectOffset(banner.frame, _adView.center.x, -banner.frame.size.height);
        }];
        _bannerIsVisible = YES;
    }
    
}

//iAd広告取得失敗時の処理
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [_adView removeFromSuperview];
    _adView = nil;
    [self loadAdmobViewRequest];
}

//AdMob取得処理
- (void)loadAdmobViewRequest
{
    GADRequest *request = [GADRequest request];
    //以下の端末ではテスト広告をリクエスト
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,// シミュレータ
                           nil];
    [_gadView loadRequest:request];
}

//AdMob取得成功
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if (!_bannerIsVisible) {
        [UIView animateWithDuration:0.1 animations:^{
            _gadView.frame = CGRectOffset(view.frame, _gadView.center.x, -view.frame.size.height);
        }];
        _bannerIsVisible = YES;
    }
}

//AdMob取得失敗
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    [_gadView removeFromSuperview];
    _gadView = nil;
}
-(void)removeAd{
    [_gadView removeFromSuperview];
    [_adView removeFromSuperview];
    NSLog(@"REMOVE AD");
}
@end
