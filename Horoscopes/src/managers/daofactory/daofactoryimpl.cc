//
//  daofactoryimpl.c
//  Horoscopes
//
//  Created by Jasf on 30.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#include "daofactoryimpl.h"
#include "managers/horoscopedao/horoscopedaoimpl.h"

namespace horo {
  
strong<HoroscopeDAO> DAOFactoryImpl::createHoroscopeDAO() {
    return new HoroscopeDAOImpl(database_);
}

};
