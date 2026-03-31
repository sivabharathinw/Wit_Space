const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyOnNewEvent = functions.firestore
    .document('events/{eventId}')
    .onCreate(async (snap, context) => {
        const eventData = snap.data();
        const eventTitle = eventData.title || 'New Event';
        
        // Fetch all users with fcmToken
        const usersSnapshot = await admin.firestore().collection('users').get();
            
        if (usersSnapshot.empty) {
            console.log("No users found in the database.");
            return null;
        }

        const tokens = [];
        usersSnapshot.forEach(doc => {
            const token = doc.data().fcmToken;
            if (token) {
               tokens.push(token);
            }
        });

        if (tokens.length === 0) {
           console.log("No valid FCM tokens found in users.");
           return null;
        }

        // Create the notification payload
        const message = {
            notification: {
                title: 'New Event available!',
                body: `An event titled "${eventTitle}" has just been created.`
            },
            tokens: tokens
        };

        try {
            const response = await admin.messaging().sendEachForMulticast(message);
            console.log("Successfully sent notification. Success count:", response.successCount);
            return null;
        } catch (error) {
            console.error("Error sending notification:", error);
            return null;
        }
    });
