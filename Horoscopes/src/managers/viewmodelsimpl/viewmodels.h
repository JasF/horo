//
//  viewmodels.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef viewmodels_hpp
#define viewmodels_hpp

#include "base/horobase.h"
#include "viewmodels/predictionscreenviewmodel/predictionscreenviewmodel.h"
#include "viewmodels/helloscreenviewmodel/helloscreenviewmodel.h"
#include "viewmodels/menuscreenviewmodel/menuscreenviewmodel.h"
#include "viewmodels/friendsscreenviewmodel/friendsscreenviewmodel.h"

namespace horo {
  
    class _ViewModels {
    public:
        virtual ~_ViewModels() {}
    public:
        virtual strong<PredictionScreenViewModel> predictionScreenViewModel()=0;
        virtual strong<HelloScreenViewModel> helloScreenViewModel()=0;
        virtual strong<MenuScreenViewModel> menuScreenViewModel()=0;
        virtual strong<FriendsScreenViewModel> friendsScreenViewModel()=0;
    };
    
    typedef reff<_ViewModels> ViewModels;
};

#endif /* viewmodels_hpp */
