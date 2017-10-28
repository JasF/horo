//
//  horoasserts.h
//  Horoscopes
//
//  Created by Jasf on 28.10.2017.
//  Copyright © 2017 Mail.Ru. All rights reserved.
//

#ifndef horoasserts_h
#define horoasserts_h

#include <assert.h>

#ifdef DEBUG

#define SCAssert(a, ...) assert(a)
#define SCParameterAssert(a) assert(a)

#else

#define SCAssert(...)
#define SCParameterAssert(...)

#endif

#endif /* horoasserts_h */
