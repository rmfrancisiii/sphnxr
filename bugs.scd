// bugs!

// 1. creating another effect with the same name will replace the existing one.

// 2. using a wrong bus name will default to bus 0. unknown effect when using a number.

// 3. not executing
         ~me=~addrBook.me
//    in the session file will break the oscdef.
//    (also need to look for other misuses of enironment variables like this.
