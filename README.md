CCScreenshot
============

Cocos2D Screenshot Class



USAGE
===========

Simply import CCScreenshot.h and call one of the following methods according to your need.

Screenshot as UIImage
```
UIImage *img = [[CCScreenshot screenshot] takeScreenshotAsUIImage];
```
Screenshot as CCSprite
```
CCSprite *sp = [[CCScreenshot screenshot] takeScreenshotAsCCSprite];
```
Screenshot as CCTexture2D
```
CCTexture2D *texture = [[CCScreenshot screenshot] takeScreenshotAsCCTexture2D];
```

Alternatively, if you need to add some text in to your screenshot, you can use one of the following methods.

Screenshot as UIImage with 2D text







Copyright
============

/*	
 *
 *
 * Created by Oguzhan Cansin Gungor on 24/03/13.
 *
 * Copyright (c) 2013 Aslan-Apps. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *       This product includes software developed by Aslan-Apps.
 * 4. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior written
 *    permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */




