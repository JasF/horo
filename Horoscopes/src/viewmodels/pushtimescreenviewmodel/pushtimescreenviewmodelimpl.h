//
//  pushtimescreenviewmodelimpl.h
//  Horoscopes
//
//  Created by Jasf on 27.12.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef pushtimescreenviewmodelimpl_h
#define pushtimescreenviewmodelimpl_h

#include <stdio.h>
#include "viewmodels/pushtimescreenviewmodel/pushtimescreenviewmodel.h"
#include "models/pushtimescreenmodel/pushtimescreenmodel.h"
#include "managers/screensmanager/screensmanager.h"

namespace horo {
    class PushTimeScreenViewModelImpl : public PushTimeScreenViewModel {
    public:
        PushTimeScreenViewModelImpl(strong<PushTimeScreenModel> model);
        ~PushTimeScreenViewModelImpl() override;
        
    public:
        int pushTime() override;
        void setPushTime(int pushTime) override;
        void sendSettingsIfNeeded() override;
        
    private:
        strong<PushTimeScreenModel> model_;
    };
};

#endif /* pushtimescreenviewmodelimpl_h */
