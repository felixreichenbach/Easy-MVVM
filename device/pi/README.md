# Simple example of an edge device MongoDB Realm application

## Setup MongoDB Atlas


Create the realm app:
https://www.mongodb.com/docs/realm/manage-apps/create/create-with-realm-ui/


Configure user authentication:
https://www.mongodb.com/docs/realm/authentication/email-password/


Enable Sync:
https://www.mongodb.com/docs/realm/sync/configure/enable-sync/#enable-flexible-sync


## Use the demo application

1. Configure "config.js" -> replace App ID and if needed adjust username and password
2. Start the nodeJS application in the Easy-MVVM/device/pi directory
```
node nodePi.js
```
![Start nodeJS application](/device/pi/images/startDeviceApp.png)
3. Navigate to the website [http://localhost:3000/](http://localhost:3000/)
![Onboard UI](/device/pi/images/accessDeviceWebsite.png)
4. Hit the create device button to create a device.
5. Hit the add component button to create and relate a component to the previosuly created device. Works multiple times but will always add components to the first created device only!


## Helpful Links

Sense Hat nodejs library: https://www.npmjs.com/package/pi-sense-hat

Pi demo including javascript sense hat access: https://github.com/WekanCompany/mongodb-iot-realm