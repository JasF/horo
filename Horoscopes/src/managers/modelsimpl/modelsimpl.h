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

namespace horo {
  
    class ModelsImpl : public Models {
    public:
        ModelsImpl();
        ~ModelsImpl() override;
    public:
        strong<PredictionScreenModel> predictionScreenModel() override;
        
    };
    
};

#endif /* modelsimpl_h */
