importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
  apiKey: 'AIzaSyAL9jKF_sVyy3BAg97lk1o3kgjQ5J9XkvU',
  appId: '1:1048620869448:web:46488b00a5398c1058f57d',
  messagingSenderId: '1048620869448',
  projectId: 'spesho-entebbe-drammp',
  authDomain: 'spesho-entebbe-drammp.firebaseapp.com',
  storageBucket: 'spesho-entebbe-drammp.appspot.com',
  measurementId: 'G-M3PS6VDZBQ',
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});