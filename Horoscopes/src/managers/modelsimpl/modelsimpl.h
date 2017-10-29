//
//  modelsimpl.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef modelsimpl_h
#define modelsimpl_h

#include "models.h"
#include "models/corecomponents/corecomponents.h"
#include "managers/facebookmanager/facebookmanager.h"
#include "managers/settings/settings.h"

namespace horo {
  
    class ModelsImpl : public Models {
    public:
        ModelsImpl(strong<CoreComponents> components,
                   strong<FacebookManager> facebookManager,
                   strong<Settings> settings);
        ~ModelsImpl() override;
    public:
        strong<PredictionScreenModel> predictionScreenModel() override;
        strong<HelloScreenModel> helloScreenModel() override;
        
    private:
        strong<CoreComponents> components_;
        strong<FacebookManager> facebookManager_;
        strong<Settings> settings_;
    };
    
};

#endif /* modelsimpl_h */
