import * as functions from 'firebase-functions';
import * as admin from "firebase-admin";

admin.initializeApp();
// https://firebase.google.com/docs/functions/typescript

export const sortSemesters = functions.database.ref('/Semesters')
    .onWrite(() => admin.database().ref(`/Semesters`).orderByKey());

export const sortSemesterTerms = functions.database.ref('/Semesters/{SemYear}')
    .onWrite(() => admin.database().ref(`/Semesters/{SemYear}`).orderByKey());
