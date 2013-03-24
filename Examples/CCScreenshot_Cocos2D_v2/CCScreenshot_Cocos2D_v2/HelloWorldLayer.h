//
//  HelloWorldLayer.h
//  CCScreenshot_Cocos2D_v2
//
//  Created by Oguzhan Gungor on 24/03/13.
//  Copyright Oguzhan Gungor 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
