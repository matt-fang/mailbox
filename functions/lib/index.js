"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notifyPartnerOnActive = void 0;
const database_1 = require("firebase-functions/v2/database");
const app_1 = require("firebase-admin/app");
const database_2 = require("firebase-admin/database");
const messaging_1 = require("firebase-admin/messaging");
(0, app_1.initializeApp)();
const friendPairs = {
    matthew: "Matthew",
    atharva: "Atharva",
    noa: "Noa",
    alfred: "Alfred",
    devon: "Devon",
    hayden: "Hayden",
};
const partnerMap = {
    matthew: "Atharva",
    atharva: "Matthew",
    noa: "Alfred",
    alfred: "Noa",
    devon: "Hayden",
    hayden: "Devon",
};
exports.notifyPartnerOnActive = (0, database_1.onValueWritten)({ ref: "{userId}/isActive", instance: "talkbox-592ae-default-rtdb" }, async (event) => {
    var _a;
    const userId = event.params.userId;
    const isActiveNow = event.data.after.val();
    // Only notify when someone comes ONLINE
    if (isActiveNow !== true)
        return;
    const partnerDisplayName = partnerMap[userId];
    if (!partnerDisplayName)
        return;
    const partnerKey = partnerDisplayName.toLowerCase();
    // Check if partner is offline
    const db = (0, database_2.getDatabase)();
    const partnerActiveSnap = await db.ref(`${partnerKey}/isActive`).get();
    if (partnerActiveSnap.val() === true)
        return;
    // Get partner's FCM token
    const tokenSnap = await db.ref(`users/${partnerDisplayName}/fcmToken`).get();
    const token = tokenSnap.val();
    if (!token)
        return;
    // Get the display name of whoever came online
    const whoIsOnline = (_a = friendPairs[userId]) !== null && _a !== void 0 ? _a : userId;
    await (0, messaging_1.getMessaging)().send({
        token,
        notification: {
            title: "talkbox t-1",
            body: `${whoIsOnline.toLowerCase()} is online!`,
        },
        apns: {
            payload: { aps: { sound: "default" } },
        },
    });
});
//# sourceMappingURL=index.js.map