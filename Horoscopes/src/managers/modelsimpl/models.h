//
//  models.hpp
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef models_hpp
#define models_hpp

#include <stdio.h>
#include "base/horobase.h"
#include "models/predictionscreenmodel/predictionscreenmodel.h"
#include "models/helloscreenmodel/helloscreenmodel.h"
#include "models/menuscreenmodel/menuscreenmodel.h"
#include "models/friendsscreenmodel/friendsscreenmodel.h"
#include "models/accountscreenmodel/accountscreenmodel.h"
#include "models/notificationsscreenmodel/notificationsscreenmodel.h"
#include "models/pushtimescreenmodel/pushtimescreenmodel.h"

namespace horo {
    
    class _Models {
    public:
        virtual ~_Models() {}
    public:
        virtual strong<PredictionScreenModel> predictionScreenModel()=0;
        virtual strong<PredictionScreenModel> predictionScreenModel(strong<Person> person)=0;
        virtual strong<HelloScreenModel> helloScreenModel()=0;
        virtual strong<MenuScreenModel> menuScreenModel()=0;
        virtual strong<FriendsScreenModel> friendsScreenModel()=0;
        virtual strong<AccountScreenModel> accountScreenModel()=0;
        virtual strong<NotificationsScreenModel> notificationsScreenModel()=0;
        virtual strong<PushTimeScreenModel> pushTimeScreenModel()=0;
    };
    
    typedef reff<_Models> Models;
};

#endif /* models_hpp */
