//
//  API.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

struct API {
    static var RepHubUser = UserAPI()
    static var Post = PostAPI()
    static var Comment = CommentAPI()
    static var PostComments = PostCommentsAPI()
    static var UserPosts = UserPostsAPI()
    static var Follow = FollowAPI()
    static var Feed = FeedAPI()
    static var MyPosts = MyPostsAPI()
    static var HashTag = HashTagAPI()
    static var UserTag = UserTagAPI()
    static var Notification = NotificationAPI()
    static var Hydrate = HydrateAPI()
    static var Exercise = ExerciseAPI()
    static var Workout = WorkoutAPI()
    static var WorkoutExercises = WorkoutExercisesAPI()
    static var UserWorkouts = UserWorkoutsAPI()
    static var UserExerciseLogs = UserExerciseLogsAPI()
    static var ExerciseLog = ExerciseLogAPI()
    static var WorkoutLog = WorkoutLogsAPI()
    static var UserWorkoutLogs = UserWorkoutLogsAPI()
    static var WourkoutJournal = WorkoutJournalAPI()
    static var UserJournalEntries = UserJournalEntriesAPI()
    static var Block = BlockAPI()
    static var Report = ReportAPI()
    static var Mute = MuteAPI()
    static var ExerciseTarget = ExerciseTargetAPI()
    static var WorkoutExerciseLogs = WorkoutExerciseLogsAPI()
}
