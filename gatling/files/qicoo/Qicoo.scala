package qicoo

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class Qicoo extends Simulation {

    object Configuration {
        var SCENARIO_NAME = "Qicoo test"
        var REQUEST_NAME = "List Question"
        var PATH = "/v1/jkd1812/questions"

        val BASE_URL = System.getProperty("baseUrl", "https://api.qicoo.tokyo")
        val USERS : Long = java.lang.Long.valueOf(System.getProperty("users", "12"))
        val DURING : Int = java.lang.Integer.valueOf(System.getProperty("during", "12"))

        val URL = BASE_URL + PATH
    }

    val get2productpage = scenario(Configuration.SCENARIO_NAME)
        .exec(
            http(Configuration.REQUEST_NAME)
            .get(Configuration.URL)
            .queryParamSeq(Seq(("start", "1"), ("end", "100"), ("sort", "created_at"), ("order", "desc"))))
        .pause(1)

    var httpProtocol = http
        .acceptHeader("application/json")
        .header("Cache-Control", "max-age=0")
        .connectionHeader("keep-alive")

    setUp(
        get2productpage.inject(Seq(
                rampUsersPerSec(1).to(Configuration.USERS).during(Configuration.DURING / 3),
                constantUsersPerSec(Configuration.USERS) during(Configuration.DURING / 3),
                rampUsersPerSec(Configuration.USERS).to(1).during(Configuration.DURING / 3)
            ))
    ).protocols(httpProtocol)

}

