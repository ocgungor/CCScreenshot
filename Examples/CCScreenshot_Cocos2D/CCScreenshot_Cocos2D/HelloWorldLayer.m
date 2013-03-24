//
//  HelloWorldLayer.m
//  CCScreenshot_Cocos2D
//
//  Created by Oguzhan Gungor on 24/03/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCScreenshot.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
    
        
        CCMenuItem *sceenshot = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"Icon.png"] selectedSprite:nil target:self selector:@selector(takeScreenshot)];
        
        CCMenu *menu = [CCMenu menuWithItems:sceenshot, nil];
        menu.position =  ccp(100, 100);
        [menu alignItemsHorizontallyWithPadding:15];
        [self addChild: menu z: 100];

        
        
        
        
        
	}
	return self;
}

- (void) takeScreenshot {
    CCScreenshot *scr = [[CCScreenshot alloc] init];
    
    
    
    CCSprite *screenshot = [[CCScreenshot sharedInstance] takeScreenshotAsCCSprite];
    [scr release];
    screenshot.scale = .3;
    screenshot.position = ccp(100, 300);
    [self addChild:screenshot];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
