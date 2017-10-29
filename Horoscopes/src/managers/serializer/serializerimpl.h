//
//  serializerimpl.h
//  Horoscopes
//
//  Created by Jasf on 29.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef serializerimpl_h
#define serializerimpl_h

#include "serializer.h"

namespace horo {
    class SerializerImpl : public Serializer {
    public:
        static void setPrivateInstance(Serializer *privateInstance);
    public:
        SerializerImpl();
        ~SerializerImpl() override;
        
    public:
        void saveString(std::string key, std::string value) override;
        std::string loadString(std::string key) override;
    };
};

#endif /* serializerimpl_h */
