package qicoo

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class QicooWrite extends Simulation {

    object Configuration {
        var SCENARIO_NAME_POST = "Qicoo Post"
        var SCENARIO_NAME_LIKE = "Qicoo Like"
        var REQUEST_NAME_POST = "Post a Question"
        var REQUEST_NAME_LIKE = "Like a Question"
        var BASE_PATH = "/v1/jkd1812/questions"

        val BASE_URL = System.getProperty("baseUrl", "https://api-s.qicoo.tokyo")
        val USERS_POST : Long = java.lang.Long.valueOf(System.getProperty("postUsers", "12"))
        val USERS_LIKE : Long = java.lang.Long.valueOf(System.getProperty("likeUsers", "12"))
        val DURING : Int = java.lang.Integer.valueOf(System.getProperty("during", "12"))
        val LIKE_QID = System.getProperty("likeQid", "fcfd4f19-0623-47cc-a078-c99d6112b6d4")

        val URL_POST = BASE_URL + BASE_PATH
        val URL_LIKE = BASE_URL + BASE_PATH + "/" + LIKE_QID + "/like"

        val QUESTION_BODY =
            "{" +
                 "\"program_id\": \"1\"," +
                 "\"comment\": \"東方仗助の開発秘話を教えてください\"" +
            "}"
    }

    val post = scenario(Configuration.SCENARIO_NAME_POST)
        .exec(
            http(Configuration.REQUEST_NAME_POST)
            .post(Configuration.URL_POST)
            .body(StringBody(Configuration.QUESTION_BODY)).asJson
            .check(status.is(200)))
        .pause(1)
    val like = scenario(Configuration.SCENARIO_NAME_LIKE)
        .exec(
            http(Configuration.REQUEST_NAME_LIKE)
            .put(Configuration.URL_LIKE)
            .check(status.is(200)))
        .pause(1)

    var httpProtocol = http
        .acceptHeader("application/json")
        .header("Cache-Control", "max-age=0")
        .connectionHeader("keep-alive")

    setUp(
        post.inject(Seq(
                rampUsersPerSec(1).to(Configuration.USERS_POST).during(Configuration.DURING / 3),
                constantUsersPerSec(Configuration.USERS_POST) during(Configuration.DURING / 3),
                rampUsersPerSec(Configuration.USERS_POST).to(1).during(Configuration.DURING / 3)
            )),
        like.inject(Seq(
                rampUsersPerSec(1).to(Configuration.USERS_LIKE).during(Configuration.DURING / 3),
                constantUsersPerSec(Configuration.USERS_LIKE) during(Configuration.DURING / 3),
                rampUsersPerSec(Configuration.USERS_LIKE).to(1).during(Configuration.DURING / 3)
            ))
    ).protocols(httpProtocol)

}