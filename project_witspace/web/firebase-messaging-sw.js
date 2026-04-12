importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyA0tKUaiTUdYdzDJjiXvWzw4J_jAXEta-4",
  authDomain: 'wit-space.firebaseapp.com',
  messagingSenderId: '744752433120',
    projectId: 'wit-space',
      appId: '1:744752433120:web:085e508f17140a3f8a0d85',

});

const messaging = firebase.messaging();