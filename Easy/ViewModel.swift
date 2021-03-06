//
//  ViewModel.swift
//  Easy
//
//  Created by Felix Reichenbach on 04.06.21.
//

import Foundation
import RealmSwift
import Combine

class ViewModel: ObservableObject {
    
    var realm: Realm?
    @Published var username: String = "demo"
    @Published var password: String = "demopw"
    @Published var error: String = ""
    @Published var itemName: String = ""
    @Published var progressView: Bool = false
    
    @Published var items: RealmSwift.Results<Item>?
    
    let app: RealmSwift.App = RealmSwift.App(id: "<--REALM APP ID-->")
    var notificationToken: NotificationToken?
    
    init() {
        print("init")
        openRealm()
    }
    
    
    func login() {
        print("userlogin: \(username)")
        self.progressView = true
        app.login(credentials: Credentials.emailPassword(email: username, password: password)) { result in
            switch result {
            case .success:
                self.openRealm()
                DispatchQueue.main.async {
                    self.error = ""
                    self.progressView = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Failed to log in: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    self.progressView = false
                }
            }
        }
    }
    
    
    func logout() {
        print("logout")
        self.progressView = true
        self.notificationToken?.invalidate()
        app.currentUser?.logOut() { result in
        }
        self.progressView = false
    }
    
    
    func openRealm() {
        // If there is no user logged in, exit function.
        guard let user = app.currentUser else {
            return
        }
        print("User custom data: \(user.customData)\(user.id)")
        Realm.asyncOpen(configuration: user.flexibleSyncConfiguration()) { result in
            switch result {
            case .success(let realm):
                self.realm = realm
                let subscriptions = realm.subscriptions
                subscriptions.write {
                    subscriptions.removeAll()
                    subscriptions.append(QuerySubscription<Item>(name: "filter") {
                        $0.owner_id == user.id
                    })
                }
                self.items = realm.objects(Item.self).sorted(byKeyPath: "_id", ascending: true)
                self.notificationToken = realm.observe { notification, realm in
                    print("Notification")
                    self.objectWillChange.send()
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func addItem() {
        print("addItem")
        try! items?.realm?.write(withoutNotifying: [notificationToken!]){
            items?.realm!.add(Item(name: itemName, owner_id: "624f4819a133a0b065578a10"))
        }
        objectWillChange.send()
    }
    
    func deleteItem(at offsets: IndexSet) {
        print("delete")
        
        /*guard let realm = self.realm else {
         print("Delete Failed")
         return
         }*/
        try! items?.realm?.write(withoutNotifying: [notificationToken!]){
            items?.realm!.delete(items![offsets.first!])
        }
    }
}
