//
//  viewmodelsimpl.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef viewmodelsimpl_h
#define viewmodelsimpl_h

#include "viewmodels.h"
#include "models.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
    
    class ViewModelsImpl : public ViewModels {
    public:
        ViewModelsImpl(strong<Models> models);
        ~ViewModelsImpl() override;
        
        void setScreensManager(strong<ScreensManager> screensManager) { screensManager_ = screensManager; }
        
    public:
        strong<PredictionScreenViewModel> predictionScreenViewModel() override;
        
    private:
        strong<Models> models_;
        strong<ScreensManager> screensManager_;
    };
    
};

#endif /* viewmodelsimpl_h */
