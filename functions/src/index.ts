import { onValueWritten } from "firebase-functions/v2/database";
import { initializeApp } from "firebase-admin/app";
import { getDatabase } from "firebase-admin/database";
import { getMessaging } from "firebase-admin/messaging";

initializeApp();

const friendPairs: Record<string, string> = {
  matthew: "Matthew",
  atharva: "Atharva",
  noa: "Noa",
  alfred: "Alfred",
  devon: "Devon",
  hayden: "Hayden",
};

const partnerMap: Record<string, string> = {
  matthew: "Atharva",
  atharva: "Matthew",
  noa: "Alfred",
  alfred: "Noa",
  devon: "Hayden",
  hayden: "Devon",
};

export const notifyPartnerOnActive = onValueWritten(
  { ref: "{userId}/isActive", instance: "talkbox-592ae-default-rtdb" },
  async (event) => {
    const userId = event.params.userId;
    const isActiveNow = event.data.after.val();

    // Only notify when someone comes ONLINE
    if (isActiveNow !== true) return;

    const partnerDisplayName = partnerMap[userId];
    if (!partnerDisplayName) return;

    const partnerKey = partnerDisplayName.toLowerCase();

    // Check if partner is offline
    const db = getDatabase();
    const partnerActiveSnap = await db.ref(`${partnerKey}/isActive`).get();
    if (partnerActiveSnap.val() === true) return;

    // Get partner's FCM token
    const tokenSnap = await db.ref(`users/${partnerDisplayName}/fcmToken`).get();
    const token = tokenSnap.val();
    if (!token) return;

    // Get the display name of whoever came online
    const whoIsOnline = friendPairs[userId] ?? userId;

    await getMessaging().send({
      token,
      notification: {
        title: "talkbox t-1",
        body: `${whoIsOnline.toLowerCase()} is online!`,
      },
      apns: {
        payload: { aps: { sound: "default" } },
      },
    });
  }
);
