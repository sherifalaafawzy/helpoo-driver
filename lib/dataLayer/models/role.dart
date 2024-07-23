 import '../constants/enum.dart';

Role parseRole(roleName) {
    try {
      if (roleName == null) {
        return Role.public;
      }
     
      switch (roleName.toLowerCase()) {
        case 'driver':
          return Role.driver;
        case 'client':
          return Role.client;
        case 'inspector':
          return Role.inspector;
        case 'corporate':
          return Role.corporate;
        default:
          return Role.public;
      }
    } catch (e) {
      return Role.public;
    }
  }
