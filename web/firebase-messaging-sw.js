importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyAL9jKF_sVyy3BAg97lk1o3kgjQ5J9XkvU',
    appId: '1:1048620869448:web:46488b00a5398c1058f57d',
    messagingSenderId: '1048620869448',
    projectId: 'spesho-entebbe-drammp',
    authDomain: 'spesho-entebbe-drammp.firebaseapp.com',
    storageBucket: 'spesho-entebbe-drammp.appspot.com',
    measurementId: 'G-M3PS6VDZBQ'

});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
