//
//  color.h
//  Horoscopes
//
//  Created by Jasf on 19.01.2018.
//  Copyright © 2018 Mail.Ru. All rights reserved.
//

#ifndef color_h
#define color_h

#include "base/horobase.h"

namespace horo {
  
    class Color {
    public:
        static Color clearColor() {return Color(.0f,.0f,.0f,.0f);}
        static Color whiteColor() {return Color(1.f,1.f,1.f);}
        static Color blackColor() {return Color(0.f,0.f,0.f);}
    public:
        Color() : red_(0), green_(0), blue_(0), alpha_(0) {}
        Color(float red, float green, float blue, float alpha=1.f) : red_(red), green_(green), blue_(blue), alpha_(alpha) {}
        ~Color() {}
        
    public:
        float red_;
        float green_;
        float blue_;
        float alpha_;
    };
};

#endif /* color_h */
