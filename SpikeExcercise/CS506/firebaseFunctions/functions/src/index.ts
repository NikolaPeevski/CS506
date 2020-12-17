import * as functions from 'firebase-functions';
import * as admin from "firebase-admin";

admin.initializeApp();
// https://firebase.google.com/docs/functions/typescript

export const sortSemesters = functions.database.ref('/Semesters')
    .onWrite(() => admin.database().ref(`/Semesters`).orderByKey());

export const sortSemesterTerms = functions.database.ref('/Semesters/{SemYear}')
    .onWrite(() => admin.database().ref(`/Semesters/{SemYear}`).orderByKey());

export const computeAssignmentAverage = functions.database.ref('/Courses/{CourseId}/TaughtIn/{Year}/{Term}/Assignments/{id}/Rating/{rId}')
    .onWrite( (change, context) => {

        const gradeToGPA = (grade: string) => {
          switch(grade) {
              case 'A':
                  return 4;
              case 'B':
                  return 3;
              case 'C':
                  return 2;
              case 'D':
                  return 1;
              case 'F':
                  return 0;
              default:
                  return 0;
          }
        };
        admin.database().ref(`/Courses/${context.params.CourseId}/TaughtIn/${context.params.Year}/${context.params.Term}/Assignments/${context.params.id}/Rating`).once('value')
            .then(res => {
                let average = 0;
                let i = 0;
                //TODO: Change to reduce
                res.forEach(a => {
                    average += gradeToGPA(a.child("Grade").val());
                    i++;
                });
                admin.database().ref(`/Courses/${context.params.CourseId}/TaughtIn/${context.params.Year}/${context.params.Term}/Assignments/${context.params.id}/Average`)
                    .set(Math.round((average/i) * 100) / 100)
                    .then(() => Promise.resolve())
                    .catch(err => Promise.reject(err));
            })
            .catch(err => console.error(err));
    });

export const computeCourseAverage = functions.database.ref('/Courses/{CourseId}/TaughtIn/{Year}/{Term}/Assignments/{id}/Average')
    .onUpdate( (change, context) => {
        admin.database().ref(`/Courses/${context.params.CourseId}/TaughtIn/${context.params.Year}/${context.params.Term}/Assignments`).once('value')
            .then(res => {
                let average = 0;
                let i = 0;
                res.forEach(a => {
                    //TODO: Change to reduce
                    average += a.child("Average").val();
                    i++;
                });
                admin.database().ref(`/Courses/${context.params.CourseId}/TaughtIn/${context.params.Year}/${context.params.Term}/Average`)
                    .set(Math.round((average/i) * 100) / 100)
                    .then(() => Promise.resolve())
                    .catch(err => Promise.reject(err));
            })
            .catch(err => console.error(err));
    });
